#ifndef LANGUAGE_PLUGIN_H
#define LANGUAGE_PLUGIN_H

#include <QQmlExtensionPlugin>

class LanguagePlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri);
};

#endif // LANGUAGE_PLUGIN_H

