local EffectFactory = EffectFactory or {}

--bgKey主精灵图像
--sparkKey横扫图像
function EffectFactory.sweepSprite(bgKey, sparkKey)
		
	local cliper = cc.ClippingNode:create();
	local content = gp.Sprite:create(bgKey);	

	local spark = gp.Sprite:create(sparkKey);
	--spark:setPosition(-content:getContentSize().width,0);
	cliper:setContentSize(content:getContentSize())

	cliper:setAlphaThreshold(0.5);
	cliper:setStencil(content);
	cliper:addChild(content);
	cliper:addChild(spark);
	_VLP(content)
	_VLP(spark, content, vl.OUT_L)

	local moveTo = cc.MoveBy:create(2.0,cc.p(content:getContentSize().width+spark:getContentSize().width,0));
	local moveBack = cc.MoveBy:create(2.0,cc.p(-content:getContentSize().width-spark:getContentSize().width,0));
	local seq = cc.Sequence:create(moveTo,moveBack);
	local action = cc.RepeatForever:create(seq);
	spark:runAction(action);

	return cliper
end

function EffectFactory.collector(collector, beCollect, collectTime)
	local x, y = collector:getPosition()
	EffectFactory.collectorXY(cc.p(x,y), beCollect, collectTime)	
end

function EffectFactory.collectorXY(collectorXY, beCollect, collectTime)
	local x = collectorXY.x
	local y = collectorXY.y
	collectTime = collectTime or 2.5
	collectTime = collectTime+math.random(-1,1.5)
	
	local moveTo = cc.MoveTo:create(collectTime,cc.p(x+math.random(-18,18), y+math.random(-18,18)));
	local easeMove = cc.EaseBackInOut:create(moveTo);  
 	local scaleBig = cc.ScaleTo:create(0.3*collectTime,1.5+math.random(-0.01,0.01));
 	local scaleSmall = cc.ScaleTo:create(0.7*collectTime,0.5+math.random(-0.01,0.01));
	local scale = cc.Sequence:create(scaleBig,scaleSmall);
	local move = cc.Spawn:create(easeMove,scale);
	--[[
	local callFunc = cc.CallFunc::create(  
		beCollect:removeFromParentAndCleanup(true);  
		m_callback();  
		});  
	local function _setAnimate(sender)
		if sender.spriteFile_ and sender.spriteFile_ == option.frameValue.frameName then
			--return
		end
		sender:setSpriteFrame(frame)
	end
	arr[#arr+1] = cc.CallFunc:create(_setAnimate)
	--]]
	local action = cc.Sequence:create(move,cc.RemoveSelf:create());
	beCollect:runAction(action);
end

--targetPos, srcPos为世界坐标
EffectFactory.collectTicking = false
function EffectFactory.collectorPos(targetPos, srcPos, count, imgKey, layer)
	targetPos = layer:convertToNodeSpace(targetPos)
	srcPos = layer:convertToNodeSpace(srcPos)
	EffectFactory.collectTickDataList = EffectFactory.collectTickDataList or {}
	EffectFactory.collectTicker = EffectFactory.collectTicker or {}

	local tickData = {}
	tickData.targetPos = targetPos
	tickData.srcPos = srcPos
	tickData.imgKey = imgKey
	tickData.layer = layer
	tickData.count = count	
	table.insert(EffectFactory.collectTickDataList, tickData)

	if EffectFactory.collectTicking == true then return end

	local function collectTick( dt )
		for i,v in ipairs(EffectFactory.collectTickDataList) do
			local beCollect = gp.Sprite:create(v.imgKey)
			layer:addChild(beCollect)
			beCollect:setPosition(cc.p(v.srcPos.x+math.random(-30,30), v.srcPos.y+math.random(-30,30)))
			
			_EFactory.collectorXY(v.targetPos, beCollect, 2)		
			v.count = v.count-1
			if v.count < 0 then
				table.remove(EffectFactory.collectTickDataList, i)
			end
		end

		if #EffectFactory.collectTickDataList < 1 then
			JOTickMgr:Instance():unRegisterTick(EffectFactory.collectTicker)
			EffectFactory.collectTicking = false
		end		
	end
	EffectFactory.collectTicking = true
	JOTickMgr:Instance():registerTick(EffectFactory.collectTicker, collectTick)

end

--通过一纹理，创建带倒影图层
function EffectFactory.invertedImage(imgKey, dis)
	dis = dis or 6
	local base = gp.BaseNode.new()	
	local sprite = gp.Sprite:create(imgKey)
	base:setContentSize(cc.size(sprite:getContentSize().width, sprite:getContentSize().height*1.8))
	base:addChild(sprite, 2)
	local reflectionSprite = gp.Sprite:create(imgKey)
	base:addChild(reflectionSprite)
	_VLP(sprite, base, vl.IN_T)
	_VLP(reflectionSprite, sprite, nil, cc.p(0,-sprite:getContentSize().height-dis))
	reflectionSprite:setScaleY(-0.9)
	--reflectionSprite:setFlippedY(true)
	reflectionSprite:setOpacity(25)	
	
	return base
	
end

function EffectFactory.invertedLabel(text, dis)
	dis = dis or 6
	local base = gp.BaseNode.new()	
	local lb = gp.Label:create(text)
	base:setContentSize(cc.size(lb:getContentSize().width, lb:getContentSize().height*1.8))
	--[[
		pockectTitleTxt->setOpacity(255);
        for (int i = 0; i < pockectTitleTxt->getStringLength(); i++) {
            Sprite* letter1 = pockectTitleTxt->getLetter(i);
            letter1->setOpacity(255);
        }
	]]
	base:addChild(lb, 4)
	_VLP(lb)
	local reflection = gp.Label:create(text)
	base:addChild(reflection)
	_VLP(reflection)
	
	for i=0,reflection:getStringLength()-1 do
		local orgSprite = lb:getLetter(i)
		local refSprite = reflection:getLetter(i)
		--refSprite:setFlippedY(true)
		refSprite:setScaleY(-0.9)
		refSprite:setOpacity(25)
		--refSprite:setAnchorPoint(cc.p(0.5, 0.5))
		refSprite:setPosition(cc.p(orgSprite:getPositionX(), -orgSprite:getPositionY()-dis))
	end	
	return base	
end









return EffectFactory