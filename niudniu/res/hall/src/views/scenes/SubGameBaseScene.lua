-------------------------------------------------------------------------
-- Desc:    子游戏公用Scene基类
-- Last: 
-- Content:  所有字游戏的场景都需要继承该类
--			主要集中处理各个游戏的公告
--    尽量使用sslog _cclog虽然可以用，但是不建议使用
--------------------------------------------------------------------------
-- local HallRedPacketSummaryLayer = requireForGameLuaFile("HallRedPacketSummaryLayer")
local SubGameBaseScene = class("SubGameBaseScene",requireForGameLuaFile("CustomBaseScene"))
local dispatcher = cc.Director:getInstance():getEventDispatcher()

function SubGameBaseScene:ctor()
	self.logTag = self.__cname..".lua"
	if SubGameBaseScene.super and SubGameBaseScene.super.ctor then
		SubGameBaseScene.super.ctor(self)
	end
  CustomHelper.addSetterAndGetterMethod(self,"isNeedDoNormalReconnect",false)
end

function SubGameBaseScene:registerNotification()
    self:addOneTCPMsgListener(HallMsgManager.MsgName.GC_GameServerCfg);
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_StandUpAndExitRoom);
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_EnterRoomAndSitDown)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_NotifySitDown)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_GameMaintain);
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_WinBonusNotify)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_BonusActivity)  --红包
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_PrizePool_show) --彩池
	--监听游戏公告和系统公告
    self:addOneKNotifyToListener(HallMsgManager.kNotifyName_NeedShowNotice,handler(self,self.showNoticeTip))
	-- local noticeShowListener =  cc.EventListenerCustom:create(HallMsgManager.kNotifyName_NeedShowNotice,handler(self,self.showNoticeTip))
 --    dispatcher:addEventListenerWithSceneGraphPriority(noticeShowListener,self)
	SubGameBaseScene.super.registerNotification(self)
end
--游戏公告处理
-- event.userInfo._Content.content_type 表示公告类型
-- 2大厅公告
-- 3跑马灯
-- 4全服公告
-- 5游戏房间公告
function SubGameBaseScene:showNoticeTip(event)
	if not event.userInfo or not event.userInfo._Content  then
		return
	end
	local HallDataManager = GameManager:getInstance():getHallManager():getHallDataManager();
	-- if event.userInfo._Content.content_type and 
	-- tonumber(event.userInfo._Content.content_type) ==  HallDataManager.NOTICE_TYPE.GLOBAL_NOTICE  or 
	-- tonumber(event.userInfo._Content.content_type) == HallDataManager.NOTICE_TYPE.GAME_NOTICE then
	-- 	ViewManager.showNotice(event.userInfo)
	-- end
  
  local is_alert = event.userInfo._Content.is_alert or 0
  if  tonumber(is_alert) == 1 then ---根据服务器开关是否要弹出提示框
      ViewManager.showNotice(event.userInfo)
  end 
	
end
--收到服务器处理成功通知函数
function SubGameBaseScene:receiveServerResponseSuccessEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    -- print("12222223123123123")
    if msgName == HallMsgManager.MsgName.GC_GameServerCfg then --关闭提示框
        --todo
       	--判断当前游戏是否开放
     --   	local hallDataManager = GameManager:getInstance():getHallManager():getHallDataManager();
     --   	local detailGameInfoTab = hallDataManager:getCurSelectedGameDetailInfoTab();
     --   	local serverIDKey = "game_id"
     --   	local serverID = detailGameInfoTab[serverIDKey];
     --   	local allOpenServerListTab = hallDataManager:getGameServerList();
     --   	local serverIsClosed = true;
     --   	if allOpenServerListTab then
     --   		--todo
     --   		for i,v in ipairs(allOpenServerListTab) do
     --   			local openServerID = v[serverIDKey]
     --   			if openServerID == serverID then
     --   				--todo
					-- serverIsClosed = false;
     --   				break
     --   			end
     --   		end
     --   	end
     --   	if serverIsClosed then --该服务器已经关闭
     --   		--todo
     --   		local gameName = detailGameInfoTab[HallGameConfig.GameNameKey] or ""
     --   		CustomHelper.showAlertView(
    	-- 			gameName.."游戏升级维护中，请尝试其他游戏",
    	-- 			false,
    	-- 			true,
    	-- 			function(tipLayer)
    	-- 				-- body
    	-- 				tipLayer:removeSelf();
    	-- 				SceneController.goHallScene();
    	-- 			end,
    	-- 			function(tipLayer)
    	-- 				-- body
    	-- 				tipLayer:removeSelf();
    	-- 				SceneController.goHallScene();
    	-- 			end
    	-- 		)
     --    end
     elseif msgName == HallMsgManager.MsgName.SC_GameMaintain then
     --todo
        if self:getIsPlaying() == false then
            self:isContinueGameConditions()
        end
          --红包
    elseif msgName == HallMsgManager.MsgName.SC_WinBonusNotify then
        -- self:showRedPacketGet()
    elseif msgName == HallMsgManager.MsgName.SC_BonusActivity then
        -- self:showRedPacketShow()
    elseif msgName == HallMsgManager.MsgName.SC_PrizePool_show then
        -- self:showLuckBounsTxt()
    end
    if SubGameBaseScene.super then
    	--todo
      SubGameBaseScene.super.receiveServerResponseSuccessEvent(self,event);
    end
