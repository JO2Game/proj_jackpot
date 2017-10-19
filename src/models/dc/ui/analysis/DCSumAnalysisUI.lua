--[[
=================================
文件名：DCSumAnalysisUI.lua
作者：James Ou
=================================
]]

local DCSumAnalysisUI = class("DCSumAnalysisUI", glg.UIAnalysisView)

function DCSumAnalysisUI:ctor()
	DCSumAnalysisUI.super.ctor(self)
	self.graph:showCurve(false)
end

function DCSumAnalysisUI:onSelStageRange(fromStage, toStage)
	local sumDataList = GMODEL(MOD.DC):getDCStatisticsMgr():theSum(fromStage, toStage)
	self.graph:setDataList(sumDataList)
end


return DCSumAnalysisUI
