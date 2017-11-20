--[[
登录的初始配置
]]

local LoginInit = class("LoginInit")

function LoginInit:ctor()
	
	self:_initFrameWork()
	self:_initUIConfig()

	--gp.AudioMgr:playMusic(_RM("Cant-Smile-Without-You.mp3"))
end

function LoginInit:onDelete()
	
end

local PUB_KEY = "LOGIN_Pub"
local LEN_KEY = "LOGIN_Language"

function LoginInit:_initFrameWork(  )

	gp.RefMgr:setLoginPubPath("login/pub/ref/")
	gp.JOCsbLuaMgr:setLoginPubPath("login/pub/csb/")

	gp.ResConfigMgr.fontVo:setLoginPubPath("login/pub/font/")
	gp.ResConfigMgr.musicVo:setLoginPubPath("login/pub/audio/music/")
	gp.ResConfigMgr.soundVo:setLoginPubPath("login/pub/audio/sound/")
	gp.ResConfigMgr.textVo:setLoginPubPath("login/pub/language/")

	JOResConfig:Instance():loadSrcConfig("login/pub/img.cof", "login/pub/image/", PUB_KEY)
	JOResConfig:Instance():addAniBasePath("login/pub/ani/", PUB_KEY)

	local function _resetResLanguage( language )
		JOResConfig:Instance():removeConfig(LEN_KEY)
		JOResConfig:Instance():loadSrcConfig("login/"..language.."/img.cof", "login/"..language.."/image/", LEN_KEY);

		JOResConfig:Instance():removeAniBasePath(LEN_KEY)
		JOResConfig:Instance():addAniBasePath("login/"..language.."/ani/", LEN_KEY)
		--JOResConfig:Instance():description()

		gp.JOCsbLuaMgr:clearLoginLan()
		gp.JOCsbLuaMgr:addLoginLanPath("login/"..language.."/csb/")

		gp.RefMgr:clearLoginLan()
		gp.RefMgr:addLoginLanPath("login/"..language.."/ref/")

		gp.ResConfigMgr.fontVo:clearLoginLan()
		gp.ResConfigMgr.fontVo:addLoginLanPath("login/"..language.."/font/")

		gp.ResConfigMgr.musicVo:clearLoginLan()
		gp.ResConfigMgr.musicVo:addLoginLanPath("login/"..language.."/audio/music/")

		gp.ResConfigMgr.soundVo:clearLoginLan()
		gp.ResConfigMgr.soundVo:addLoginLanPath("login/"..language.."/audio/sound/")

		gp.ResConfigMgr.textVo:clearLoginLan()
		gp.ResConfigMgr.textVo:addLoginLanPath("login/"..language.."/language/")
		
		--这两个, 应该只用在语言区
		gp.RandomNameMgr:clear()
		gp.RandomNameMgr:setRandomRefPath("demo/res/"..language.."/ref/RandomNames.lua")

		gp.KeyWordMgr:clear()
		gp.KeyWordMgr:setKeyWordRefPath("demo/res/pub/ref/KeyWordRef.lua")
		--refresh ui
	end
	if _gcf.LANGUAGE and _gcf.LANGUAGE~="" then
		--gp.LanguageMgr:clearCall()
		gp.LanguageMgr:setLanguage(_gcf.LANGUAGE)
		_resetResLanguage(_gcf.LANGUAGE)
	end
	gp.LanguageMgr:AddCall(_resetResLanguage)
	gp.RandomNameMgr:setMaxLen(12)

	JOShaderMgr:Instance():clearShaderSearchPath()
	JOShaderMgr:Instance():addShaderSearchPath("baseLua/shader/")
	JOShaderMgr:Instance():setDefaultVsh("default")
	JOShaderMgr:Instance():setDefaultOriginal("original")
end

function LoginInit:_initUIConfig(  )
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


return LoginInit
