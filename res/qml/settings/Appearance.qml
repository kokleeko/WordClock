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
    title: qsTr("Appearance") + DeviceAccess.managers.translation.emptyString

    Controls.MenuItem
    {
        title: (HelpersJS.isIos ? qsTr("Hide Status Bar")
                                : qsTr("FullScreen")) + DeviceAccess.managers.translation.emptyString
        active: HelpersJS.isDesktop || HelpersJS.isMobile

        QtControls.Switch
        {
            checked: root.isFullScreen

            onToggled: HelpersJS.updateVisibility(root)
            QtQuick.Component.onCompleted:
            {
                if (root.isFullScreen !== DeviceAccess.managers.persistence.value("Appearance/fullScreen", false))
                    toggled()
            }
        }
        details: qsTr("When the settings menu is closed, this can also be done by a long press on the clock.")
        /**/       + DeviceAccess.managers.translation.emptyString
    }
    Controls.MenuItem
    {
        active: isTouchDevice
        title: qsTr("Pie Menu") + DeviceAccess.managers.translation.emptyString
        model: [ QT_TR_NOOP("Right-handed"), QT_TR_NOOP("Left-handed") ]
        delegate: QtControls.Button
        {
            autoExclusive: true
            checkable: true
            checked: index === DeviceAccess.managers.persistence.value("Appearance/hand_preference", 0)
            text: qsTr(modelData) + DeviceAccess.managers.translation.emptyString

            onClicked:
            {
                isLeftHanded = Boolean(index)
                DeviceAccess.managers.persistence.setValue("Appearance/hand_preference", index)
            }
        }
        details: qsTr("Optimize its layout to match the preference of your hand when using your finger")
        /**/       + DeviceAccess.managers.translation.emptyString
    }
    Controls.MenuItem
    {
        id: applicationLanguage

        readonly property string defaultLanguage: Qt.locale().name.substr(0,2)

        function switchLanguage(language)
        {
            DeviceAccess.managers.translation.switchLanguage(language)
            DeviceAccess.managers.persistence.setValue("Appearance/uiLanguage", language)
        }

        title: qsTr("Application Language") + DeviceAccess.managers.translation.emptyString

        QtControls.Button
        {
            text: qsTr("Reset") + DeviceAccess.managers.translation.emptyString
            enabled: Object.keys(DeviceAccess.managers.translation.availableTranslations)
                     [applicationLanguage.extraControls[0].currentIndex] !== applicationLanguage.defaultLanguage

            onClicked:
            {
                applicationLanguage.switchLanguage(applicationLanguage.defaultLanguage)
                applicationLanguage.extraControls[0].currentIndex = Object
                .keys(DeviceAccess.managers.translation.availableTranslations)
                .indexOf(applicationLanguage.defaultLanguage)
            }
        }
        extras: QtQuick.ListView
        {
            delegate: QtControls.Button
            {
                autoExclusive: true
                checkable: true
                checked: index === Object.keys(DeviceAccess.managers.translation.availableTranslations).indexOf(
                             DeviceAccess.managers.persistence.value("Appearance/uiLanguage",
                                                                     applicationLanguage.defaultLanguage))
                text: modelData

                onClicked: applicationLanguage.switchLanguage(
                               Object.keys(DeviceAccess.managers.translation.availableTranslations)[index])
            }
            height: contentItem.childrenRect.height
            model: Object.values(DeviceAccess.managers.translation.availableTranslations)
            orientation: QtQuick.ListView.Horizontal
            spacing: 5
            width: parent.width
        }
    }
    Controls.MenuItem
    {
        title: qsTr("Clock Language") + DeviceAccess.managers.translation.emptyString

        QtControls.Button
        {
            text: qsTr("Reset") + DeviceAccess.managers.translation.emptyString
            enabled: wordClock.selected_language !== (DeviceAccess.managers.speech.enabled
                                                      ? Qt.locale().name
                                                      : Qt.locale().name.substring(0,2))

            onClicked: wordClock.selectLanguage(Qt.locale().name)
        }
        extras: QtQuick.ListView
        {
            delegate: QtControls.Button
            {
                autoExclusive: true
                checkable: true
                checked: index === Object.keys(wordClock.languages).indexOf(wordClock.selected_language)
                text: modelData

                onClicked: wordClock.selectLanguage(Object.keys(wordClock.languages)[index])

                QtControls.Label
                {
                    color: parent.icon.color
                    anchors { right: parent.right; bottom: parent.bottom; margins: 2 }
                    font: SmallestReadableFont
                    text: "%1/%2".arg(index+1).arg(parent.QtQuick.ListView.view.count)
                }
            }
            height: contentItem.childrenRect.height
            model: Object.values(wordClock.languages)
            orientation: QtQuick.ListView.Horizontal
            spacing: 5
            width: parent.width
        }
    }
    Controls.MenuItem
    {
        title: qsTr("Enable Special Message") + DeviceAccess.managers.translation.emptyString
        details: qsTr("Each grid contains a special message displayed in place of the hour for one minute at \
the following times: 00:00 (12:00 AM), 11:11 (11:11 AM), and 22:22 (10:22 PM). The (4-dot) minute indicator will \
display 0, 1, or 2 lights, allowing you to distinguish these different times.") +
                 DeviceAccess.managers.translation.emptyString

        QtControls.Switch
        {
            checked: wordClock.enable_special_message
            onToggled:
            {
                DeviceAccess.managers.persistence.setValue("Appearance/specialMessage",
                                                           wordClock.enable_special_message = checked)
                if (HelpersJS.isWeaklyEqual(wordClock.time, "00:00:am", "11:11:am", "22:22:pm"))
                    wordClock.updateTable()
            }
        }
    }
}
