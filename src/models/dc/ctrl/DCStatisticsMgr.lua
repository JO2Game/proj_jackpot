local keyList = {"r1", "r2", "r3", "r4", "r5", "r6"}

local DCStatisticsMgr = class("DCStatisticsMgr")

function DCStatisticsMgr:ctor()

end

function DCStatisticsMgr:onDelete()
	
end

local function _sortStage( a, b )
	if a.stage < b.stage then
		return true
	end
	return false
end
--获取期数范围内的数据
function DCStatisticsMgr:getLegalStageData(startStage, endStage)
	local startYear = tonumber(string.sub(startStage,1,4))
	local endYear = tonumber(string.sub(endStage,1,4))
	local allData = GMODEL(MOD.DC):getDCMgr():getAllData()

	local legalDataList = {}
	for k=startYear,endYear do
		local yds = allData[k]
		for _,v in pairs(yds) do
			if v.stage>=startStage and v.stage<=endStage then
				table.insert(legalDataList, v)
			end
		end
	end
	table.sort(legalDataList, _sortStage)
	return legalDataList
end

--获取数据的开出信息
function DCStatisticsMgr:appearRate(startStage, endStage)
	
	local legalDataList = self:getLegalStageData(startStage, endStage)

	local MAX_TOTAL = 0
	local redRateDataList = {}
	for i=1,33 do
		local rateData = {}
		rateData.ball = i
		rateData.total = 0
		rateData.stageInfos = {}
		for _,v in ipairs(legalDataList) do
			local stageInfo = {}
			if v.r[1]==i or v.r[2]==i or v.r[3]==i or v.r[4]==i or v.r[5]==i or v.r[6]==i then
				rateData.total = rateData.total+1
				stageInfo.flag = true--用于曲线画点上
			else
				stageInfo.flag = false--用于曲线画点下
			end
			stageInfo.stage = v.stage			
			table.insert(rateData.stageInfos, stageInfo)
		end
		if MAX_TOTAL<rateData.total then
			MAX_TOTAL = rateData.total
		end
		--table.sort( rateData.stageInfos, _sortStage )
		table.insert(redRateDataList, rateData)
	end

	for _,v in ipairs(redRateDataList) do
		v.percent = v.total*100.0/MAX_TOTAL
	end

	MAX_TOTAL = 0
	local blueRateDataList = {}
	for i=1,16 do
		local rateData = {}
		rateData.ball = i
		rateData.total = 0
		rateData.stageInfos = {}
		for _,v in ipairs(legalDataList) do
			local stageInfo = {}
			if v.b1==i then
				rateData.total = rateData.total+1
				stageInfo.flag = true
			else
				stageInfo.flag = false
			end
			stageInfo.stage = v.stage
			table.insert(rateData.stageInfos, stageInfo)
		end
		if MAX_TOTAL<rateData.total then
			MAX_TOTAL = rateData.total
		end
		--table.sort( rateData.stageInfos, _sortStage )
		table.insert(blueRateDataList, rateData)
	end

	for _,v in ipairs(blueRateDataList) do
		v.percent = v.total*100.0/MAX_TOTAL
	end
	return redRateDataList, blueRateDataList
end

--获取数据的总和信息
function DCStatisticsMgr:theSum(startStage, endStage)
	local legalDataList = self:getLegalStageData(startStage, endStage)
	local MAX_TOTAL = 0
	local THE_SUM = 0
	local sumDataList = {}
	for _,v in ipairs(legalDataList) do
		local rateData = {}
		rateData.ball = string.sub(v.stage,3)
		rateData.total = v.r[1]+v.r[2]+v.r[3]+v.r[4]+v.r[5]+v.r[6]
		if MAX_TOTAL<rateData.total then
			MAX_TOTAL=rateData.total
		end
		table.insert(sumDataList, rateData)
		THE_SUM = THE_SUM+rateData.total
	end
	for _,v in ipairs(sumDataList) do
		v.percent = v.total*100.0/MAX_TOTAL
	end
	local cnt = #sumDataList
	if cnt>0 then
		local average = THE_SUM/#sumDataList
		LOG_INFO("DCStatisticsMgr", "总和的平均数:%d", average)
		return sumDataList, average
	end

	return sumDataList
