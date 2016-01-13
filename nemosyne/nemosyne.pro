# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-nemosyne

QT += sql

QMAKE_CXXFLAGS += "-std=c++0x"

INCLUDEPATH += ../thirdparty/sailfish-widgets/src/lib/core

SOURCES += src/harbour-nemosyne.cpp

RESOURCES += images.qrc \
             data.qrc

OTHER_FILES += qml/harbour-nemosyne.qml \
    qml/cover/CoverPage.qml \
    qml/pages/* \
    translations/*.ts \
    harbour/nemosyne/* \
    ../thirdparty/* \
    harbour-nemosyne.desktop \
    lib/* \
    README.md

QML_IMPORT_PATH = .

# Deployment instructions
nemosyne.files = harbour
nemosyne.path = /usr/share/$${TARGET}
INSTALLS += nemosyne

swl.files = ../thirdparty/sailfish-widgets/src/qml/SailfishWidgets
swl.path = /usr/share/$${TARGET}/harbour/nemosyne
INSTALLS += swl

### Rename QML modules for Harbour store
swlc.path = /usr/share/$${TARGET}/harbour/nemosyne
swlc.commands = find /home/deploy/installroot$$swl.path -name 'qmldir' -exec sed -i \"s/module Sail/module harbour.nemosyne.Sail/\" \\{} \;;
swlc.commands += find /home/deploy/installroot$$swl.path -name '*.qmltypes' -exec sed -i \"s/SailfishWidgets/harbour\/nemosyne\/SailfishWidgets/\" \\{} \;
INSTALLS += swlc

qmllogger.files = ../thirdparty/QmlLogger/qmldir ../thirdparty/QmlLogger/qmllogger/Logger.js
qmllogger.path = /usr/share/$${TARGET}/harbour/nemosyne/QmlLogger
INSTALLS += qmllogger

#nemosynelibs.files = ../thirdparty/sailfish-widgets/src/qml/SailfishWidgets/Settings/libapplicationsettings* \
nemosynelibs.files = $$OUT_PWD/../thirdparty/sailfish-widgets/src/lib/core/libcore.so.1
nemosynelibs.path = /usr/share/$${TARGET}/lib
nemosynelibs.commands = "pushd /home/deploy/installroot/usr/share/$${TARGET}/lib; ln -s ../harbour/nemosyne/SailfishWidgets/Settings/libapplicationsettings.so ."
INSTALLS += nemosynelibs

# Linker instructions--The order of -L and -l is important
LIBS += -L$$_PRO_FILE_PWD_/../thirdparty/sailfish-widgets/src/qml/SailfishWidgets/Settings \
        -lapplicationsettings \
        -L$$OUT_PWD/../thirdparty/sailfish-widgets/src/lib/core \
        -lcore

# to disable building translations every time, comment out the
# following CONFIG line

CONFIG += sailfishapp sailfishapp_i18n
TRANSLATIONS += translations/harbour-nemosyne.ts \
                translations/harbour-nemosyne-ja.ts \
                translations/harbour-nemosyne-nl.ts \
                translations/harbour-nemosyne-zh.ts \
                translations/harbour-nemosyne-zh_TW.ts
