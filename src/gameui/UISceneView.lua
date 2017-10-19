
local UISceneView = class("UISceneView", gp.BaseNode)

function UISceneView:ctor()
	UISceneView.super.ctor(self)
	self:setContentSize(gd.VISIBLE_SIZE)
	self.titleLb = gp.Label:create()
	
	self:addChild(self.titleLb)
end

function UISceneView:setTitle(titleStr)
	if type(titleStr) == "string" then		
		self.titleLb:setString(titleStr)
	end
end

function UISceneView:initBg( size )
	if size == nil then
		size = self:getContentSize()
	end
	self.fullBg = gp.Scale9Sprite:create("gui_bg_white_yellow.png")
	self.fullBg:setContentSize(size)	
	
	self:addChild(self.fullBg)
	_VLP(self.fullBg)
end

function UISceneView:showClose( bShow )
	if bShow and not self.closeBtn then
		local function _btnCallback( sender )
			self:removeFromParent()
		end
		self.closeBtn = gp.Button:create("gui_btn_close.png", _btnCallback)
		self.closeBtn:setScale(_gcf.SCREEN_SCALE)
		self:addChild(self.closeBtn, 10)
		_VLP(self.closeBtn, self, vl.IN_TR)
	elseif bShow == false and self.closeBtn then
		self:setVisible(false)
	elseif bShow == true and self.closeBtn then
		_VLP(self.closeBtn, self, vl.IN_TR)
		self:setVisible(true)
	end
end

function UISceneView:addChildInContent( child, order )
	if order then
		self.fullContentView:addChild(child, order)	
	else
		self.fullContentView:addChild(child)	
	end
end
--[[
function UISceneView:onTouchBegan(touch, event)
	return true
end

function UISceneView:onTouchEnded(touch, event)
	local ret = self:hitPoint(self:convertToNodeSpace(touch:getLocation()))
	if ret == false then
		self:removeFromParent()
	end
end
--]]
return UISceneView;