end
--弹出游戏维护提示框
function SubGameBaseScene:alertAlertViewWhenServerMaintain()
  local tipStr =HallUtils:getDescWithMsgNameAndRetNum(HallMsgManager.MsgName.SC_GameMaintain,14)
  CustomHelper.showAlertView(
    tipStr,
    false,
    true,
    function()
      self:jumpToHallScene();    
    end,
    function()
      self:jumpToHallScene();
    end
  );
end
function SubGameBaseScene:receiveServerResponseErrorEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"]
    local result = userInfo["result"]
    print("SubGameBaseSceneResult:",result)
    ---退出房间失败 然后客户端强制退出
    if msgName == HallMsgManager.MsgName.SC_StandUpAndExitRoom then
		    if userInfo["result"] == 1 then --在游戏中不能退出游戏
            MyToastLayer.new(self, "你已经在游戏中无法退出房间");
        else
            self:jumpToHallScene();
        end
        return;
        -- end
    elseif msgName == HallMsgManager.MsgName.SC_GameMaintain then
        --todo
        self:alertAlertViewWhenServerMaintain();
        
        return;
    
    elseif msgName == HallMsgManager.MsgName.SC_EnterRoomAndSitDown and result == 12 then ---检查钱不够多 GAME_SERVER_RESULT_ROOM_LIMIT
        
        print("HallMsgManager.MsgName------------1:")
        local roomInfo = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab();
        local needMoney = roomInfo[HallGameConfig.SecondRoomMinMoneyLimitKey]
        if self:checkMoneyIsEnough(needMoney) then 
            print("HallMsgManager.MsgName------------2:")
        else
            return
        end

    end
    
    SubGameBaseScene.super.receiveServerResponseErrorEvent(self,event);
end
--检测是否需要弹出游戏维护提示框
function SubGameBaseScene:checkIsNeedAlertGameMaintainTipView()
    local subGameManager = GameManager:getInstance():getHallManager():getSubGameManager()
    if subGameManager then
        --todo
        local gameSwitchStatus = subGameManager:getGameSwitchStatus()
        if gameSwitchStatus == GameMaintainStatus.On then
            --todo
            return true;
        end
    end
    return false;
end
function SubGameBaseScene:callbackWhenReloginAndGetPlayerInfoFinished()
  if self:getIsNeedDoNormalReconnect() == true then
    --todo
    self:doNormalReconnect()
  end