end

--获取数据的连号信息
function DCStatisticsMgr:theTwoEvenRate( startStage, endStage)
	local legalDataList = self:getLegalStageData(startStage, endStage)
	
	local MAX_TOTAL = 0
	local redRateDataList = {}
	for i=1,32 do
		local rateData = {}
		rateData.ball = i.."~"..i+1
		rateData.total = 0
		rateData.stageInfos = {}
		for _,v in ipairs(legalDataList) do
			local stageInfo = {}
			local lastD = -1
			stageInfo.flag = false
			--for _,key in ipairs(keyList) do
			for _,d in ipairs(v.r) do
				--local d = v[key]
				if lastD==i and lastD+1 == d then
					rateData.total = rateData.total+1
					stageInfo.flag = true
					break
				else
					lastD = d
				end
			end
			
			stageInfo.stage = string.sub(v.stage,3)		
			table.insert(rateData.stageInfos, stageInfo)
		end
		if MAX_TOTAL<rateData.total then
			MAX_TOTAL = rateData.total
		end
		table.sort( rateData.stageInfos, _sortStage )
		table.insert(redRateDataList, rateData)
	end

	for i,v in ipairs(redRateDataList) do
		v.percent = v.total*100.0/MAX_TOTAL
	end
	return redRateDataList
end


--获取数据的隔号信息
function DCStatisticsMgr:IntervalEvenRate( startStage, endStage)
	local legalDataList = self:getLegalStageData(startStage, endStage)
	
	local MAX_TOTAL = 0
	local redRateDataList = {}
	for i=1,31 do
		local rateData = {}
		rateData.ball = i.."~"..i+2
		rateData.total = 0
		rateData.stageInfos = {}
		for _,v in ipairs(legalDataList) do
			local stageInfo = {}
			local lastD = -1
			stageInfo.flag = false
			--for _,key in ipairs(keyList) do
			for _,d in ipairs(v.r) do
				--local d = v[key]
				if lastD==i and lastD+1 == d then
					rateData.total = rateData.total+1
					stageInfo.flag = true
					break
				else
					lastD = d
				end
			end
			
			stageInfo.stage = string.sub(v.stage,3)		
			table.insert(rateData.stageInfos, stageInfo)
		end
		if MAX_TOTAL<rateData.total then
			MAX_TOTAL = rateData.total
		end
		table.sort( rateData.stageInfos, _sortStage )
		table.insert(redRateDataList, rateData)
	end

	for i,v in ipairs(redRateDataList) do
		v.percent = v.total*100.0/MAX_TOTAL
	end
	return redRateDataList
end

--获取数据的顺序范围信息
function DCStatisticsMgr:sequenceRange(startStage, endStage)
	local legalDataList = self:getLegalStageData(startStage, endStage)
	local MAX_TOTAL = #legalDataList
	local rangeMap = {}
	for i=1,6 do
		local rangeList = {}
		for j=1,33 do
			local rateData = {}
			rateData.ball = j
			rateData.total=0
			for _,v in ipairs(legalDataList) do
				--if v["r"..i]==j then
				if v.r[i]==j then
					rateData.total=rateData.total+1
				end
			end
			rateData.percent = rateData.total*100.0/MAX_TOTAL
			table.insert(rangeList, rateData)
			
		end
		rangeMap[i] = rangeList
	end
	
	return rangeMap
end

local function _inTenSection( v )
	if v>0 and v<10 then
		return true
	end
end

local function _in2TenSection( v )
	if v>9 and v<20 then
		return true
	end
end

local function _in3TenSection( v )
	if v>19 and v<34 then
		return true
	end
end

