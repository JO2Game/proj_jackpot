--[[
=================================
文件名：DCAppearAnalysisUI.lua
作者：James Ou
=================================
]]

local DCAppearAnalysisUI = class("DCAppearAnalysisUI", glg.UIAnalysisView)

function DCAppearAnalysisUI:ctor()
	DCAppearAnalysisUI.super.ctor(self)
end

function DCAppearAnalysisUI:onSelStageRange(fromStage, toStage)
	local redRateDataList, blueRateDataList = GMODEL(MOD.DC):getDCStatisticsMgr():appearRate(fromStage, toStage)
	self.graph:setDataList(redRateDataList, blueRateDataList)
end


return DCAppearAnalysisUI
