BEGIN TRANSACTION;
CREATE TABLE card_types(
        id text primary key,
        name text,
        fact_keys_and_names text,
        unique_fact_keys text,
        required_fact_keys text,
        fact_view_ids text,
        keyboard_shortcuts text,
        extra_data text default ""
    );
CREATE TABLE cards(
        _id integer primary key,
        id text,
        card_type_id text,
        _fact_id integer,
        fact_view_id text,

        question text,
        answer text,
        tags text,

        grade integer,
        next_rep integer,
        last_rep integer,
        easiness real,
        acq_reps integer,
        ret_reps integer,
        lapses integer,
        acq_reps_since_lapse integer,
        ret_reps_since_lapse integer,
        creation_time integer,
        modification_time integer,
        extra_data text default "",
        scheduler_data integer default 0,
        active boolean default 1
    );
CREATE TABLE criteria(
       _id integer primary key,
       id text,
       name text,
       type text,
       data text
    );
CREATE TABLE data_for_fact(
        _fact_id integer,
        key text,
        value text
    );
CREATE TABLE fact_views(
        id text primary key,
        name text,
        q_fact_keys text,
        a_fact_keys text,
        q_fact_key_decorators text,
        a_fact_key_decorators text,
        a_on_top_of_q boolean default 0,
        type_answer boolean default 0,
        extra_data text default ""
    );
CREATE TABLE facts(
        _id integer primary key,
        id text,
        extra_data text default ""
    );
CREATE TABLE global_variables(
        key text,
        value text
    );
INSERT INTO global_variables VALUES('version','Mnemosyne SQL 1.0');
CREATE TABLE log(
        _id integer primary key autoincrement, /* Should never be reused. */
        event_type integer,
        timestamp integer,
        object_id text,
        grade integer,
        easiness real,
        acq_reps integer,
        ret_reps integer,
        lapses integer,
        acq_reps_since_lapse integer,
        ret_reps_since_lapse integer,
        scheduled_interval integer,
        actual_interval integer,
        thinking_time integer,
        next_rep integer,
        /* Storing scheduler_data allows syncing the cramming scheduler */
        scheduler_data integer
    );
CREATE TABLE media(
        filename text primary key,
        _hash text
    );
CREATE TABLE partnerships(
        partner text unique,
        _last_log_id integer
    );
CREATE TABLE tags(
        _id integer primary key,
        id text,
        name text,
        extra_data text default ""
    );
CREATE TABLE tags_for_card(
        _card_id integer,
        _tag_id integer
    );
CREATE INDEX i_cards on cards (id);
CREATE INDEX i_cards_2 on cards (fact_view_id);
CREATE INDEX i_cards_3 on cards (_fact_id);
CREATE INDEX i_data_for_fact on data_for_fact (_fact_id);
CREATE INDEX i_facts on facts (id);
CREATE INDEX i_log_object_id on log (object_id);
CREATE INDEX i_log_timestamp on log (timestamp);
CREATE INDEX i_tags on tags (id);
CREATE INDEX i_tags_for_card on tags_for_card (_card_id);
CREATE INDEX i_tags_for_card_2 on tags_for_card (_tag_id);
COMMIT;
