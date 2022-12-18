QT += widgets quick dbus

CONFIG += c++11 core qml quick qtquickcompiler lrelease embed_translations


# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        src/main.cpp \
        src/messaging.cpp \
        src/ofonomodem.cpp

RESOURCES += src/qml/qml.qrc
RESOURCES += icons/icons.qrc
HEADERS += \
        src/messaging.h \
        src/ofonomodem.h

INCLUDEPATH += src

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
target.path = /usr/bin/
!isEmpty(target.path): INSTALLS += target
desktopfile.files = cutie-messaging.desktop
desktopfile.path = /usr/share/applications/
autostart.files = cutie-messaging-autostart.desktop
autostart.path = /etc/xdg/autostart/

icon.files = cutie-messaging.svg
icon.path = /usr/share/icons/hicolor/scalable/apps/

INSTALLS += desktopfile icon autostart

TRANSLATIONS = translations/cutie-messaging_fi.ts

include(singleapplication/singleapplication.pri)
DEFINES += QAPPLICATION_CLASS=QApplication
