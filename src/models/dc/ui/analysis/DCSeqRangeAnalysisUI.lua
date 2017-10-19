--[[
=================================
文件名：DCSumAnalysisUI.lua
作者：James Ou
=================================
]]

local DCSeqRangeAnalysisUI = class("DCSeqRangeAnalysisUI", glg.UIAnalysisView)

function DCSeqRangeAnalysisUI:ctor()
	DCSeqRangeAnalysisUI.super.ctor(self)
	self.graph:showCurve(false)
	local function _ballBtnCall(sender)
		local idx=-1
		local title = sender:getTitleString()
		if title=="序号1" then
			idx = 2
		elseif title=="序号2" then
			idx = 3
		elseif title=="序号3" then
			idx = 4
		elseif title=="序号4" then
			idx = 5
		elseif title=="序号5" then
			idx = 6
		elseif title=="序号6" then
			idx = 1
		end
		if idx>0 then
			sender:setTitle("序号"..idx)
			self:setRangeIdx(idx)
		end
	end
	self.graph:setBallBtnCall(_ballBtnCall, "序号1")
	self.rangeMap = {}
	self.rangeIdx = 1
end

function DCSeqRangeAnalysisUI:setRangeIdx(idx)
	if idx<1 or self.rangeIdx==idx then return end
	self.rangeIdx = idx
	self.graph:setDataList(self.rangeMap[self.rangeIdx])
end

function DCSeqRangeAnalysisUI:onSelStageRange(fromStage, toStage)
	self.rangeMap = GMODEL(MOD.DC):getDCStatisticsMgr():sequenceRange(fromStage, toStage)
	self.graph:setDataList(self.rangeMap[self.rangeIdx])
end


return DCSeqRangeAnalysisUI