function DCStatisticsMgr:sameSection_desc(  )
	if self.sameSectionDesc then
		return self.sameSectionDesc
	end	
	local section1_I3 = 0
	local section2_I3 = 0
	local section3_I3 = 0
	local section1_I4 = 0
	local section2_I4 = 0
	local section3_I4 = 0
	local section1_2 = 0
	local section1_3 = 0
	local section2_3 = 0
	local section_e = 0
	local tenCnt = 0
	local ten2Cnt = 0
	local ten3Cnt = 0

	local allData = GMODEL(MOD.DC):getDCMgr():getAllData()
	for _,yds in pairs(allData) do
		for _,v in pairs(yds) do
			tenCnt = 0
			ten2Cnt = 0
			ten3Cnt = 0

			--for _,key in ipairs(keyList) do
			for _,sv in ipairs(v.r) do
				if _inTenSection(sv) then
					tenCnt = tenCnt+1
				elseif _in2TenSection(sv) then
					ten2Cnt = ten2Cnt+1
				elseif _in3TenSection(sv) then
					ten3Cnt = ten3Cnt+1
				end
			end

			if tenCnt==3 then
				section1_I3=section1_I3+1
			elseif tenCnt>3 then
				section1_I4=section1_I4+1
			end
			if ten2Cnt==3 then
				section2_I3=section2_I3+1
			elseif ten2Cnt>3 then
				section2_I4=section2_I4+1
			end
			if ten3Cnt==3 then
				section3_I3=section3_I3+1
			elseif ten3Cnt>3 then
				section3_I4=section3_I4+1
			end

			if tenCnt>2 and ten2Cnt>2 then
				section1_2=section1_2+1
			end
			if tenCnt>2 and ten3Cnt>2 then
				section1_3=section1_3+1
			end
			if ten2Cnt>2 and ten3Cnt>2 then
				section2_3=section2_3+1
			end
			if tenCnt==2 and ten2Cnt==2 and ten3Cnt==2 then
				section_e = section_e+1
			end
		end
	end
	local totalCount = GMODEL(MOD.DC):getDCMgr():getTotalStageCount()

	local desc = {}
	table.insert(desc, string.format(_TT("dc","DC77"), section1_I3, section1_I3/totalCount*100))
	table.insert(desc, string.format(_TT("dc","DC78"), section2_I3, section2_I3/totalCount*100))
	table.insert(desc, string.format(_TT("dc","DC79"), section3_I3, section3_I3/totalCount*100))
	table.insert(desc, string.format(_TT("dc","DC91"), section1_I4, section1_I4/totalCount*100))
	table.insert(desc, string.format(_TT("dc","DC92"), section2_I4, section2_I4/totalCount*100))
	table.insert(desc, string.format(_TT("dc","DC93"), section3_I4, section3_I4/totalCount*100))
	table.insert(desc, string.format(_TT("dc","DC80"), section1_2, section1_2/totalCount*100))
	table.insert(desc, string.format(_TT("dc","DC81"), section1_3, section1_3/totalCount*100))
	table.insert(desc, string.format(_TT("dc","DC82"), section2_3, section2_3/totalCount*100))
	table.insert(desc, string.format(_TT("dc","DC95"), section_e, section_e/totalCount*100))

	-- for _,v in ipairs(desc) do
	-- 	LOG_DEBUG("DCStatisticsMgr", v)
	-- end
	self.sameSectionDesc = desc
	return desc	
end

function DCStatisticsMgr:lastBlueBallInRed_desc(  )

	if self.lastBlueBallInRedDesc then
		return self.lastBlueBallInRedDesc
	end
	local allData = GMODEL(MOD.DC):getDCMgr():getAllData()
	local allYearKeys = gp.table.keys(allData)
	local lastBlue = nil
	local lastBlue2 = nil
	
	local lastBlueCnt = 0
	local lastBlue2Cnt = 0
	table.sort( allYearKeys )
	for j=#allYearKeys,1,-1 do
		local yds = allData[allYearKeys[j]]
		local allKeys = gp.table.keys(yds)
		table.sort( allKeys )
		for k=#allKeys,1,-1 do
			local v = yds[allKeys[k]]
			if lastBlue2 and (v.r[1]==lastBlue2 or v.r[2]==lastBlue2 or v.r[3]==lastBlue2 or v.r[4]==lastBlue2 or v.r[5]==lastBlue2 or v.r[6]==lastBlue2) then
				lastBlue2Cnt = lastBlue2Cnt+1
			end

			if lastBlue and (v.r[1]==lastBlue or v.r[2]==lastBlue or v.r[3]==lastBlue or v.r[4]==lastBlue or v.r[5]==lastBlue or v.r[6]==lastBlue) then
				lastBlueCnt = lastBlueCnt+1
			end
			lastBlue2 = lastBlue
			lastBlue = v.b1
		end
	end

	
	---[[
	local totalCount = GMODEL(MOD.DC):getDCMgr():getTotalStageCount()
	local desc = {}
	table.insert(desc, string.format(_TT("dc","DC83"), lastBlueCnt, lastBlueCnt/totalCount*100))
	table.insert(desc, string.format(_TT("dc","DC84"), lastBlue2Cnt, lastBlue2Cnt/totalCount*100))

	-- for _,v in ipairs(desc) do
	-- 	LOG_DEBUG("DCStatisticsMgr", v)
	-- end
	self.lastBlueBallInRedDesc = desc
	return desc
	--]]
