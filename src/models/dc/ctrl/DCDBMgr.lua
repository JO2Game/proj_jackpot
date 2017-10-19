
local SQL_MAIN_CREATE = "create table %s(stage int not null unique, year varchar(6), r1 int(2), r2 int(2), r3 int(2), r4 int(2), r5 int(2), r6 int(2), b1 int(2), PRIMARY KEY( stage ))";
local SQL_MAIN_INSERT = "insert or ignore into %s(stage, year, r1,r2,r3,r4,r5,r6, b1) values (%d,%s, %d,%d,%d,%d,%d,%d, %d)"
local SQL_MAIN_DELETE = "delete from %s where stage = %d"
local SQL_MAIN_SEL_YEAR = "select year from %s group by year"
local SQL_MAIN_SEL_IN_YEAR = "select * from %s where year=%s order by stage"

local SQL_SEL_CREATE = "create table %s(stage int, r1 int(2), r2 int(2), r3 int(2), r4 int(2), r5 int(2), r6 int(2), b1 int(2))";
local SQL_SEL_INSERT = "insert or ignore into %s(stage, r1,r2,r3,r4,r5,r6, b1) values (%d, %d,%d,%d,%d,%d,%d, %d)"
local SQL_SEL_DELETE = "delete from %s where r1=%d and r2=%d and r3=%d and r4=%d and r5=%d and r6=%d and b1=%d"
local SQL_SEL_DELETE_ALL = "delete from %s where stage = %d"
local SQL_SEL_SEL_STAGE = "select stage from %s group by stage"
local SQL_SEL_SEL_IN_STAGE = "select * from %s where stage=%s"
local SQL_SEL_CLEAR = "Truncate Table %s"

local DCDBMgr = class("DCDBMgr")

function DCDBMgr:ctor()
	self:init()	
end

function DCDBMgr:init()
	self.tableName = "ssq"
	self.selTableName = "ssq_sel"
	self.year = {}
	self.yearDatas = {}
	self.selStage = {}
	self.selStageDatas = {}

	local workingPath = cc.FileUtils:getInstance():fullPathForFilename(_gcf.GAME_WRITABLE_PATH.."info.db")
	LOG_INFO("DCDBMgr", "workingPath = %s", workingPath)
	JOSQL:Instance():initDB(workingPath)

	JOSQL:Instance():createTable(string.format(SQL_MAIN_CREATE, self.tableName), self.tableName)
	JOSQL:Instance():createTable(string.format(SQL_SEL_CREATE, self.selTableName), self.selTableName)

	--self:loadAllDataInTxt()
end

function DCDBMgr:onDelete()
	JOSQL:Instance():closeDB()
	self.tableName = nil
	self.selTableName = nil
	self.year = nil
	self.yearDatas = nil
	self.selStage = nil
	self.selStageDatas = nil
end

function DCDBMgr:insertMain(dcData)
	if dcData then
		local sql = string.format(SQL_MAIN_INSERT, self.tableName, dcData.stage, dcData.year, dcData.r1, dcData.r2, dcData.r3, dcData.r4, dcData.r5, dcData.r6, dcData.b1)
		--LOG_INFO("DCDBMgr", "dbInsert %s", sql)
		JOSQL:Instance():execSql(sql)
	end
end

function DCDBMgr:insertSel( selData )
	if selData then
		local sql = string.format(SQL_SEL_INSERT, self.selTableName, dcData.stage, dcData.r1, dcData.r2, dcData.r3, dcData.r4, dcData.r5, dcData.r6, dcData.b1)
		--LOG_INFO("DCDBMgr", "dbInsertSel %s", sql)
		JOSQL:Instance():execSql(sql)
	end
end

function DCDBMgr:deleteMain( stage )
	if stage then
		local sql = string.format(SQL_MAIN_DELETE, self.tableName, stage)
		JOSQL:Instance():execSql( sql )
	end
end

function DCDBMgr:deleteSel( selData )
	if selData then
		local sql = string.format(SQL_SEL_DELETE, self.selTableName, selData.r1, selData.r2, selData.r3, selData.r4, selData.r5, selData.r6, selData.b1)
		JOSQL:Instance():execSql( sql )
	end
end

function DCDBMgr:deleteSelAll( stage )
	if stage then
		local sql = string.format(SQL_SEL_DELETE_ALL, self.selTableName, stage)
		JOSQL:Instance():execSql( sql )
	end
end

function DCDBMgr:clearAllSel()
	local sql = string.format(SQL_SEL_CLEAR, self.selTableName)
	JOSQL:Instance():execSql( sql )
