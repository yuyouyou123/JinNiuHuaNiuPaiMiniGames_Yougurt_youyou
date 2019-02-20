local TipLayer = class("TipLayer", cc.Node);
FrameSound_Btn = "sound/frame_btn.mp3"

function TipLayer.createByName(name)
    local tipLayerName = CustomHelper.md5String(name or "TipLayerName")
    local parent = cc.Director:getInstance():getRunningScene();
    local tipLayer = parent:getChildByName(tipLayerName)
    if tipLayer  then
        return tipLayer;
    end
	tipLayer = TipLayer:create();
    tipLayer:setName(tipLayerName);
    parent:addChild(tipLayer,1000);
    return tipLayer;
end

function TipLayer:ctor()
	local CCSLuaNode =  requireForGameLuaFile("TipLayerCCS")
    self.csNode = CCSLuaNode:create().root;
    self:addChild(self.csNode);
	-- self.csNode:align(display.CENTER, display.cx, display.cy)    
    self.alertView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alert_view"), "ccui.Layout");
    self.contentTextNode = tolua.cast(CustomHelper.seekNodeByName(self.alertView, "contentTextNode"), "ccui.Text");
    self.confirmBtn = tolua.cast(CustomHelper.seekNodeByName(self.alertView, "confirmBtn"), "ccui.Button");
    self.cancelBtn = tolua.cast(CustomHelper.seekNodeByName(self.alertView, "cancelBtn"), "ccui.Button");
    self.orginConfirmPos = cc.p(self.confirmBtn:getPositionX(),self.confirmBtn:getPositionY());
    self.orginCancelPos = cc.p(self.cancelBtn:getPositionX(),self.cancelBtn:getPositionY());
    self.closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.alertView, "close_btn"), "ccui.Button");
    self.bgPanel = CustomHelper.seekNodeByName(self.csNode, "bg_panel")
    self.showDisAppearAnim = true;
end
function TipLayer:getCloseBtn()
	return self.closeBtn;
end

function TipLayer:showLackMoneyAlertView(content,cancelBtnStr,confirmBtnStr,cancelCallbackFunc,confirmCallbackFunc,closeCallbackFunc)

	local richText = myLua.LuaBridgeUtils:createHLCustomRichTextWithNode(content,self.contentTextNode,1,1);
    if self.contentTextNode:getParent():getChildByName(richText:getName()) then
        --todo
        --print("delete skill description richtext");
        self.contentTextNode:getParent():removeChildByName(richText:getName(), true);
    end
    richText:formatText();
    richText:setVisible(true)
    self.contentTextNode:getParent():addChild(richText)
	-- self.contentTextNode:setString(content);


	-- if cancelCallbackFunc == nil then
	-- 	--todo
		-- cancelCallbackFunc = function()
		-- 	CustomHelper.disappearAnimation(self.alertView, self.bgPanel, function()
		-- 		self:removeSelf();
		-- 	end)
		-- end
	-- end

	-- if closeCallbackFunc == nil then
	-- 	closeCallbackFunc = cancelCallbackFunc
	-- end

	self.cancelBtn:setVisible(false);
	self.confirmBtn:setVisible(false);

	if cancelBtnStr and confirmBtnStr then

		self.cancelBtn:setVisible(true);
		self.confirmBtn:setVisible(true);
		self.confirmBtn:setPosition(self.orginConfirmPos);
		self.cancelBtn:setPosition(self.orginCancelPos);
	elseif cancelBtnStr then
			--todo
		self.cancelBtn:setVisible(true);
		self.cancelBtn:setPosition(cc.p(self.cancelBtn:getParent():getContentSize().width/2,self.orginCancelPos.y));
	elseif confirmBtnStr then
		--todo
		self.confirmBtn:setVisible(true);
		self.confirmBtn:setPosition(cc.p(self.cancelBtn:getParent():getContentSize().width/2,self.orginCancelPos.y));
	end


	local function  setBtnTexture( btn,btnTag,callBackFunc )
		if btnTag == nil then return end 
		if btnTag == "cancal" then
			-- btn:loadTextures("","","")
		elseif btnTag == "bank" then
			
			btn:loadTextures("new_hall_res/cow_bank_button.png","","")
			btn:ignoreContentAdaptWithSize(true)
			local normalSize = btn:getRendererNormal():getOriginalSize();
			btn:setContentSize(normalSize)
		elseif  btnTag == "store" then
			btn:ignoreContentAdaptWithSize(true)
			btn:loadTextures("new_hall_res/cow_charge_button.png","","")
			local normalSize = btn:getRendererNormal():getOriginalSize();
			btn:setContentSize(normalSize)
		elseif btnTag == "confirm" then

		end
		btn:addClickEventListener(function(sender)
			GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(FrameSound_Btn)
			if callBackFunc then
				CustomHelper.disappearAnimation(self.alertView, self.bgPanel, function()
					callBackFunc(self)
				end)
			else
				CustomHelper.disappearAnimation(self.alertView, self.bgPanel, function()
					self:removeSelf()
				end)
			end
		end);
	end

	

	setBtnTexture( self.cancelBtn,cancelBtnStr,cancelCallbackFunc )
	setBtnTexture( self.confirmBtn,confirmBtnStr,confirmCallbackFunc)
	setBtnTexture( self.closeBtn, "", closeCallbackFunc)
	-- self.closeBtn:addClickEventListener(function(sender)
	-- 	GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(FrameSound_Btn)
	-- 	closeCallbackFunc(self);
	-- end);
	self.closeBtn:setVisible(true)
	-- CustomHelper.addAlertAppearAnim(self.alertView)
	-- self:showAppearAnim()
	CustomHelper.appearAnimation(self.alertView, self.bgPanel)
