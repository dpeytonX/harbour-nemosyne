import QtQuick 2.1
import harbour.nemosyne.Nemosyne 1.0
import harbour.nemosyne.QmlLogger 2.0
import harbour.nemosyne.SailfishWidgets.Database 1.3
import harbour.nemosyne.SailfishWidgets.FileManagement 1.3
import harbour.nemosyne.SailfishWidgets.Utilities 1.3
import harbour.nemosyne.SailfishWidgets.JS 1.3

SQLiteDatabase {
    property bool initialized
    property bool validDb
    property int active
    property int scheduled
    property int unmemorized
    property Card card

    readonly property int late: 0
    readonly property int early: 0
    readonly property int onTime: 0

    signal validateDatabase(string filePath)
    /*!
          The Mnemosyne 2.3 algorithm is more complex allowing for randomization of
          cards on a stack and avoiding sister cards.

          Until requested otherwise, this algorithm will just stick to the basics.
         */
    signal next(int rating)
    signal initializedDone()
    signal deleteCard()

    DynamicLoader {
        id: cardCreator
        onObjectCompleted: {
            card = object
            Console.debug("cardCreator: card fact id is " + card.factId)
        }
    }

    File {
        id: sqlFile
        fileName: ":/data/nemosyne.sql"
    }

    onDeleteCard: {
        Console.info("Manager: delete card selected")

        if(!opened || !card) return

        // Get cards with the same fact id
        prepare("SELECT _id FROM cards where _fact_id = :factId;")
        bind(":factId", card.factId)

        if(!exec() || !query.first()) {
            Console.error(lastError)
            return
        }

        var cardIds = []
        do {
            cardIds.push(query.value("_id"))
        } while(query.next())

        // Delete fact data
        Console.debug("Manager: deleting data for fact " + card.factId)
        prepare("DELETE FROM data_for_fact where _fact_id = :factId;")
        bind(":factId", card.factId)
        if(!exec()) {
            Console.error(lastError)
        }

        // Delete the fact itself
        Console.debug("Manager: deleting fact " + card.factId)
        prepare("DELETE FROM facts where _id = :factId;")
        bind(":factId", card.factId)
        exec()
        if(!exec()) {
            Console.error(lastError)
        }

        // Delete tag associations
        Console.debug("Manager: deleting tags for cards " + cardIds)
        prepare("DELETE FROM tags_for_card where _card_id IN (:cardIds);")
        bind(":cardIds", cardIds)
        exec()
        if(!exec()) {
            Console.error(lastError)
        }

        // Delete cards
        Console.debug("Manager: deleting cards with fact id " + card.factId)
        prepare("DELETE FROM cards where _fact_id = :factId")
        bind(":factId", card.factId)
        exec()
        if(!exec()) {
            Console.error(lastError)
        }

        card = null
    }

    onValidateDatabase: {
        //Check if this is an sql lite db
        if(opened) close()

        Console.debug("opening db at " + filePath)
        databaseName = filePath

        if(!open()) return

        Console.debug("running query on " + databaseName)

        //Check for a mnemosyne table for verification

        var result = exec("SELECT * FROM global_variables WHERE key='version' AND value='Mnemosyne SQL 1.0';")
        if(!result) {
            Console.error(lastError)
            validDb = false
        }
        Console.debug("query was valid")

        if(query.indexOf("value") !== -1) initTrackingValues()

        validDb = result
    }

    onNext: {
        Console.debug("Manager::next")
        if(!opened || !valid) return

        Console.debug("Rating is " + rating)
        if(!!card) {
            Console.debug("Card is not null")
            if(rating != -1) {
                //If the database was just opened, current card is orphaned.
                grade(rating)
                saveCard()
            }
            card = null
        }

        initTrackingValues();

        Console.debug("searching in graded pool")
        var result = exec("SELECT * FROM cards WHERE grade>=2 " +
                          "AND strftime('%s',datetime('now', 'start of day', '-1 day')) >=next_rep AND active=1 " +
                          "ORDER BY next_rep DESC LIMIT 1;")
        if(!result) {
            Console.error("next: " + "memory stack " + lastError)
            return
        }
        query.first()

        if(!query.valid) {
            Console.debug("searching in unmemorized pool")
            result = exec("SELECT * FROM cards WHERE grade < 2 AND active=1 " +
                          "ORDER BY next_rep DESC LIMIT 1;");

            if(!result) {
                Console.error("next: " + "unmemorized stack " + lastError)
                return
            }
            query.first()
        }

        if(!query.valid) {
            //Last attempt: pull card from the reviewed stack, longest rep first
            Console.debug("searching in reviewed pool")
            result = exec("SELECT * FROM cards WHERE active=1 " +
                          "ORDER BY next_rep DESC LIMIT 1;")

            if(!result) {
                Console.error("next: " + "reviewed stack " + lastError)
                return
            }
            query.first()
        }

        if(!query.valid) {
            //No card found
            Console.info("no card found in database")
            return
        }

        Console.debug("next " + query)

        cardCreator.create(Qt.createComponent("Card.qml"), this, {
                               "seq" : query.value("_id"),
                               "question" : query.value("question"),
                               "answer" : query.value("answer"),
                               "nextRep" : query.value("next_rep"),
                               "lastRep" : query.value("last_rep"),
                               "grade" : query.value("grade"),
                               "easiness" : query.value("easiness"),
                               "acquisition" : query.value("acq_reps"),
                               "acquisitionRepsSinceLapse": query.value("acq_reps_since_lapse"),
                               "retentionRep" : query.value("ret_reps"),
                               "lapses" : query.value("lapses"),
                               "retentionRepsSinceLapse" : query.value("ret_reps_since_lapse"),
                               "factId" : query.value("_fact_id")
                           })
    }

    function initialize() {
        if(!sqlFile.exists) {
            Console.debug("initialize: resource does not exist!")
            initialized = false
        }

        sqlFile.open(File.ReadOnly);
        var commands = sqlFile.readAll().split(';')
        Console.debug(commands)
        initialized = execBatch(commands, true)
        initializedDone()
        return initialized
    }

    function initTrackingValues() {
        if(!opened) return

        //scheduled
        Console.info("checking scheduled pool")
        var result = exec("SELECT count(*) AS count FROM cards WHERE grade >= 2 AND strftime('%s',datetime('now', 'start of day', '-1 day'))>=next_rep AND active=1;")
        if(!result || query.indexOf("count") === -1) {
            Console.debug("initTracking " + lastError)
            return
        }
        query.first()
        scheduled = query.value("count")

        //active
        result = exec("SELECT count(*) AS count FROM cards WHERE active=1;")

        Console.info("checking active pool")
        if(!result || query.indexOf("count") === -1) {
            Console.debug("initTracking " + lastError)
            return
        }
        query.first()
        active = query.value("count")

        //unmemorized
        Console.info("checking unmemorized pool")
        result = exec("SELECT count(*) AS count FROM cards WHERE grade < 2 AND active=1;")
        if(!result || query.indexOf("count") === -1) {
            Console.debug("initTracking " + lastError)
            return
        }
        query.first()
        unmemorized = query.value("count");
    }

    function calculateInitialInterval(rating, timing, actualInterval, scheduledInterval) {
        var day = 60*60*24
        var intervals = [0, 0, day, 3 * day, 4 * day, 7 * day]
        var choice3 = [1, 1, 2]
        var choice4 = [1, 2, 2]

        var oldGrade = card.grade
        Console.debug("caculate interval: grade " + oldGrade + " new " + rating)

        if(oldGrade == -1)
            return intervals[rating]
        if(oldGrade <= 1 && rating <= 1)
            return 0
        if(oldGrade <= 1) {
            switch(rating) {
            case 2:
                return day
            case 3:
                return choice3[MathHelper.randomInt(0, choice3.length)] * day
            case 4:
                return choice4[MathHelper.randomInt(0, choice4.length)] * day
            case 5:
                return 2 * day
            }
        }

        if(rating <= 1)
            return 0

        // Card's old grade and rating are > 1
        if(card.retentionRepsSinceLapse == 1)
            return 6 * day

        if(scheduledInterval == 0) scheduledInterval = day

        if(rating <= 3)
            return (timing == onTime || timing == early) ? actualInterval * card.easiness : scheduledInterval

        if(rating == 4) return actualInterval * card.easiness

        if(rating == 5) return timing == early ? scheduledInterval : actualInterval * card.easiness

        //I'm ignoring interval noise. Just get the d*** value.
        return day
    }

    /*!
      \internal

         Mnemosyne 2.3 keeps track of "facts" which seem to be a table that contains
         memorized cards. One purpose is to avoid pulling in sister cards in the schedule.
         This class will ignore facts for simplicity; although, I'm not sure how this
         will Mnemosyne proper when shuffling the database.
         */
    function grade(rating) {
        if(rating == -1) return

        // First calculate timing
        var tstamp = Date.now() / 1000
        Console.debug("grade: timestamp " + tstamp)
        Console.debug("grade: nextrep " + card.nextRep)

        var timing = late
        if(tstamp - 60*60*24 < card.nextRep) {
            timing = tstamp < card.nextRep ? early : onTime
        }

        //Get last seen interval
        var oldGrade = card.grade
        var interval = card.nextRep - card.lastRep
        var actualInterval = tstamp - card.lastRep
        Console.debug(" actual interval " + actualInterval + "scheduled interval " + interval)
        var intervalNew = calculateInitialInterval(rating, timing, oldGrade < 1 ? 0 : actualInterval, interval)

        // Set acquisition stage
        if(oldGrade == -1) {
            card.easiness = 2.5
            card.acquisition = 1
            card.acquisitionRepsSinceLapse = 1
        } else if(oldGrade <= 1 && rating <= 1 ) {
            card.acquisition += 1
            card.acquisitionRepsSinceLapse += 1
            intervalNew  = 0
        } else if(oldGrade <= 1) {
            card.acquisition += 1
            card.acquisitionRepsSinceLapse += 1
        } else if (rating <= 1) {
            card.retentionRep += 1
            card.lapses += 1
            card.acquisition = 0
            card.acquisitionRepsSinceLapse = 0
            card.retentionRepsSinceLapse = 0
        } else {
            var easiness = card.easiness
            card.retentionRep += 1
            card.retentionRepsSinceLapse += 1
            switch(timing) {
            case late:
            case onTime:
                if(rating == 2) card.easiness = easiness - 0.16
                else if(rating == 3) card.easiness = easiness - 0.14
                else if(rating == 5) card.easiness = easiness + 0.1
                easiness = card.easiness
                if(easiness < 1.3) card.easiness = 1.3
                break
            default:
                break
            }
        }

        card.grade = rating
        card.lastRep = tstamp

        Console.debug("grade: old next rep " + card.nextRep)
        Console.debug("grade: interval new " + intervalNew)

        card.nextRep = card.lastRep
        if(rating >= 2) card.nextRep = card.lastRep + intervalNew;

        Console.debug("grade: new next rep " + card.nextRep)

        //Ignoring log entry
    }

    function saveCard() {
        if(!opened || !card) return;

        Console.debug("saving card " + card.seq)

        prepare("UPDATE cards SET " +
                "question = :question, "+
                "answer = :answer, "+
                "next_rep = datetime(:next_rep, 'unixepoch'), "+
                "last_rep = datetime(:last_rep, 'unixepoch'), "+
                "grade = :grade, "+
                "easiness = :easiness, "+
                "acq_reps = :acq_reps, "+
                "acq_reps_since_lapse = :acq_reps_since_lapse, "+
                "ret_reps = :ret_reps, "+
                "lapses = :lapses, "+
                "ret_reps_since_lapse = :ret_reps_since_lapse "+
                "WHERE _id = :seq;")

        bind(":question", card.question)
        bind(":answer", card.answer)
        bind(":next_rep", card.nextRep)
        bind(":last_rep", card.lastRep)
        bind(":grade", card.grade)
        bind(":easiness", card.easiness)
        bind(":acq_reps", card.acquisition)
        bind(":acq_reps_since_lapse", card.acquisitionRepsSinceLapse)
        bind(":ret_reps", card.retentionRep)
        bind(":lapses", card.lapses)
        bind(":ret_reps_since_lapse", card.retentionRepsSinceLapse)
        bind(":seq", card.seq)

        if(!exec()) {
            Console.debug("save:" + "error" + lastError )
            return
        }
    }
}
