/***************************************************************************
** This file is part of SailfishWidgets
**
** Copyright (c) 2015 Dametrious Peyton
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

#ifndef INSTALLEDLOCALES_H
#define INSTALLEDLOCALES_H

#include <QQuickItem>
#include <QQmlListProperty>
#include <QLocale>

#include "localeitem.h"

template <typename T>
class QList;

class InstalledLocales : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<LocaleItem> locales READ locales NOTIFY localesChanged)
    Q_PROPERTY(bool includeAppDefault READ includeAppDefault WRITE setIncludeAppDefault)
    Q_PROPERTY(QString appName READ appName WRITE setAppName NOTIFY appNameChanged)
    Q_PROPERTY(QString applicationDefaultText READ applicationDefaultText WRITE setApplicationDefaultText NOTIFY applicationDefaultTextChanged)
public:
    InstalledLocales(QQuickItem *parent=0);
    bool includeAppDefault() const;
    void setIncludeAppDefault(bool includeAppDefault);
    QQmlListProperty<LocaleItem> locales();
    QString appName() const;
    void setAppName(const QString& appName);
    QString applicationDefaultText() const;
    void setApplicationDefaultText(const QString& applicationDefaultText);
    Q_INVOKABLE int findLocale(const QString& locale);

    static LocaleItem* localeAt(QQmlListProperty<LocaleItem> *property, int index);
    static int localeCount(QQmlListProperty<LocaleItem> *property);

signals:
    void localesChanged();
    void appNameChanged();
    void applicationDefaultTextChanged();

private:
    QList<LocaleItem*> m_availableLocales;
    QString m_appName;
    QString m_applicationDefaultText;
    bool m_includeAppDefault;
};

#endif // LOCALEHELPER_H
