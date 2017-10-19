
local CELL_SIZE = cc.size(250, 40)

local UICommonCell =  class("UICommonCell", gp.TableViewCell )

function UICommonCell:ctor(size, callback, beSelType)
	UICommonCell.super.ctor(self)
	size = size or CELL_SIZE
    self:setContentSize(size)
    self.callback = callback
    
    local btn = nil
    if beSelType==true then
    	btn = gp.SelButton:create("Border_V2.png", nil, true)
    	btn:setCatchTouch(false)
    else
    	local function _btnCall()
	    	if self.callback then
				self.callback(sender, self.data)
			end
	    end
    	btn = gp.Button:create("Border_V2.png", _btnCall, true)
    end

	btn:setContentSize(size)
	btn:setTitleArg("", 18, gd.FCOLOR.c7, 2, gd.FCOLOR.c9)
	self:addChild(btn)
	_VLP(btn, self)
	self.btn = btn
	self.beSelType = beSelType
end

function UICommonCell:setBg(imgKey)
	self.btn:setKey(imgKey)
end

function UICommonCell:setData(title, data)
	self.btn:setTitle(title)
	self.data = data
end

function UICommonCell:setTouchSel(beSel)
	if self.beSelType~= true then return end
	--print("setTouchSel "..tostring(beSel))
	self.beSel = beSel
	if beSel==true then
		self.btn:setBtnState(gd.BTN_SEL)
	else
		self.btn:setBtnState(gd.BTN_NOR)
	end
	if self.callback then
		self.callback(sender, self.data, beSel)
	end
end

return UICommonCell

