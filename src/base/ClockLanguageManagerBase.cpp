#include "ClockLanguageManagerBase.h"

#include <QDir>
#include <QFileInfo>

template<>
QString ManagerBase<ClockLanguageManagerBase>::m_name{"clockLanguage"};

void ClockLanguageManagerBase::detectClockAvailableLocales()
{
    QFileInfoList wordClockLanguages = QDir(":/qml/languages").entryInfoList({"[^.]*.qml"});
    for (const auto &fileInfo : wordClockLanguages) {
        const QString baseName(fileInfo.baseName());
        if (baseName != QStringLiteral("Language")) {
            const QLocale locale(baseName);
            const bool hasCountryCode = (baseName.split("_").length() == 2);
            QString name = QLocale::languageToString(locale.language());
            if (hasCountryCode)
                name.append(QString(" (%1)").arg(locale.nativeCountryName()));
            m_clockAvailableLocales.insert(baseName, name);
        }
    }
}

ClockLanguageManagerBase::ClockLanguageManagerBase(QObject *parent)
    : ManagerBase<ClockLanguageManagerBase>(parent)
{
    detectClockAvailableLocales();
}

QVariantMap ClockLanguageManagerBase::clockAvailableLocales() const
{
    return m_clockAvailableLocales;
}
