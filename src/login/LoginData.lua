--[[
serverInfo:
id
name
ip
port
servicesUrl
fightReportUrl 战报地址
clientUpdateUrl 程序包更新地址
updateVer	资源\脚本的版本
zipUrl 		资源\脚本的地址
zipMd5		资源\脚本的Md5
backupZipUrl	资源\脚本的后备地址
]]

local LoginData = class("LoginData")

function LoginData:ctor()
	self:onInit();
end

function LoginData:onDelete()
	
end

function LoginData:onInit()
	--由后台提供的数据
	--[[	
	noticeUrl = 0	--区公告地址	
	--backupresUrl = 0	--客户端后备资源配置地址
	gameNoticeUrl = 0	--游戏公告地址
	gameNoticeListUrl = 0	--游戏公告列表地址
	GMServicesUrl = 0	--后台游戏服地址	
	serverList = {} --服务器列表	
	specialVerServers --用于只显示测试服数据 用于IOS提审时只显示限制版本的特殊服
	shareUrl =  --用于特殊开关（分享按键）
	rechargeParams --用于特殊开关(第三方充值)
	
	clientUpdateUrl 程序包更新地址
	updateVer	资源\脚本的版本
	zipUrl 		资源\脚本的地址
	zipMd5		资源\脚本的Md5
	backupZipUrl	资源\脚本的后备地址
	]]
	self.backendDs = {}

	--由sdk提供的数据	
	self.sdkDs = {}
	self.sdkDs.identityId	= ""
	self.sdkDs.identityName = ""
	self.sdkDs.timeStamp = os.time()
	self.sdkDs.sign = "sign"
	self.sdkDs.uuid = "uuid"
	self.sdkDs.qdCode1 = 1
	self.sdkDs.qdCode2 = 1
	self.sdkDs.appId = ""
	self.sdkDs.userId = ""
	self.sdkDs.channelId = ""

	self.selSerId = -1 --选中的服务器ID
	self.selSerInfo = nil --选中的服务信息
end

function LoginData._sortServerList(a, b)
	if a and b and a.orders > b.orders then
		return true
	end
	return false
end

--保存账号，密码
--记录用过的账号
function LoginData:saveAccount( account, password )
	--[[
	local accountArray = cc.UserDefault:getInstance():getStringForKey(_up.UK.ACCOUNT_ARRAY)
	local function _decodeJson()
		accountArray = gp.json.jsonTableFromString( accountArray );
	end
	
	if pcall(_decodeJson) and type(accountArray) == "table" then
		local accountData = accountArray[1]
		if accountData.account ~= account or accountData.password ~= password then
			local accountData = {}
			accountData.account = account
			accountData.password = password	

			local t = {}
			table.insert(t, accountData)
			for i=1,#accountArray do
				table.insert(t, accountArray[i])
			end
			local jsonStr = gp.json.jsonTableToJString(t)
			cc.UserDefault:getInstance():setStringForKey(_up.UK.ACCOUNT_ARRAY, jsonStr)		
		end		
	else
		local accountData = {}
		accountData.account = account
		accountData.password = password
		local jsonStr = gp.json.jsonTableToJString(accountData)
		cc.UserDefault:getInstance():setStringForKey(_up.UK.ACCOUNT_ARRAY, jsonStr)		
	end
	]]
