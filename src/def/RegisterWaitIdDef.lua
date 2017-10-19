

local waitIdRegister = {}

--注册消息等待验证
function waitIdRegister.register()	
	--绑定等待消息
	gp.MessageMgr:bindWaitInfo(gai.C2S_WORLD_SYNC, { ops={gai.S2C_WORLD_BASE_SYNC, gai.S2C_WORLD_COORD_SYNC, gai.S2C_WORLD_POINT_SYNC}, succes=true, error=true })

	gp.MessageMgr:bindWaitInfo(gai.C2S_PLAYER_SYNC, { ops={gai.S2C_PLAYER_SYNC}, succes=true, error=true })
	gp.MessageMgr:bindWaitInfo(gai.C2S_PLAYER_LIST, { ops={gai.S2C_PLAYER_LIST}, succes=true, error=true })

	gp.MessageMgr:bindWaitInfo(gai.C2S_PET_DATA, { ops={gai.S2C_PET_FIXED_DATA, gai.S2C_PET_BASE_DATA}, succes=true, error=true })
	gp.MessageMgr:bindWaitInfo(gai.C2S_PET_FEED, { ops={gai.S2C_PET_BASE_DATA}, succes=true, error=true })
	gp.MessageMgr:bindWaitInfo(gai.C2S_PET_FAST_FEED, { ops={gai.S2C_PET_BASE_DATA}, succes=true, error=true })
	gp.MessageMgr:bindWaitInfo(gai.C2S_PET_UPDATE, { ops={gai.S2C_PET_BASE_DATA}, succes=true, error=true })
	gp.MessageMgr:bindWaitInfo(gai.C2S_PET_FAST_UPDATE, { ops={gai.S2C_PET_BASE_DATA}, succes=true, error=true })
	gp.MessageMgr:bindWaitInfo(gai.C2S_PET_EQUIP_DRESS, { ops={gai.S2C_PET_BASE_DATA}, succes=true, error=true })
	gp.MessageMgr:bindWaitInfo(gai.C2S_PET_FAST_EQUIP_DRESS, { ops={gai.S2C_PET_BASE_DATA}, succes=true, error=true })
	gp.MessageMgr:bindWaitInfo(gai.C2S_PET_EQUIP_GETOFF, { ops={gai.S2C_PET_BASE_DATA}, succes=true, error=true })
	gp.MessageMgr:bindWaitInfo(gai.C2S_PET_SKILL_EQUIP, { ops={gai.S2C_PET_SKILL_DATA}, succes=true, error=true })

	gp.MessageMgr:bindWaitInfo(gai.C2S_LAND_SYNC, { ops={gai.S2C_LAND_SYNC}, succes=true, error=true })
	gp.MessageMgr:bindWaitInfo(gai.C2S_LAND_COLLECT, { ops={gai.S2C_LAND_SYNC}, succes=true, error=true })
	gp.MessageMgr:bindWaitInfo(gai.C2S_LAND_UPDATE, { ops={gai.S2C_LAND_SYNC}, succes=true, error=true })
	gp.MessageMgr:bindWaitInfo(gai.C2S_LAND_SECTION, { ops={gai.S2C_LAND_SECTION}, succes=true, error=true })

	gp.MessageMgr:bindWaitInfo(gai.C2S_ITEM_SYNC, { ops={gai.S2C_ITEM_SYNC}, succes=true, error=true })
	gp.MessageMgr:bindWaitInfo(gai.C2S_ITEM_USE, { ops={gai.S2C_ITEM_SYNC, gai.S2C_ITEM_ADD} , succes=true, error=true })

	gp.MessageMgr:bindWaitInfo(gai.C2S_FORMULA_SYNC, { ops={gai.S2C_FORMULA_SYNC} , succes=true, error=true })
	gp.MessageMgr:bindWaitInfo(gai.C2S_FORMULA_LIGHT, { ops={gai.S2C_FORMULA_SYNC} , succes=true, error=true })
	gp.MessageMgr:bindWaitInfo(gai.C2S_FORMULA_SYNTHETISE, { ops={gai.S2C_FORMULA_SYNC} , succes=true, error=true })
	gp.MessageMgr:bindWaitInfo(gai.C2S_FORMULA_UPATE, { ops={gai.S2C_FORMULA_SYNC} , succes=true, error=true })

	gp.MessageMgr:bindWaitInfo(gai.C2S_FIGHT_ATTACK_PALYER, { succes=true, error=true })
	gp.MessageMgr:bindWaitInfo(gai.C2S_FIGHT_ATTACK_PALYER_RESULT, { ops={gai.S2C_FIGHT_ATTACK_PALYER_RESULT} , succes=true, error=true })
	gp.MessageMgr:bindWaitInfo(gai.C2S_FIGHT_ATTACK_SECTION, { succes=true, error=true })	
	gp.MessageMgr:bindWaitInfo(gai.C2S_FIGHT_ATTACK_SECTION_RESULT, { ops={gai.S2C_FIGHT_ATTACK_SECTION_RESULT} , succes=true, error=true })

	gp.MessageMgr:bindWaitInfo(gai.C2S_RES_SYNC, { ops={gai.S2C_RES_SYNC, gai.S2C_RES_ADD} , succes=true, error=true })

	gp.MessageMgr:bindWaitInfo(gai.C2S_REPORD_SYNC, { ops={gai.S2C_REPORD_SYNC, gai.S2C_REPORD_ADD} , succes=true, error=true })


	


	--添加忽略过滤
	--gp.MessageMgr:addIgnoreWaitId(gai.C2G_XXX)
end




return waitIdRegister;


