

local SocketEventHandle = SocketEventHandle or class("SocketEventHandle") 

function SocketEventHandle:ctor()
	self.sn = JOSnMgr:Instance():getSn()
	self:registerEvent()
	self.bReConnect = false
end
function SocketEventHandle:onDelete()
	gp.MessageMgr:unRegisterAll(self.sn)
	JOSnMgr:Instance():dispose(self.sn)
end
function SocketEventHandle:registerEvent()
	if _gcf.ENTER == _gcf.ENTER_GAME then
	---[[
		gp.MessageMgr:registerEvent(self.sn, gei.SOCKET_CONNECT, function() self:_hanedleConnect() end)
		gp.MessageMgr:registerEvent(self.sn, gei.SOCKET_DISCONNECT, function() self:_hanedleDisConnect() end)
		gp.MessageMgr:registerEvent(self.sn, gei.SOCKET_CONNECTFAIL, function() self:_hanedleConnectFail() end)
		gp.MessageMgr:registerEvent(self.sn, gei.SOCKET_RECVOP, function(eveId, dataCoder) self:_hanedleRecvOp(dataCoder) end)
	--]]
	end
end

function SocketEventHandle:unRegisterEvent()
	gp.MessageMgr:unRegisterEvent(self.sn)
end

function SocketEventHandle:_hanedleConnect()
	if self.bReConnect == false then
		--GameLogic.onConnected()
	else
		--可能要发协议给服务器，说明是重连的
	end
end

function SocketEventHandle:_hanedleDisConnect()
	local function _alertCallback(btnTag, alertTag)
		if gd.ALERT_OK == btnTag then
			self.bReConnect = true
			GameLogic.connectServer();
		end
	end
	local alert = glg.Alert.new("连接断开, 是否重连？", gd.ALERT_OKCANCEL, _alertCallback)
end

function SocketEventHandle:_hanedleConnectFail()
	local function _alertCallback(btnTag, alertTag)
		if gd.ALERT_OK == btnTag then
			self.bReConnect = true
			GameLogic.connectServer();
		end
	end
	local alert = glg.Alert.new("连接失败, 是否重连？", gd.ALERT_OKCANCEL, _alertCallback)
end

function SocketEventHandle:_hanedleRecvOp(dataCoder)
	local opId = dataCoder:getShort()-- dataBundle:getNumber("opId");
	gp.MessageMgr:_handleResWaitWithOp(opId)
end

return SocketEventHandle

