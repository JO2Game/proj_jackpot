--[[
=================================
文件名：DCIntervalAnalysisUI.lua
作者：James Ou
=================================
]]

local DCIntervalAnalysisUI = class("DCIntervalAnalysisUI", glg.UIAnalysisView)

function DCIntervalAnalysisUI:ctor()
	DCIntervalAnalysisUI.super.ctor(self)
	
end

function DCIntervalAnalysisUI:onSelStageRange(fromStage, toStage)
	local redRateDataList = GMODEL(MOD.DC):getDCStatisticsMgr():IntervalEvenRate(fromStage, toStage)
	self.graph:setDataList(redRateDataList)
end


return DCIntervalAnalysisUI
