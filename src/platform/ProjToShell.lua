
local ProjToShell = class("ProjToShell")

function ProjToShell:OpenUserCenter()	
	return PlatformMgr:_callShellFunction("ToShell_OpenUserCenter")	
end



function ProjToShell:reLogin(bCallSDK)
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

--TO_Shell ��� BEGIN

--ע��callGameFunction�ľ��
function ProjToShell:registerToLuaCallback()
	LOG_DEBUG("PlatformMgr","registerToLuaCallback ... BEGIN");
	if PlatformMgr:_registerGameCallback() == nil then		
		GameWorld:getLoginModule():requestServerList()
	end
	LOG_DEBUG("PlatformMgr","requestServerList ... BEGIN");
end

function ProjToShell:closeLogo()
	LOG_DEBUG("PlatformMgr","ToShell_ToCloseLogo ... BEGIN");
	if PlatformMgr:_callShellFunction("ToShell_ToCloseLogo", "") == nil then
		GameWorld:getLoginModule():onLogoClosed();		
	end
end
--ƽ̨���汾�����������ͻ���
function ProjToShell:localServerId()
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


function ProjToShell:sdkLogin()    
	LOG_DEBUG("PlatformMgr","ToShell_SdkLogin ... BEGIN");
	
	if PlatformMgr:_callShellFunction("ToShell_SdkLogin", "") == nil then							
		GameWorld:getLoginModule():showLoginInput()		
	end
end

--��ȡconfig��Ϣ
--��ȡconfig.xml������
function ProjToShell:getConfig(key)
	LOG_DEBUG("PlatformMgr","ToShell_GetConfig key="..tostring(key));
	if key == nil or type(key) ~= "string" then
		LOG_WARN("PlatformMgr", "ToShell_GetConfig key == [%s] error", tostring(key))
		return nil
	end
	return PlatformMgr:_callShellFunction("ToShell_GetConfig", key)	
end
-- ��ȡԤ���ص����ݡ�
function ProjToShell:getPreLoadData(key)
	LOG_DEBUG("PlatformMgr","ToShell_GetPreLoadData key="..tostring(key));
	if key == nil or type(key) ~= "string" then
		LOG_WARN("PlatformMgr", "ToShell_GetPreLoadData key == [%s] error", tostring(key))
		return nil
	end
	return PlatformMgr:_callShellFunction("ToShell_GetPreLoadData", key)	
end

--[[
��¼��Ҳ���

100���������������Ĳ����¼
--]]
ProjToShell.playerStep_ResBeginDownload = "12" --��Դ��ʼ���� ��Ҫƴ����Դ�汾�� ","Ϊ�ָ�����
ProjToShell.playerStep_ResDownloadError = "13"	--��Դ���س���
ProjToShell.playerStep_ResDownloadSuccess = "14" --��Դ�������
ProjToShell.playerStep_LoadResSuccess = "17" --��Դ�������
ProjToShell.playerStep_EnterMainScence = "18" --��һ�ν�����Ϸ����
ProjToShell.playerStep_FirstEnterGuan = "19" --��һ�ν���ؿ�

function ProjToShell:playerStep(iStep)
	LOG_DEBUG("PlatformMgr","ToShell_PlayerStep iStep="..iStep);
	PlatformMgr:_callShellFunction("ToShell_PlayerStep", tostring(iStep))	
end

--֪ͨ�������б�������(�ɹ�&ʧ��)result:�����������б�json // ʧ��ʱ����""
--��ʵ���ڸ���SDK�򿪵�¼����
function ProjToShell:serverListResult(result)
	LOG_DEBUG("PlatformMgr","serverListResult ...BEGIN");
	PlatformMgr:_callShellFunction("ToShell_ServerListResult", result)	
end


function ProjToShell:pay(payRef)
	LOG_DEBUG("PlatformMgr","ToShell_Pay ...BEGIN");
	--�������ڳ�ֵ��ʾ��
	
	if self:getDeviceType() == 4 then --iosƽ̨ ������ֵ�Ƚ��� ���Բ��������ķ�ʽӦ�Զ��ε��
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

function ProjToShell:playerInfo(hero)

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

function ProjToShell:consumeGold(subGlod)
	LOG_DEBUG("PlatformMgr","ToShell_ConsumeGold ...BEGIN");	
	PlatformMgr:_callShellFunction("ToShell_ConsumeGold", tostring(subGlod))	
end

--�����ص�
function ProjToShell:exit()
	LOG_DEBUG("PlatformMgr","ToShell_Exit ...BEGIN");
	PlatformMgr:_callShellFunction("ToShell_Exit", "")	
end

function ProjToShell:getVersion()
	local version = PlatformMgr:_callShellFunction("ToShell_GetVersion", "")
	if version == nil then
		version = "1.0.0.0"
	end
	return version	
end

function ProjToShell:upgradeLvl()	
	local hero = GameWorld:getPlayerModule():getHero()
	if hero then
		PlatformMgr:_callShellFunction("ToShell_UpgradeLvl", tostring(hero.level))		
	end	
end

function ProjToShell:createRole()
	local hero = GameWorld:getPlayerModule():getHero()	
	if hero then
		local jData = {}
		jData.playerName = hero.name	
		jData.lvl = hero.level	
		local jsonStr = gp.json.jsonTableToJString(jData)
		PlatformMgr:_callShellFunction("ToShell_CreateRole", jsonStr)		
	end	
end

function ProjToShell:pickImage()
	PlatformMgr:_callShellFunction("ToShell_PickImage", "")	
end

function ProjToShell:openWebView(url)    
    if url then
    	PlatformMgr:_callShellFunction("ToShell_OpenWebView", url)        
    end	
end

function ProjToShell:thirdPartyPayment()
    local loginMgr = GameWorld:getLoginModule():getMgr();
    if loginMgr.rechargeParams or GameConfig.Language =="tw" then
    	PlatformMgr:_callShellFunction("ToShell_ThirdPartyPayment", "")        
    end
	
end
--TO_Shell ��� END

--������ BEGIN

ProjToShell.Prompt_LoginGameServer = 1
function ProjToShell:handlePrompt(promptType, param)
	local msg = _TT(18)--"����ص���";
	if promptType == PlatformMgr.Prompt_LoginGameServer then
		if param == 1 then
			msg = _TT(19)--"md5У��ʧ��,�����ԣ�";
		elseif param == 2 then
			msg = _TT(20)--"ʱ������,�����ԣ�";
		elseif param == 3 then
			msg = _TT(21)--"��������,�����ԣ�";
		else
			msg = _TT(22)--"�ɹ�������Ϸ";
		end
	end
	
	showNoticeString(msg)
end
--[[
ProjToShell.Error_ServerList = _TT(23)--��ȡ�����б�ʧ�ܣ����˳���Ϸ�����ԣ�
ProjToShell.Error_ResouresList = _TT(24)--������Դ�б�����������磡
ProjToShell.Error_ResouresDown = _TT(25)--��Դ���س����������磡
ProjToShell.Error_ResouresMd5 = _TT(26)--������Դ�𻵣������ԣ�
--]]
function ProjToShell:handleError(errorType)
	local function _callback()
		cc.Director:getInstance():endToLua()
	end
	local alert = createAlertOK(errorType, _callback)
	GameWorld:getUIMgr():showAlert(alert)		
end

--������ END

return ProjToShell
