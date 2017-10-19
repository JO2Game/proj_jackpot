
local BaseGame = require("baseLua/base/BaseGame")
local GameLogic = class("GameLogic", BaseGame)

function GameLogic:ctor()
	GameLogic.super.ctor(self)		
	LOG_INFO("GameLogic", "进入游戏逻辑")
end

function GameLogic:onInit()
	GameLogic.super.onInit(self)
	self.logicInit = loadLuaFile("LogicInit").new()
	
	self:setupCollectGarbage(60)
end

function GameLogic:onDelete()
	
	GameLogic.SocketEventHandle:onDelete()
	GameLogic.tickRegister:unRegister()
	
	self.logicInit:onDelete();
	self.logicInit = nil
	GameLogic.super.onDelete(self)
end


function GameLogic:connectServer()
	self:onConnected()
end

function GameLogic:onConnected()

	self:showMainUI();
end

function GameLogic:onDisconnect()

end

function GameLogic:showWorld()
	--display.runScene(gp.UIManager.gameRootNode)
	local world = GMODEL(MOD.WORLD)
	if world then
		world:showWorld()
	end
end

return GameLogic



