#ifndef DOWNLOADMANAGER_H
#define DOWNLOADMANAGER_H

#include <QObject>

class DownloadManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY passwordChanged)
    Q_PROPERTY(QString url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(double progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)
public:
    explicit DownloadManager(QObject *parent = 0);

private:
    QString m_szName;
    QString m_szPassword;
    QString m_szUrl;
    double m_rProgressValue;
    bool m_bLoading;

signals:
    void nameChanged();
    void passwordChanged();
    void urlChanged();
    void progressChanged();
    void loadingChanged();

public slots:
    QString name();
    QString password();
    QString url();
    double progress();
    bool loading();

    void setName(QString);
    void setPassword(QString);
    void setUrl(QString);
};

#endif // DOWNLOADMANAGER_H
