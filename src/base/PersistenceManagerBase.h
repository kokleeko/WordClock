/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include "ManagerBase.h"

#include <QString>
#include <QVariant>

class PersistenceManagerBase : public ManagerBase<PersistenceManagerBase>
{
    Q_OBJECT

public:
    explicit PersistenceManagerBase(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    Q_PROPERTY(bool enabled READ enabled CONSTANT)

    Q_INVOKABLE virtual QVariant value(QString /*key*/, QVariant /*defaultValue*/ = {}) const
    {
        Q_UNIMPLEMENTED();
        return {QVariant::String};
    }
    Q_INVOKABLE virtual void setValue(QString /*key*/, QVariant /*value*/) { Q_UNIMPLEMENTED(); }
    Q_INVOKABLE virtual void clear() { Q_UNIMPLEMENTED(); }
    Q_INVOKABLE virtual void printAll() { Q_UNIMPLEMENTED(); }

public slots:
    virtual void processAtSettingsReady()
    {
#ifdef QT_DEBUG
        printAll();
#endif
    }

signals:
    void settingsReady();
};

#ifndef Q_OS_WIN
template<>
QString ManagerBase<PersistenceManagerBase>::m_name;
#endif
