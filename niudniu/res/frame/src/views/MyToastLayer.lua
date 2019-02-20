MyToastLayer = class("MyToastLayer",cc.Node)
MyToastLayer.showingText = '';
MyToastLayer.showingTexts = {}; --正在显示的所有提示


--1，要添加的对象，2文字，3持续时间 4,触摸 5 是否可以重复显示 
function MyToastLayer:ctor(parentLayer,text,num,isTouch ,isRepeat)
    self:enableNodeEvents();

    local CCSLuaNode =  requireForGameLuaFile("MyToastLayerCCS")
    self.csNode = CCSLuaNode:create().root;
    self:addChild(self.csNode)

    self.tipPanel= CustomHelper.seekNodeByName(self.csNode, "tip_panel");
    local t_text= CustomHelper.seekNodeByName(self.csNode, "tip_text")
    local Image_6 = CustomHelper.seekNodeByName(self.tipPanel, "Image_6");
    
    -- text = "这是一个很长的文字，很长长的文字，有这么长！！！"
    t_text:setString(text)
    local tipPanelContentSize = Image_6:getContentSize()
    local textWidth = t_text:getContentSize().width
    local tipPanelWidth = tipPanelContentSize.width
     if textWidth + 150 > tipPanelWidth  then
         Image_6:setContentSize(cc.size(textWidth + 150,tipPanelContentSize.height))
         self.tipPanel:setContentSize(cc.size(textWidth + 150,self.tipPanel:getContentSize().height))
    end
    ccui.Helper:doLayout(self.tipPanel)
    parentLayer = cc.Director:getInstance():getRunningScene()
    parentLayer:addChild(self,10001)

    ---是否让触摸事件穿透 true不穿透
    local panel_noTouch = CustomHelper.seekNodeByName(self.csNode, "panel_noTouch")
    if isTouch == nil  then
        isTouch = false
    end
    panel_noTouch:setVisible(isTouch)

    self:setVisible(false);

    --向上移动msgNode之前的消息
    local function moveUpMessages(msgNode)
        for i=1, #MyToastLayer.showingTexts - 1 do
            local msgNode = MyToastLayer.showingTexts[i];
            if msgNode:isVisible() then
                msgNode:runAction(cc.MoveBy:create(0.15, cc.p(0, 60)));
            end
        end
    end

    --添加新消息
    local function addMessage(msgNode)
        table.insert(MyToastLayer.showingTexts, msgNode);
        moveUpMessages(msgNode);
        local showActions = {};
        msgNode:setVisible(true);

        table.insert(showActions, cc.ScaleTo:create(0.08, 1.1));
        table.insert(showActions, cc.ScaleTo:create(0.08, 1.0));
        table.insert(showActions, cc.DelayTime:create(1.0));
        table.insert(showActions, cc.FadeOut:create(0.2));
        table.insert(showActions, cc.CallFunc:create(function()
            msgNode:removeFromParent();
        end));
        self.tipPanel:runAction(cc.Sequence:create(showActions));
    end

    local delayTime = 0;
    self:runAction(cc.Sequence:create(
        cc.DelayTime:create(delayTime),
        cc.Show:create(),
        cc.CallFunc:create(function()
            addMessage(self);
        end)
    ));

end

function MyToastLayer:onExit()
    print('MyToastLayer:onExit')
    self.tipPanel:stopAllActions();
    self:stopAllActions();
    for i=1, #MyToastLayer.showingTexts do
        if MyToastLayer.showingTexts[i] == self then
            table.remove(MyToastLayer.showingTexts, i);
            break;
        end
    end
end

return MyToastLayer

