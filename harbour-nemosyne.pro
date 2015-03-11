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

CONFIG += sailfishapp

QT += sql

QMAKE_CXXFLAGS += "-std=c++0x"

SOURCES += src/harbour-nemosyne.cpp

OTHER_FILES += qml/harbour-nemosyne.qml \
    qml/cover/CoverPage.qml \
    qml/pages/* \
    rpm/* \
    translations/*.ts \
    harbour/nemosyne/* \
    harbour-nemosyne.desktop \
    README.md

QML_IMPORT_PATH = .
nemosyne.files = harbour
nemosyne.path = /usr/share/$${TARGET}
INSTALLS += nemosyne

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-nemosyne-ja.ts translations/harbour-nemosyne-zh.ts

RESOURCES += \
    images.qrc \
    data.qrc
