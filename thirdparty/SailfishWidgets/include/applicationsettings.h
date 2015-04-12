/***************************************************************************
** This file is part of SailfishWidgets
**
** Copyright (c) 2014-2015 Dametrious Peyton
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

#ifndef APPLICATIONSETTINGS_H
#define APPLICATIONSETTINGS_H

#include <QtCore/qglobal.h>

#if defined(APPLICATIONSETTINGS_LIBRARY)
#  define APPLICATIONSETTINGS_EXPORT Q_DECL_EXPORT
#else
#  define APPLICATIONSETTINGS_EXPORT Q_DECL_IMPORT
#endif


#include <QEvent>
#include <QByteArray>
#include <QList>
#include <QQmlParserStatus>
#include <QQuickItem>
#include <QString>
#include <QSettings>
#include <QQmlProperty>
#include <QMap>
#include <QStringList>

#include "qmlpropertywrapper.h"

class APPLICATIONSETTINGS_EXPORT ApplicationSettings : public QQuickItem
{
    Q_OBJECT
    Q_DISABLE_COPY(ApplicationSettings)

    Q_INTERFACES(QQmlParserStatus)
    Q_PROPERTY(QString applicationName READ applicationName WRITE setApplicationName NOTIFY applicationNameChanged)
    Q_PROPERTY(QString fileName READ fileName WRITE setFileName NOTIFY fileNameChanged)

public:
    explicit ApplicationSettings();
    ApplicationSettings(QQuickItem *parent);

    ApplicationSettings(const QString& appName, const QString& fileName, QQuickItem *parent=0);

    ~ApplicationSettings();

    QString applicationName() const;

    QString fileName() const;

    QSettings* settings() const;

    void componentComplete();

    void setApplicationName(const QString& appName);

    void setFileName(const QString& fileName);

    bool isValid(const QString& property);

    Q_INVOKABLE QVariant value(const QString& setting);

public slots:
    void refresh();

    void setTarget(const QQmlProperty& qmlProperty);

    void updateProperty(const QString& propertyName, const QVariant& value);

private slots:
    void qmlPropertyLookup(QmlPropertyWrapper *wrapper);

signals:
    void applicationNameChanged();
    void fileNameChanged();
    void settingsInitialized();
    void settingsPropertyUpdated(QString name);

private:
    void firstLoad();
    bool isSettingsValid();
    void handleProperty(const QQmlProperty& qmlProperty, bool overwrite=true);

    static QList<ApplicationSettings*> s_allSettings;

    bool m_disposed;
    bool m_initialized;
    QMap<QString, QVariant>* m_pending;
    QList<QmlPropertyWrapper*>* m_userProperties;
    QSettings* m_settings;
    QString m_applicationName;
    QStringList* m_existingProperties;
    QString m_fileName;

};

#endif // APPLICATIONSETTINGS_H

