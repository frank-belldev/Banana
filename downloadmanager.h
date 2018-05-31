#ifndef DOWNLOADMANAGER_H
#define DOWNLOADMANAGER_H

#include <QtCore>
#include <QObject>
#include <QtNetwork>

class DownloadManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(QString dir READ dir WRITE setDir NOTIFY dirChanged)
    Q_PROPERTY(QString file READ file WRITE setFile NOTIFY fileChanged)
    Q_PROPERTY(double progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)
public:
    explicit DownloadManager(QObject *parent = 0);

private:
    QString m_szUrl;
    QString m_szDir;
    QString m_szFile;
    double m_rProgressValue;
    bool m_bLoading;

private:
    QNetworkAccessManager m_qNAM;
    QNetworkReply *m_qReply;
    QFile *m_qFile;
    bool m_bOverwrite;
    bool m_bHttpRequestAborted;

private:
    QFile *openFileForWrite(const QString &fileName);

signals:
    void sendMsg(QString, QString);

    void urlChanged();
    void dirChanged();
    void fileChanged();
    void progressChanged();
    void loadingChanged();

public slots:
    void setOverwrite(bool newOV) { m_bOverwrite = newOV; }
    QString defaultUrl();
    QString defaultDir();
    QString defaultFile();
    void downloadFile();
    void cancelDownload();
    void httpFinished();
    void httpReadyRead();
    void slotAuthenticationRequired(QNetworkReply*,QAuthenticator *);
#ifndef QT_NO_SSL
    void sslErrors(QNetworkReply*,const QList<QSslError> &errors);
#endif

public slots:
    QString url();
    QString dir();
    QString file();
    double progress();
    bool loading();

    void setUrl(QString);
    void setDir(QString);
    void setFile(QString);
    void setProgress(double);
    void setLoading(bool);

    void startRequest(const QUrl&);
};

#endif // DOWNLOADMANAGER_H
