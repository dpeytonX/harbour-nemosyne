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

#ifndef QMLPROPERTYWRAPPER_H
#define QMLPROPERTYWRAPPER_H

#include <QObject>
#include <QQmlProperty>

class QmlPropertyWrapper : public QObject
{
    Q_OBJECT
public:
    explicit QmlPropertyWrapper(QQmlProperty property, QObject *parent = 0);

    QQmlProperty property() const {return m_property;}

signals:
    void notifySignal(QmlPropertyWrapper *property);

public slots:
    void notified();

private:
    QQmlProperty m_property;

};

#endif // QMLPROPERTYWRAPPER_H
