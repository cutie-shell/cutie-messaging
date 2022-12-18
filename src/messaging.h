#pragma once
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QCommandLineParser>
#include <QProcess>
#include <QTranslator>
#include <QDBusInterface>
#include <QDBusConnection>
#include <QDBusReply>
#include <QDBusMetaType>
#include <singleapplication.h>
#include "ofonomodem.h"

class Messaging : public SingleApplication {
	Q_OBJECT
public:
	Messaging(int &argc, char *argv[]);
public Q_SLOTS:
	void onInstanceStarted();
	void onIncomingMessage(QString message, QVariantMap props);
private:
	QQmlApplicationEngine engine;
	QTranslator translator;
	QMap<QString,OfonoModem *> m_modems;
};

typedef QPair<QDBusObjectPath, QVariantMap> OfonoServicePair;
typedef QList<OfonoServicePair> OfonoServiceList;

Q_DECLARE_METATYPE(OfonoServicePair)
Q_DECLARE_METATYPE(OfonoServiceList)