
local ProjMain = class("ProjMain")

function ProjMain:ctor()
	LOG_INFO("ProjMain", "进入游戏逻辑")
	self:onInit()
end

function ProjMain:onInit()
	self.projInit = loadLuaFile("ProjInit").new()

	ProjToGame = loadLuaFile ("platform/ProjToGame").new()
	ProjToShell = loadLuaFile ("platform/ProjToShell").new()
end

function ProjMain:onDelete()
	self.projInit:onDelete();
	self.projInit = nil

	ProjToGame:onDelete()
	ProjToGame = nil
	ProjToShell:onDelete()
	ProjToShell = nil
end

function ProjMain:launch()
	--display.runScene(gp.UIManager.gameRootNode)
	local world = GMODEL(MOD.WORLD)
	if world then
		JOWinMgr:Instance():clearAll()
		world:showWorld()
	end
end

return ProjMain



