#pragma once
#include <QFileSystemWatcher>
#include <QStandardPaths>
#include <QDir>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QCborMap>

class MessageStore : public QObject {
	Q_OBJECT
	Q_PROPERTY(QList<QVariantMap> threads READ threads WRITE updateThreads NOTIFY threadsChanged)
public:
	MessageStore(QObject *parent = 0);
	QList<QVariantMap> threads();
	void updateThreads(QList<QVariantMap> threads);

Q_SIGNALS:
	void threadsChanged(QList<QVariantMap> threads);

private Q_SLOTS:
	void onDataDirModified(QString filePath);
	void onDataFileModified(QString filePath);

private:
	void loadData();
	void saveData();

	QFileSystemWatcher watcher;
	QString filePath;
	QList<QVariantMap> m_threads;
};