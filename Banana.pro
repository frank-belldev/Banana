TEMPLATE = app

QT += qml quick network

SOURCES += main.cpp \
    downloadmanager.cpp

RESOURCES += qml.qrc

DISTFILES += ./qml/main.qml

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    downloadmanager.h
