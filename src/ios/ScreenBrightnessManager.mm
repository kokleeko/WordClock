/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "ScreenBrightnessManager.h"

ScreenBrightnessManager::ScreenBrightnessManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : ScreenBrightnessManagerBase{deviceAccess, parent}
{
    m_enabled = true;
}

void ScreenBrightnessManager::setBrightnessRequested(float brightness) {}
