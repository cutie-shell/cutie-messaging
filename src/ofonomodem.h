#pragma once
#include <QDebug>
#include <QtQuick>
#include <QDBusInterface>
#include <QDBusConnection>
#include <QDBusReply>
#include <QDBusMetaType>

class OfonoModem : public QObject
{
    Q_OBJECT
    Q_PROPERTY (QString path READ path() NOTIFY pathChanged);
    Q_PROPERTY (QVariantMap data READ data() NOTIFY dataChanged);
    Q_PROPERTY (QVariantMap simData READ simData() NOTIFY simDataChanged);
public:
    OfonoModem(QObject *parent=0);
    ~OfonoModem();

    QString path();
    QVariantMap data();
    QVariantMap simData();

    void setPath(QString path);
Q_SIGNALS:
    void pathChanged(QString);
    void dataChanged(QVariantMap);
    void simDataChanged(QVariantMap);
	void incomingMessage(QString message, QVariantMap props);

public Q_SLOTS:
    void onPropertyChanged(QString name, QVariant value);
    void onSimPropertyChanged(QString name, QVariant value);
	void onIncomingMessage(QString message, QVariantMap props);

private:
    QString m_path;
    QVariantMap m_data;
    QVariantMap m_simData;
};