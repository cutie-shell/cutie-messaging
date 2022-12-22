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
#include "messagestore.h"

class Messaging : public SingleApplication {
	Q_OBJECT
public:
	Messaging(int &argc, char *argv[]);
public Q_SLOTS:
	void onInstanceStarted();
private:
	QQmlApplicationEngine engine;
	QTranslator translator;
	MessageStore store;
};