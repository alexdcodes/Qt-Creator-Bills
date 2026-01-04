#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "filewriter.h"
#include <QQmlContext>

int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("Bills", "Main");

    FileWriter writer;
    engine.rootContext()->setContextProperty("FileWriter", &writer);

    return app.exec();
}

