
--[[
=================================
文件名：DCModel.lua
作者：James Ou
=================================
]]
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ctrl/DCStorageMgr" )
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ctrl/DCLuaDataMgr" )
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ctrl/DCDBMgr" )
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ctrl/DCMgr" )
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ctrl/DCAnalysisMgr" )
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ctrl/DCStatisticsMgr" )

gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ui/DCBallUI" )
--[[
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ui/DCAnalysisUI" )
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ui/DCNumberView" )
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ui/DCFilterCustomView" )

gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ui/DCFilterResultUI" )
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ui/DCCustomHistoryUI" )
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ui/DCStatisticsUI" )

--]]

gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ui/Statistics/UICurveGraphView" )
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ui/Statistics/UICylinderGraphView" )
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ui/Statistics/UIPeriodView" )
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ui/Statistics/UIDataGraphView" )

gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ui/analysis/DCAppearAnalysisUI" )
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ui/analysis/DCSumAnalysisUI" )
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ui/analysis/DCEvenAnalysisUI" )
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ui/analysis/DCSeqRangeAnalysisUI" )
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ui/analysis/DCIntervalAnalysisUI" )

gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ui/DCTopMessageView" )
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ui/DCHistoryDataUI" )
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ui/DCConditionUI" )
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ui/DCOptionalDataUI" )
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ui/DCOptionalResultUI" )
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ui/DCDataAnalysisUI" )
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ui/DCDrawResultUI" )
gp.ModelMgr:modelSubLua( MOD.DC, "models/dc/ui/DCTheLotteryUI" )





local DCModel = DCModel or class("DCModel", gp.BaseModel)

function DCModel:onInitData()
	--创建数据管理对象及其get方法
	gp.macro.SYNTHESIZE_READONLY(self, "DCStorageMgr", "DCStorageMgr", MCLASS(MOD.DC, "DCStorageMgr").new())
	gp.macro.SYNTHESIZE_READONLY(self, "DCLuaDataMgr", "DCLuaDataMgr", MCLASS(MOD.DC, "DCLuaDataMgr").new())
	--gp.macro.SYNTHESIZE_READONLY(self, "DCDBMgr", "DCDBMgr", MCLASS(MOD.DC, "DCDBMgr").new())
	gp.macro.SYNTHESIZE_READONLY(self, "DCMgr", "DCMgr", MCLASS(MOD.DC, "DCMgr").new())
	gp.macro.SYNTHESIZE_READONLY(self, "DCAnalysisMgr", "DCAnalysisMgr", MCLASS(MOD.DC, "DCAnalysisMgr").new())
	gp.macro.SYNTHESIZE_READONLY(self, "DCStatisticsMgr", "DCStatisticsMgr", MCLASS(MOD.DC, "DCStatisticsMgr").new())

	--[[
	local dataList = self.DCAnalysisMgr:_comb(33, 6)
	for i,v in ipairs(dataList) do
		LOG_INFO("DCModel", table.concat(v,","))
	end
	--]]
	local function _delayUpdate()
		self:updateDCData()
	end
	gp.TickMgr:delayCall( 1, _delayUpdate)
	
	--self.DCAnalysisMgr:start(_call)
	LOG_DEBUG("DCModel", "ORG TOTAL: %d", #self.DCAnalysisMgr.orgDataList)
end

function DCModel:updateDCData(  )
	local newDCData = self.DCMgr:getNewDCData()
	if newDCData then
		local d = os.date()
		if string.sub(newDCData.year, 3,4)==string.sub(d, 7,8) and string.sub(newDCData.date,1,2)==string.sub(d,1,2) then
			if tonumber(string.sub(d, 4,5))<tonumber(string.sub(newDCData.date, 3,4))+1 then
				LOG_DEBUG("", "date = %s", d)
				LOG_DEBUG("", "newDCData = %s", newDCData.date)
				return
			end
		end
	end
	
	local function _dcDataSort( a, b )
		if a.stage < b.stage then
			return true
		end
		return false
	end

	local function _httpCallback( http )
		JOWinMgr:Instance():clear(gd.LAYER_WAIT)
		---[[
		local fail = true;
		if( http.status == 200 ) then
			-- 获取成功的处理
			local reportJson = http.response;
			--解释得到的内容到luaTable
			local report = ""
			local function _decodeJson()
				report = gp.json.jsonTableFromString( reportJson );
			end			
			if pcall(_decodeJson) and type(report) == "table" then
				--LOG_INFO("Login", "reportJson = %s", reportJson)
				fail = false;
				local rows = tonumber(report.rows)
				if rows>0 then
					local dcDatas = {}
					for i=rows,1,-1 do
						local dc = {}
						local d = report.data[i]						
						dc.stage = tonumber(d.expect)
						local temps = gp.str.split(d.opentime,"-")
						dc.year = tonumber(temps[1])
						dc.date = temps[2].."-"..string.sub(temps[3],1,2)
						temps = gp.str.split(d.opencode, "+")
						dc.b1 = tonumber(temps[2])
						temps = gp.str.split(temps[1], ",")
						dc.r = table.sort(temps)
						--[[
						dc.r1 = tonumber(temps[1])
						dc.r2 = tonumber(temps[2])
						dc.r3 = tonumber(temps[3])
						dc.r4 = tonumber(temps[4])
						dc.r5 = tonumber(temps[5])
						dc.r6 = tonumber(temps[6])
						--]]
						table.insert(dcDatas, dc)
					end

					table.sort(dcDatas, _dcDataSort)
					--LOG_DEBUG("", gp.table.tostring(dcDatas))
					GMODEL(MOD.DC):getDCMgr():insertDCData(dcDatas)
				end
			end
		end
		if fail == true then
			gp.Factory:noiceView(_TT("dc","DC43"))
		end
		--]]
	end

	--gp.Factory:waitView()
	gp.macro.HTTP_REQUEST("http://f.apiplus.cn/ssq-50.json", _httpCallback)
end

function DCModel:onInitEvent()
	
end


function DCModel:onDelete( )

	--析构UI

	--析构MGR及其它对象
	self.DCAnalysisMgr:onDelete()
	self.DCStatisticsMgr:onDelete()
	self.DCMgr:onDelete()
	self.DCLuaDataMgr:onDelete()
	self.DCDBMgr:onDelete()

	--析构父类
	DCModel.super.onDelete(self)
end

--数据相关----------------------------------------------------------------------------

--ui相关----------------------------------------------------------------------------
function DCModel:showDCBallUI( )
	JOWinMgr:Instance():showWin(MCLASS(MOD.DC, "DCBallUI").new(), gd.LAYER_HOME)
end

--消息相关----------------------------------------------------------------------------

--[[
--成功错误码处理----------------------------------------------------------------------------
function DCModel:handleErrorCode(errorData)

end

function DCModel:handleSuccessCode(successData)

end
--]]

return DCModel