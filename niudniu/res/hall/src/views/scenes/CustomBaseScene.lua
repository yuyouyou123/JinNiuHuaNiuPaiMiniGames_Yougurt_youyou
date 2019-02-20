local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local CustomBaseScene = class("CustomBaseScene", CustomBaseView)
--返回场景需要预加载的资源数组
CustomBaseScene.Status = {
    Status_ReadyExitScene = 1
}
function CustomBaseScene.getNeedPreloadResArray()
    return {};
end
function CustomBaseScene:ctor()
    
    if CustomBaseScene.super then
        --todo
        CustomBaseScene.super.ctor(self)
    end

    self:_initBaseSceneData()
end
function CustomBaseScene:onEnterTransitionFinish()
    self:checkisNeedAlertFreezeAccountTipView();
    if CustomBaseScene.super and CustomBaseScene.super.onEnterTransitionFinish then
        --todo
        CustomBaseScene.super.onEnterTransitionFinish();
    end
end
function CustomBaseScene:showWithScene()
    CustomBaseScene.super.showWithScene(self);
    -- self:callbackWhenReloginAndGetPlayerInfoFinished();
end
function CustomBaseScene:registerNotification()
	local dispatcher = cc.Director:getInstance():getEventDispatcher();
	---增加服务器消息监听 ,只有增加了的命令，才会回调对应成功监听函数
    -- self:addOneTCPMsgListener(HallMsgManager.MsgName.CL_Login,{HallMsgManager.MsgName.LC_Login});
    -- self:addOneTCPMsgListener(HallMsgManager.MsgName.LC_Login);
    -- self:addOneTCPMsgListener(HallMsgManager.MsgName.C_PublicKey);
    -- self:addOneTCPMsgListener(HallMsgManager.MsgName.CS_RequestPlayerInfo,{HallMsgManager.MsgName.SC_ReplyPlayerInfoComplete});
    -- self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_ReplyPlayerInfoComplete);
    -- self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_FreezeAccount);
	CustomBaseScene.super.registerNotification(self);
end
function CustomBaseScene:alertReconnectTip()
end
--请求失败通知，网络连接状态变化
-- function CustomBaseScene:callbackWhenConnectionStatusChange(event)
--     local status = event.userInfo.status;
--     if status == NetworkManager.TCPConnectionStatus.TCPConnectionStatus_Close then
--         --todo
--         -- CustomHelper.removeIndicationTip();
--         --self:alertReconnectTip();
--     elseif status == NetworkManager.TCPConnectionStatus.TCPConnectionStatus_Connected then
--         --todo
--         --CustomHelper.removeIndicationTip();
--     end
-- end
function CustomBaseScene:callbackWhenReloginAndGetPlayerInfoFinished()

end
function CustomBaseScene:logoutScene()
    if self.isAlreadyOut == true then
        --todo
        -- print("12312312312312312312312")
        return
    end
    self.isAlreadyOut = true
    
    reloadGameLuaFiles()
    -- 释放资源
    GameManager:getInstance():getMusicAndSoundManager():unloadHallSound()
    --设置LoginScene不自动登录
    local LoginScene = requireForGameLuaFile("LoginScene");
    LoginScene.isChangedAccount = true
    local status = GameManager:getInstance():getHallManager():getHallDataManager():getConnectionStatus()
    if status == NetworkManager.TCPConnectionStatus.TCPConnectionStatus_Close then
        -- SceneController.goLaunchScene()
        self:checkIsGoLaunchScene()
    else
        self.sceneStatus = CustomBaseScene.Status.Status_ReadyExitScene
        GameManager:getInstance():getHallManager():getHallMsgManager():callbackWhenDoExitGame();    
    end 
end
function CustomBaseScene:checkIsGoLaunchScene()
    local needUpdateInfoTabForHall = GameManager:getInstance():getVersionManager():getNeedUpdateBeforeEnterHall(false)
    --dump(needUpdateInfoTabForHall, "needUpdateInfoTabForHall", nesting)
    if needUpdateInfoTabForHall ~= nil and table.nums(needUpdateInfoTabForHall) > 0 then -- 需要更新
        SceneController.goLaunchScene();
    else
        -- SceneController.goLoginScene()
        GameManager:getInstance():callbackWhenHallVersionDownloadFinished();
    end
end

function CustomBaseScene:checkisNeedAlertFreezeAccountTipView()
    -- body
    local hallManager = GameManager:getInstance():getHallManager();
end
function CustomBaseScene:_alertLogoutSceneWithTipStr(tipStr)
    CustomHelper.showAlertView(
        tipStr,
        false,
        true,
        function()
            self:logoutScene()
        end,
        function()
            self:logoutScene()
        end
    );
