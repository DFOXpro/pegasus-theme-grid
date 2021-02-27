import QtQuick 2.6
import "../configs.js" as CONFIGS
import "../constants.js" as CONSTANTS
import "../layer_filter"

FocusScope {
    id: root

    property alias panelColor: panel.color
    property color textColor: CONFIGS.getForegroundColour(api)

    width: parent.parent.width * 0.4
    //content.width
    height: content.height

    Rectangle {
        id: panel
        color: CONFIGS.getMainColour(api)
        anchors.fill: parent
    }

    Column {
        id: content

        property int normalTextSize: CONSTANTS.FONT_SIZE
        property int selectedIndex: 0
        padding: vpx(20)
        spacing: vpx(8)

        width: parent.width

        Text {
            id: header
            text: "Settings"
            color: root.textColor
            font.bold: true
            font.pixelSize: vpx(26)
            height: font.pixelSize * 1.5
        }

        ComboBox {
            id: itemColour
            focus: true
            fontSize: content.normalTextSize
            label: "Colour"
            textColor: root.textColor
            model: CONSTANTS.AVAILABLE_COLOURS
            value: api.memory.get(CONSTANTS.MAIN_COLOUR) || ''
            onValueChange: updateColour()

            KeyNavigation.up: itemDisableGuide
            KeyNavigation.down: itemFavorites
        }

        CheckBox {
            id: itemFavorites
            text: "Enable favorite list"
            textColor: root.textColor
            fontSize: content.normalTextSize
            checked: api.memory.get(CONSTANTS.ENABLE_FAVORITES) || false
            onCheckedChange: updateFavorites()

            KeyNavigation.up: itemColour
            KeyNavigation.down: itemListAll
        }

        CheckBox {
            id: itemListAll
            text: "Enable all apps list"
            textColor: root.textColor
            fontSize: content.normalTextSize
            checked: api.memory.get(CONSTANTS.ENABLE_LIST_ALL) || false
            onCheckedChange: updateListAll()

            KeyNavigation.up: itemFavorites
            KeyNavigation.down: itemAndroid
        }

        CheckBox {
            id: itemAndroid
            text: "Enable Android app list"
            textColor: root.textColor
            fontSize: content.normalTextSize
            checked: api.memory.get(CONSTANTS.ENABLE_ANDROID) || false
            onCheckedChange: updateAndroid()

            KeyNavigation.up: itemListAll
            KeyNavigation.down: itemAutoplay
        }

        CheckBox {
            id: itemAutoplay
            text: "Enable video autoplay"
            textColor: root.textColor
            fontSize: content.normalTextSize
            checked: api.memory.get(CONSTANTS.ENABLE_AUTOPLAY) || false
            onCheckedChange: updateAutoplay()

            KeyNavigation.up: itemAndroid
            KeyNavigation.down: itemSmallGrid
        }
        
        CheckBox {
            id: itemSmallGrid
            text: "Use small grid items"
            textColor: root.textColor
            fontSize: content.normalTextSize
            checked: api.memory.get(CONSTANTS.SMALL_GRID) || false
            onCheckedChange: updateSmallGrid()

            KeyNavigation.up: itemAutoplay
            KeyNavigation.down: itemHideSupport
        }
        
        CheckBox {
            id: itemHideSupport
            text: "Only show cartridge/disk on details"
            textColor: root.textColor
            fontSize: content.normalTextSize
            checked: api.memory.get(CONSTANTS.HIDE_SUPPORT) || false
            onCheckedChange: updateHideSupport()

            KeyNavigation.up: itemSmallGrid
            KeyNavigation.down: itemLastOpen
        }

        CheckBox {
            id: itemLastOpen
            text: "Keep last open"
            textColor: root.textColor
            fontSize: content.normalTextSize
            checked: api.memory.get(CONSTANTS.ENABLE_LAST_OPEN) || false
            onCheckedChange: updateLastOpen()

            KeyNavigation.up: itemHideSupport
            KeyNavigation.down: itemDisableGuide
        }

        CheckBox {
            id: itemDisableGuide
            text: "Disable guide"
            textColor: root.textColor
            fontSize: content.normalTextSize
            checked: api.memory.get(CONSTANTS.DISABLE_GUIDE) || false
            onCheckedChange: updateDisableGuide()

            KeyNavigation.up: itemLastOpen
            KeyNavigation.down: itemColour
        }
    }

    function updateColour() {
        api.memory.set(CONSTANTS.MAIN_COLOUR, itemColour.value)
    }
    function updateAutoplay() {
        api.memory.set(CONSTANTS.ENABLE_AUTOPLAY, itemAutoplay.checked)
    }
    function updateFavorites() {
        api.memory.set(CONSTANTS.ENABLE_FAVORITES, itemFavorites.checked)
    }
    function updateListAll() {
        api.memory.set(CONSTANTS.ENABLE_LIST_ALL, itemListAll.checked)
    }
    function updateAndroid() {
        api.memory.set(CONSTANTS.ENABLE_ANDROID, itemAndroid.checked)
    }
    function updateSmallGrid() {
        api.memory.set(CONSTANTS.SMALL_GRID, itemSmallGrid.checked)
    }
    function updateHideSupport() {
        api.memory.set(CONSTANTS.HIDE_SUPPORT, itemHideSupport.checked)
    }
    function updateLastOpen() {
        api.memory.set(CONSTANTS.ENABLE_LAST_OPEN, itemLastOpen.checked)
        if(!itemLastOpen.checked) {
            api.memory.set('collection', '')
            api.memory.set('game', '')
        }
    }
    function updateDisableGuide() {
        api.memory.set(CONSTANTS.DISABLE_GUIDE, itemDisableGuide.checked)        
    }
}
