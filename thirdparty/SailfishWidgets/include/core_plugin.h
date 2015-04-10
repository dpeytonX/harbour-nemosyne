#ifndef CORE_PLUGIN_H
#define CORE_PLUGIN_H

#include <QQmlExtensionPlugin>

class CorePlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri);
};

#endif // CORE_PLUGIN_H

