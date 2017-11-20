
local DCMgr = class("DCMgr")

--[[
低概率去除因素：
连号，4~6连
全单、全双
最近两期都出现的号码
最值限制[40-170]

可以试下区间取位
]]

local function _sortStage( a, b )
	if a.stage < b.stage then
		return true
	end
	return false
end

local PROBABILITY_COUNT = 12

function DCMgr:ctor()
	self:_initData()
end

function DCMgr:_initData()	
	self.year = nil
	self.yearData = {}
	self.allStage = nil
	self.allDataMap = nil
	self.totalStageCount = 0

	self:getYears()
	self:getAllData()

	local allStage = self:getAllStage(_allStageCall)
	if allStage then
		self.totalStageCount = #allStage
	end
end

function DCMgr:onDelete()
	self.year = nil
	self.yearData = nil
end

function DCMgr:getTotalStageCount(  )
	return self.totalStageCount
end

function DCMgr:getYears()
	if self.year==nil then
		self.year = GMODEL(MOD.DC):getDCLuaDataMgr():getDataYears()
	end
	return self.year
end

function DCMgr:getYearData(year)
	return GMODEL(MOD.DC):getDCLuaDataMgr():getDataWithYear(year)
end

function DCMgr:getAllDataMap(  )
	return self.allDataMap
end

function DCMgr:getAllData(  )
	local allData = GMODEL(MOD.DC):getDCLuaDataMgr():getYearDatas()
	if self.allDataMap==nil then
		self.allDataMap = {}
		for _,yds in pairs(allData) do
			--LOG_WARN("DCAnalysisMgr", "yds count %d", gp.table.nums(yds))
			for _,v in pairs(yds) do
				--local key = v.r1+v.r2*100+v.r3*10000+v.r4*1000000+v.r5*100000000+v.r6*10000000000
				local key = v.r[1]+v.r[2]*100+v.r[3]*10000+v.r[4]*1000000+v.r[5]*100000000+v.r[6]*10000000000
				self.allDataMap[key] = v
			end
		end
	end
	return allData
end

function DCMgr:getAllStage( )
	if self.allStage and #self.allStage>0 then
		return self.allStage
	end
	local allData = self:getAllData()
	self.allStage = {}
	for _,v in pairs(allData) do
		for _,vv in pairs(v) do
			table.insert(self.allStage, vv.stage)
		end
	end
	table.sort( self.allStage )
	return self.allStage
end


function DCMgr:insertDCData(dcDatas)
	if dcDatas then
		self.allDataMap = self.allDataMap or {}
		self.yearData = self.yearData or {}
		self.allStage = nil
		local newData = self:getNewDCData()
		local dcd = {}
		
		if #dcDatas > 0 then
			for _,v in ipairs(dcDatas) do
				if not newData or newData.stage < v.stage then
					table.insert(dcd, v)
					if not newData or newData.year < v.year then
						table.insert(self.year, v.year)
						self.newYear = v.year
					end
					--self.yearData[v.year] = self.yearData[v.year] or {}
					--table.insert(self.yearData[v.year], v)
					--self.yearData[v.year][v.stage] = v
					newData = v
					--local key = string.format("%02d,%02d,%02d,%02d,%02d,%02d",v.r1,v.r2,v.r3,v.r4,v.r5,v.r6)
					--local key = v.r1+v.r2*100+v.r3*10000+v.r4*1000000+v.r5*100000000+v.r6*10000000000
					local key = v.r[1]+v.r[2]*100+v.r[3]*10000+v.r[4]*1000000+v.r[5]*100000000+v.r[6]*10000000000
					self.allDataMap[key] = v
				end
			end

			if #dcd>0 then
				self.totalStageCount = self.totalStageCount + #dcd
				GMODEL(MOD.DC):getDCLuaDataMgr():addData(dcd)
			end
		else
			if newData and newData.stage > dcDatas.stage then
				return
			end

			if not newData or newData.year < dcDatas.year then
				table.insert(self.year, dcDatas.year)
				self.newYear = dcDatas.year
			end

			--local key = dcDatas.r1+dcDatas.r2*100+dcDatas.r3*10000+dcDatas.r4*1000000+dcDatas.r5*100000000+dcDatas.r6*10000000000
			local key = dcDatas.r[1]+dcDatas.r[2]*100+dcDatas.r[3]*10000+dcDatas.r[4]*1000000+dcDatas.r[5]*100000000+dcDatas.r[6]*10000000000
			self.allDataMap[key] = dcDatas
			self.totalStageCount = self.totalStageCount+1
			GMODEL(MOD.DC):getDCLuaDataMgr():addData(dcDatas)
		end

		self.newDCData = nil
		gp.MessageMgr:dispatchEvent(ENT.DC_ADD_HISTORY_DATA)
	end
end

function DCMgr:getNewYear(  )
	if self.newYear then
		return self.newYear
	end
	self.newYear = self.year[#self.year]
	return self.newYear
end

function DCMgr:getNewDCData(  )
	if self.newDCData then
		return self.newDCData
	end
	
	local allData = self:getAllData()
	local datas = allData[self:getNewYear()]
	if datas then		
		local stages = gp.table.keys(datas)
		table.sort( stages )
		self.newDCData = datas[stages[#stages]]		
		return self.newDCData
	end
end

return DCMgr
