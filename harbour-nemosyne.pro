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

INCLUDEPATH += thirdparty/SailfishWidgets/include

SOURCES += src/harbour-nemosyne.cpp \
    src/languageselector.cpp

RESOURCES += \
    images.qrc \
    data.qrc

HEADERS += \
    src/languageselector.h

OTHER_FILES += qml/harbour-nemosyne.qml \
    qml/cover/CoverPage.qml \
    qml/pages/* \
    rpm/* \
    translations/*.ts \
    harbour/nemosyne/* \
    harbour-nemosyne.desktop \
    lib/* \
    README.md

QML_IMPORT_PATH = .
nemosyne.files = harbour
nemosyne.path = /usr/share/$${TARGET}
INSTALLS += nemosyne

# Deployment folders
linux:meego {
  message( $$(MER_SSH_TARGET_NAME) )
  LIBS += -L$$PWD/thirdparty/SailfishWidgets/armv/SailfishWidgets/Settings -lapplicationsettings
  nemosynelibs.files = $$PWD/thirdparty/SailfishWidgets/armv/SailfishWidgets/Settings/libapplicationsettings.so
  nemosynelibs.path = /usr/share/$${TARGET}/lib
  INSTALLS += nemosynelibs
}
linux:i486 {
  message( $$(MER_SSH_TARGET_NAME) )
  LIBS += -L$$PWD/thirdparty/SailfishWidgets/i486/SailfishWidgets/Settings -lapplicationsettings
  nemosynelibs.files = $$PWD/thirdparty/SailfishWidgets/i486/SailfishWidgets/Settings/libapplicationsettings.so
  nemosynelibs.path = /usr/share/$${TARGET}/lib
  INSTALLS += nemosynelibs
}

# to disable building translations every time, comment out the
# following CONFIG line

CONFIG += sailfishapp sailfishapp_i18n
TRANSLATIONS += translations/harbour-nemosyne-ja.ts \
                translations/harbour-nemosyne-nl.ts \
                translations/harbour-nemosyne-zh.ts \
                translations/harbour-nemosyne-zh_TW.ts
