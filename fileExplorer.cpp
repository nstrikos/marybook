#include "fileExplorer.h"
#include <QDebug>

#include <QDir>

FileExplorer::FileExplorer(QObject *parent) : QObject(parent)
{

}

void FileExplorer::makeBackup(QString dir, QString filename)
{
    //QString backDir = dir + "backup";
    //    if (!QDir(dir).exists()) {
    //        QDir().mkdir(backDir);
    //    }

    QString backDirString = dir + "backup";
    QString newFile = backDirString + "/" + filename;
    QString oldFile = dir + filename;

    QDir backDir(backDirString);
    QFile file(oldFile);
    if (!backDir.exists())
        backDir.mkpath(".");
    file.rename(newFile);
}

void FileExplorer::removeFile(QString filename)
{
    QFile::remove(filename);
}

void FileExplorer::rename(QString oldName, QString newName)
{
    QFile::rename(oldName, newName);
}

QString FileExplorer::read(QString filename)
{
    filename.replace("file://", "");
    QFile file(filename);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return "";

    QTextStream in(&file);
    while (!in.atEnd()) {
        QString text = in.readAll();
        return text;
    }

    return "";
}

void FileExplorer::write(QString filename, QString text)
{
    filename.replace("file://", "");
    QFile file(filename);

    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
        return;

    QTextStream out(&file);
    out << text;
}
