import QtQuick 2.0
import "../constants.js" as CONSTANTS

Rectangle {
    property string hint: 'Guide'
    property int icon: 1
    color: "#00111111"

    height: 34
    width: iconimage.width+hinttext.width+15

    Image {
        id: iconimage
        source: "../assets/controller/" + icon + ".png"
        fillMode: Image.PreserveAspectFit

        asynchronous: true

        width: 24
        height: 24
        anchors {
            leftMargin: 5
            verticalCenter: parent.verticalCenter
        }
    }

    Text {
        id:hinttext
        text: hint
        color: '#fff'
        font.pixelSize: CONSTANTS.FONT_SIZE
        anchors{
            left: iconimage.right
            verticalCenter: parent.verticalCenter
            leftMargin: 5
            rightMargin: 5
        }
    }
}