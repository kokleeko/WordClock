/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the MIT license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "." as Controls
import "qrc:/js/Helpers.js" as Helpers

Controls.MenuItem {
    function hide(notify = true) {
        if (activatedPositionIndex !== -1 && wordClock.accessories[activatedPositionIndex] === name) {
            wordClock.accessories[activatedPositionIndex] = ""
            if (isMinutes && activatedPositionIndex === 0) {
                wordClock.accessories[2] = ""
                wordClock.accessories[3] = ""
                wordClock.accessories[5] = ""
            }
            if (notify) {
                wordClock.accessoriesChanged()
                activatedPositionIndex = -1
            }
        }
    }
    function activate(positionIndex, isMinutes) {
        if (activatedPositionIndex !== positionIndex) {
            hide(false)
            wordClock.accessories[positionIndex] = name
            if (isMinutes && positionIndex === 0) {
                wordClock.accessories[2] = name
                wordClock.accessories[3] = name
                wordClock.accessories[5] = name
            }
            wordClock.accessoriesChanged()
            activatedPositionIndex = positionIndex
        }
    }
    readonly property bool isMinutes: name === "minutes"
    required property string name
    property int activatedPositionIndex: -1
    property var positions: [ QT_TR_NOOP("Top"), QT_TR_NOOP("Bottom") ]
    withRadioGroup: true
    RadioButton { text: qsTr("Hide"); checked: true; ButtonGroup.group: radioGroup; onClicked: hide() }
    Component.onCompleted: { if (isMinutes) { positions.unshift(QT_TR_NOOP("Around")) } model = positions }
}