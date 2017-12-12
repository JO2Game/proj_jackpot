local EMPTY_TEXT = "__  __  __  __  __  __"
local DCTheLotteryUI = class("DCTheLotteryUI", gp.BaseNode)

function DCTheLotteryUI:ctor()
	DCTheLotteryUI.super.ctor(self)
	self:setCatchTouch(true)
	self:setContentSize(gd.VISIBLE_SIZE)
	self:setGrayBackgroundEnable(true)
	self.bg = gp.Scale9Sprite:create("TwoPanel_V2.png", false)
	self.bg:setCapInsets(cc.rect(10,70,2,2))
	
	self.bg:setContentSize(cc.size(552, 260))
	self:addChild(self.bg)
	_VLP(self.bg)

	local titleLb = gp.Label:create("开奖", 24)	
	self:addChild(titleLb)
	_VLP(titleLb, self.bg, vl.IN_T, cc.p(0, -10))

	self.lotteryLb = gp.Label:create("", 52)
	self.lotteryLb:setAnchorPoint(cc.p(0, 0.5))
	self.lotteryLb:setOutline(2)
	self:addChild(self.lotteryLb)
	_VLP(self.lotteryLb, self.bg, vl.IN_L, cc.p(20, 10))

	self.resultList = {} --候选结果
	self.resultCnt = 0
	self.tmpResultList = {}
	self.tmpResultCnt = 0
	self.tmpIdx = 1
	self.curPos = 0--当前位置
	self.curStr = ""
	self.curData = {}--筛选出来的数据
	self.isStart = false

	self.blueResultList = {}
	for i=1,16 do
		table.insert(self.blueResultList, i)
	end
	self.blueCount = 1
	self.bluePos = 0
	self.blueTmpResultList = {}
	self.blueTmpResultCnt = 0
	self.blueTmpIdx = 1
	self.curBlueStr = ""

	self.isStartBlue = false
	self.blueLb = gp.Label:create("", 48)
	self.blueLb:setAnchorPoint(cc.p(1, 0.5))
	self.blueLb:setLabelColor(gd.FCOLOR.c20)
	self.blueLb:setOutline(2)
	self:addChild(self.blueLb)
	_VLP(self.blueLb, self.bg, vl.IN_R, cc.p(-60, -10))
	self.blueLb:setVisible(false)


	local function _btnCloseCall( sender )
		JOWinMgr:Instance():removeWin(self)
	end

	local backBtn = gp.Button:create("CancelBtn_V2.png", _btnCloseCall)
	self:addChild(backBtn)
	_VLP(backBtn, self.bg, vl.IN_TR, cc.p(-10, -10))

	local function _resultCall(resultList, resultCnt)
		if resultCnt>0 then
			self.resultList = resultList
			self.resultCnt = resultCnt
		else
			self.resultList = {}
			self.resultCnt = 0
			gp.Factory:noiceView("没有数据")
		end
		self:reStart()
	end

	local function _btnCall( sender )
		local tag = sender:getTag()
		if tag==2 then
			self.tabCtrl:setCatchTouch(true)
			self:reStart()
		elseif tag==3 then
			self.tabCtrl:setCatchTouch(false)
			--初始没有数据的情况
			if self.resultCnt==0 then
				GMODEL(MOD.DC):getDCAnalysisMgr():start(self.selId, _resultCall)
				return;
			end
			if self.isStart then
				self:_setOneRed()
			elseif self.isStartBlue then
				self:_setOneBlue()
			else
				--下一轮开始
				self:reStart()
			end
		end
	end

	self.nextNumBtn = gp.Button:create("AttackBtn_V2.png", _btnCall)
	self:addChild(self.nextNumBtn)
	self.nextNumBtn:setTag(3)
	_VLP(self.nextNumBtn, self.bg, vl.IN_BR, cc.p(-10, 30))

	self.reloadBtn = gp.Button:create("DoBtn_V2.png", _btnCall)
	self:addChild(self.reloadBtn)
	self.reloadBtn:setTag(2)
	_VLP(self.reloadBtn, self.nextNumBtn, vl.OUT_L, cc.p(-10, 0))
	--reloadBtn:setVisible(false)


	local btnBlue1 = gp.Button:create("Top2Bg_V2.png", nil, "蓝1")
	btnBlue1:setContentSize(cc.size(180,38))
	self:addChild(btnBlue1)
	_VLP(btnBlue1, self.bg, vl.IN_BL, cc.p(10, 30))

	local btnBlue2 = gp.Button:create("Top2Bg_V2.png", nil, "蓝2")
	btnBlue2:setContentSize(cc.size(180,38))
	self:addChild(btnBlue2)
	_VLP(btnBlue2, btnBlue1, vl.OUT_R, cc.p(10, 0))

	local function _tabCall( key, tag )
		if self.isStartBlue==true then return end
		if key=="blue1" then
			self.blueCount = 1
		elseif key=="blue2" then
			self.blueCount = 2
		end
	end
	self.tabCtrl = gp.TabCtrl.new({["blue1"]=btnBlue1, ["blue2"]=btnBlue2}, _tabCall)
	self.tabCtrl:setSelKey("blue1")
end