end
--请求失败通知，网络连接状态变化
function CustomBaseScene:callbackWhenConnectionStatusChange(event)
    local status = event.userInfo.status;
    if status == NetworkManager.TCPConnectionStatus.TCPConnectionStatus_Close then
        --todo
        if self.sceneStatus == CustomBaseScene.Status.Status_ReadyExitScene then
            --todo
           self:checkIsGoLaunchScene()
           return;
        end
    elseif status == NetworkManager.TCPConnectionStatus.TCPConnectionStatus_Connected then
        --todo
        if self.reconnectAlertLayer and not tolua.isnull(self.reconnectAlertLayer)  then
            --todo
            self.reconnectAlertLayer:removeSelf()
            self.reconnectAlertLayer = nil;
        end
    end
    CustomBaseScene.super.callbackWhenConnectionStatusChange(self,event)
end
function CustomBaseScene:receiveMsgRequestErrorEvent(event)
    print("CustomBaseScene:receiveMsgRequestErrorEvent(event)")
    CustomHelper.removeIndicationTip();
    self:alertReconnectTip();
end
--收到服务器返回的失败的通知，如果登录失败，密码错误
function CustomBaseScene:receiveServerResponseErrorEvent(event)
    --print("CustomBaseView:receiveServerResponseErrorEvent(event)")
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    local ret = userInfo["ret"] or userInfo["result"]; 
    if msgName == HallMsgManager.MsgName.LC_Login then 
        --账号被封 | 服务器登录维护中 | token失效 | 被踢 | 玩家已经在线   
        if ret == 15 or ret == 32 or ret == 43 or ret == 44 or ret ==45 then
            --todo
            local tipStr = HallUtils:getDescWithMsgNameAndRetNum(msgName,ret)
            -- 提示并跳转到登录界面
            print("CustomBaseScene:receiveServerResponseErrorEvent")
            self:_alertLogoutSceneWithTipStr(tipStr);
            return;
        end
        --todo
    end
    CustomBaseScene.super.receiveServerResponseErrorEvent(self,event);
end
--收到服务器处理成功通知函数
function CustomBaseScene:receiveServerResponseSuccessEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];

    if msgName == HallMsgManager.MsgName.C_PublicKey then
        CustomHelper.removeIndicationTip();
        -- CustomHelper.addIndicationTip(HallUtils:getDescriptionWithKey("loginTip"),self,0);
        CustomHelper.addIndicationTip("",self,0);
        -- MyToastLayer.new(self, "网络连接成功",0,true)
        local isResendMsg = GameManager:getInstance():getHallManager():getHallMsgManager():checkIsNeedResendMsgToServer(false);
        -- if isResendMsg == false then
        --     --todo
        --     CustomHelper.removeIndicationTip();
        -- end
    elseif msgName == HallMsgManager.MsgName.LC_Login then --登录成功，则发送获取玩家信息
    	--todo
    	-- CustomHelper.addIndicationTip(HallUtils:getDescriptionWithKey("get_player_info_tip"),self,0);
        CustomHelper.addIndicationTip("",self,0);
		GameManager:getInstance():getHallManager():getHallMsgManager():sendGetPlayerInfoMsg();
	elseif msgName == HallMsgManager.MsgName.SC_ReplyPlayerInfoComplete then
		--todo
        --发送获取玩家信息消息
        GameManager:getInstance():getHallManager():getHallMsgManager():checkIsNeedResendMsgToServer(true);
        self:callbackWhenReloginAndGetPlayerInfoFinished();
        --CustomHelper.removeIndicationTip();
        CustomHelper.removeIndicationTip();
    elseif msgName == HallMsgManager.MsgName.SC_FreezeAccount then
        self:checkisNeedAlertFreezeAccountTipView();
    end
end
function CustomBaseScene:receiveApplicationDidEnterBackground()
    print("CustomBaseScene:receiveApplicationDidEnterBackground()")
end
function CustomBaseScene:receiveApplicationWillEnterForeground()
    print("CustomBaseScene:receiveApplicationWillEnterForeground()")
end
function CustomBaseScene:_initBaseSceneData()
    self._data = {}
    self._data.openUpdatePrompt = false
end

function CustomBaseScene:setUpdatePrompt(status)
    self._data.openUpdatePrompt = status
end

function CustomBaseScene:getUpdatePrompt()
    return self._data.openUpdatePrompt
end

function CustomBaseScene:handleHotPrompt()
    if self:getUpdatePrompt() then
        -- 提示有热更新，需要去更新
        --大厅里面不需要检测斗地主下载了
        local needUpdateInfoTabForHall = GameManager:getInstance():getVersionManager():getNeedUpdateBeforeEnterHall(false)
        -- -- dump(needUpdateInfoTabForHall, "needUpdateInfoTabForHall", nesting)
        if needUpdateInfoTabForHall ~= nil and table.nums(needUpdateInfoTabForHall) > 0 then -- 需要更新
            CustomHelper.showAlertView("游戏有更新，前往更新？",false,true,nil, function(tipLayer)
                cc.Director:getInstance():getRunningScene().layer:logoutScene()
            end)
        end
    end
end
--常量刷新相应函数
function CustomBaseScene:receiveRefreshConstConfigNotify()
    -- print("CustomBaseView:receiveRefreshConstConfigNotify()")
    self:handleHotPrompt();
end
return CustomBaseScene;
