
--[[
=================================
文件名：WorldModel.lua
作者：James Ou
=================================
]]

--gp.ModelMgr:modelSubLua( "models/world/ctrl/WorldMgr" )
--gp.ModelMgr:modelSubLua( "models/world/ctrl/StatisticsMgr" )


gp.ModelMgr:modelSubLua( MOD.WORLD, "models/world/WorldScene" )

--[[
gp.ModelMgr:modelSubLua( "models/world/ui/AnalysisDataUI" )
gp.ModelMgr:modelSubLua( "models/world/ui/HistoryDataUI" )
gp.ModelMgr:modelSubLua( "models/world/ui/SelDataUI" )
--]]

local WorldModel = WorldModel or class("WorldModel", gp.BaseModel)


function WorldModel:onInitData()
		
end

function WorldModel:onInitEvent()
	
end


function WorldModel:onDelete( )
	--析构UI

	--析构MGR及其它对象

	--析构父类
	WorldModel.super.onDelete(self)
end

--数据相关----------------------------------------------------------------------------

--ui相关----------------------------------------------------------------------------
function WorldModel:showWorld( )
	JOWinMgr:Instance():showWin(MCLASS(MOD.WORLD, "WorldScene").new(), gd.LAYER_SCENE)
end

--消息相关----------------------------------------------------------------------------

--[[
--成功错误码处理----------------------------------------------------------------------------
function WorldModel:handleErrorCode(errorData)

end

function WorldModel:handleSuccessCode(successData)

end
--]]

return WorldModel