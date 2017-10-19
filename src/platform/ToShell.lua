
local ToShell = ToShell or {}


function ToShell:OpenUserCenter()	
	return PlatformMgr:_callShellFunction("ToShell_OpenUserCenter")	
end



function ToShell:reLogin(bCallSDK)
	--JOGame:shutdown()	
	
	local function _clearCallback(bFinish)
		if bFinish == true then
			GameWorld:getUIMgr():clear()
			GameWorld:reloadLoginModule()
			GameWorld:getSceneMgr():showLoginScene()
			
			if bCallSDK == true then				
				PlatformMgr:_callShellFunction("ToShell_ChangeAccount", "")				
			end			
		end
	end	
	gp.time.stopAll()
	JOGame:getDispatcher():shutdown()	
	GameWorld:clearModules(_clearCallback)	
end

--TO_Shell 相关 BEGIN

--注册callGameFunction的句柄
function ToShell:registerToLuaCallback()
	LOG_DEBUG("PlatformMgr","registerToLuaCallback ... BEGIN");
	if PlatformMgr:_registerGameCallback() == nil then		
		GameWorld:getLoginModule():requestServerList()
	end
	LOG_DEBUG("PlatformMgr","requestServerList ... BEGIN");
end

function ToShell:closeLogo()
	LOG_DEBUG("PlatformMgr","ToShell_ToCloseLogo ... BEGIN");
	if PlatformMgr:_callShellFunction("ToShell_ToCloseLogo", "") == nil then
		GameWorld:getLoginModule():onLogoClosed();		
	end
end
--平台检测版本，用于升级客户端
function ToShell:localServerId()
	LOG_DEBUG("PlatformMgr","ToShell_LocalServerId ... BEGIN");
	local mgr = GameWorld:getLoginModule():getMgr()
	if mgr.defServerId == -1 then
		PlatformMgr:handleError(PlatformMgr.Error_ServerList);
		--PlatformMgr:getServerListFail()
	else		
		GameWorld:getUIMgr():showWaiting(5)				
		if PlatformMgr:_callShellFunction("ToShell_LocalServerId", tostring(mgr.defServerId)) == nil then		
			GameWorld:getLoginModule():requestResJson()			
		end
	end	
end


function ToShell:sdkLogin()    
	LOG_DEBUG("PlatformMgr","ToShell_SdkLogin ... BEGIN");
	
	if PlatformMgr:_callShellFunction("ToShell_SdkLogin", "") == nil then							
		GameWorld:getLoginModule():showLoginInput()		
	end
end

--获取config信息
--获取config.xml的配置
function ToShell:getConfig(key)
	LOG_DEBUG("PlatformMgr","ToShell_GetConfig key="..tostring(key));
	if key == nil or type(key) ~= "string" then
		LOG_WARN("PlatformMgr", "ToShell_GetConfig key == [%s] error", tostring(key))
		return nil
	end
	return PlatformMgr:_callShellFunction("ToShell_GetConfig", key)	
end
-- 获取预加载的数据。
function ToShell:getPreLoadData(key)
	LOG_DEBUG("PlatformMgr","ToShell_GetPreLoadData key="..tostring(key));
	if key == nil or type(key) ~= "string" then
		LOG_WARN("PlatformMgr", "ToShell_GetPreLoadData key == [%s] error", tostring(key))
		return nil
	end
	return PlatformMgr:_callShellFunction("ToShell_GetPreLoadData", key)	
end

--[[
记录玩家步骤

100以外是新手引导的步骤记录
--]]
ToShell.playerStep_ResBeginDownload = "12" --资源开始下载 （要拼个资源版本号 ","为分隔符）
ToShell.playerStep_ResDownloadError = "13"	--资源下载出错
ToShell.playerStep_ResDownloadSuccess = "14" --资源下载完成
ToShell.playerStep_LoadResSuccess = "17" --资源加载完成
ToShell.playerStep_EnterMainScence = "18" --第一次进入游戏场景
ToShell.playerStep_FirstEnterGuan = "19" --第一次进入关卡

function ToShell:playerStep(iStep)
	LOG_DEBUG("PlatformMgr","ToShell_PlayerStep iStep="..iStep);
	PlatformMgr:_callShellFunction("ToShell_PlayerStep", tostring(iStep))	
end

--通知服务器列表请求结果(成功&失败)result:整个服务器列表json // 失败时返回""
--其实用于告诉SDK打开登录界面
function ToShell:serverListResult(result)
	LOG_DEBUG("PlatformMgr","serverListResult ...BEGIN");
	PlatformMgr:_callShellFunction("ToShell_ServerListResult", result)	
end


