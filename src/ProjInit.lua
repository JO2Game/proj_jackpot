--公共逻辑游戏内容

local ProjInit = class("ProjInit")

function ProjInit:ctor()
	glg = {}
	self:onInit()
end

function ProjInit:onInit()
	self:_initFrameWork()
	self:_initUIConfig()
		
	self:_initLogicDef()
	---[[
	self:_initGameui();
	self:_initRegisterDef();
	--]]
end

function ProjInit:onDelete()
	glg = nil
end

local PUB_KEY = "PROJ_Pub"
local LEN_KEY = "PROJ_Language"

function ProjInit:_initFrameWork(  )

	gp.RefMgr:setPubPath("pub/ref/")
	gp.JOCsbLuaMgr:setPubPath("pub/csb/")

	gp.ResConfigMgr.fontVo:setPubPath("pub/font/")
	gp.ResConfigMgr.musicVo:setPubPath("pub/audio/music/")
	gp.ResConfigMgr.soundVo:setPubPath("pub/audio/sound/")
	gp.ResConfigMgr.textVo:setPubPath("pub/language/")	

	JOResConfig:Instance():loadSrcConfig("pub/img.cof", "pub/image/", PUB_KEY)
	JOResConfig:Instance():addAniBasePath("pub/ani/", PUB_KEY)

	local function _resetResLanguage( language )
		JOResConfig:Instance():removeConfig(LEN_KEY)
		JOResConfig:Instance():loadSrcConfig(language.."/img.cof", language.."/image/", LEN_KEY);

		JOResConfig:Instance():removeAniBasePath(LEN_KEY)
		JOResConfig:Instance():addAniBasePath(language.."/ani/", LEN_KEY)
		--JOResConfig:Instance():description()

		gp.JOCsbLuaMgr:clearGameLan()
		gp.JOCsbLuaMgr:addLanPath(language.."/csb/")

		gp.RefMgr:clearGameLan()
		gp.RefMgr:addLanPath(language.."/ref/")

		gp.ResConfigMgr.fontVo:clearGameLan()
		gp.ResConfigMgr.fontVo:addLanPath(language.."/font/")

		gp.ResConfigMgr.musicVo:clearGameLan()
		gp.ResConfigMgr.musicVo:addLanPath(language.."/audio/music/")

		gp.ResConfigMgr.soundVo:clearGameLan()
		gp.ResConfigMgr.soundVo:addLanPath(language.."/audio/sound/")

		gp.ResConfigMgr.textVo:clearGameLan()
		gp.ResConfigMgr.textVo:addLanPath(language.."/language/")

		--refresh ui
	end
	
	if _gcf.LANGUAGE and _gcf.LANGUAGE~="" then
		gp.LanguageMgr:setLanguage(_gcf.LANGUAGE)
		_resetResLanguage(_gcf.LANGUAGE)
	end
	gp.LanguageMgr:AddCall(_resetResLanguage)
end


function ProjInit:_initUIConfig(  )
	gp.Label:setDefaultBase(24, _FP("DroidSansFallback.ttf"), gd.FCOLOR.c12)
	gp.Label:setDefaultOutline(2, gd.FCOLOR.c9)
	gp.Label:setDefaultShadow(cc.p(0,0), gd.FCOLOR.c9)

	gp.RichLabel.TTF = _FP("DroidSansFallback.ttf")
	
	--gp.Button:setDefaultBase(gd.BTN_ZOOM_BIG)
	gp.Button:setDefaultTitleBase(24, _FP("DroidSansFallback.ttf"), gd.FCOLOR.c12)
	gp.Button:setDefaultTitleOutline(2, gd.FCOLOR.c9)

	--TIPS
	local opt = gp.Factory.TIPS_OPT
	opt.t_bgKey="Tips_V2.png"
	--opt.t_subKey="gui_box3.png"
	opt.t_titleStr="标题"
	opt.t_tfSize=30
	opt.t_fSize=30

	--NOICE
	opt = gp.Factory.NOICE_OPT
	opt.n_bgKey = "TipsBg_V2.png"	
	opt.n_fcolor = gd.FCOLOR.c13

	--ALERT
	opt = gp.Factory.ALERT_OPT
	opt.a_bgKey="Tips_V2.png"
	opt.a_subKey="gui_box9.png"
	opt.a_tfColor=gd.FCOLOR.c17--nil
	opt.a_tfOColor=gd.FCOLOR.c9
	opt.a_fSize=30-- nil
	opt.a_fColor=gd.FCOLOR.c17-- nil
	opt.a_onlyClick=false--是否在有按键的情况下，也可以点空白处关闭(true为可以， 默认false)
	opt.a_spacingH=94
	opt.a_btnStdTitile = {"确定", "取消", "其他"}
	local btnOpt1 = {
			key = "Btn_Small_Red.png",
			fsize = 30,
			fname = nil,
			fcolor = gd.FCOLOR.c9,
			focolor = nil
		}
	local btnOpt2 = {
			key = "Btn_Small_Gold.png",
			fsize = 30,
			fname = nil,
			fcolor = gd.FCOLOR.c9,
			focolor = nil
		}
	local btnOpt3 = {
			key = "Btn_Small_Blue.png",
			fsize = 30,
			fname = nil,
			fcolor = gd.FCOLOR.c9,
			focolor = nil
		}
	opt.a_btnOpts = {}
	table.insert(opt.a_btnOpts, btnOpt1)
	table.insert(opt.a_btnOpts, btnOpt2)
	table.insert(opt.a_btnOpts, btnOpt3)
	
	--WAIT
	opt = gp.Factory.WAIT_OPT
	opt.w_key = "LoadingIn_V2.png"
 	
end

function ProjInit:_initGameui()
	--_EFactory = loadLuaFile("factory/EffectFactory")
	glg.MainWin = loadLuaFile("gameui/UIMainWin")
	glg.SubWin = loadLuaFile("gameui/UISubWin")
	glg.UICommonCell = loadLuaFile("gameui/UICommonCell")
	glg.DCBaseNumView = loadLuaFile("gameui/DCBaseNumView")
	glg.DCFullNumView = loadLuaFile("gameui/DCFullNumView")
	glg.DCKeypadView = loadLuaFile("gameui/DCKeypadView")
	glg.DCEvenNumView = loadLuaFile("gameui/DCEvenNumView")
	glg.DCIntervalNumView = loadLuaFile("gameui/DCIntervalNumView")
	glg.DCNumpadView = loadLuaFile("gameui/DCNumpadView")
	
	glg.UIDropView = loadLuaFile("gameui/UIDropView")
	glg.UIAnalysisView = loadLuaFile("gameui/UIAnalysisView")
	
end

function ProjInit:_initLogicDef()
	glg.DC = loadLuaFile("def/DCDef")
end

function ProjInit:_initRegisterDef()
	loadLuaFile("def/RegisterModelDef").register()
	loadLuaFile("def/RegisterWaitIdDef").register()
end

return ProjInit
