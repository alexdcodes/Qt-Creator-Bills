#include "filewriter.h"
#include <QFile>
#include <QTextStream>

bool FileWriter::appendLine(const QString &path, const QString &line)
{
    QFile file(path);
    if (!file.open(QIODevice::Append | QIODevice::Text))
        return false;

    QTextStream out(&file);
    out << line << "\n";
    return true;
}
