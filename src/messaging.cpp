#include "messaging.h"

Messaging::Messaging(int &argc, char *argv[]) : SingleApplication(argc, argv, true) {
	QCoreApplication::setApplicationName("cutie-messaging");
	QCoreApplication::setApplicationVersion("0.1");
	QCommandLineParser parser;
	parser.setApplicationDescription("Test helper");
	parser.addHelpOption();
	parser.addVersionOption();
	QCommandLineOption daemonOption(QStringList() << "d" << "daemon",
		QCoreApplication::translate("main", "Run only as daemon."));
	parser.addOption(daemonOption);
	parser.addPositionalArgument("number", 
		QCoreApplication::translate("main", "The number to open."));
	parser.process(*this);
	if(isSecondary()) {
		if (parser.positionalArguments().count() > 0)
			sendMessage(parser.positionalArguments().at(0).toUtf8().constData());
		else
			sendMessage(QString("x").toUtf8().constData());
		return;
	} 
	setQuitOnLastWindowClosed(false);
	QString locale = QLocale::system().name();
	translator.load(QString(":/i18n/cutie-messaging_") + locale);
	installTranslator(&translator);
	const QUrl url(QStringLiteral("qrc:/main.qml"));
	QObject::connect(
		&engine, &QQmlApplicationEngine::objectCreated, this,
		[url](QObject *obj, const QUrl &objUrl) {
		if (!obj && url == objUrl)
		QCoreApplication::exit(-1);
		},
		Qt::QueuedConnection);
	engine.rootContext()->setContextProperty("Store", &store);
	engine.load(url);

	if (!parser.isSet(daemonOption))
		QMetaObject::invokeMethod(engine.rootObjects()[0], "view", 
			Q_ARG(QVariant, QString(
				(parser.positionalArguments().count() > 0)
				? parser.positionalArguments().at(0)
				: QString("x")
			)));
	connect(this, &SingleApplication::receivedMessage, this, &Messaging::onReceivedMessage);
}

void Messaging::onReceivedMessage(int instanceId, QByteArray message) {
	Q_UNUSED(instanceId)
	QMetaObject::invokeMethod(engine.rootObjects()[0], "view", Q_ARG(QVariant, QString(message)));
}