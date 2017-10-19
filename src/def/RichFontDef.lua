
local fontRegister = {}

--[[style---
e_plain=1,
e_strengthen,
e_border,
e_shadow
 --]]

function fontRegister.register()	

	local fontPath = _FP("DroidSansFallback.ttf")
	--local fontPath = "fonts/锐字云字库黑体GBK.TTF"
	--local fontPath = "fonts/arial.ttf"

	
	--fnl 普通字体
	JOFontUtils:sharedFontUtils():createFont("fpn01", fontPath, 24, 1, 0)

	--fsn 黑体
	JOFontUtils:sharedFontUtils():createFont("fsn01", fontPath, 24, 2, 1)

	--fbr 描边字体
	JOFontUtils:sharedFontUtils():createFont("fbr01", fontPath, 24, 3, 1)

	--fsw 阴影字体
	JOFontUtils:sharedFontUtils():createFont("fsw01", fontPath, 24, 4, 1)


end




return fontRegister;