end
--保存后台数据
function LoginData:setDataFromJTable(jData)

	--资源更新相关 BEGIN
	self.backendDs.clientUpdateUrl = jData.clientUpdateUrl	
	self.backendDs.updateVer = jData.updateVer	
	self.backendDs.zipUrl = jData.zipUrl	
	self.backendDs.zipMd5 = jData.zipMd5	
	self.backendDs.backupZipUrl = jData.backupZipUrl	
	--资源更新相关 END
	self.backendDs.noticeUrl = jData.noticeUrl	
	self.backendDs.backupresUrl = jData.backupresUrl
	self.backendDs.gameNoticeUrl = jData.gameNoticeUrl
	self.backendDs.gameNoticeListUrl = jData.gameNoticeListUrl
	self.backendDs.GMServicesUrl = jData.GMServicesUrl	
	self.backendDs.serverList = jData.serversList
    self.backendDs.vkPeiZhi = jData.vkPeiZhi

    if jData.specialVerServers then
        local specialServersInfos = string.split(jData.specialVerServers, ";");
        local verMap = {}
        for i=1, #specialServersInfos do
        
            local info = specialServersInfos[i]
            local verInfo = string.split(info, ":");
            if #verInfo >1 then
                local serIdList = string.split(verInfo[2], ",")
                verMap[verInfo[1]] = serIdList;
            end
        end
        self.backendDs.specialVerServers = verMap;
    end
    
    if jData.shareUrl and string.len(tostring(jData.shareUrl)) > 0 then
        self.backendDs.shareUrl = jData.shareUrl
    end
    if jData.rechargeParams and string.len(tostring(jData.rechargeParams)) > 0 then
        self.backendDs.rechargeParams = jData.rechargeParams
    end

	for i=1, #self.backendDs.serverList do
		LOG_INFO("LoginMgr", "id = %s", tostring(self.backendDs.serverList[i].id))
		LOG_INFO("LoginMgr", "name = %s", tostring(self.backendDs.serverList[i].name))
		LOG_INFO("LoginMgr", "port = %s", tostring(self.backendDs.serverList[i].port))
		LOG_INFO("LoginMgr", "ip = %s", tostring(self.backendDs.serverList[i].ip))
		LOG_INFO("LoginMgr", "servicesUrl = %s", tostring(self.backendDs.serverList[i].servicesUrl))
		LOG_INFO("LoginMgr", "clientUpdateUrl = %s", tostring(self.backendDs.serverList[i].clientUpdateUrl))
		LOG_INFO("LoginMgr", "resJsonUrl = %s", tostring(self.backendDs.serverList[i].resJsonUrl))
		LOG_INFO("LoginMgr", "resUrl = %s", tostring(self.backendDs.serverList[i].resUrl))
		LOG_INFO("LoginMgr", "fightReportUrl = %s", tostring(self.backendDs.serverList[i].fightReportUrl))
	end
	LOG_INFO("LoginMgr", "self.backendDs.noticeUrl = %s", tostring(self.backendDs.noticeUrl))
	LOG_INFO("LoginMgr", "self.backendDs.rechargeChannelUrl = %s", tostring(self.backendDs.rechargeChannelUrl))
	LOG_INFO("LoginMgr", "self.backendDs.servicesUrl = %s", tostring(self.backendDs.servicesUrl))

	-- 这个很重要！！！
	-- 如果配置了特殊版本提审服，当本客户端版本与特殊版本相等，则默认服取提审服
	-- 如果是有一个正常的良好状态的提审服
	if self.backendDs.specialVerServers then       
		local clientVer = "" --_up.ToShell:getVersion()
        for k, v in pairs(self.backendDs.specialVerServers) do
            if k == clientVer then
                for i=1, #v do
					local serId = v[i]; -- 一般只需要一个提审服。
					local srvInfo = self:getServerWithId(serId)
					if srvInfo and srvInfo.state then -- and ( srvInfo.state >= 2 and srvInfo.state <= 5 ) then
						self.selSerId = serId; -- 这里还要判断提审服的状态。
						return true
					end
                end
            end 
        end
    end	
		
	if #self.backendDs.serverList > 0 then				
		table.sort(self.backendDs.serverList, self._sortServerList)
		--获取默认服务器id
		local serId = cc.UserDefault:getInstance():getStringForKey(_up.UK.defServerId)
		
		if serId and string.len(tostring(serId)) > 0 then
			LOG_INFO("LoginData", "UK.defServerId = %s", tostring(serId))
			if self:getServerWithId(serId) then
				self.selSerId = serId		
				return true
			end
		end
		-- 如果有推荐的服，随机分流到推荐服 
		local signList = {} 
		for _,v in ipairs(self.backendDs.serverList) do
			-- sign 0:无;1:新服;2:热门;3:推荐
			-- state 0：停机；1：维护；2：良好；3：繁忙；4：爆满；5：火爆
			if v.state == 2 and v.sign and v.sign==3 then 
				table.insert(signList, v)
			end
		end  

		if #signList > 0 then 
			local randomIndex = math.random(1, #signList) 
			self.selSerId = signList[randomIndex].id
			return true
		end
		-- 如果没有推荐服，取第一个良好的服务器作为默认服
		for i=1, #self.backendDs.serverList do
			local srvInfo = self.backendDs.serverList[i]
			if srvInfo and srvInfo.state and ( srvInfo.state >= 2 and srvInfo.state <= 5 ) then
				self.selSerId = srvInfo.id
				return true
			end
		end
		self.selSerId = self.backendDs.serverList[1].id				
		return true
	end
	
	return false	
end

function LoginData:getServerWithId(serId)
	if self.backendDs.serverList then
		for i=1, #self.backendDs.serverList do
			if tonumber(serId) == tonumber(self.backendDs.serverList[i].id) then
				LOG_INFO("LoginData", "getServerWithId = %s", tostring(serId))
				return self.backendDs.serverList[i]
			end
		end
	end
	return nil
end

function LoginData:getSelServer()
	return self:getServerWithId(self.selSerId)
end

return LoginData;

