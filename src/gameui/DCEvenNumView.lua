
local DCEvenNumView = class("DCEvenNumView", glg.DCBaseNumView)

function DCEvenNumView:ctor()
	DCEvenNumView.super.ctor(self)
	
	self:onInit(gp.JOCsbLuaMgr:load("DCEvenNumViewCSB"), 32)
end


return DCEvenNumView
