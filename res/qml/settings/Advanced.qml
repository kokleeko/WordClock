/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15 as QtQuick
import QtQuick.Controls 2.15 as QtControls

import DeviceAccess 1.0

import "qrc:/qml/controls" as Controls

import "qrc:/js/Helpers.js" as HelpersJS

Controls.MenuSection
{
    title: qsTr("Advanced") + DeviceAccess.managers.translation.emptyString

    Controls.MenuItem
    {
        title: qsTr("Display as widget") + DeviceAccess.managers.translation.emptyString
        active: HelpersJS.isDesktop  // @disable-check M16  @disable-check M31

        QtControls.Switch
        {
            checked: root.isWidget

            onToggled: HelpersJS.updateDisplayMode(root)
            QtQuick.Component.onCompleted:
            {
                if (root.isWidget !== DeviceAccess.managers.persistence.value("Appearance/widget", false))
                    toggled()
            }
        }
    }
    Controls.MenuItem
    {
        title: "%1 (%2%)".arg(qsTr("Opacity")).arg(Math.floor(control ? control.value : 0)) +
               DeviceAccess.managers.translation.emptyString
        active: HelpersJS.isDesktop  // @disable-check M16  @disable-check M31
        enabled: !root.isFullScreen  // @disable-check M16  @disable-check M31
        details: qsTr("This setting is not persistent and enabled only when the application is not in fullscreen mode") +
                 DeviceAccess.managers.translation.emptyString

        QtControls.Slider
        {
            from: 10
            to: 100
            value: DeviceAccess.managers.persistence.value("Appearance/opacity", 1) * 100

            onMoved:
            {
                root.opacity = value/100
                DeviceAccess.managers.persistence.setValue("Appearance/opacity", root.opacity)
            }
        }
    }
    Controls.MenuItem
    {
        title: qsTr("Display as watermark") + DeviceAccess.managers.translation.emptyString
        active: HelpersJS.isDesktop  // @disable-check M16  @disable-check M31

        QtControls.Button
        {
            text: qsTr("Activate") + DeviceAccess.managers.translation.emptyString
            onClicked:
            {
                root.visibility = Window.Maximized
                root.opacity = Math.min(root.opacity, .85)
                root.flags = (Qt.WindowStaysOnTopHint | Qt.WindowTransparentForInput | Qt.FramelessWindowHint)
                settingsPanel.close()
            }
        }
    }
    Controls.MenuItem
    {
        id: timeZone

        function update()
        {
            wordClock.deltaTime = (wordClock.deviceOffset - extraControls[0].value) * 30
        }

        title: qsTr("Time Zone (%1)").arg(wordClock.selectedGMT) + DeviceAccess.managers.translation.emptyString
        extras: QtControls.Slider
        {
            from: -24
            stepSize: 1
            to: 28
            value: wordClock.deviceOffset

            onPressedChanged: if (!pressed) timeZone.update()
            onValueChanged: wordClock.selectedOffset = value
        }
        details: qsTr("This setting is not persistent, the time zone of the device <b>(%1)</b> is used each \
time the application is launched").arg(wordClock.deviceGMT) + DeviceAccess.managers.translation.emptyString

        QtControls.Button
        {
            text: qsTr("Reset") + DeviceAccess.managers.translation.emptyString
            enabled: wordClock.selectedGMT !== wordClock.deviceGMT

            onClicked:
            {
                timeZone.extraControls[0].value = wordClock.deviceOffset
                timeZone.update()
            }
        }
    }
    Controls.MenuItem
    {
        active: !HelpersJS.isWasm
        title: qsTr("Welcome popup") + DeviceAccess.managers.translation.emptyString

        QtControls.Switch
        {
            checked: root.showWelcome
            onCheckedChanged: DeviceAccess.managers.persistence.setValue("Welcome/showPopup", checked)
        }
        details: qsTr("Display at startup.") + DeviceAccess.managers.translation.emptyString
    }
}
