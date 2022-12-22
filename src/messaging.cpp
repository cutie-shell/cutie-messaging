#include "messaging.h"

Messaging::Messaging(int &argc, char *argv[]) : SingleApplication(argc, argv, false) {
	QCoreApplication::setApplicationName("cutie-messaging");
	QCoreApplication::setApplicationVersion("0.1");
	QCommandLineParser parser;
	parser.setApplicationDescription("Test helper");
	parser.addHelpOption();
	parser.addVersionOption();
	QCommandLineOption daemonOption(QStringList() << "d" << "daemon",
		QCoreApplication::translate("main", "Run only as daemon."));
	parser.addOption(daemonOption);
	parser.process(*this);
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
		QMetaObject::invokeMethod(engine.rootObjects()[0], "view");
	connect(this, SIGNAL(instanceStarted()), this, SLOT(onInstanceStarted()));
}

void Messaging::onInstanceStarted() {
	QMetaObject::invokeMethod(engine.rootObjects()[0], "view");
}