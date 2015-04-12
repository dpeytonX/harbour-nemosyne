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
#ifndef DEFAULTLOCALE_H
#define DEFAULTLOCALE_H

#include "localeitem.h"

class QQuickItem;
class QString;

class DefaultLocale: public LocaleItem {
    Q_OBJECT
    Q_PROPERTY(QString applicationDefaultText READ pretty WRITE setApplicationDefaultText NOTIFY applicationDefaultTextChanged)
    Q_PROPERTY(QString DEFAULT_APPLICATION_LOCALE READ applicationLocale CONSTANT)
public:
    explicit DefaultLocale(QQuickItem* parent=0);
    void setApplicationDefaultText(const QString& applicationDefaultText);
    virtual QString pretty() const;
    static QString applicationLocale();
    static const char* APPLICATION_LOCALE;

signals:
    void applicationDefaultTextChanged();

private:
    QString m_applicationDefaultText;
};

#endif // DEFAULTLOCALE_H
