local EMPTY_TEXT = "__  __  __  __  __  __"
local DCTheLotteryUI = class("DCTheLotteryUI", gp.BaseNode)

function DCTheLotteryUI:ctor()
	DCTheLotteryUI.super.ctor(self)
	self:setCatchTouch(true)
	self:setContentSize(gd.VISIBLE_SIZE)
	self:setGrayBackgroundEnable(true)
	local bg = gp.Scale9Sprite:create("TwoPanel_V2.png", false)
	local bgSize = bg:getContentSize()
	bg:setCapInsets(cc.rect(10,70,2,2))
	
	bg:setContentSize(cc.size(552, 260))
	self:addChild(bg)
	_VLP(bg)

	local titleLb = gp.Label:create("开奖", 24)	
	self:addChild(titleLb)
	_VLP(titleLb, bg, vl.IN_T, cc.p(0, -10))

	self.lotteryLb = gp.Label:create("", 52)
	self.lotteryLb:setAnchorPoint(cc.p(0, 0.5))
	self.lotteryLb:setOutline(2)
	self:addChild(self.lotteryLb)
	_VLP(self.lotteryLb, bg, vl.IN_L, cc.p(20, 10))

	self.resultList = {} --候选结果
	self.resultCnt = 0
	self.tmpResultList = {}
	self.tmpResultCnt = 0
	self.tmpIdx = 0
	self.curPos = 0--当前位置
	self.curStr = ""
	self.curData = {}--筛选出来的数据
	self.isStart = false


	local function _btnCloseCall( sender )
		JOWinMgr:Instance():removeWin(self)
	end

	local backBtn = gp.Button:create("CancelBtn_V2.png", _btnCloseCall)
	self:addChild(backBtn)
	_VLP(backBtn, bg, vl.IN_TR, cc.p(-10, -10))

	local function _resultCall(resultList, resultCnt)
		if resultCnt>0 then
			self.resultList = resultList
			self.resultCnt = resultCnt
		else
			self.resultList = {}
			self.resultCnt = 0
			gp.Factory:noiceView("没有数据")
		end
		self.tmpResultList = self.resultList
		self.tmpResultCnt = self.resultCnt

		self.isStart=true
		self.tmpIdx = 0
		self.curPos = 1--当前位置
		self.curStr = ""
		self.curData = {}
		gp.TickMgr:register(self)
	end
	

	local function _btnCall( sender )
		local tag = sender:getTag()
		if tag==1 then
			if self.curPos==0 or self.resultCnt==0 then return end
			self.curPos = 1
			self.isStart=true
			self.tmpIdx = 0			
			self.curStr = ""
			self.curData = {}
			self.tmpResultList = self.resultList
			self.tmpResultCnt = self.resultCnt
			gp.TickMgr:register(self)
		elseif tag==2 then
			self:reStart()
		elseif tag==3 then
			--初始没有数据的情况
			if self.resultCnt==0 then
				GMODEL(MOD.DC):getDCAnalysisMgr():start(self.selId, _resultCall)
				return
			end
			--未开始运转时
			if self.isStart==false then
				--大于6，已筛选一组完整号码，确认保存，并准备下一轮
				if self.curPos>=6 then
					--to save
					GMODEL(MOD.DC):getDCStorageMgr():insertDrawData(self.curData)
					self.curPos=1
					local curPixelFormat = cc.Texture2D:getDefaultAlphaPixelFormat()
					cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
					local particle = cc.ParticleSystemQuad:create("pub/particle/shengjiguangquan.plist")
					particle:setAutoRemoveOnFinish(true)
					self:addChild(particle)
					_VLP(particle)
					cc.Texture2D:setDefaultAlphaPixelFormat(curPixelFormat)
				else
					--下一轮开始
					self:reStart()
				end
			else
				--筛选每个位的号码
				local data = self.tmpResultList[self.tmpIdx]
				if data==nil then
					gp.Factory:noiceView("data==nil")
					return
				end
				local posData = data[self.curPos]
				self.curData[self.curPos] = posData
				if self.curPos==1 then
					self.curStr = string.format("%02d", posData)
				else
					self.curStr = string.format("%s, %02d", self.curStr, posData)
				end
				if self.curPos<6 then
					self:exactRange()
				end
				self.curPos = self.curPos+1
				if self.curPos>6 then
					self.curPos = 6
					self.isStart=false
					gp.TickMgr:unRegister(self)
				end
				
			end
		end
	end

	local nextNumBtn = gp.Button:create("AttackBtn_V2.png", _btnCall)
	self:addChild(nextNumBtn)
	nextNumBtn:setTag(3)
	_VLP(nextNumBtn, bg, vl.IN_BR, cc.p(-10, 30))

	local reloadBtn = gp.Button:create("DoBtn_V2.png", _btnCall)
	self:addChild(reloadBtn)
	reloadBtn:setTag(2)
	_VLP(reloadBtn, nextNumBtn, vl.OUT_L, cc.p(-10, 0))
	--reloadBtn:setVisible(false)
	
	local reloadAllBtn = gp.Button:create("ReturnBtn_V2.png", _btnCall)
	self:addChild(reloadAllBtn)
	reloadAllBtn:setTag(1)
	_VLP(reloadAllBtn, reloadBtn, vl.OUT_L, cc.p(-10, 0))
	reloadAllBtn:setVisible(false)
end

function DCTheLotteryUI:reStart()
	self.isStart=true
	self.curPos=1
	self.curStr = ""
	self.curData = {}
	self.tmpResultList = self.resultList
	self.tmpResultCnt = self.resultCnt
	gp.TickMgr:register(self)
end

function DCTheLotteryUI:exactRange()
	if self.curPos>0 then
		local tmpR = self.tmpResultList
		local cnt = self.tmpResultCnt
		self.tmpResultList = {}

		local isAccord = true
		for _,v in ipairs(tmpR) do
			isAccord = true
			for i=1,self.curPos do
				if v[i]~=self.curData[i] then
					isAccord = false
					break
				end
			end

			if isAccord==true then
				table.insert(self.tmpResultList, v)
			end
		end
		self.tmpResultCnt = #self.tmpResultList
		if self.tmpResultCnt==0 then
			gp.Factory:noiceView("没有合适的数据")
		end
	end
end

function DCTheLotteryUI:setSelId(selId)
	self.selId = selId
	self.resultList = {}
	self.resultCnt = 0
	self.lotteryLb:setString(EMPTY_TEXT)
end

function DCTheLotteryUI:tick()
	if self.isStart and self.curPos>0 and self.tmpResultCnt>0 then
		self.tmpIdx = math.random(1, self.tmpResultCnt)
		local data = self.tmpResultList[self.tmpIdx]
		if self.curPos==1 then
			self.lotteryLb:setString(string.format("%02d", data[self.curPos]))
		else
			self.lotteryLb:setString(string.format("%s, %02d", self.curStr, data[self.curPos]))
		end
	end
end

function DCTheLotteryUI:onEnter(  )
	DCTheLotteryUI.super.onEnter(self)

end


function DCTheLotteryUI:onExit()
	gp.TickMgr:unRegister(self)
	--gp.MessageMgr:unRegAll(self.sn)
	DCTheLotteryUI.super.onExit(self)
end

return DCTheLotteryUI

