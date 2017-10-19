
local NUM_COUNT = 16

local DCKeypadView = class("DCKeypadView", glg.DCBaseNumView)

function DCKeypadView:ctor()
	DCKeypadView.super.ctor(self)
	self:onInit(gp.JOCsbLuaMgr:load("DCKeypadViewCSB"), 16)
end


return DCKeypadView
