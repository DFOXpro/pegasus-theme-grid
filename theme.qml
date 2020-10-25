// Pegasus Frontend
// Copyright (C) 2017-2020  Mátyás Mustoha
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

import QtQuick 2.0
import SortFilterProxyModel 0.2
import "layer_filter"
import "layer_gameinfo"
import "layer_grid"
import "layer_platform"
import "layer_guide"
import "layer_theme_settings"
import "configs.js" as CONFIGS
import "constants.js" as CONSTANTS

FocusScope {
    // Private
    SortFilterProxyModel {
        id: allFavorites
        sourceModel: api.allGames
        filters: ValueFilter { roleName: "favorite"; value: true; }
    }
    SortFilterProxyModel {
        id: allLastPlayed
        sourceModel: api.allGames
        filters: ValueFilter { roleName: "lastPlayed"; value: ""; inverted: true; }
        sorters: RoleSorter { roleName: "lastPlayed"; sortOrder: Qt.DescendingOrder }
    }
    SortFilterProxyModel {
        id: filterLastPlayed
        sourceModel: allLastPlayed
        filters: IndexFilter { maximumIndex: {
            if (allLastPlayed.count >= 17) return 17
            return allLastPlayed.count
        } }
    }

    property var allCollections: {
        let collections = api.collections.toVarArray()
        if(api.memory.get(CONSTANTS.ENABLE_FAVORITES)) collections.unshift({"name": "Favorites", "shortName": "favs", "games": allFavorites})
        if(api.memory.get(CONSTANTS.ENABLE_LAST_OPEN)) collections.unshift({"name": "Last Played", "shortName": "last", "games": filterLastPlayed})
        if(api.memory.get(CONSTANTS.ENABLE_LIST_ALL)) collections.unshift({"name": "All Games", "shortName": "all", "games": api.allGames})
        if(!api.memory.get(CONSTANTS.ENABLE_ANDROID)) collections.splice(collections.findIndex(c => c.shortName === "android"),1)
        // @See GameGrid originalModel

        return collections
    }
    Keys.onPressed: {
        // debug.text = event.key
        if (event.isAutoRepeat)
            return;

        if (api.keys.isPrevPage(event)) {
            event.accepted = true;
            if (api.memory.get(CONSTANTS.ENABLE_POSITIONS)) savePosition();            
            topbar.prev();
            if (api.memory.get(CONSTANTS.ENABLE_POSITIONS)) loadPosition();
            return;
        }
        if (api.keys.isNextPage(event)) {
            event.accepted = true;
            if (api.memory.get(CONSTANTS.ENABLE_POSITIONS)) savePosition();            
            topbar.next();
            if (api.memory.get(CONSTANTS.ENABLE_POSITIONS)) loadPosition();
            return;
        }
        if (api.keys.isDetails(event)) {
            event.accepted = true;
            gamepreview.focus = gamesupport.isDetailsActive = true;
            return;
        }
        if (api.keys.isFilters(event)) {
            event.accepted = true;
            filter.focus = true;
            return;
        }
        if (api.keys.isCancel(event)) {
            event.accepted = true;
            theme_settings.focus = true;
            return;
        }

        // Retroid SELECT Button
        if(event.key == 1048586) {
            event.accepted = true
            gamepreview.togglePlayPauseVideo()
            // debug.text = 'asd'
            return;
        }

        // Retroid Joystick
        if(event.key == 0) {
            event.accepted = true
            bottombar.toggleHelp()
            return;
        }
    }

    // Text {
    //     id: debug
    //     color: 'white'
    //     anchors {
    //         top: topbar.bottom
    //         topMargin: 10
    //     }
    //     text: ''
    // }

    PlatformBar {
        id: topbar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        z: 300

        model: allCollections // api.collections
        onCurrentIndexChanged: gamegrid.cells_need_recalc()
    }

    BackgroundImage {
        anchors.top: topbar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        game: gamegrid.currentGame
    }

    GameGrid {
        id: gamegrid

        focus: true

        gridWidth: parent.width * 0.66 - 20
        gridMarginTop: vpx(32)
        gridMarginRight: vpx(6)

        anchors.top: topbar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        originalModel: topbar.currentCollection.games
        filteredModel: filteredGames
        onDetailsRequested: {
            gamesupport.isDetailsActive = true
            gamepreview.focus = true
        }
        onLaunchRequested: launchGame()
    }

    GamePreview {
        id: gamepreview

        panelWidth: parent.width * 0.66
        anchors {
            top: topbar.bottom
            bottom: bottombar.top
            left: parent.left
            right: parent.right
        }

        game: gamegrid.currentGame
        onOpenRequested: {
            gamesupport.isDetailsActive = true
            gamepreview.focus = true
        }
        onCloseRequested: {
            gamesupport.isDetailsActive = false
            gamegrid.focus = true
        }
        onFiltersRequested: filter.focus = true
        onLaunchRequested: launchGame()
    }

    GameSupport {
        id: gamesupport

        anchors {
            right: parent.right
            bottom: bottombar.top
        }

        game: gamegrid.currentGame
        isDetailsActive: false
    }

    GuideBar {
        id: bottombar
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
    }

    ButtonHint {
        hint: '?'
        icon: 'input_STCK-L'
        colour: CONFIGS.getForegroundColour(api)
        ignoreGlobalVisible: true
        localVisible: !Globals.guideHintsAreVisible
        z: 400
        anchors {
            right: parent.right
            top: parent.top
            topMargin: -4
        }
    }
    ButtonHint {
        hint: 'Hide help'
        icon: 'input_STCK-L'
        backgroundcolour: "#88111111"
        anchors {
            left: parent.left
            bottom: parent.bottom
            bottomMargin: 34
        }
    }

    FilterLayer {
        id: filter
        anchors {
            top: topbar.bottom
        }
        onCloseRequested: gamegrid.focus = true
    }

    ThemeSettingsLayer {
        id: theme_settings
        anchors {
            bottom: bottombar.top
        }
        onCloseRequested: gamegrid.focus = true
    }

    SortFilterProxyModel {
        id: filteredGames
        sourceModel: topbar.currentCollection.games
        filters: [
            RegExpFilter {
                roleName: "title"
                pattern: filter.withTitle
                caseSensitivity: Qt.CaseInsensitive
                enabled: filter.withTitle
            },
            RangeFilter {
                roleName: "players"
                minimumValue: 2
                enabled: filter.withMultiplayer
            },
            ValueFilter {
                roleName: "favorite"
                value: true
                enabled: filter.withFavorite
            }
        ]
    }

    Component.onCompleted: {
        if (!api.memory.get(CONSTANTS.ENABLE_LAST_OPEN)) {
            topbar.currentIndex = 0;
            gamegrid.currentIndex = 0;
            if (api.memory.get(CONSTANTS.ENABLE_POSITIONS)) loadPosition();
            gamegrid.memoryLoaded = true;
            return
        }

        const last_collection = api.memory.get('collection');
        if (!last_collection)
            return;

        const last_coll_idx = allCollections
            .findIndex(c => c.name === last_collection);
        if (last_coll_idx < 0)
            return;

        topbar.currentIndex = last_coll_idx;

        const last_game = api.memory.get('game');
        if (!last_game)
            return;

        const last_game_idx = allCollections[last_coll_idx]
            .games
            .toVarArray()
            .findIndex(g => g.title === last_game);
        if (last_game_idx < 0) {
            if (api.memory.get(CONSTANTS.ENABLE_POSITIONS)) loadPosition();
            return;
        }

        gamegrid.currentIndex = last_game_idx;
        gamegrid.memoryLoaded = true;
    }

    Component.onDestruction: {
        if (api.memory.get(CONSTANTS.ENABLE_POSITIONS)) savePosition();
    }

    function clearPositions() {
        for (var i = 0; i < allCollections.length; i++) {
            api.memory.unset('collection' + i + 'GameIndex');
        }
    }

    function clearPositionsIfNeeded() {
        if ((api.memory.get('collectionCount') || 0) != allCollections.length) {
            api.memory.set('collectionCount', allCollections.length);        
            clearPositions();
        }
    }    

    function savePosition() {
        clearPositionsIfNeeded();
        api.memory.set('collection' + topbar.currentIndex + 'GameIndex', gamegrid.currentIndex);
    }

    function loadPosition() {
        clearPositionsIfNeeded();
        gamegrid.currentIndex = api.memory.get('collection' + topbar.currentIndex + 'GameIndex') || 0;
    }

    function launchGame() {
        if(api.memory.get(CONSTANTS.ENABLE_LAST_OPEN) || false) {
            api.memory.set('collection', topbar.currentCollection.name)
            api.memory.set('game', gamegrid.currentGame.title)
        }
        let currentGame
        if(gamegrid.currentGame.launch) currentGame = gamegrid.currentGame
        else if (topbar.currentCollection.shortName === "favs")
            currentGame = api.allGames.get(allFavorites.mapToSource(gamegrid.currentIndex))
        else if (topbar.currentCollection.shortName === "last")
            currentGame = api.allGames.get(allLastPlayed.mapToSource(gamegrid.currentIndex))
        currentGame.launch();
    }
}
