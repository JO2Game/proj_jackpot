
local DCBaseNumView = class("DCBaseNumView", gp.BaseNode)

function DCBaseNumView:ctor()
	DCBaseNumView.super.ctor(self)
	self:setCatchTouch(true)
	self:setContentSize(gd.VISIBLE_SIZE)
end

--交由子类调用
function DCBaseNumView:onInit(csbNode, numCount)
	if not csbNode or numCount<1 then return end

	self.csbNode = csbNode
	self:addChild(self.csbNode)
	_VLP(self.csbNode)

	self.maxCount = numCount
	self.maxSelCount = numCount

	self.selNums = {}
	self.defNums = {}
	self.unableSelNums = {}

	local function _numBtnCall(sender)
		local tag = sender:getTag()
		if tag>=1 and tag<=self.maxCount then
			local btnState = sender:getBtnState()
			if btnState==gd.BTN_NOR then
				self:removeSelNum(tag)
			elseif btnState==gd.BTN_SEL then
				for _,v in ipairs(self.unableSelNums) do
					if v==tag then
						sender:setBtnState(gd.BTN_NOR)
						if self.noiceCall then
							self.noiceCall(v)
						end
						return
					end
				end
				
				if self.maxSelCount<self.maxCount and #self.selNums>=self.maxSelCount then
					sender:setBtnState(gd.BTN_NOR)
					gp.Factory:noiceView("超出选中上限！！！！")
					return
				end
				self:addSelNum(tag)
			end
		end
	end

	for i=1,self.maxCount do
		local btn = gp.JOCsbLuaMgr:getChild(self.csbNode, "num"..i)
		btn:setCall(_numBtnCall)
	end
	
	local function _functBtnCall(sender)
		local tag = sender:getTag()
		if tag==40 then
			self:clear()
		elseif tag==41 then
		elseif tag==42 then
			JOWinMgr:Instance():removeWin(self)
		elseif tag==43 then
			if self.okCall then
				self.okCall(self, gp.table.copy(self.selNums))
			end
			JOWinMgr:Instance():removeWin(self)
		end
	end
	
	local btnClear = gp.JOCsbLuaMgr:getChild(self.csbNode, "btnClear")
	btnClear:setCall(_functBtnCall)
	-- local btnUndo = gp.JOCsbLuaMgr:getChild(self.csbNode, "btnUndo")
	-- btnUndo:setCall(_functBtnCall)
	local btnBack = gp.JOCsbLuaMgr:getChild(self.csbNode, "btnBack")
	btnBack:setCall(_functBtnCall)
	local btnOk = gp.JOCsbLuaMgr:getChild(self.csbNode, "btnOk")
	btnOk:setCall(_functBtnCall)
end

function DCBaseNumView:setOkCall( call )
	self.okCall = call
end

function DCBaseNumView:addSelNum( num )
	for _,v in ipairs(self.selNums) do
		if v==num then
			return
		end
	end
	table.insert(self.selNums, num)
end

function DCBaseNumView:removeSelNum( num )
	for i,v in ipairs(self.selNums) do
		if v==num then
			table.remove(self.selNums, i)
			return true
		end
	end
end


--设置开始默认选中的
function DCBaseNumView:setDefSelNum( numTable )
	if numTable==nil then return end
	self.defNums = {}
	local flag = true
	for _,v in ipairs(numTable) do
		local btn = gp.JOCsbLuaMgr:getChild(self.csbNode, "num"..v)
		if btn then
			--btn:setBtnState(gd.BTN_SEL)
			local tag = btn:getTag()
			flag = true
			--过滤重复
			for _,n in ipairs(self.defNums) do
				if n==tag then
					flag = false
					break
				end
			end
			if flag then
				table.insert(self.defNums, v)
			end
		end
	end
end

--设置不能选中的，若选中这些数据会触发noiceCall回调
function DCBaseNumView:setUnableSelNum(numTable, noiceCall)
	if numTable==nil then return end
	self.unableSelNums = numTable
	self.noiceCall = noiceCall
	for _,v in ipairs(self.unableSelNums) do
		if self:removeSelNum(v) then
			local btn = gp.JOCsbLuaMgr:getChild(self.csbNode, "num"..v)
			if btn then
				btn:setBtnState(gd.BTN_NOR)
			end
		end
	end
end
--设置选中的最大数量
function DCBaseNumView:setMaxSelCount( count )
	self.maxSelCount = count
end

function DCBaseNumView:getSelNums(  )
	return self.selNums
end


function DCBaseNumView:clear()
	for i=1,self.maxCount do
		local btn = gp.JOCsbLuaMgr:getChild(self.csbNode, "num"..i)
		btn:setBtnState(gd.BTN_NOR)
	end

	self.selNums = {}
end

function DCBaseNumView:onEnter()
	DCBaseNumView.super.onEnter(self)
	self.selNums = {}
	--设置默认选中
	for _,v in ipairs(self.defNums) do
		local btn = gp.JOCsbLuaMgr:getChild(self.csbNode, "num"..v)
		if btn then
			btn:setBtnState(gd.BTN_SEL)
			table.insert(self.selNums, v)
		end
	end
	--过滤指定不能选中的
	for _,v in ipairs(self.unableSelNums) do
		self:removeSelNum(v)
		local btn = gp.JOCsbLuaMgr:getChild(self.csbNode, "num"..v)
		if btn then
			btn:setBtnState(gd.BTN_NOR)
		end
	end
end


return DCBaseNumView
