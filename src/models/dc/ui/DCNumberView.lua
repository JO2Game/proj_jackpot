local BALL_SIZE = cc.size(38,38)

local DCNumberView = class("DCNumberView", gp.BaseNode)

function DCNumberView:ctor(size, totalRed, totalBlue)
	DCNumberView.super.ctor(self)
	self:setContentSize(size)
	self.redBalls = {}
	self.blueBalls = {}
	self.redHitBalls = {}
	self.blueHitBalls = {}
	self.maxRed = 1
	self.maxBlue = 1

	self:_initBalls(totalRed, totalBlue)
	---[[
	local function _clearCall()
		self:clear()
	end
	local clearBtn = gp.Button:create("gui_btn4.png", _clearCall, "ClEAR")
	clearBtn:setContentSize(cc.size(100,40))
	self:addChild(clearBtn)
	_VLP(clearBtn, self, vl.IN_BL, cc.p(0,0))
	--]]
end

function DCNumberView:_initBalls( totalRed, totalBlue )
	local startPosX = 20
	local startPosY = -80
	local offsetX = 52
	local offsetY = 58
	local changeRowIdx = 10

	local function _redBtnCall( sender )
		local key = sender:getTag()
		if self.redHitCall and self.redHitCall(key) then
			sender:setBtnState(gd.BTN_NOR)
			return
		end
		local beSel = true
		if sender:getBtnState()==gd.BTN_NOR then
			self.redHitBalls[key] = nil
			beSel = false
		else
			if gp.table.nums(self.redHitBalls)>=self.maxRed then
				gp.Factory:noiceView(string.format(_TT("dc","DC11"),self.maxRed))
				return
			else
				self.redHitBalls[key] = true
			end
		end
		if self.callback then
			self.callback(1, key, beSel)
		end
	end
	---[[
	local tempIdx = 0;
	for i=1, totalRed, 1 do
		local ball = gp.SelButton:create("gui_box4.png", _redBtnCall, tostring(i))
		ball:setContentSize(BALL_SIZE)
		ball:setTag(i)
		self:addChild(ball)
--		ball:setSelShader(gp.shader.HUE(100,0.8,0))
		table.insert(self.redBalls, ball)
		tempIdx = tempIdx+1
		if changeRowIdx==tempIdx then
			startPosY = startPosY-offsetY
			startPosX = 20
			tempIdx=1
		end
		_VLP(ball, self, vl.IN_TL, cc.p(startPosX, startPosY))
		startPosX = startPosX+offsetX
	end
	

	local function _blueBtnCall( sender )
		local key = sender:getTag()
		if self.blueHitCall and self.blueHitCall(key) then
			sender:setBtnState(gd.BTN_NOR)
			return
		end
		local beSel = true
		if sender:getBtnState()==gd.BTN_NOR then
			self.blueHitBalls[key] = nil
			beSel = false
		else
			if gp.table.nums(self.blueHitBalls)>=self.maxBlue then
				sender:setBtnState(gd.BTN_NOR)
				gp.Factory:noiceView(string.format(_TT("dc","DC11"),self.maxBlue))
				return
			else
				self.blueHitBalls[key] = true
			end
		end
		if self.changeCall then
			self.changeCall(1, key, beSel)
		end
	end

	startPosX = 20+(changeRowIdx+2)*offsetX
	startPosY = -80
	local changeRowIdx2 = 5	
	tempIdx = 0;
	for i=1, totalBlue, 1 do
		local ball = gp.SelButton:create("gui_box6.png", _blueBtnCall, tostring(i))
		ball:setContentSize(BALL_SIZE)
		ball:setTag(i)
		self:addChild(ball)
	--	ball:setSelShader(gp.shader.HUE(105,0.8,0))
		table.insert(self.blueBalls, ball)
		tempIdx = tempIdx+1
		if changeRowIdx2==tempIdx then
			startPosY = startPosY-offsetY
			startPosX = 20+(changeRowIdx+2)*offsetX
			tempIdx=1
		end
		_VLP(ball, self, vl.IN_TL, cc.p(startPosX, startPosY))
		startPosX = startPosX+offsetX		
	end
	--]]
end

function DCNumberView:setChangeCall(callback)
	self.changeCall = callback
end

function DCNumberView:setRedHitCall( callback )
	self.redHitCall = callback
end
function DCNumberView:setBlueHitCall( callback )
	self.blueHitCall = callback
end

function DCNumberView:hitMaxCount(maxRed, maxBlue)
	self.maxRed = maxRed
	self.maxBlue = maxBlue
end

function DCNumberView:getSelRed()
	local keys = gp.table.keys(self.redHitBalls)
	table.sort(keys)
	return keys
end

function DCNumberView:getSelBule()
	local keys = gp.table.keys(self.blueHitBalls)
	table.sort(keys)
	return keys
end

function DCNumberView:setSelRed( redSet )
	self:clearRed()
	if redSet then
		for _,v in ipairs(redSet) do
			for _,btn in ipairs(self.redBalls) do
				if btn:getTag()==v then
					btn:setBtnState(gd.BTN_SEL)
					self.redHitBalls[v] = true					
				end
			end
		end
	end
end

function DCNumberView:setSelBule( buleSet )
	self:clearBule()
	if buleSet then
		for _,v in ipairs(buleSet) do
			for _,btn in ipairs(self.blueBalls) do
				if btn:getTag()==v then
					btn:setBtnState(gd.BTN_SEL)
					self.blueHitBalls[v] = true					
				end
			end
		end
	end
end

function DCNumberView:clearRed(  )
	for i,v in ipairs(self.redBalls) do
		v:setBtnState(gd.BTN_NOR)
	end
	self.redHitBalls = {}
end

function DCNumberView:clearBule(  )
	for i,v in ipairs(self.blueBalls) do
		v:setBtnState(gd.BTN_NOR)
	end
	self.blueHitBalls = {}
end

function DCNumberView:clear()
	self:clearRed()
	self:clearBule()
end

function DCNumberView:onEnter()
	DCNumberView.super.onEnter(self)
	
end

function DCNumberView:onExit()	
	DCNumberView.super.onExit(self)
end


return DCNumberView