end
--常规断线重连
function SubGameBaseScene:doNormalReconnect()


    
    local curGamingInfoTab = GameManager:getInstance():getHallManager():getPlayerInfo():getGamingInfoTab()
    if curGamingInfoTab == nil  then
        --- 尝试直接发送进入游戏消息
        local roomInfo = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab()
        local gameTypeID = roomInfo[HallGameConfig.GameIDKey]
        local roomID = roomInfo[HallGameConfig.SecondRoomIDKey]
        print("SubGameBaseScene-----------------------------22222222")
        CustomHelper.addIndicationTip(HallUtils:getDescriptionWithKey("entering_gamescene_tip"));
        GameManager:getInstance():getHallManager():getHallMsgManager():sendEnterOneGameMsg(gameTypeID, roomID);
       return;
    else
        print("SubGameBaseScene-----------------------------11111111")
        --todo
        local firstGameType = curGamingInfoTab["first_game_type"]
        local roomID = curGamingInfoTab["second_game_type"]
        -- GameManager:getInstance():getHallManager():getHallMsgManager():sendEnterOneGameMsg(firstGameType,roomID);
        curGamingInfoTab["id"] = firstGameType
        GameManager:getInstance():getHallManager():enterOneGameWithGameInfoTab(curGamingInfoTab)
        --SceneController.goOneGameSceneWhenReceiveEnterRoomAndSitDownMsg(curGamingInfoTab,true);
    end 
end
function SubGameBaseScene:isContinueGameConditions()
    if self:checkIsNeedAlertGameMaintainTipView() == true then
        --todo
        self:alertAlertViewWhenServerMaintain();
        return false;
    end
    return true;
end
--[[
function  SubGameBaseScene:checkMoneyIsEnough(needMoney)
    local cancalCallbackFunc = function (  )
        self:jumpToHallScene(nil)
    end
    local bankCallbackFunc = function (  )
        local secondLayer = {}
        secondLayer.tag = ViewManager.SECOND_LAYER_TAG.BANK             
        local BankCenterLayer = requireForGameLuaFile("BankCenterLayer")
        secondLayer.parme = BankCenterLayer.ViewType.WithDraw
        local data = {}
        table.insert(data,secondLayer)
        self:jumpToHallScene(data)
    end

    local storeCallbackFunc = function (  )
        local secondLayer = {}
        secondLayer.tag = ViewManager.SECOND_LAYER_TAG.STORE
        local data = {}
        table.insert(data,secondLayer)
        self:jumpToHallScene(data)
    end
    if CustomHelper.showLackMoneyAlertView(needMoney,"金币不足，是否去充值?",cancalCallbackFunc,bankCallbackFunc,storeCallbackFunc,closeCallbackFunc) then
        return false
    else
        return true 
    end
end
]]--
function  SubGameBaseScene:checkMoneyIsEnough(needMoney, cancelFunc, bankFunc, storeFunc, closeFunc)
  local cancalCallback = cancelFunc;
  local bankCallback = bankFunc; 
  local storeCallback = storeFunc;
  local closeCallback = closeFunc;

  if cancelCallback == nil then
    cancalCallback = function()
      self:jumpToHallScene(nil)
    end
  end

  if bankCallback == nil then
    bankCallback = function()
      local secondLayer = {}
      local BankCenterLayer = requireForGameLuaFile("BankCenterLayer")
      local data = {}

      secondLayer.tag = ViewManager.SECOND_LAYER_TAG.BANK                     
      secondLayer.parme = BankCenterLayer.ViewType.WithDraw        
      table.insert(data,secondLayer)
      self:jumpToHallScene(data)
    end    
  end

  if storeCallback == nil then
    storeCallback = function()
      local secondLayer = {}
      local data = {}

      secondLayer.tag = ViewManager.SECOND_LAYER_TAG.STORE        
      table.insert(data,secondLayer)
      self:jumpToHallScene(data)
    end    
  end

  if closeCallback == nil then
    closeCallback = function()
      self:jumpToHallScene(nil)
    end    
  end  

  if CustomHelper.showLackMoneyAlertView(needMoney, "金币不足，是否去充值?", cancalCallback, bankCallback, storeCallback, closeCallback) then
    return false
  else
    return true 
  end
end


-----------------彩池相关--------------------------

function SubGameBaseScene:showLuckBonusAnim(parent)
    local prizemoney = GameManager:getInstance():getHallManager():getHallDataManager():getPrizePoolGetMoney()
    print("prizemoney >> " .. prizemoney)
    if prizemoney > 0 then
        print("中奖了,中奖金额:>>>>>>>>>>>" .. prizemoney)
        local LuckBonusGetLayer = requireForSubGameLuaFile("LuckBonusGetLayer"):create()
        parent:addChild(LuckBonusGetLayer)
        LuckBonusGetLayer:showLuckBonusAnim(prizemoney,function ()
            LuckBonusGetLayer:removeSelf()
        end)
        return true
    end
    return false
