
local GAME_BEGIN = 1000
local function EVENT_AUTO_ID( )
	GAME_BEGIN = GAME_BEGIN+1
	return GAME_BEGIN
end
--[[
这里定义的是游戏的事件ID,
SOCKET和登录相关的事件ID在LoginEvent中定义
]]
--用全局, 为了便于跟LoginEvent结合


ENT = ENT or {}

--主界面消息
ENT.DC_ADD_HISTORY_DATA = EVENT_AUTO_ID()
ENT.DC_ANALYSIS_RESULT = EVENT_AUTO_ID()
ENT.DC_DRAW_RESULT = EVENT_AUTO_ID()
ENT.DC_ADD_CONDITION_DATA = EVENT_AUTO_ID()


local function checkDuplicateError( )
	local t = {}
	for k,v in pairs(ENT) do
		if t[v] == true then
			LOG_ERROR("EventDefines", "==========EVENTID DUPLICATE %d", v)
		end
		t[v] = true
	end	
end 

checkDuplicateError()
