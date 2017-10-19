
local DCFullNumView = class("DCFullNumView", glg.DCBaseNumView)

function DCFullNumView:ctor()
	DCFullNumView.super.ctor(self)
	self:onInit(gp.JOCsbLuaMgr:load("DCFullNumViewCSB"), 33)
end


return DCFullNumView
