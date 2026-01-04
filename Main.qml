import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform

ApplicationWindow {
    width: 480
    height: 320
    visible: true
    title: "Bill Entry"

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 14
        width: parent.width * 0.85

        Label {
            text: "Enter a bill"
            font.pointSize: 18
            Layout.alignment: Qt.AlignHCenter
        }

        TextField {
            id: itemField
            placeholderText: "What was bought (e.g. Groceries)"
            Layout.fillWidth: true
        }

        TextField {
            id: amountField
            placeholderText: "Amount (e.g. 24.99)"
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            validator: DoubleValidator {
                bottom: 0.0
                decimals: 2
            }
            Layout.fillWidth: true
        }


        Button {
            text: "Add to bills file"
            onClicked: {
                const date = new Date().toISOString().slice(0, 10)
                const line =
                    date + " | " +
                    itemField.text + " | $" +
                    Number(amountField.text).toFixed(2)

                const path = saveDialog.file.toString().replace("file://", "")

                if (FileWriter.appendLine(path, line)) {
                    statusLabel.text = "Saved"
                    itemField.clear()
                    amountField.clear()
                } else {
                    statusLabel.text = "Failed to save"
                }
            }
        }

        Label {
            id: statusLabel
            text: ""
            color: "green"
            wrapMode: Text.Wrap
            Layout.alignment: Qt.AlignHCenter
        }
    }

    FileDialog {
        id: saveDialog
        title: "Select Bills File"
        fileMode: FileDialog.SaveFile
        nameFilters: ["Text files (*.txt)", "All files (*)"]
        defaultSuffix: "txt"

        onAccepted: {
            const fileUrl = saveDialog.file
            const date = new Date().toISOString().slice(0, 10)
            const line =
                date + " | " +
                itemField.text + " | $" +
                Number(amountField.text).toFixed(2) + "\n"

            var xhrRead = new XMLHttpRequest()
            xhrRead.open("GET", fileUrl, false)
            try {
                xhrRead.send()
            } catch (e) {
            }

            const existing = xhrRead.responseText || ""
            const updatedContent = existing + line

            var xhrWrite = new XMLHttpRequest()
            xhrWrite.open("PUT", fileUrl, false)
            xhrWrite.send(updatedContent)

            statusLabel.text = "Entry added successfully."
            statusLabel.color = "green"

            itemField.clear()
            amountField.clear()
        }

        onRejected: {
            statusLabel.text = "Save canceled."
            statusLabel.color = "orange"
        }
    }
}