end

function SubGameBaseScene:initLuckBonusBtn(parent,posx,posy,summaryCCS)
    local clickFunc = function ()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        ViewManager.showLuckBonusSummary(summaryCCS)
    end
    self.luckBonusPoolNode = requireForSubGameLuaFile("LuckBonusPoolNode"):create(clickFunc)
    self.luckBonusPoolNode:setPosition(cc.p(posx,posy))
    parent:addChild(self.luckBonusPoolNode)

    self:showLuckBounsTxt()
end

function SubGameBaseScene:showLuckBounsTxt()
    if self.luckBonusPoolNode then
        local data = GameManager:getInstance():getHallManager():getHallDataManager():getPrizePoolShowData()
        self.luckBonusPoolNode:setBounsTxt(data)
    end
end

--子游戏重写该方法
function SubGameBaseScene:alertReconnectTip(callbackFuncGoHall)
    print("SubGameBaseScene:alertReconnectTip()")
    CustomHelper.removeIndicationTip();
    if self.reconnectAlertLayer then
        --todo
        return
    end
    --如果不需要自动充电
    local isKick = GameManager:getInstance():getHallManager():getHallDataManager():getIsKick()
    if isKick == true then
      --todo
      return;
    end
    local hallMsgManager = GameManager:getInstance():getHallManager():getHallMsgManager()
      --所有配置服务器地址都连接失败了，则发出网络断开通知
    local alertLayer = CustomHelper.showSubGameReconnectAlertView(HallUtils:getDescriptionWithKey("SubGame_Connect_Fail_Tip"),
        function(tipLayer)
            CustomHelper.removeIndicationTip();
            GameManager:getInstance():getHallManager():getHallMsgManager():clenNeedResendMsg();
            tipLayer:removeSelf();
            self.reconnectAlertLayer = nil;
            GameManager:getInstance():getHallManager():getHallDataManager():setReconnectTipType(HallDataManager.ReconnectTipType.None)

            if callbackFuncGoHall then
                local myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
                myPlayerInfo:setGamingInfoTab(nil) --清空游戏数据？防止退到大厅又自动进游戏。如果需要再次进入游戏，这里需要改
                callbackFuncGoHall()
            end
        end,
        function(tipLayer)
            tipLayer:removeSelf();
            self.reconnectAlertLayer = nil
            CustomHelper.addIndicationTip("连接服务器中，请稍后");
            hallMsgManager:startReconnect();
        end);
    alertLayer:getCloseBtn():setVisible(false)
    self.reconnectAlertLayer = alertLayer
end

-----------------红包相关--------------------------

function SubGameBaseScene:showRedPacketGet()
    ViewManager.showRedpacketGetAnim()
end

function SubGameBaseScene:showRedPacketShow(parent,posx,posy)

  self.rpShowParent = parent or self.rpShowParent
  self.rpPosx = posx or self.rpPosx
  self.rpPosy = posy or self.rpPosy
  ViewManager.showRedPacketShowAnim(self.rpShowParent,self.rpPosx,self.rpPosy)
end

------注意----------
--------------子游戏场景必须实现的方法
--当前玩家是否在游戏中,需要在子游戏中重写
function SubGameBaseScene:getIsPlaying()
    --
    print("please override the method '[SubGameBaseScene:getIsPlaying()]' in your game scene")
    return false;
end
--跳转到HallScene，用于在游戏维护提示框，金币不足提示框跳转场景
function SubGameBaseScene:jumpToHallScene()
  print("please override the method '[SubGameBaseScene:jumpToHallScene()]' in your game scene")
end
-----游戏帮助接口，在游戏里面和大厅游戏二级界面会用到，需要游戏场景实现
function SubGameBaseScene.getGameHelpInfoLayer()
  print("please override the method '[SubGameBaseScene:getGameHelpInfoLayer()]' in your game scene")
end

function SubGameBaseScene:showRedPacketGet()
    ViewManager.showRedpacketGetAnim()
end

return SubGameBaseScene
