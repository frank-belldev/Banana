#include "downloadmanager.h"

DownloadManager::DownloadManager(QObject *parent) : QObject(parent)
{
    m_rProgressValue = 0;
    m_bLoading = false;
}

QString DownloadManager::name()
{
    return m_szName;
}

QString DownloadManager::password()
{
    return m_szPassword;
}

QString DownloadManager::url()
{
    return m_szUrl;
}

double DownloadManager::progress()
{
    return m_rProgressValue;
}

bool DownloadManager::loading()
{
    return m_bLoading;
}

void DownloadManager::setName(QString newName)
{
    m_szName = newName;
    emit nameChanged();
}

void DownloadManager::setPassword(QString newPassword)
{
    m_szPassword = newPassword;
    emit passwordChanged();
}

void DownloadManager::setUrl(QString newUrl)
{
    m_szUrl= newUrl;
    emit urlChanged();
}
