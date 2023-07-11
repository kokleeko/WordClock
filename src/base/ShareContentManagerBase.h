/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include "ManagerBase.h"

#include <QVariant>

class ShareContentManagerBase : public ManagerBase<ShareContentManagerBase>
{
    Q_OBJECT

public:
    explicit ShareContentManagerBase(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    Q_INVOKABLE virtual void share(QVariant /*content*/) {}
};

template<>
QString ManagerBase<ShareContentManagerBase>::m_name;
