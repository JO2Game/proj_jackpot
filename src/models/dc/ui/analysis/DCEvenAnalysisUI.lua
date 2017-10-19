--[[
=================================
文件名：DCEvenAnalysisUI.lua
作者：James Ou
=================================
]]

local DCEvenAnalysisUI = class("DCEvenAnalysisUI", glg.UIAnalysisView)

function DCEvenAnalysisUI:ctor()
	DCEvenAnalysisUI.super.ctor(self)
	
end

function DCEvenAnalysisUI:onSelStageRange(fromStage, toStage)
	local redRateDataList = GMODEL(MOD.DC):getDCStatisticsMgr():theTwoEvenRate(fromStage, toStage)
	self.graph:setDataList(redRateDataList)
end


return DCEvenAnalysisUI
