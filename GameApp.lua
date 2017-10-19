
local GameApp = class("GameApp")

function GameApp:ctor()
	require (_gcf.LOAD_PROJ.."/GameConfig")
	--self:startUpdateModel()
   	self:startGameModel()
end

function GameApp:clearAll()
	JOEventDispatcher:Instance():clearAll()
	if self.update then
		self.update:onDelete()
		self.update = nil
	end
	if self.game then
		self.game:onDelete()
		self.game = nil
	end
	package.loaded["update/Update"] = nil
	package.loaded["GameLogic"] = nil
end

function GameApp:startUpdateModel()
	self:clearAll()
	self.update = require("update/Update").new()
	self.update:launch()
end

function GameApp:startGameModel()
	self:clearAll()
	self.game = require("GameLogic").new()
	self.game:showWorld()
end

return GameApp
