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

#ifndef FILELIST_H
#define FILELIST_H

#include <QDir>
#include <QList>
#include <QObject>
#include <QStandardPaths>
#include <QString>
#include <QQmlListProperty>

#include "file.h"

class Dir : public QObject,QDir
{
    Q_OBJECT

    Q_ENUMS(DirFilter)
    Q_ENUMS(DirSortFlag)

    Q_PROPERTY(bool root READ isRoot NOTIFY pathChanged)
    Q_PROPERTY(int filter READ filter WRITE setFilter NOTIFY filterChanged)
    Q_PROPERTY(int sort READ sort WRITE setSort NOTIFY sortChanged)
    Q_PROPERTY(QQmlListProperty<File> files READ files NOTIFY filesChanged)
    Q_PROPERTY(QString dirName READ dirName NOTIFY pathChanged)
    Q_PROPERTY(QString path READ path WRITE setPath NOTIFY pathChanged)
    Q_PROPERTY(QString XdgCache READ XdgCache CONSTANT)
    Q_PROPERTY(QString XdgConfig READ XdgConfig CONSTANT)
    Q_PROPERTY(QString XdgData READ XdgData CONSTANT)
    Q_PROPERTY(QString XdgHome READ XdgHome CONSTANT)
    Q_PROPERTY(QStringList entries READ entryList CONSTANT)

public:
    explicit Dir(QObject *parent = 0);

    /*** START: Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies). Under GPL Version 3 License ***/
    enum DirFilter { Dirs        = 0x001,
                     Files       = 0x002,
                     Drives      = 0x004,
                     NoSymLinks  = 0x008,
                     AllEntries  = Dirs | Files | Drives,
                     TypeMask    = 0x00f,

                     Readable    = 0x010,
                     Writable    = 0x020,
                     Executable  = 0x040,
                     PermissionMask    = 0x070,

                     Modified    = 0x080,
                     Hidden      = 0x100,
                     System      = 0x200,

                     AccessMask  = 0x3F0,

                     AllDirs       = 0x400,
                     CaseSensitive = 0x800,
                     NoDot         = 0x2000,
                     NoDotDot      = 0x4000,
                     NoDotAndDotDot = NoDot | NoDotDot,

                     NoFilter = -1
                   };

    enum DirSortFlag { Name        = 0x00,
                       Time        = 0x01,
                       Size        = 0x02,
                       Unsorted    = 0x03,
                       SortByMask  = 0x03,

                       DirsFirst   = 0x04,
                       Reversed    = 0x08,
                       IgnoreCase  = 0x10,
                       DirsLast    = 0x20,
                       LocaleAware = 0x40,
                       Type        = 0x80,
                       NoSort = -1
                     };
    /*** End: Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies). Under GPL Version 3 License ***/

    Q_INVOKABLE void refresh();

    QString XdgCache() const;
    QString XdgConfig() const;
    QString XdgData() const;
    QString XdgHome() const;

    QString dirName() const;

    QStringList entryList();

    QQmlListProperty<File> files();

    int filter() const;

    void setFilter(int filter);

    void setPath(const QString &p);

    void setSort(int sort);

    int sort() const;

    /*! \internal */
    QList<File *>& getList() {
        return m_list;
    }

    /*! \internal */
    void clearList() {
        foreach(File *o, m_list) {
            if(o) o->deleteLater(); //Could still be in use by QML
        }
        m_list.clear();
    }

    // QQmlListProperty helpers
    /*! \internal */
    static void dclAppendObject(QQmlListProperty<File> *obj, File *model) {
        Dir *backEnd = dynamic_cast<Dir*>(obj->object);
        if(backEnd) {
            backEnd->getList().append(model);
        }
    }

    /*! \internal */
    static void dclClearObject(QQmlListProperty<File> *obj) {
        Dir *backEnd = dynamic_cast<Dir*>(obj->object);
        if(backEnd) {
            backEnd->clearList();
        }
    }

    /*! \internal */
    static File* dclAtIndex(QQmlListProperty<File> *obj, int index) {
        Dir *backEnd = dynamic_cast<Dir*>(obj->object);
        if(backEnd) {
            return (backEnd->getList())[index];
        }
        return 0;
    }

    /*! \internal */
    static int dclCountObject(QQmlListProperty<File> *obj) {
        Dir *backEnd = dynamic_cast<Dir*>(obj->object);
        if(backEnd) {
            return backEnd->getList().size();
        }
        return 0;
    }

private:
    int m_filter;
    int m_sort;
    QList<File*> m_list;
    QQmlListProperty<File> m_fileList;

    static const QString m_cacheDir;
    static const QString m_configDir;
    static const QString m_dataDir;
    static const QString m_homeDir;

signals:

    void pathChanged();
    void filesChanged();
    void sortChanged();
    void filterChanged();
};

#endif // FILELIST_H
