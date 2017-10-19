

local tickRegister = {}

local listers = {}
local function BIND_TICK( lister, handler)
	table.insert(listers, lister)
	JOTickMgr:Instance():registerTick(lister, handler)
end

function tickRegister.register()	
	--BIND_TICK(gp.ReleaseMgr, function ( dt ) gp.ReleaseMgr:tick(dt) end)
end

function tickRegister.unRegister( )
	for i=1,#listers do
		JOTickMgr:Instance():unRegisterTick(listers[i])
	end
	listers = nil
end




return tickRegister;


