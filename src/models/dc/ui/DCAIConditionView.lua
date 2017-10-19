
local DCAnalysisUI = class("DCAnalysisUI", glg.SubWin)

function DCAnalysisUI:ctor(title)
	DCAnalysisUI.super.ctor(self, title)

	local btnMap = {}	
	local tBtn2 = gp.Button:create("gui_btn2.png")
	tBtn2:setTitle(_TT("dc","DC9"))
	tBtn2:setScaleEnable(true)
	self:addChild(tBtn2)
	btnMap["t2"] = tBtn2
	_VLP(tBtn2, self, vl.IN_T, cc.p(0, -20))
	local tBtn1 = gp.Button:create("gui_btn2.png")
	tBtn1:setTitle(_TT("dc","DC8"))
	tBtn1:setScaleEnable(true)
	self:addChild(tBtn1)
	btnMap["t1"] = tBtn1
	_VLP(tBtn1, tBtn2, vl.OUT_L, cc.p(-10, 0))
	local tBtn3 = gp.Button:create("gui_btn2.png")
	tBtn3:setTitle(_TT("dc","DC10"))
	tBtn3:setScaleEnable(true)
	self:addChild(tBtn3)
	btnMap["t3"] = tBtn3
	_VLP(tBtn3, tBtn2, vl.OUT_R, cc.p(10, 0))

	local function _tabCallback(selKey, tag)

	end

	local tabCtrl = gp.TabCtrl.new(btnMap, _tabCallback)
	tabCtrl:setSelKey("t1")
	
end

function DCAnalysisUI:onEnter()
	DCAnalysisUI.super.onEnter(self)
end

function DCAnalysisUI:onExit()	
	DCAnalysisUI.super.onExit(self)
end


return DCAnalysisUI

