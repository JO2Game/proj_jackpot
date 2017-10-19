local MAX_FILTER_RESULT_COUNT = 10

local DCLuaDataMgr = class("DCLuaDataMgr")
---[[
function DCLuaDataMgr:ctor()
	self:init()	
end

function DCLuaDataMgr:init()
	self:checkData()
	self.yearDatas = DCDataRef or {}
	self:loadAllDataInTxt()
	self:checkData()
	self.yearDatas = DCDataRef or {}
	--[[
	for k,v in pairs(self.yearDatas) do
		local stageKeys = gp.table.keys(v)
		table.sort(stageKeys)
		if v[ stageKeys[1] ].r1 then
			local fileN = _gcf.GAME_WRITABLE_PATH.."/dc/".."DC_DA_"..k..".lua"
			local file = io.open(fileN, "w+")
			local dStr = string.format("DCDataRef = DCDataRef or {}\nlocal d = {}\nDCDataRef[%s]=d\n",k)
			file:write(dStr)
			for _,sk in ipairs(stageKeys) do
				local sv = v[sk]
				local tmpR = {}
				table.insert(tmpR, sv.r1)
				table.insert(tmpR, sv.r2)
				table.insert(tmpR, sv.r3)
				table.insert(tmpR, sv.r4)
				table.insert(tmpR, sv.r5)
				table.insert(tmpR, sv.r6)
				table.sort(tmpR)
				dStr = string.format("d[%d]={stage=%d,r={%d,%d,%d,%d,%d,%d},b1=%d,year=%d,date=\"%s\"}\n",sv.stage,sv.stage, tmpR[1], tmpR[2], tmpR[3], tmpR[4], tmpR[5], tmpR[6], sv.b1, sv.year, sv.date)
				file:write(dStr)
			end
			file:close()
		else
			local fileN = _gcf.GAME_WRITABLE_PATH.."/dc/".."DC_DA_"..k..".lua"
			local file = io.open(fileN, "w+")
			local dStr = string.format("DCDataRef = DCDataRef or {}\nlocal d = {}\nDCDataRef[%s]=d\n",k)
			file:write(dStr)
			for _,sk in ipairs(stageKeys) do
				local sv = v[sk]
				table.sort(sv.r)
				dStr = string.format("d[%d]={stage=%d,r={%d,%d,%d,%d,%d,%d},b1=%d,year=%d,date=\"%s\"}\n",sv.stage,sv.stage, sv.r[1], sv.r[2], sv.r[3], sv.r[4], sv.r[5], sv.r[6], sv.b1, sv.year, sv.date)
				file:write(dStr)
			end
			file:close()
		end
	end
	--]]
end


function DCLuaDataMgr:getDataWithYear( year )
	if self.yearDatas then
		return self.yearDatas[year]
	end
end

function DCLuaDataMgr:getDataYears(  )
	local keys = gp.table.keys(self.yearDatas)
	if keys then
		table.sort(keys)
		return keys
	end
end

function DCLuaDataMgr:getYearDatas()
	return self.yearDatas
end

function DCLuaDataMgr:checkData(  )
	local year = 2003
	local dataName = "DC_DA_"..year..".lua"
	while true do
		if not cc.FileUtils:getInstance():isFileExist("dc/"..dataName) then
			local filePath = cc.FileUtils:getInstance():fullPathForFilename(_gcf.LOAD_PROJ.."/src/models/dc/data/"..dataName)
			--LOG_INFO("", "2 "..filePath)
			if not cc.FileUtils:getInstance():isFileExist(filePath) then
				break
			else
				if JOFileMgr:copyFile(filePath, _gcf.GAME_WRITABLE_PATH.."dc/"..dataName)==true then
					loadLuaFile("dc/"..dataName)
				else
					LOG_ERROR("DCLuaDataMgr", "copy %s error", dataName)
				end
			end
		else			
			loadLuaFile("dc/"..dataName)
		end
		year = year+1
		dataName = "DC_DA_"..year..".lua"
	end
end

local function _getFileHandle( fileName, year, isInTxt )
	local fileN
	if isInTxt then
		--fileN = _gcf.LOAD_PROJ.."/src/models/dc/data/"..fileName..".lua"
		fileN = cc.FileUtils:getInstance():fullPathForFilename(_gcf.LOAD_PROJ.."/src/models/dc/data/"..fileName..".lua")
		if fileN=="" then
			fileN = _gcf.GAME_WRITABLE_PATH.."/dc/"..fileName..".lua"
		end	
	else
		fileN = _gcf.GAME_WRITABLE_PATH.."/dc/"..fileName..".lua"
	end	
	
	if cc.FileUtils:getInstance():isFileExist(fileN) then	
		return io.open(fileN, "a+")
	end		
	local file = io.open(fileN, "w+")
	if file then 
		local dStr = string.format("DCDataRef = DCDataRef or {}\nlocal d = {}\nDCDataRef[%s]=d\n",year)
		file:write(dStr)
		return file
	else
		LOG_ERROR("DCLuaDataMgr", "fileHandle is nil [%s]",fileName)
	end
end

--添加数据
function DCLuaDataMgr:addData( dcDatas, isInTxt )
	if not dcDatas then
		LOG_ERROR("DCLuaDataMgr", "dcDatas is nil")
		return
	end
	--LOG_INFO("","111111111111")
	local file = nil
	local year="-1"
	local fileName = ""
	if #dcDatas>0 then
		--LOG_INFO("","222222222222222")
		for _,v in ipairs(dcDatas) do
			--LOG_INFO("",gp.table.tostring(self.yearDatas[v.year]))
			if not self.yearDatas[v.year] or not self.yearDatas[v.year][v.stage] then
				fileName = "DC_DA_"..v.year
				if year~=v.year then
					if file then
						file:close()
					end
					year = v.year
					file = _getFileHandle(fileName, year, isInTxt)
				end
				--local dStr = string.format("d[%d]={stage=%d,r1=%d,r2=%d,r3=%d,r4=%d,r5=%d,r6=%d,b1=%d,year=%d,date=\"%s\"}\n",v.stage,v.stage, v.r1, v.r2, v.r3, v.r4, v.r5, v.r6, v.b1, v.year, v.date)
				local dStr = string.format("d[%d]={stage=%d,r={%d,%d,%d,%d,%d,%d},b1=%d,year=%d,date=\"%s\"}\n",v.stage,v.stage, v.r[1], v.r[2], v.r[3], v.r[4], v.r[5], v.r[6], v.b1, v.year, v.date)
				file:write(dStr)
				self.yearDatas[v.year] = self.yearDatas[v.year] or {}
				self.yearDatas[v.year][v.stage] = v
			end
		end
	else
		if not self.yearDatas[dcDatas.year] or not self.yearDatas[dcDatas.year][dcDatas.stage] then
			fileName = "DC_DA_"..dcDatas.year
			file = _getFileHandle(fileName, dcDatas.year, isInTxt)
			--local dStr = string.format("d[%d]={stage=%d,r1=%d,r2=%d,r3=%d,r4=%d,r5=%d,r6=%d,b1=%d,year=%d,date=\"%s\"}\n",dcDatas.stage,dcDatas.stage, dcDatas.r1, dcDatas.r2, dcDatas.r3, dcDatas.r4, dcDatas.r5, dcDatas.r6, dcDatas.b1, dcDatas.year, dcDatas.date)
			local dStr = string.format("d[%d]={stage=%d,r={%d,%d,%d,%d,%d,%d},b1=%d,year=%d,date=\"%s\"}\n",dcDatas.stage,dcDatas.stage, dcDatas.r[1], dcDatas.r[2], dcDatas.r[3], dcDatas.r[4], dcDatas.r[5], dcDatas.r[6], dcDatas.b1, dcDatas.year, dcDatas.date)
			file:write(dStr)
			self.yearDatas[dcDatas.year] = self.yearDatas[dcDatas.year] or {}
			self.yearDatas[dcDatas.year][dcDatas.stage] = dcDatas
		end
	end
	if file then
		file:close()
	end
end


function DCLuaDataMgr:onDelete()	
	self.yearDatas = nil	
end

--加载txt中的数据
function DCLuaDataMgr:loadAllDataInTxt()	
	local year = 2003
	while true do
		if not self:loadYearInTxt(year) then
			break
		end
		year = year + 1
	end
end

function DCLuaDataMgr:loadYearInTxt( year )
	if cc.FileUtils:getInstance():isFileExist(_gcf.LOAD_PROJ.."/src/models/dc/data/DC_DA_"..year..".lua") then return true end

	local filePath = _gcf.LOAD_PROJ.."/src/models/dc/txt/"..tostring(year)..".txt"
	if not cc.FileUtils:getInstance():isFileExist(filePath) then return false end

	local file = io.open(cc.FileUtils:getInstance():fullPathForFilename(filePath), "r")
	if not file then return false end	
	local dcDatas = {}
	for line in file:lines() do
		local dcData = {}
		dcData.year = year
		dcData.stage = tonumber(string.sub(line, 1, 7))
		--dcData.date = string.sub(line, 36, 45)

		local numStr = string.sub(line, 12, 31)
		local n = string.split(numStr, "|")
		dcData.b1 = tonumber(n[2])
		local arr = string.split(n[1], ",")
		table.sort(arr)
		dcData.r = arr
		--[[
		dcData.r1 = tonumber(arr[1])
		dcData.r2 = tonumber(arr[2])
		dcData.r3 = tonumber(arr[3])
		dcData.r4 = tonumber(arr[4])
		dcData.r5 = tonumber(arr[5])
		dcData.r6 = tonumber(arr[6])
		--]]
		dcData.date = string.sub(line, 41, 45)
		table.insert(dcDatas, dcData)
	end
	io.close(file)

	local function _sort( a, b )
		if a.stage < b.stage then
			return true
		end
		return false
	end
	table.sort( dcDatas, _sort )
	self:addData(dcDatas, true)
	return true
end
--]]

return DCLuaDataMgr