function ToShell:pay(payRef)
	LOG_DEBUG("PlatformMgr","ToShell_Pay ...BEGIN");
	--加入正在充值提示框
	
	if self:getDeviceType() == 4 then --ios平台 弹出充值比较慢 所以采用这样的方式应对二次点击
		local alert = createAlertOK(_TT(2))
		GameWorld:getUIMgr():showAlert(alert)
		PlatformMgr.isPaying = true
	end
	
	--showTextTips({"you want to pay? but this is PC, Don't think too much"})	
	
	local jData = {}
	jData.gold = payRef.getGold
	jData.money = payRef.rmbNeed
    jData.lvlLimit = payRef.lvlLimit
    jData.refId = payRef.refId
    if payRef.productId == nil then
        payRef.productId = 0
    end
    jData.productId = payRef.productId
	local jsonStr = gp.json.jsonTableToJString(jData)

	if PlatformMgr:_callShellFunction("ToShell_Pay", jsonStr) == nil then
		showTextTips({"you want to pay? but this is PC, Don't think too much"})	
	end
	
end

function ToShell:playerInfo(hero)

	LOG_DEBUG("PlatformMgr","ToShell_PlayerInfo ...BEGIN");	
	
	local jData = {}
	jData.playerName = hero.name
	jData.identityName = ""
	jData.lvl = hero.level
	jData.playerId = hero.id
    jData.vipLvl = hero.vip
    jData.gold = hero.gold
	local jsonStr = gp.json.jsonTableToJString(jData)
	
	PlatformMgr:_callShellFunction("ToShell_PlayerInfo", jsonStr)
	
end

function ToShell:consumeGold(subGlod)
	LOG_DEBUG("PlatformMgr","ToShell_ConsumeGold ...BEGIN");	
	PlatformMgr:_callShellFunction("ToShell_ConsumeGold", tostring(subGlod))	
end

--按键回调
function ToShell:exit()
	LOG_DEBUG("PlatformMgr","ToShell_Exit ...BEGIN");
	PlatformMgr:_callShellFunction("ToShell_Exit", "")	
end

function ToShell:getVersion()	
	local version = PlatformMgr:_callShellFunction("ToShell_GetVersion", "")
	if version == nil then
		version = "1.0.0.0"
	end
	return version	
end

function ToShell:upgradeLvl()	
	local hero = GameWorld:getPlayerModule():getHero()
	if hero then
		PlatformMgr:_callShellFunction("ToShell_UpgradeLvl", tostring(hero.level))		
	end	
end

function ToShell:createRole()
	local hero = GameWorld:getPlayerModule():getHero()	
	if hero then
		local jData = {}
		jData.playerName = hero.name	
		jData.lvl = hero.level	
		local jsonStr = gp.json.jsonTableToJString(jData)
		PlatformMgr:_callShellFunction("ToShell_CreateRole", jsonStr)		
	end	
end

function ToShell:pickImage()
	PlatformMgr:_callShellFunction("ToShell_PickImage", "")	
end

function ToShell:openWebView(url)    
    if url then
    	PlatformMgr:_callShellFunction("ToShell_OpenWebView", url)        
    end	
end

function ToShell:thirdPartyPayment()
    local loginMgr = GameWorld:getLoginModule():getMgr();
    if loginMgr.rechargeParams or GameConfig.Language =="tw" then
    	PlatformMgr:_callShellFunction("ToShell_ThirdPartyPayment", "")        
    end
	
end
--TO_Shell 相关 END

--错误处理 BEGIN

ToShell.Prompt_LoginGameServer = 1
function ToShell:handlePrompt(promptType, param)
	local msg = _TT(18)--"错误回调！";
	if promptType == PlatformMgr.Prompt_LoginGameServer then
		if param == 1 then
			msg = _TT(19)--"md5校验失败,请重试！";
		elseif param == 2 then
			msg = _TT(20)--"时戳过期,请重试！";
		elseif param == 3 then
			msg = _TT(21)--"参数错误,请重试！";
		else
			msg = _TT(22)--"成功进入游戏";
		end
	end
	
	showNoticeString(msg)
end
--[[
ToShell.Error_ServerList = _TT(23)--获取服务列表失败，请退出游戏再重试！
ToShell.Error_ResouresList = _TT(24)--请求资源列表出错，请检查网络！
ToShell.Error_ResouresDown = _TT(25)--资源下载出错，请检查网络！
ToShell.Error_ResouresMd5 = _TT(26)--下载资源损坏，请重试！
--]]
function ToShell:handleError(errorType)
	local function _callback()
		cc.Director:getInstance():endToLua()
	end
	local alert = createAlertOK(errorType, _callback)
	GameWorld:getUIMgr():showAlert(alert)		
end

--错误处理 END

return ToShell
