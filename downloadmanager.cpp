#include "downloadmanager.h"

DownloadManager::DownloadManager(QObject *parent) : QObject(parent)
{
    m_bOverwrite = false;
    m_rProgressValue = 0;

    m_bLoading = false;

    connect(&m_qNAM, &QNetworkAccessManager::authenticationRequired,
            this, &DownloadManager::slotAuthenticationRequired);
#ifndef QT_NO_SSL
    connect(&m_qNAM, &QNetworkAccessManager::sslErrors,
            this, &DownloadManager::sslErrors);
#endif
}

QString DownloadManager::defaultUrl()
{
    //return tr("https://www.google.com/");
    return tr("https://cmake.org/files/v3.10/cmake-3.10.3-win32-x86.msi");
}

QString DownloadManager::defaultDir()
{
    QString downloadDirectory = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
    if (downloadDirectory.isEmpty() || !QFileInfo(downloadDirectory).isDir())
        downloadDirectory = QDir::currentPath();
    return downloadDirectory;
}

QString DownloadManager::defaultFile()
{
    return tr("download.tmp");
}

QString DownloadManager::url()
{
    return m_szUrl;
}

QString DownloadManager::dir()
{
    return m_szDir;
}

QString DownloadManager::file()
{
    return m_szFile;
}

double DownloadManager::progress()
{
    return m_rProgressValue;
}

bool DownloadManager::loading()
{
    return m_bLoading;
}

void DownloadManager::setUrl(QString newUrl)
{
    m_szUrl= newUrl;
    emit urlChanged();
}

void DownloadManager::setDir(QString newDir)
{
    m_szDir = newDir;
    emit dirChanged();
}

void DownloadManager::setFile(QString newFile)
{
    m_szFile = newFile;
    emit fileChanged();
}

void DownloadManager::setProgress(double newProg)
{
    m_rProgressValue = newProg;
    emit progressChanged();
}

void DownloadManager::setLoading(bool newLoadingState)
{
    m_bLoading = newLoadingState;
    emit loadingChanged();
}

void DownloadManager::startRequest(const QUrl& url)
{
    m_qReply = m_qNAM.get(QNetworkRequest(url));
    connect(m_qReply, &QNetworkReply::finished, this, &DownloadManager::httpFinished);
    connect(m_qReply, &QIODevice::readyRead, this, &DownloadManager::httpReadyRead);

    //connect(progressDialog, &QProgressDialog::canceled, this, &DownloadManager::cancelDownload);
    connect(m_qReply, &QNetworkReply::downloadProgress, this, [=] (qint64 bytesReceived, qint64 bytesTotal) {
        if (bytesTotal <= 0)
        {
            setProgress(0);
            return;
        }
        setProgress(bytesReceived * 0.1 / bytesTotal);
    });
    connect(m_qReply, &QNetworkReply::finished, this, &DownloadManager::cancelDownload);

    setLoading(true);
}

void DownloadManager::downloadFile()
{
    setProgress(0);

    const QUrl newUrl = QUrl::fromUserInput(m_szUrl);
    if (!newUrl.isValid()) {
        sendMsg(tr("Error"), tr("Invalid URL: %1: %2").arg(m_szUrl, newUrl.errorString()));
        return;
    }

    QString fileName = m_szFile;
    QString downloadDirectory = m_szDir;
    if (!downloadDirectory.isEmpty() && QFileInfo(downloadDirectory).isDir())
        fileName.prepend(downloadDirectory + '/');
    qDebug() << m_bOverwrite;
    if (QFile::exists(fileName)) {
        if (m_bOverwrite)
            QFile::remove(fileName);
        else
        {
            sendMsg(tr("Error"), tr("%1 already exists.").arg(fileName));
            return;
        }
    }

    m_qFile = openFileForWrite(fileName);
    if (!m_qFile)
    {
        sendMsg(tr("Error"), tr("Can not open file"));
        return;
    }

    setLoading(true);

    // schedule the request
    startRequest(newUrl);
}

QFile* DownloadManager::openFileForWrite(const QString &fileName)
{
    QScopedPointer<QFile> file(new QFile(fileName));
    if (!file->open(QIODevice::WriteOnly)) {
        sendMsg(tr("Error"),
                tr("Unable to save the file %1: %2.").arg(QDir::toNativeSeparators(fileName),
                file->errorString()));
        return Q_NULLPTR;
    }
    return file.take();
}

void DownloadManager::cancelDownload()
{
    //statusLabel->setText(tr("Download canceled."));
    setLoading(false);
    delete m_qReply;
}

void DownloadManager::httpFinished()
{
    QFileInfo fi;
    if (m_qFile) {
        fi.setFile(m_qFile->fileName());
        m_qFile->close();
        delete m_qFile;
        m_qFile = Q_NULLPTR;
    }

    if (!m_bLoading) {
        m_qReply->deleteLater();
        m_qReply = Q_NULLPTR;
        return;
    }

    if (m_qReply->error()) {
        QFile::remove(fi.absoluteFilePath());
        sendMsg("Download failed!.", m_qReply->errorString());
        setLoading(false);
        m_qReply->deleteLater();
        m_qReply = Q_NULLPTR;
        return;
    }
    /*
    statusLabel->setText(tr("Downloaded %1 bytes to %2\nin\n%3")
                         .arg(fi.size()).arg(fi.fileName(), QDir::toNativeSeparators(fi.absolutePath())));*/
    //if (launchCheckBox->isChecked())
    QDesktopServices::openUrl(QUrl::fromLocalFile(fi.absoluteFilePath()));
    setLoading(false);
}

void DownloadManager::httpReadyRead()
{
    if (m_qFile)
        m_qFile->write(m_qReply->readAll());
}

void DownloadManager::slotAuthenticationRequired(QNetworkReply*,QAuthenticator *)
{
    /*
    QDialog authenticationDialog;
    Ui::Dialog ui;
    ui.setupUi(&authenticationDialog);
    authenticationDialog.adjustSize();
    ui.siteDescription->setText(tr("%1 at %2").arg(authenticator->realm(), url.host()));*/

    // Did the URL have information? Fill the UI
    // This is only relevant if the URL-supplied credentials were wrong
    /*
    ui.userEdit->setText(url.userName());
    ui.passwordEdit->setText(url.password());

    if (authenticationDialog.exec() == QDialog::Accepted) {
        authenticator->setUser(ui.userEdit->text());
        authenticator->setPassword(ui.passwordEdit->text());
    }
    */
}

#ifndef QT_NO_SSL
void DownloadManager::sslErrors(QNetworkReply*,const QList<QSslError> &errors)
{
    QString errorString;
    foreach (const QSslError &error, errors) {
        if (!errorString.isEmpty())
            errorString += '\n';
        errorString += error.errorString();
    }
    sendMsg(tr("SSL Errors"),
            tr("One or more SSL errors has occurred:\n%1").arg(errorString));
    //    m_qReply->ignoreSslErrors();
}
#endif