end

function DCStatisticsMgr:even_desc(  )
	if self.evenDesc then
		return self.evenDesc
	end

	local max_even = 0

	local totalEvenCnt = 0
	local evenCnt = 0
	local lastData = -1

	local even3Cnt = 0
	local last3Data = -1
	local total2Cnt = 0
	local total3Cnt = 0
	local total4Cnt = 0
	local total5Cnt = 0

	local total2A3Cnt = 0
	local noEvenCnt = 0;

	local allData = GMODEL(MOD.DC):getDCMgr():getAllData()
	for _,yds in pairs(allData) do
		for _,v in pairs(yds) do

			max_even = 0
			evenCnt = 0
			even3Cnt = 0

			lastData = -1
			last3Data = -1

			--for _,key in ipairs(keyList) do
			for _,d in ipairs(v.r) do
				if lastData+1 == d then
					evenCnt = evenCnt+1					
				else
					lastData = d
				end				

				if even3Cnt>max_even then
					max_even = even3Cnt
				end
				if last3Data+1==d then
					even3Cnt = even3Cnt+1
				else
					even3Cnt = 0
				end
				last3Data = d
			end

			if evenCnt>1 then
				totalEvenCnt = totalEvenCnt+1
			end

			if max_even==1 then
				total2Cnt = total2Cnt+1
			elseif max_even==2 then
				total3Cnt = total3Cnt+1
			elseif max_even==3 then
				total4Cnt = total4Cnt+1
			elseif max_even==4 then
				total5Cnt = total5Cnt+1
			elseif max_even < 1 then
				noEvenCnt = noEvenCnt+1
			end

			if evenCnt>1 and max_even>1 then
				total2A3Cnt = total2A3Cnt+1
				--LOG_INFO("", gp.table.tostring(v))
			end
		end
	end

	local totalCount = GMODEL(MOD.DC):getDCMgr():getTotalStageCount()
	local desc = {}
	table.insert(desc, string.format(_TT("dc","DC85"), totalEvenCnt, totalEvenCnt/totalCount*100))
	table.insert(desc, string.format(_TT("dc","DC86"), total2A3Cnt, total2A3Cnt/totalCount*100))
	table.insert(desc, string.format(_TT("dc","DC87"), total2Cnt, total2Cnt/totalCount*100))
	table.insert(desc, string.format(_TT("dc","DC88"), total3Cnt, total3Cnt/totalCount*100))
	table.insert(desc, string.format(_TT("dc","DC89"), total4Cnt, total4Cnt/totalCount*100))
	table.insert(desc, string.format(_TT("dc","DC90"), total5Cnt, total5Cnt/totalCount*100))
	table.insert(desc, string.format(_TT("dc","DC100"), noEvenCnt, noEvenCnt/totalCount*100))

	-- for _,v in ipairs(desc) do
	-- 	LOG_DEBUG("DCStatisticsMgr", v)
	-- end
	self.evenDesc = desc
	return desc
	
end

