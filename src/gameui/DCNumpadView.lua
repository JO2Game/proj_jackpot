
local NUM_COUNT = 16

local DCNumpadView = class("DCNumpadView", gp.BaseNode)

function DCNumpadView:ctor()
	DCNumpadView.super.ctor(self)
	self:setCatchTouch(true)
	self:setContentSize(gd.VISIBLE_SIZE)
	
	self.csbNode = gp.JOCsbLuaMgr:load("DCNumpadViewCSB")
	self:addChild(self.csbNode)
	_VLP(self.csbNode)

	self.curNum = 0
	self.maxNum = -1
	self.minNum = 0

	self.text = gp.JOCsbLuaMgr:getChild(self.csbNode, "text")

	local function _functBtnCall(sender)
		local tag = sender:getTag()
		if tag==40 then
			self.curNum = math.floor(self.curNum*0.1)
			self:_loadCurNum()
		elseif tag==41 then
		elseif tag==42 then
			JOWinMgr:Instance():removeWin(self)
		elseif tag==43 then
			if self.okCall then
				self.okCall(self, self.curNum)
			end
			JOWinMgr:Instance():removeWin(self)
		end
	end
	local btnClear = gp.JOCsbLuaMgr:getChild(self.csbNode, "btnClear")
	btnClear:setCall(_functBtnCall)
	local btnBack = gp.JOCsbLuaMgr:getChild(self.csbNode, "btnBack")
	btnBack:setCall(_functBtnCall)
	local btnOk = gp.JOCsbLuaMgr:getChild(self.csbNode, "btnOk")
	btnOk:setCall(_functBtnCall)

	local function _numBtnCall(sender)

		-- if self.maxSelCount<self.maxCount and #self.selNums>=self.maxSelCount then
		-- 	gp.Factory:noiceView("超出数值上限！！！！")
		-- 	return
		-- end

		local tag = sender:getTag()
		if tag==10 then
			if self.curNum==0 then
				return
			end
			self.curNum=self.curNum*10
		else 
			self.curNum=self.curNum*10+tag
		end

		self:_loadCurNum()
	end

	for i=1,10 do
		local btn = gp.JOCsbLuaMgr:getChild(self.csbNode, "num"..i)
		btn:setCall(_numBtnCall)
	end
end

function DCNumpadView:setMaxNum(num)
	self.maxNum = num
end

function DCNumpadView:setMinNum(num)
	self.minNum = num
end

function DCNumpadView:setOkCall( call )
	self.okCall = call
end

function DCNumpadView:setDefNum(num)
	if type(num)=="number" then
		self.defNum = num
	else
		self.defNum = 0
	end
end

function DCNumpadView:setupData()
	self.curNum = self.defNum
	self:_loadCurNum()
end

function DCNumpadView:_loadCurNum()
	if self.curNum>self.maxNum and self.maxNum>0 then
		self.curNum = self.maxNum
	elseif self.curNum<self.minNum then
		self.curNum = self.minNum
	end
	self.text:setString(self.curNum)
end

return DCNumpadView