end

-- function  TipLayer:showAppearAnim()
-- 	local bg_panel = CustomHelper.seekNodeByName(self.csNode, "bg_panel")
-- 	bg_panel:setOpacity(0)
--     local fadeBgFunc = function()
--         bg_panel:runAction(
--             cc.Sequence:create(
--                 -- cc.DelayTime:create(0.3),
--                 cc.FadeIn:create(0.2)
--             )
--         )
--     end
--     CustomHelper.addAlertAppearAnim(self.alertView,fadeBgFunc)
-- end
function TipLayer:showAlertView(content,showCancelBtn,showConfirmBtn,cancelCallbackFunc,confirmCallbackFunc)

    local richText = myLua.LuaBridgeUtils:createHLCustomRichTextWithNode(content,self.contentTextNode,1,1);
    if self.contentTextNode:getParent():getChildByName(richText:getName()) then
        --todo
        --print("delete skill description richtext");
        self.contentTextNode:getParent():removeChildByName(richText:getName(), true);
    end
    richText:formatText();
    richText:setVisible(true)
    self.contentTextNode:getParent():addChild(richText)
	-- self.contentTextNode:setString(content);

	self.cancelBtn:setVisible(false);
	self.confirmBtn:setVisible(false);
	if showCancelBtn == nil then
		--todo
		showCancelBtn = false
	end
	if showConfirmBtn == nil then
		--todo
		showConfirmBtn = true
	end

	if showCancelBtn and showConfirmBtn then
		--todo
		self.cancelBtn:setVisible(true);
		self.confirmBtn:setVisible(true);
		self.confirmBtn:setPosition(self.orginConfirmPos);
		self.cancelBtn:setPosition(self.orginCancelPos);
	elseif showCancelBtn then
			--todo
		self.cancelBtn:setVisible(true);
		self.cancelBtn:setPosition(cc.p(self.cancelBtn:getParent():getContentSize().width/2,self.orginCancelPos.y));
	elseif showConfirmBtn then
		--todo
		self.confirmBtn:setVisible(true);
		self.confirmBtn:setPosition(cc.p(self.cancelBtn:getParent():getContentSize().width/2,self.orginCancelPos.y));
	end

	self.confirmBtn:addClickEventListener(function(sender)
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(FrameSound_Btn)
		if confirmCallbackFunc then
			if self.showDisAppearAnim then
				--todo
				CustomHelper.disappearAnimation(self.alertView, self.bgPanel, function ()
					confirmCallbackFunc(self)
				end)
			else
				confirmCallbackFunc(self)
			end
		else
			CustomHelper.disappearAnimation(self.alertView, self.bgPanel, function ()
				self:removeSelf();
			end)
		end
	end);

	self.closeBtn:addClickEventListener(function(sender)
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(FrameSound_Btn)
		if cancelCallbackFunc then
			CustomHelper.disappearAnimation(self.alertView, self.bgPanel, function ()
				cancelCallbackFunc(self)
			end)
		else
			CustomHelper.disappearAnimation(self.alertView, self.bgPanel, function ()
				self:removeSelf();
			end)
		end
	end);
	self.closeBtn:setVisible(true)

	self.cancelBtn:addClickEventListener(function(sender)
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(FrameSound_Btn)
		if cancelCallbackFunc then
			CustomHelper.disappearAnimation(self.alertView, self.bgPanel, function ()
				cancelCallbackFunc(self)
			end)
		else
			CustomHelper.disappearAnimation(self.alertView, self.bgPanel, function ()
				self:removeSelf();
			end)
		end
	end);
	CustomHelper.appearAnimation(self.alertView, self.bgPanel)