function DCTheLotteryUI:reStart()
	self.tmpIdx = 1
	self.curPos=1 --当前位置
	self.curStr = ""
	self.curData = {}
	self.tmpResultList = self.resultList
	self.tmpResultCnt = self.resultCnt
	if self.resultCnt>0 then
		self.isStart=true
	end

	
	self.bluePos = 0
	self.curBlueStr = ""

	self.isStartBlue = false
	self.blueLb:setVisible(false)
	self.blueLb:setString("")
	self.blueLb:stopAllActions()
	self.blueLb:setScale(1)

	self.lotteryLb:stopAllActions()
	self.lotteryLb:setVisible(true)
	self.lotteryLb:setScale(1)
	self.lotteryLb:setString(EMPTY_TEXT)
	_VLP(self.lotteryLb, self.bg, vl.IN_L, cc.p(20, 10))

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
	if self.isStart and self.tmpResultCnt>0 then
		self:_randomRed()
	elseif self.isStartBlue and self.blueTmpResultCnt>0 then
		self:_randomBlue()
	end
end

function DCTheLotteryUI:_randomRed(  )
	if self.curPos<1 or self.curPos>6 then return end

	self.tmpIdx = math.random(1, self.tmpResultCnt)
	local data = self.tmpResultList[self.tmpIdx]
	if self.curPos==1 then
		self.lotteryLb:setString(string.format("%02d", data[self.curPos]))
	elseif self.curPos>1 then
		self.lotteryLb:setString(string.format("%s, %02d", self.curStr, data[self.curPos]))
	end
end

function DCTheLotteryUI:_randomBlue(  )
	if self.bluePos<1 or self.bluePos>self.blueCount then return end

	self.blueTmpIdx = math.random(1, self.blueTmpResultCnt)
	local data = self.blueTmpResultList[self.blueTmpIdx]
	if self.bluePos==1 then
		self.blueLb:setString(string.format("%02d", data))
	else
		self.blueLb:setString(string.format("%02d, %s", data, self.curBlueStr))
	end
end

function DCTheLotteryUI:_setOneRed(  )

	if self.curPos>6 then
		self.curPos = 6
		self.isStart=false
		self.isStartBlue = false	
		--检查是否随机蓝球
		if self.blueCount>0 and self.bluePos<self.blueCount then
			local function _moveLotteryLbCall(  )
				if not next(self.blueTmpResultList) then
					self.blueTmpResultList = gp.table.copy(self.blueResultList)
					self.blueTmpResultCnt = #self.blueTmpResultList
				end
				self.reloadBtn:setCatchTouch(true)
				self.nextNumBtn:setCatchTouch(true)

				self.isStartBlue = true	
				self.bluePos = 1
				self.blueLb:setVisible(true)
			end
			self.reloadBtn:setCatchTouch(false)
			self.nextNumBtn:setCatchTouch(false)
			
			local seq = cc.Sequence:create(cc.Spawn:create(cc.MoveBy:create(0.2, cc.p(0, 40)),cc.ScaleTo:create(0.2,0.72)), cc.CallFunc:create(_moveLotteryLbCall))
			self.lotteryLb:runAction(seq)
		else
			self:_saveWinData()
		end
		return
	end
	
	if self.curPos<=6 then
		--筛选每个位的号码
		local data = self.tmpResultList[self.tmpIdx]
		if data==nil then
			gp.Factory:noiceView("red data==nil")
			return
		end

		local posData = data[self.curPos]
		table.insert(self.curData, posData)
		
		if self.curPos==1 then
			self.curStr = string.format("%02d", posData)
		else
			self.curStr = string.format("%s, %02d", self.curStr, posData)
		end
		if self.curPos<6 then
			self:exactRange()
		end
		self.tmpIdx = math.random(1, self.tmpResultCnt)
		self.curPos = self.curPos+1
	end
end

function DCTheLotteryUI:_setOneBlue(  )

	if self.bluePos>self.blueCount then
		self.bluePos = self.blueCount
		self.isStartBlue=false
		self:_saveWinData()
		return
	end

	if self.bluePos<=self.blueCount then
		local data = self.blueTmpResultList[self.blueTmpIdx]
		if data==nil then
			gp.Factory:noiceView("blue data==nil")
			return
		end
		table.insert(self.curData, data)
		if self.bluePos==1 then
			self.curBlueStr = string.format("%02d", data)
		else
			self.curBlueStr = string.format("%s, %02d", self.curBlueStr, data)
		end
		table.remove(self.blueTmpResultList, self.blueTmpIdx)
		
		--容器里没有数据的情况下，重新填满
		if not next(self.blueTmpResultList) then
			self.blueTmpResultList = gp.Table.copy(self.blueResultList)
		end

		self.blueTmpResultCnt = #self.blueTmpResultList
		self.blueTmpIdx = math.random(1, self.blueTmpResultCnt)

		self.bluePos = self.bluePos+1
	end
end


function DCTheLotteryUI:_saveWinData(  )
	GMODEL(MOD.DC):getDCStorageMgr():insertDrawData(self.curData)
	
	local particle = cc.ParticleSystemQuad:create("pub/particle/shengjiguangquan.plist")
	particle:setAutoRemoveOnFinish(true)
	self:addChild(particle)
	_VLP(particle)

	local seq = cc.Sequence:create(cc.Spawn:create(cc.MoveBy:create(0.1, cc.p(0, -18)),cc.ScaleTo:create(0.1,0.8)))
	self.lotteryLb:runAction(seq)

	self.blueLb:runAction(cc.ScaleTo:create(0.1,0.78))
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

