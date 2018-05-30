#include <QtGui>
#include <QtQml>
#include <QtCore>
#include <QtQuick>
#include <downloadmanager.h>

int main(int argc, char *argv[])
{
    QGuiApplication::setApplicationName("Banana");
    QGuiApplication::setOrganizationName("QtProject");
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    qmlRegisterType<DownloadManager>("banana.components", 1, 0, "DownloadManager");

    qputenv("QT_LABS_CONTROLS_STYLE", "Material");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
