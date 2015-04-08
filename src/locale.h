#ifndef LOCALE_H
#define LOCALE_H

#include <QObject>
#include <QLocale>
#include <QString>

/*!
 * Represents a locale in a UI friendly manner
 */
class Locale : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString language READ language)
    Q_PROPERTY(QString country READ country)
    Q_PROPERTY(QString pretty READ pretty)
    Q_PROPERTY(QString locale READ locale WRITE setLocale NOTIFY localeChanged)
public:
    explicit Locale(QObject *parent = 0);
    Locale(const QString& locale, QObject *parent=0) : QObject(parent), m_locale(locale) {

    }

    QString locale() const {
        return m_locale;
    }

    void setLocale(const QString& locale) {
        m_locale = locale;
        emit localeChanged();
    }

    virtual QString pretty() const {
        QString lang(language(m_locale));
        QString ctry(country(m_locale));
        if(ctry.isEmpty()) {
            return lang;
        }
        return lang + " (" + ctry + ")";
    }

    QString language() const {
        return QLocale(locale).nativeLanguageName();
    }

    QString country(const QString& locale) const {
        return QLocale(locale).nativeCountryName();
    }

    friend bool operator==(const Locale& lhs, const Locale& rhs);

signals:
    void localeChanged();

protected:
    QString m_locale;
};

inline bool operator==(const Locale& lhs, const Locale& rhs) {
    return lhs.locale == rhs.locale;
}

/*!
 * Applications usually have a default translation file which is not suffixed with a country/region specifier.
 *
 * This special file is given the locale of "app" and instead of corresponding to a specific language, it just represents
 * the default translation bundle if no others have been installed.
 */
class DefaultLocale: public Locale {
    Q_OBJECT
    Q_PROPERTY(QString applicationDefaultText READ pretty WRITE setApplicationDefaultText)
    Q_PROPERTY(QString DEFAULT_APPLICATION_LOCALE READ applicationLocale CONSTANT)
public:
    explicit DefaultLocale(QObject* parent=0) : Locale(parent, APPLICATION_LOCALE) {
    }

    QString pretty() const {
        return m_applicationDefaultText;
    }

    void setApplicationDefaultText(const QString& applicationDefaultText) {
        m_applicationDefaultText = applicationDefaultText;
        emit applicationDefaultTextChanged();
    }

    static QString applicationLocale() const {
        return APPLICATION_LOCALE;
    }

    static const QString APPLICATION_LOCALE;

signals:
    void applicationDefaultTextChanged();

private:
    QString m_applicationDefaultText;
};

DefaultLocale::APPLICATION_LOCALE("app");

#endif // LOCALE_H
