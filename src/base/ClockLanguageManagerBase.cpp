/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "ClockLanguageManagerBase.h"

#include <QDir>
#include <QFileInfo>

template<>
QString ManagerBase<ClockLanguageManagerBase>::m_name{QStringLiteral("clockLanguage")};

ClockLanguageManagerBase::ClockLanguageManagerBase(DeviceAccessBase *deviceAccess, QObject *parent)
    : ManagerBase(deviceAccess, parent)
{}
