

local waitIdRegister = {}

--注册消息等待验证
function waitIdRegister.register()	
	--绑定等待消息
	gp.MessageMgr:bindWaitInfo(GOP.C2S_HEART_BEAT, { ops={GOP.S2C_HEART_BEAT} })
	gp.MessageMgr:bindWaitInfo(GOP.C2S_WORLD_SYNC, { ops={GOP.S2C_WORLD_BASE_SYNC, GOP.S2C_WORLD_COORD_SYNC, GOP.S2C_WORLD_POINT_SYNC} })

	gp.MessageMgr:bindWaitInfo(GOP.C2S_PLAYER_SYNC, { ops={GOP.S2C_PLAYER_SYNC} })
	gp.MessageMgr:bindWaitInfo(GOP.C2S_PLAYER_LIST, { ops={GOP.S2C_PLAYER_LIST} })

	gp.MessageMgr:bindWaitInfo(GOP.C2S_PET_DATA, { ops={GOP.S2C_PET_FIXED_DATA, GOP.S2C_PET_BASE_DATA} })
	gp.MessageMgr:bindWaitInfo(GOP.C2S_PET_FEED, { ops={GOP.S2C_PET_BASE_DATA} })
	gp.MessageMgr:bindWaitInfo(GOP.C2S_PET_FAST_FEED, { ops={GOP.S2C_PET_BASE_DATA} })
	gp.MessageMgr:bindWaitInfo(GOP.C2S_PET_UPDATE, { ops={GOP.S2C_PET_BASE_DATA} })
	gp.MessageMgr:bindWaitInfo(GOP.C2S_PET_FAST_UPDATE, { ops={GOP.S2C_PET_BASE_DATA} })
	gp.MessageMgr:bindWaitInfo(GOP.C2S_PET_EQUIP_DRESS, { ops={GOP.S2C_PET_BASE_DATA} })
	gp.MessageMgr:bindWaitInfo(GOP.C2S_PET_FAST_EQUIP_DRESS, { ops={GOP.S2C_PET_BASE_DATA} })
	gp.MessageMgr:bindWaitInfo(GOP.C2S_PET_EQUIP_GETOFF, { ops={GOP.S2C_PET_BASE_DATA} })
	gp.MessageMgr:bindWaitInfo(GOP.C2S_PET_SKILL_EQUIP, { ops={GOP.S2C_PET_SKILL_DATA} })

	gp.MessageMgr:bindWaitInfo(GOP.C2S_LAND_SYNC, { ops={GOP.S2C_LAND_SYNC} })
	gp.MessageMgr:bindWaitInfo(GOP.C2S_LAND_COLLECT, { ops={GOP.S2C_LAND_SYNC} })
	gp.MessageMgr:bindWaitInfo(GOP.C2S_LAND_UPDATE, { ops={GOP.S2C_LAND_SYNC} })
	gp.MessageMgr:bindWaitInfo(GOP.C2S_LAND_SECTION, { ops={GOP.S2C_LAND_SECTION} })

	gp.MessageMgr:bindWaitInfo(GOP.C2S_ITEM_SYNC, { ops={GOP.S2C_ITEM_SYNC} })
	gp.MessageMgr:bindWaitInfo(GOP.C2S_ITEM_USE, { ops={GOP.S2C_ITEM_SYNC, GOP.S2C_ITEM_ADD}  })

	gp.MessageMgr:bindWaitInfo(GOP.C2S_FORMULA_SYNC, { ops={GOP.S2C_FORMULA_SYNC}  })
	gp.MessageMgr:bindWaitInfo(GOP.C2S_FORMULA_LIGHT, { ops={GOP.S2C_FORMULA_SYNC}  })
	gp.MessageMgr:bindWaitInfo(GOP.C2S_FORMULA_SYNTHETISE, { ops={GOP.S2C_FORMULA_SYNC}  })
	gp.MessageMgr:bindWaitInfo(GOP.C2S_FORMULA_UPATE, { ops={GOP.S2C_FORMULA_SYNC}  })

	gp.MessageMgr:bindWaitInfo(GOP.C2S_FIGHT_ATTACK_PALYER, {  })--默认在成功错误码中处理
	gp.MessageMgr:bindWaitInfo(GOP.C2S_FIGHT_ATTACK_PALYER_RESULT, { ops={GOP.S2C_FIGHT_ATTACK_PALYER_RESULT}  })
	gp.MessageMgr:bindWaitInfo(GOP.C2S_FIGHT_ATTACK_SECTION, {  })	
	gp.MessageMgr:bindWaitInfo(GOP.C2S_FIGHT_ATTACK_SECTION_RESULT, { ops={GOP.S2C_FIGHT_ATTACK_SECTION_RESULT}  })

	gp.MessageMgr:bindWaitInfo(GOP.C2S_RES_SYNC, { ops={GOP.S2C_RES_SYNC, GOP.S2C_RES_ADD}  })

	gp.MessageMgr:bindWaitInfo(GOP.C2S_REPORD_SYNC, { ops={GOP.S2C_REPORD_SYNC, GOP.S2C_REPORD_ADD}  })


	


	--添加忽略过滤
	--gp.MessageMgr:addIgnoreWaitId(GOP.C2G_XXX)
end




return waitIdRegister;


