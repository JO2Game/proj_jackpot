local FUNCTION_CELL_SIZE = cc.size(280, 80)
local DCBallUI = class("DCBallUI", glg.MainWin)

function DCBallUI:ctor()
	DCBallUI.super.ctor(self)

	self.topView = MCLASS(MOD.DC, "DCTopMessageView").new()
	self:addChild(self.topView,2)
	_VLP(self.topView, self, vl.IN_T)

	self.dataAnalysis = MCLASS(MOD.DC, "DCDataAnalysisUI").new()
	self:addChild(self.dataAnalysis)
	_VLP(self.dataAnalysis, self, vl.IN_B)
	
end

function DCBallUI:onEnter(  )
	DCBallUI.super.onEnter(self)

	local function _ADD_HISTORY_DATA_Handle()
		local data = GMODEL(MOD.DC):getDCMgr():getNewDCData()
		
		--local context = string.format("%d,%d,%d,%d,%d,%d|%d [%d]", data.r1,data.r2,data.r3,data.r4,data.r5,data.r6,data.b1,data.stage)
		local context = string.format("%s|%d [%d]", table.concat(data.r, ","),data.b1,data.stage)
		self.topView:setNewData(context)

		GMODEL(MOD.DC):getDCStatisticsMgr().coolHot_all = nil
		GMODEL(MOD.DC):getDCStatisticsMgr().coolHot_noAll = nil
	end
	
	gp.MessageMgr:regEvent(self.sn, ENT.DC_ADD_HISTORY_DATA, _ADD_HISTORY_DATA_Handle)

	_ADD_HISTORY_DATA_Handle()	
end


function DCBallUI:onExit()
	gp.MessageMgr:unRegAll(self.sn)
end

return DCBallUI

