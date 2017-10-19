--[[
=================================
文件名：DCOptionalResultUI.lua
作者：James Ou
根据条件数据得到的数据集合
=================================
]]
local OPTIONAL_SIZE = cc.size(210, 30)

local TmpOptionalCell =  class("TmpOptionalCell", gp.TableViewCell )

function TmpOptionalCell:ctor()
	TmpOptionalCell.super.ctor(self)
    self:setContentSize(OPTIONAL_SIZE)
        
    self.lb = gp.Label:create("", 22)    
	self:addChild(self.lb)
	_VLP(self.lb, self)
end


function TmpOptionalCell:setTitle(info)
	--LOG_INFO("", gp.table.tostring(info))
	self.lb:setString(table.concat(info, ","))
	--self.lb:setString(string.format("%02d, %02d, %02d, %02d, %02d, %02d", info.r1, info.r2, info.r3, info.r4, info.r5, info.r6))
end


local DCOptionalResultUI = class("DCOptionalResultUI", glg.UIDropView)

function DCOptionalResultUI:ctor()
	DCOptionalResultUI.super.ctor(self)

	self.tableView = nil	
	self.titleList = {}
	self.titleCount = 0

	self:_initTableView()

	self.nums = nil
	local function _numPadCall( sender, nums )
		self.nums = nums
		if nums==nil or #nums==0 then
			self.searchNumBtn:setTitle(self.searchEmptyStr)
			if self.tableDatasCount ~= self.resultCnt then
				self:_setpuData(self.resultList, self.resultCnt)
			end
		else
			self.searchNumBtn:setTitle(string.format(table.concat(nums, ",")))
		end
	end
	local function _btnNumCall( sender )
		local fullNum = glg.DCFullNumView.new()
		fullNum:setMaxSelCount(6)
		fullNum:setDefSelNum(self.nums)
		fullNum:setOkCall(_numPadCall)
		JOWinMgr:Instance():showWin(fullNum, gd.LAYER_WIN)
	end
	self.searchEmptyStr = "搜索号码"
	self.searchNumBtn = gp.Button:create("Top2Bg_V2.png", _btnNumCall, true, self.searchEmptyStr)
	self.searchNumBtn:setContentSize(cc.size(140,38))
	self.searchNumBtn:setTitleArg("", 17, gd.FCOLOR.c1, 0)
	self:addChild(self.searchNumBtn)

	_VLP(self.searchNumBtn, self, vl.IN_TL, cc.p(10, -80))

	--在条件数据列表中，查找相应出现的数据，放在self.tableDatas中
	local function _searchCall()
		if self.nums==nil or #self.nums==0 then
			if self.tableDatasCount ~= self.resultCnt then
				self:_setpuData(self.resultList, self.resultCnt)
			end
			return
		end
		self.tableDatas = {}
		local isAccord = true
		for _,v in ipairs(self.resultList) do
			isAccord = true
			for _,n in ipairs(self.nums) do
				if v[1]~=n and v[2]~=n and v[3]~=n and v[4]~=n and v[5]~=n and v[6]~=n then
					isAccord = false
					break
				end
			end
			if isAccord==true then
				table.insert(self.tableDatas, v)
			end
		end
		self.tableDatasCount = #self.tableDatas
		self:_setpuData(self.tableDatas, self.tableDatasCount)
	end
	self.searchBtn = gp.Button:create("AttackBtn_V2.png", _searchCall)
	self.searchBtn:setScale(0.6)
	self:addChild(self.searchBtn)
	_VLP(self.searchBtn, self.searchNumBtn, vl.OUT_R, cc.p(10,0))

end

function DCOptionalResultUI:_initTableView()
	local tableView = gp.TableView.new(cc.size(self:getContentSize().width-10, self:getContentSize().height-140))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setMargin(2)
	self:addChild(tableView)
	_VLP(tableView, self, vl.IN_B, cc.p(0,10))

	local function _cellSizeForTable(table,idx)
	    return OPTIONAL_SIZE, true--(返回的布尔值是为告诉TableView,是否每个cell的大小一样)
	end

	local function _tableCellAtIndex(table, idx, cell)
		if nil == cell then
		    cell = TmpOptionalCell.new(_selDataCall)
		end
		cell:setTitle(self.tableDatas[idx])

		return cell
	end

	local function _numberOfCellsInTableView(table)
	    return self.tableDatasCount
	end

	tableView:setHandler(_cellSizeForTable, gd.CELL_SIZE)
	tableView:setHandler(_numberOfCellsInTableView, gd.CELL_NUMS)
	tableView:setHandler(_tableCellAtIndex, gd.CELL)

	--tableView:reloadData()
	self.tableView = tableView
end


function DCOptionalResultUI:setupData(resultList, resultCnt)
	if resultList==nil then 
		self.resultCnt = 0
	else
		self.resultList = resultList
		self.resultCnt = resultCnt
	end
	self:_setpuData(self.resultList, self.resultCnt)
end

function DCOptionalResultUI:_setpuData(list, cnt)
	self.tableDatasCount = cnt
	self.tableDatas = list

	self.title:setString(string.format("总共: %d 条", cnt))
	self.tableView:reloadData()
end


return DCOptionalResultUI
