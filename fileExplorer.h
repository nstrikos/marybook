#ifndef FILEEXPLORER_H
#define FILEEXPLORER_H

#include <QObject>
#include <QFile>

class FileExplorer : public QObject
{
    Q_OBJECT
public:
    explicit FileExplorer(QObject *parent = nullptr);
    Q_INVOKABLE void makeBackup(QString dir, QString filename);
    Q_INVOKABLE void removeFile(QString filename);
    Q_INVOKABLE void rename(QString oldName, QString newName);
    Q_INVOKABLE QString read(QString filename);
    Q_INVOKABLE void write(QString filename, QString text);

signals:

};

#endif // FILEEXPLORER_H
