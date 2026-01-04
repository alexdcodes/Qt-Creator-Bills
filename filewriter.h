#pragma once
#include <QObject>

class FileWriter : public QObject {
    Q_OBJECT
public:
    Q_INVOKABLE bool appendLine(const QString &path, const QString &line);
};
