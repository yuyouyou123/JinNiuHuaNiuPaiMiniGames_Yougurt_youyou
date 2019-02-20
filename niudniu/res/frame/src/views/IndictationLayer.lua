local IndictationLayer = class("IndictationLayer",cc.Node);
if _indictationLayerInstance then
	--todo
	_indictationLayerInstance:destory()
end
_indictationLayerInstance = nil
function IndictationLayer:getInstance()
	if _indictationLayerInstance == nil then
		--todo
		print("IndictationLayer.instance") 
		_indictationLayerInstance = IndictationLayer:create();
		_indictationLayerInstance:retain();
	end
	return _indictationLayerInstance; 
end
function IndictationLayer:destory()
	if _indictationLayerInstance then
		--todo
		_indictationLayerInstance:clean()
		_indictationLayerInstance:release()
		_indictationLayerInstance = nil
	end
end
function IndictationLayer:clean()	
	if self.indictationNodeAc then
		--todo
		self.indictationNodeAc:release();
		self.indictationNodeAc = nil
	end
	if self:getParent() ~= nil then
		--todo
		self:removeSelf();
	end
end
function IndictationLayer:ctor()
    local CCSLuaNode =  requireForGameLuaFile("IndicationLayerCCS")
    self.csNode = CCSLuaNode:create().root;
    self.bgView = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"bg_view"),"ccui.Widget")
    self:addChild(self.csNode);
    --旋转图标
    self.indictationNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Image_1"), "ccui.ImageView");
	if self.indictationNode then
		--todo
	    self.indictationNodeAc = cc.RotateBy:create(1.0, 360);
	    self.indictationNodeAc:retain();
	    self.indictationNode:runAction(self.indictationNodeAc);
	end 
	self.textBgView = CustomHelper.seekNodeByName(self,"Image_2");
    --提示内容
    self.tipText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "tipText"), "ccui.Text");
    -- self.tipText:getParent():setContentSize(cc.size(self.tipText:getPositionX()+self.tipText:getContentSize().width,self.tipText:getParent():getContentSize().height))

end
--
function IndictationLayer:addIndicationTip(tipStr,parent,delay)
	self.tipText:setString(tipStr);


	if self:getParent() ~= nil then
		--todo
		self:removeSelf();
	end
	if parent == nil then
		--todo
		parent = cc.Director:getInstance():getRunningScene();
	end
	if delay == nil then
		--todo
		delay = 0.5--2;
	end
	self.tipText:setString(tipStr);
	
	self.tip_parent_view = CustomHelper.seekNodeByName(self.csNode, "tip_parent_view");


    local tipPanelContentSize = self.textBgView:getContentSize()
    local textWidth = self.tipText:getContentSize().width
    local tipPanelWidth = tipPanelContentSize.width

 	if textWidth + 150 > tipPanelWidth  then
         --todo
         self.textBgView:setContentSize(cc.size(textWidth + 150,tipPanelContentSize.height))
         self.tip_parent_view:setContentSize(cc.size(textWidth + 150,self.tip_parent_view:getContentSize().height))
    end
    self.textBgView:setPositionX(self.tip_parent_view:getContentSize().width*0.5)    
    self.tip_panel = CustomHelper.seekNodeByName(self.csNode, "tip_panel")
    self.tip_panel:setContentSize(cc.size(self.tipText:getPositionX() + self.tipText:getContentSize().width,self.tip_panel:getContentSize().height));
	self.tip_panel:setPositionX(self.tip_panel:getParent():getContentSize().width/2)
	ccui.Helper:doLayout(self.tip_panel);
	if tipStr == "" then --背景框不显示
		--todo
		self.textBgView:setVisible(false)
		self.indictationNode:setVisible(true)
	else
		--todo	
		self.textBgView:setVisible(true)
	end

	parent:addChild(self,1000);
	self:setVisible(true);
	self.bgView:setVisible(false);
	self.tip_parent_view:setVisible(false)
	local ac = cc.Sequence:create(
		cc.DelayTime:create(delay),
		cc.CallFunc:create(function()
		-- body
			self.tip_parent_view:setVisible(true)
			self.bgView:setVisible(true);
		end)
	);
	
	if self.indictationNode then
		--todo
		self.indictationNode:stopAllActions();
		self.indictationNode:runAction(cc.RepeatForever:create(self.indictationNodeAc))
	end

	self.bgView:runAction(ac)
end
function IndictationLayer:removeIndicationTip()
	--self.tipText("")
	self:setVisible(false);
	if self.indictationNode then
		--todo
		self.indictationNode:stopAllActions();
	end
	
	self.bgView:stopAllActions();
end
return IndictationLayer;