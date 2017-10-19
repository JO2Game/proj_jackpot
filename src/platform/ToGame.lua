local ToGame = ToGame or {}


function ToGame:_onCallback(key,jsonParam)	
		
		if key == "ToGame_StartUp" then	
			
			ToGame:startUp()

		elseif key == "ToGame_LogoClosed" then	
		
			ToGame:logoClosed()

		elseif key == "ToGame_ShowVersionUpdateDlg" then
		
			ToGame:showVersionUpdateDlg()

		elseif key == "ToGame_ShowDownloadDlg" then
		
			ToGame:showDownloadDlg(jsonParam)

		elseif key == "ToGame_updateProgress" then	
		
			ToGame:updateProgress(jsonParam)

		elseif key == "ToGame_DownloadError" then
		
			ToGame:showVersionUpdateDlg()

		elseif key == "ToGame_EndCheckUpdate" then	
		
			ToGame:endCheckUpdate()
			
		elseif key == "ToGame_LoginSuccess" then			
			
			ToGame:loginSuccess()
			
		elseif key == "ToGame_IdentityResult" then	
		
			ToGame:identityResult(jsonParam)
		
		elseif key == "ToGame_ChangeAccount" then
		
			ToGame:changeAccount()
			
		elseif key == "ToGame_PickImage" then
		
			ToGame:pickImage(jsonParam)
		elseif key == "ToGame_PayAlertClose" then
	
			ToGame:payAlertClose()			
		end

		return true;
end


function ToGame:startUp()
	GameWorld:getLoginModule():requestServerList()	
end

function ToGame:logoClosed()
	GameWorld:getLoginModule():onLogoClosed()
end

function ToGame:payAlertClose()
	PlatformMgr.isPaying = false
	GameWorld:getUIMgr():clearAlert()
end

function ToGame:showVersionUpdateDlg()
	GameWorld:getUIMgr():removeWaiting()
	local function _alertCallback(tag)			
        local mgr = GameWorld:getLoginModule():getMgr()
		local serInfo = mgr:getServerWithId(mgr.defServerId)

        if serInfo == nil then
            local alert = createAlertOK("serInfo == nil defServerId == %s", tostring(mgr.defServerId))
	        GameWorld:getUIMgr():showAlert(alert)
            return
        end
        local platformModule = nil
        local updateUrl = nil
		if DeviceUtil.platform == "android" then
			platformModule = JniModule
            updateUrl = {}
            updateUrl.url = serInfo.clientUpdateUrl
            updateUrl.backupUrl = serInfo.backupClientUpdateUrl
            updateUrl = gp.json.jsonTableToJString(updateUrl)
		elseif DeviceUtil.platform == "ios" then
			platformModule = IosBridge		
            updateUrl = serInfo.clientUpdateUrlIOS
		end
        if platformModule and updateUrl then
            if UIAlert.ok == tag then        
				platformModule:callShellFunction("ToShell_AutoDownload", updateUrl)
			elseif UIAlert.cancel == tag then
				platformModule:callShellFunction("ToShell_ManualDownload", updateUrl)
			end       
        else
            local alert = createAlertOK("clientUpdateUrl == nil ")
	        GameWorld:getUIMgr():showAlert(alert)
        end
	end
	
	local alert
	if DeviceUtil.platform == "ios" then	
        alert = createAlertOKCancel(_TT(136), _alertCallback)
		alert.okText = _TT(134)
		alert.cancelText = _TT(135)
	else
        alert = createAlertOKCancel(_TT(157), _alertCallback)
		alert.okText = _TT(155)
		alert.cancelText = _TT(156)
	end	
	--alert:setMsgHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT);
	GameWorld:getUIMgr():showAlert(alert)	
end

function ToGame:showDownloadDlg(progress)	
	LOG_DEBUG("ToGame","showDownloadView progress="..tostring(progress))	
	GameWorld:getLoginModule():showLogin()
	PlatformMgr:ToShell_ToCloseLogo()
	GameWorld:getLoginModule():showDownLoadRes(progress)		
end

function ToGame:updateProgress(progress)
	LOG_DEBUG("ToGame","updateDownloadProgress progress="..tostring(progress))
	GameWorld:getLoginModule():showDownLoadRes(progress)	
end

function ToGame:endCheckUpdate()
	cc.Director.getInstance():resume()
	local platformModule = nil
	if DeviceUtil.platform == "android" then
		platformModule = JniModule
	elseif DeviceUtil.platform == "ios" then
		platformModule = IosBridge		
	end
	if platformModule then		
		local function _time()			
			local mgr = GameWorld:getLoginModule():getMgr()
			platformModule:callShellFunction("ToShell_GetIdentity", tostring(mgr.defServerId))
		end
		--暂时只传id		
		gp.time.delayCall(0.1, _time)
	else
		GameWorld:getLoginModule():requestResJson()	
	end
	
end


function ToGame:loginSuccess()
	GameWorld:fastDispatchEvent00(Event_Login.Login_InputedAccount)
end
-- 获取预加载的数据。
function ToGame:identityResult(jsonParam)
	local jData = gp.json.jsonTableFromString(jsonParam)
	local mgr = GameWorld:getLoginModule():getMgr()
	mgr.identityId = jData.identityId
	mgr.identityName = jData.identityName
	mgr.timeStamp = jData.tstamp
	mgr.sign = jData.sign

    if tostring( jData.serverId ) ~= tostring( mgr.defServerId ) then
        return;
    end
	
	local platformModule = nil
	if DeviceUtil.platform == "android" then
		platformModule = JniModule		
	elseif DeviceUtil.platform == "ios" then
		platformModule = IosBridge		
	end
	if platformModule then
		mgr.uuid = platformModule:callShellFunction("ToShell_GetConfig", "uuid")
		mgr.qdCode1 = platformModule:callShellFunction("ToShell_GetConfig", "QD_Code1")
		mgr.qdCode2 = platformModule:callShellFunction("ToShell_GetConfig", "QD_Code2")
		mgr.appId = platformModule:callShellFunction("ToShell_GetConfig", "appId")
		mgr.userId = platformModule:callShellFunction("ToShell_GetConfig", "userId")
		mgr.channelId = platformModule:callShellFunction("ToShell_GetConfig", "channelId")				
	end
	
	GameWorld:getLoginModule():requestResJson()
end

function ToGame:changeAccount()
	PlatformMgr:reLogin(false)
end

function ToGame:showWaiting()
	--showWaiting(18)
	GameWorld:getUIMgr():showWaitingAlways()
end

function ToGame:hideWaiting()
	--removeWaiting()
	GameWorld:getUIMgr():removeWaitingAlways()
end

function ToGame:pickImage(jsonParam)
	
end

return ToGame
