local theme_assets = require'beautiful.theme_assets'
local xresources = require'beautiful.xresources'
local dpi = xresources.apply_dpi

local gfs = require'gears.filesystem'

local theme = {}

theme.font = 'sans 8'

theme.bg_normal		= "#161616"
theme.bg_focus		= "#262626"
theme.bg_urgent		= "#be95ff"
theme.bg_minimize = "#393939"


theme.fg_normal		= "#08bdba"
theme.fg_focus		= "#ffffff"
theme.fg_urgent		= "#ffffff"
theme.fg_minimize = "#ffffff"

theme.useless_gap	= dpi(1)
theme.border_width  = dpi(1)
theme.border_normal = "#262626"
theme.border_focus  = "#be95ff"
theme.border_marked = "#ee5396"



local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
	taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
	taglist_square_size, theme.fg_normal
)

theme.wallpaper = os.getenv("HOME") .. "/wallpaper.png"

theme.icon_theme = nil


local themes_path = gfs.get_themes_dir()

theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

theme.notification_icon_size = 32

return theme
