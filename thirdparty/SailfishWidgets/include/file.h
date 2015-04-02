/***************************************************************************
** This file is part of SailfishWidgets
**
** Copyright (c) 2014 Dametrious Peyton
**
** $QT_BEGIN_LICENSE:GPLV3$
** SailfishWidgets is free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** SailfishWidgets is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with SailfishWidgets.  If not, see <http://www.gnu.org/licenses/>.
** $QT_END_LICENSE$
**
**************************************************************************/

#ifndef FILE_H
#define FILE_H

#include <QFile>
#include <QFileInfo>
#include <QString>

class File : public QFile, public QFileInfo
{
    Q_OBJECT

    Q_PROPERTY(bool dir READ isDir NOTIFY fileNameChanged)
    Q_PROPERTY(bool executable READ isExecutable NOTIFY fileNameChanged)
    Q_PROPERTY(bool exists READ exists NOTIFY fileNameChanged)
    Q_PROPERTY(bool file READ isFile NOTIFY fileNameChanged)
    Q_PROPERTY(bool hidden READ isHidden NOTIFY fileNameChanged)
    Q_PROPERTY(bool readable READ isReadable NOTIFY fileNameChanged)
    Q_PROPERTY(bool root READ isRoot NOTIFY fileNameChanged)
    Q_PROPERTY(bool symLink READ isSymLink NOTIFY fileNameChanged)
    Q_PROPERTY(bool writable READ isWritable NOTIFY fileNameChanged)
    Q_PROPERTY(QString absoluteFilePath READ absoluteFilePath CONSTANT)
    Q_PROPERTY(QString fileName READ fileName WRITE setFileName NOTIFY fileNameChanged)

    Q_ENUMS(OpenModeFlag)
public:
    explicit File();
    File(const QString &name, QObject *parent=0);

    bool exists() const;
    QString fileName();

    bool isReadable() const;
    bool isWritable() const;

    void setFileName(const QString& name);

    Q_INVOKABLE bool open(int mode);
    Q_INVOKABLE void close();
    Q_INVOKABLE QString readAll();
    Q_INVOKABLE void write(const QString& text);

    Q_INVOKABLE bool remove();
    Q_INVOKABLE bool rename(const QString &newName);
    Q_INVOKABLE bool copy(const QString &newName);

    /*** START: Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies). Under GPL Version 3 License ***/
    enum OpenModeFlag {
        NotOpen = 0x0000,
        ReadOnly = 0x0001,
        WriteOnly = 0x0002,
        ReadWrite = ReadOnly | WriteOnly,
        Append = 0x0004,
        Truncate = 0x0008,
        Text = 0x0010,
        Unbuffered = 0x0020
    };
    /*** End: Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies). Under GPL Version 3 License ***/


signals:
    void fileNameChanged();
};

#endif // FILE_H
