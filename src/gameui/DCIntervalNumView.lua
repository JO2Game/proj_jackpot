
local DCIntervalNumView = class("DCIntervalNumView", glg.DCBaseNumView)

function DCIntervalNumView:ctor()
	DCIntervalNumView.super.ctor(self)
	
	self:onInit(gp.JOCsbLuaMgr:load("DCEvenNumViewCSB"), 31)
	local btn = gp.JOCsbLuaMgr:getChild(self.csbNode, "num32")
	if btn then
		btn:setVisible(false)
	end
	for i=1,self.maxCount do
		local btn = gp.JOCsbLuaMgr:getChild(self.csbNode, "num"..i)
		btn:setTitle(string.format("%d-%d",i,i+2))
	end
end


return DCIntervalNumView
