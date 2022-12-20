#include "messagestore.h"

MessageStore::MessageStore(QObject *parent)
: QObject(parent), filePath(QDir(
	QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)
).filePath("messages.dat")) {
	if (!QDir(
		QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)
	).exists()) {
		QDir(
			QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)
		).mkpath(".");
	}
	watcher.addPath(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
	watcher.addPath(filePath);
	loadData();
	connect(&watcher, SIGNAL(directoryChanged(QString)),
		this, SLOT(onDataDirModified(QString)));
	connect(&watcher, SIGNAL(fileChanged(QString)),
		this, SLOT(onDataFileModified(QString)));
}

void MessageStore::onDataDirModified(QString filePath) {
	Q_UNUSED(filePath);
	if (QFile(this->filePath).exists() &&
		!watcher.files().contains(this->filePath)) 
		watcher.addPath(this->filePath);
}

void MessageStore::onDataFileModified(QString filePath) {
	Q_UNUSED(filePath);
	loadData();
}

QList<QVariantMap> MessageStore::threads() {
	return m_threads;
}

void MessageStore::updateThreads(QList<QVariantMap> threads) {
	m_threads = threads;
	saveData();
}

void MessageStore::loadData() {
	QFile loadFile(filePath);
	if (!loadFile.open(QIODevice::ReadOnly)) return;

	QByteArray saveData = loadFile.readAll();
	QJsonDocument loadDoc(QCborValue::fromCbor(saveData).toMap().toJsonObject());

	if (!loadDoc.object()["threads"].isArray())
		return;

	QJsonArray threadJSONArray = loadDoc.object()["threads"].toArray();

	QList<QVariantMap> newThreads;
	foreach (QJsonValue threadJSON, threadJSONArray) {
		if (threadJSON.isObject()) {
			newThreads.append(threadJSON.toObject().toVariantMap());
		}
	}

	m_threads = newThreads;
	emit threadsChanged(m_threads);
}

void MessageStore::saveData() {
	QFile saveFile(filePath);
	if (!saveFile.open(QIODevice::WriteOnly))  {
		qWarning("Couldn't open save file.");
		return;
	}

	QJsonArray threads;
	foreach (QVariantMap t, m_threads) {
		threads.append(QJsonObject::fromVariantMap(t));
	}
	QJsonObject data;
	data.insert("threads", QJsonArray(threads));
	saveFile.write(QCborValue::fromJsonValue(data).toCbor());
	watcher.addPath(filePath);
}