function DCStatisticsMgr:twoEven_desc(  )
	if self.twoEvenDesc then
		return self.twoEvenDesc
	end
	local evenMap = {}
	local allData = GMODEL(MOD.DC):getDCMgr():getAllData()
	for _,yds in pairs(allData) do
		for _,v in pairs(yds) do
			lastData = -1
			for _,d in ipairs(v.r) do
			--for _,key in ipairs(keyList) do
				--local d = v[key]
				if lastData+1 == d then
					evenMap[lastData] = evenMap[lastData] or 0
					evenMap[lastData] = evenMap[lastData]+1
				end
				lastData = d
			end
		end
	end


	local totalCount = GMODEL(MOD.DC):getDCMgr():getTotalStageCount()
	local desc = {}
	for k,v in pairs(evenMap) do
		table.insert(desc, string.format(_TT("dc","DC98"), k.."~"..k+1, v, v/totalCount*100))
	end
	
	-- for _,v in ipairs(desc) do
	-- 	LOG_DEBUG("DCStatisticsMgr", v)
	-- end
	self.twoEvenDesc = desc
	return desc
end

function DCStatisticsMgr:Interval3Even_desc(  )
	if self.intervalEvenDesc then
		return self.intervalEvenDesc
	end
	local t = "a b "
	local arr = gp.str.split(t, " ")
	print("arr "..#arr)
	local evenCnt = 1
	local evenMap = {}
	local allData = GMODEL(MOD.DC):getDCMgr():getAllData()
	for _,yds in pairs(allData) do
		for _,v in pairs(yds) do
			lastData = -1
			evenCnt = 1
			--for _,key in ipairs(keyList) do
			for _,d in ipairs(v.r) do
				--local d = v[key]
				if lastData>0 and lastData+2 == d then
					evenCnt = evenCnt+1
				else
					if lastData>0 and evenCnt>1 then
						local evenKey = ""
						for i=evenCnt, 1, -1 do
							evenKey = evenKey..lastData.." "
							lastData = lastData-2
						end
						evenMap[evenKey] = evenMap[evenKey] or 0
						evenMap[evenKey] = evenMap[evenKey] + 1
					end
					evenCnt = 1
				end
				lastData = d
			end
		end
	end


	local totalCount = GMODEL(MOD.DC):getDCMgr():getTotalStageCount()
	local even3 = 0
	local even4 = 0
	local even5 = 0
	local even6 = 0
	local desc = {}
	for k,v in pairs(evenMap) do
		table.insert(desc, string.format("间隔号[%s]总出现:%d次, 占%f%%", k, v, v/totalCount*100))
		local cnt = #gp.str.split(k, " ")-1
		if cnt==3 then
			even3=even3+v
		elseif cnt==4 then
			even4=even4+v
		elseif cnt==5 then
			even5=even5+v
		elseif cnt==6 then
			even6=even6+v
		end
	end
	table.insert(desc, string.format("间隔连续3个的有:%d次, 占%f%%", even3, even3/totalCount*100))
	table.insert(desc, string.format("间隔连续4个的有:%d次, 占%f%%", even4, even4/totalCount*100))
	table.insert(desc, string.format("间隔连续5个的有:%d次, 占%f%%", even5, even5/totalCount*100))
	table.insert(desc, string.format("间隔连续6个的有:%d次, 占%f%%", even6, even6/totalCount*100))
	
	-- for _,v in ipairs(desc) do
	-- 	LOG_DEBUG("DCStatisticsMgr", v)
	-- end
	self.intervalEvenDesc = desc
	return desc
end

function DCStatisticsMgr:numApp_desc(  )
	if self.numAppDesc then
		return self.numAppDesc
	end
	local evenMap = {}
	local allData = GMODEL(MOD.DC):getDCMgr():getAllData()
	for _,yds in pairs(allData) do
		for _,v in pairs(yds) do
			local key = v.r[1].."_"..v.r[2]
			evenMap[key] = evenMap[key] or 0
			evenMap[key] = evenMap[key] + 1
		end
	end


	local totalCount = GMODEL(MOD.DC):getDCMgr():getTotalStageCount()
	local desc = {}
	for k,v in pairs(evenMap) do
		table.insert(desc, string.format("首号连气:%s == %d", k, v))
	end
	
	-- for _,v in ipairs(desc) do
	-- 	LOG_DEBUG("DCStatisticsMgr", v)
	-- end
	self.numAppDesc = desc
	return desc
end

return DCStatisticsMgr