end

function TipLayer:showSubGameReconnectAlertView(content,callbackFuncGotoHall,callbackFuncReconnect)
	self.closeBtn:setVisible(false)

	local richText = myLua.LuaBridgeUtils:createHLCustomRichTextWithNode(content,self.contentTextNode,1,1);
    if self.contentTextNode:getParent():getChildByName(richText:getName()) then
        self.contentTextNode:getParent():removeChildByName(richText:getName(), true);
    end
    richText:formatText();
    richText:setVisible(true)
    self.contentTextNode:getParent():addChild(richText)

	local function  setBtnTexture( btn,btnTag,callBackFunc )
		if btnTag == nil then return end 
		if btnTag == "BACKHALL" then
			btn:ignoreContentAdaptWithSize(true)
			btn:loadTextures("new_hall_res/login_hall_back_button.png","","")
			local normalSize = btn:getRendererNormal():getOriginalSize();
			btn:setContentSize(normalSize)
		elseif btnTag == "RECONNECT" then
			btn:ignoreContentAdaptWithSize(true)
			btn:loadTextures("new_hall_res/login_relink_button.png","","")
			local normalSize = btn:getRendererNormal():getOriginalSize();
			btn:setContentSize(normalSize)
		end
		btn:addClickEventListener(function(sender)
			GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(FrameSound_Btn)
			if callBackFunc then
				CustomHelper.disappearAnimation(self.alertView, self.bgPanel, function()
					callBackFunc(self)
				end)
			else
				CustomHelper.disappearAnimation(self.alertView, self.bgPanel, function()
					self:removeSelf()
				end)
			end
		end);
	end
	setBtnTexture( self.cancelBtn,"BACKHALL",callbackFuncGotoHall)
	setBtnTexture( self.confirmBtn,"RECONNECT",callbackFuncReconnect)
	CustomHelper.appearAnimation(self.alertView, self.bgPanel)
end

function TipLayer:setConfirmBtnRes(res1, res2, res3)
	self.confirmBtn:loadTextures(res1, res2, res3)
	local normalSize = self.confirmBtn:getRendererNormal():getOriginalSize();
	self.confirmBtn:setContentSize(normalSize)
end

function TipLayer:setCancelBtnRes(res1, res2, res3)
	self.cancelBtn:loadTextures(res1, res2, res3)
	local normalSize = self.cancelBtn:getRendererNormal():getOriginalSize();
	self.cancelBtn:setContentSize(normalSize)
end

function TipLayer:addClickCancelBtnLinistener(cancelCallbackFunc)
	self.cancelBtn:addClickEventListener(function(sender)
		CustomHelper.disappearAnimation(self.alertView, self.bgPanel, function()
			cancelCallbackFunc(self)
		end)
	end);
end

function TipLayer:setBackgroundTouchEnable(isEnable)
	if self.bgPanel then
		self.bgPanel:setTouchEnabled(isEnable)
	end
end


return TipLayer;