end

function DCDBMgr:loadMainYear(callback)	
	self.year = {}	
	local function _selectSqlCall( sqlReader, tName, bFinish )
		if bFinish then 
			if callback then				
				callback(self.year)
			end
			return
		end
		if self.tableName == tName then
			local y = sqlReader:readString(0)
			table.insert(self.year, y)
		end
	end

	local sql = string.format(SQL_MAIN_SEL_YEAR, self.tableName)
	JOSQL:Instance():execLuaLoadSqlData(sql, self.tableName, _selectSqlCall);
end

function DCDBMgr:loadMainInYear(year, callback)
	self.yearDatas = {}
	local function _selectSqlCall( sqlReader, tName, bFinish )
		if bFinish then 
			if callback then
				callback(self.yearDatas)
			end
			return
		end
		if self.tableName == tName then
			local dcData = {}
			dcData.stage = sqlReader:readInt(0)
			dcData.year = sqlReader:readString(1)
			dcData.r1 = sqlReader:readInt(2)
			dcData.r2 = sqlReader:readInt(3)
			dcData.r3 = sqlReader:readInt(4)
			dcData.r4 = sqlReader:readInt(5)
			dcData.r5 = sqlReader:readInt(6)
			dcData.r6 = sqlReader:readInt(7)
			dcData.b1 = sqlReader:readInt(8)
			table.insert(self.yearDatas, dcData)
		end
	end

	local sql = string.format(SQL_MAIN_SEL_IN_YEAR, self.tableName, year)
	JOSQL:Instance():execLuaLoadSqlData(sql, self.tableName, _selectSqlCall);
end

function DCDBMgr:loadSelStage(callback)
	self.selStage = {}
	local function _selectSqlCall( sqlReader, tName, bFinish )
		if bFinish then 
			if callback then
				callback(self.selStage)
			end
			return
		end
		if self.selTableName == tName then
			local stage = sqlReader:readInt(0)
			table.insert(self.selStage, stage)
		end
	end

	local sql = string.format(SQL_MAIN_SEL_YEAR, self.selTableName)
	JOSQL:Instance():execLuaLoadSqlData(sql, self.selTableName, _selectSqlCall);
end

function DCDBMgr:loadSelInStage(stage, callback)
	self.selStageDatas = {}
	local function _selectSqlCall( sqlReader, tName, bFinish )
		if bFinish then 
			if callback then
				callback(self.selStageDatas)
			end
			return
		end
		if self.selTableName == tName then
			local dcData = {}
			dcData.stage = sqlReader:readInt(0)			
			dcData.r1 = sqlReader:readInt(1)
			dcData.r2 = sqlReader:readInt(2)
			dcData.r3 = sqlReader:readInt(3)
			dcData.r4 = sqlReader:readInt(4)
			dcData.r5 = sqlReader:readInt(5)
			dcData.r6 = sqlReader:readInt(6)
			dcData.b1 = sqlReader:readInt(7)
			table.insert(self.selStageDatas, dcData)
		end
	end

	local sql = string.format(SQL_SEL_SEL_IN_STAGE, self.selTableName, stage)
	JOSQL:Instance():execLuaLoadSqlData(sql, self.selTableName, _selectSqlCall);
end

function DCDBMgr:loadAllDataInTxt()	
	local year = 2003
	while true do
		if not self:loadYearInTxt(year) then
			break
		end
		year = year + 1
	end
end

function DCDBMgr:loadYearInTxt( year )
	local fileName = "txt/"..tostring(year)..".txt"
	local filePath = cc.FileUtils:getInstance():fullPathForFilename(fileName)

	if not cc.FileUtils:getInstance():isFileExist(filePath) then return false end

	local file = io.open(filePath, "r")
	if not file then return false end

	for line in file:lines() do
		local dcData = {}
		dcData.year = year
		dcData.stage = tonumber(string.sub(line, 1, 7))		
		--dcData.date = string.sub(line, 36, 45)

		local numStr = string.sub(line, 12, 31)		
		local n = string.split(numStr, "|")
		dcData.b1 = tonumber(n[2])
		local arr = string.split(n[1], ",")
		dcData.r1 = tonumber(arr[1])
		dcData.r2 = tonumber(arr[2])
		dcData.r3 = tonumber(arr[3])
		dcData.r4 = tonumber(arr[4])
		dcData.r5 = tonumber(arr[5])
		dcData.r6 = tonumber(arr[6])		

		self:insertMain(dcData)
	end
	io.close(file)

	return true
end

return DCDBMgr
