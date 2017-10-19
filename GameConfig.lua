_gcf = _gcf or {}

--******************GAME配置****************************************
_gcf.NO_LOGIN = false
_gcf.NO_NET_MESSAGE = false
if _gcf.NO_LOGIN == true then
    _gcf.NO_NET_MESSAGE = true
end

--******************基本高等设置****************************************
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
_gcf.DEBUG = 2

-- display FPS stats on screen
_gcf.DEBUG_FPS = true

-- dump memory info every 10 seconds
_gcf.DEBUG_MEM = true

if _gcf.DEBUG == 0 then
    _gcf.DEBUG_FPS = false
    _gcf.DEBUG_MEM = false
end
-- load deprecated API
_gcf.LOAD_DEPRECATED_API = false

-- load shortcodes API
_gcf.LOAD_SHORTCODES_API = true

-- design resolution
_gcf.DESIGN_WIDTH = 1136-- CONFIG_SCREEN_WIDTH  = 640
_gcf.DESIGN_HEIGHT = 640-- CONFIG_SCREEN_HEIGHT = 960
---[[
_gcf.SCREEN_WIDTH = 1136-- CONFIG_SCREEN_WIDTH  = 640
_gcf.SCREEN_HEIGHT = 640--CONFIG_SCREEN_HEIGHT = 960
--]]
--[[
_gcf.SCREEN_WIDTH = 453-- CONFIG_SCREEN_WIDTH  = 640
_gcf.SCREEN_HEIGHT = 260--CONFIG_SCREEN_HEIGHT = 960
--]]
-- auto scale mode
--_gcf.DESIGH_RESOLUTION = cc.ResolutionPolicy.FIXED_WIDTH
_gcf.DESIGH_RESOLUTION = cc.ResolutionPolicy.FIXED_HEIGHT
_gcf.SCREEN_SCALE = 1.0 --CONFIG_SCREEN_AUTOSCALE = "FIXED_WIDTH"
_gcf.ZOOM_FACTOR = 1
--******************日志设置****************************************
_gcf.LOG_SHOW = true
_gcf.LOG_TITLE = "DCBALL"
_gcf.LOG_LIMIT_LEVEL = "DEBUG"
_gcf.LOG_IN_TICK = true
_gcf.LOG_EXCLUSIVE = {"yeash!!","WorldMgr"}
--lua日志用
_gcf.LOG_IGNORE_DEBUG = {}
_gcf.LOG_IGNORE_INFO = {}
_gcf.LOG_IGNORE_WARN = {}
_gcf.LOG_IGNORE_ERROR = {}

--******************网络配置****************************************
_gcf.SERVER_HTTP = "http://static.wpzj.gzyouai.com/servers/uc.json" --正式服UC
_gcf.IP="192.168.1.101"
_gcf.PORT=18081

_gcf.UPDATE_MODEL_HTTP=""

--******************原有配置****************************************
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = _gcf.DEBUG

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = _gcf.DEBUG_FPS

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = false

-- for module display
--[[
CC_DESIGN_RESOLUTION = {
    width = 960,
    height = 640,
    autoscale = "FIXED_HEIGHT",
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        if ratio <= 1.34 then
            -- iPad 768*1024(1536*2048) is 4:3 screen
            return {autoscale = "FIXED_WIDTH"}
        end
    end
}
--]]