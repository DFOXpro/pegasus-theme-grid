.pragma library
// DFOXpro Colours guideline
// Take next guidelne for example when you chose the colour
// the default indigo is #4b0082
// THE indigo (screen dye) in the rp2 screen@50%brightness with sun light behind is more like #332b51

// also night colour means less blue light
const
    FONT_SIZE = 14,
    FOREGROUND_LIGHT = "#ffffff",
    BACKGROUND_LIGHT = "#bbbbbb",
    FOREGROUND_DARK = "#222222",
    BACKGROUND_DARK = "#555555",

//MAIN COLOURS LIST
    AVAILABLE_COLOURS = [
        'YELLOW',
        'BLUE',
        'PINK',
        'INDIGO',
        'BLACK',
        'GREY',
    ],

    INDIGO = "#332b51",
// @TODO fill with better colours
    // INDIGO_NIGHT = "#332b11",

// from retroid front page
    YELLOW = "#feca4f",
    // YELLOW_NIGHT = "#fce100",

    BLUE = "#9ad2da",
    // BLUE_NIGHT = "#000011",

    PINK = "#fe99a7",
    // PINK_NIGHT = "#fc9211",

    BLACK = "#343434", // the ps2 and master system
    GREY = "#cdc8c9", // the psx
    WHITE = "#e1dad8", // the snes & gb
    
    DEFAULT_MAIN_COLOUR = 'PINK',

// api.memory keys used
    MAIN_COLOUR = 'main_colour',
    ENABLE_FAVORITES = 'enable_favorites',
    ENABLE_LIST_ALL = 'enable_list_all',
    ENABLE_ANDROID = 'enable_android',
    ENABLE_AUTOPLAY = 'enable_autoplay',
    ENABLE_LAST_OPEN = 'enable_last_open',
    ENABLE_POSITIONS = 'enable_positions',
    SMALL_GRID = 'small_grid',
    HIDE_SUPPORT = 'hide_support'
