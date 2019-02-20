-- local LaunchScene = class(LaunchScene, cc.load("mvc").ViewBase)
local LaunchScene = class("LaunchScene", cc.Scene)
local scheduler = cc.Director:getInstance():getScheduler()
function LaunchScene:ctor()
	requireForGameLuaFile("PublicProgressLayerCCS")
	local CCSLuaNode =  requireForGameLuaFile("LaunchSceneCCS")
    self.csNode = CCSLuaNode:create().root;
    -- self.csNode:align(display.CENTER, display.cx, display.cy)
    -- dump(self.csNode, "self.csNode", nesting)
    self:addChild(self.csNode);

    -- local bg_anim_node = CustomHelper.seekNodeByName(self.csNode, "bg_anim_node")
    -- CustomHelper.createSpineAnimation(
    -- 	"frame_res/anim/sldt2_loading_eff/sldt2_loading_eff",
    -- 	"ani_01",
    -- 	bg_anim_node,
    -- 	nil,
    -- 	true
    -- )

    --客服按钮
    self.btn_CustomerService = CustomHelper.seekNodeByName(self.csNode, "btn_CustomerService")
    self.btn_CustomerService:setVisible(false)
    CustomHelper.adapterPosWithSafeAreaRect(self.btn_CustomerService,PosAdapterDir.ToRight);
	self.btn_CustomerService:setVisible(false)
	self.btn_CustomerService:retain()
	self.btn_CustomerService:removeFromParent()
	self:addChild(self.btn_CustomerService, 9999) --重新加在runscene上，以方便在弹出错误提示时也可以点击客服,层级在tiplayer上面
	self.btn_CustomerService:release()


	self.maintain_tip_panel = CustomHelper.seekNodeByName(self.csNode, "maintain_tip_panel")
	self.maintain_tip_panel:setVisible(false)

    self.progressTipText = CustomHelper.seekNodeByName(self.csNode, "progress_text")
    self.progressTipText:setVisible(true)
    self.tipText = CustomHelper.seekNodeByName(self.csNode,"tip_text")
    --进度条
    self.progressBarNode = CustomHelper.seekNodeByName(self.csNode, "download_progress_bar")
    self.progressBarNode:setScale9Enabled(true)
    self.progressBarNode:setCapInsets(cc.rect(30, 0, self.progressBarNode:getContentSize().width-30*2, self.progressBarNode:getContentSize().height))

    -- self.progressArrow = CustomHelper.seekNodeByName(self.csNode, "progress_arrow")
	self.progress_bar_parent = CustomHelper.seekNodeByName(self.csNode, "Image_1")
	self.progress_bar_parent:setVisible(false)
	self:showProgressBarPercent(0)

	--进度标记
	-- local arrowSpr = CustomHelper.seekNodeByName(self.csNode, "arrow_spr")
	-- local times = 9999
	-- arrowSpr:runAction(cc.RotateBy:create(9999,9999*360)) --旋转9999秒

    -- 显示大厅版本号
	local Text_Version = CustomHelper.seekNodeByName(self.csNode, "Text_Version")
	local versionManager =   GameManager:getInstance():getVersionManager()
	local verStr = versionManager:getVersionStr().."."..versionManager:getChannelName()
    Text_Version:setString(verStr)
    Text_Version:setVisible(true)
	CustomHelper.adapterPosWithSafeAreaRect(Text_Version,PosAdapterDir.ToRight);

	-- self.Image_6 = CustomHelper.seekNodeByName(self.csNode, "Image_6")
	-- self.Image_6:loadTexture("frame_res/pictrue/loading_background1_2.png",0)

	self:enableNodeEvents()

end



function LaunchScene:onEnterTransitionFinish()
  --   local startScheduleFunc = function() 
		-- --检测权限
	 --    local DeviceUtils = requireForGameLuaFile("DeviceUtils");
		-- DeviceUtils.checkAppPermissions(function()
		-- 	self.hasPermissionsResult = true;
		-- 	print("self.hasPermissionsResult = true")
		-- end);
  --       CustomHelper.unscheduleGlobal(self.permissionsResultSchedule)
  --       self.permissionsResultSchedule = nil 
  --       --开启定时器刷新
  --       self.permissionsResultSchedule = CustomHelper.performWithDelayGlobal(function()
  --           if self.hasPermissionsResult then
  --               --todo
  --               CustomHelper.unscheduleGlobal(self.permissionsResultSchedule)
  --               self.permissionsResultSchedule = nil 
  --               --获取服务器配置
  --               self:getServerConfig()
  --           end
  --       end,0.02,true)    
  --   end
    
  --   if LaunchScene.super and LaunchScene.super.onEnterTransitionFinish then
  --   	--todo
  --   	LaunchScene.super.onEnterTransitionFinish(self)
  --   end
  --   --延迟执行，否则android可能会崩
  --   self:runAction(cc.Sequence:create(cc.DelayTime:create(0.02),cc.CallFunc:create(function()
		-- 	startScheduleFunc()
  --   	end)))	

  	self:getServerConfig()
end

--检测是否需要更新
function LaunchScene:getServerConfig()
	self.tipText:setString("loading...")
	--根据版本号和渠道号，从服务器获取最新配置
	local callback = function(xhr,isSuccess)
		CustomHelper.removeIndicationTip()
		--显示并初始化客服按钮信息，没有数据时取本地缓存数据
		self:initCustomerService()

		if isSuccess then
			--todo
			--检测是否有更新
			self:checkIsNeedUpdateClient();
		else -- 异常获取失败
			--判断是否弹出维护公告界面
			if xhr.serverConstTab and xhr.serverConstTab["server_is_aintain"] then
				--todo
				if not self.maintain_alert_view then
					--todo
					self.maintain_alert_view = CustomHelper.seekNodeByName(self.maintain_tip_panel,"maintain_alert_view")
				end
				if not self.maintain_title then
					--todo
					self.maintain_title = tolua.cast(CustomHelper.seekNodeByName(self.maintain_tip_panel,"title_txt"),"ccui.Text") 
				end
				local titleStr = xhr.serverConstTab["server_is_aintain"]["title"]
				self.maintain_title:setString(titleStr)
				if not self.maintain_content_text then
					--todo
					self.maintain_content_text = tolua.cast(CustomHelper.seekNodeByName(self.maintain_tip_panel,"content_txt"),"ccui.Text") 
				end
				self.maintain_content_text:setString(xhr.serverConstTab["server_is_aintain"]["content"])
				self.maintain_tip_panel:setVisible(true)
				CustomHelper.appearAnimation(self.maintain_alert_view)
				if not self.maintain_retry_btn then
					--todo
					self.maintain_retry_btn = tolua.cast(CustomHelper.seekNodeByName(self.maintain_tip_panel,"maintain_retry_btn"),"ccui.Button") 
				end
				self.maintain_retry_btn:addClickEventListener(function()
					self:getServerConfig();
					self.maintain_tip_panel:setVisible(false)
				end)
				if not self.retry_tip_text then
					--todo
					self.retry_tip_text = tolua.cast(CustomHelper.seekNodeByName(self.maintain_tip_panel,"retry_tip_text"),"ccui.Text") 
					self.retry_tip_text:setOpacity(255);
					local ac = cc.RepeatForever:create(
							cc.Sequence:create(
								cc.FadeTo:create(1.0,0.2 * 255),
								cc.FadeTo:create(1.0,1.0 * 255)
							)
						)
					self.retry_tip_text:runAction(ac)
				end
			else
				print('uoooooooooooo')
				self:callbackWhenAllDataAndResourceUpdated();
			end

		end
	end
	GameManager:getInstance():getServerConfig(callback);
end

function LaunchScene:initCustomerService()

	if not self.customer_service_panel then
		self.customer_service_panel = CustomHelper.seekNodeByName(self.csNode, "customer_service_panel")
	end
	self.customer_service_panel:setVisible(false)
	self.customer_service_panel:retain()
	self.customer_service_panel:removeFromParent()
	self:addChild(self.customer_service_panel, 10000) --重新加在runscene上，以方便在弹出错误提示时也可以点击客服
	self.customer_service_panel:release()
	self.customer_service_panel:setScale(1)

	--审核不显示按钮
	if CustomHelper.isExaminState() then
		self.btn_CustomerService:setVisible(false)
		return
	end

	--数据，存最新的，或取本地之前保存的
	local url = CustomHelper.getOneHallGameConfigValueWithKey("site_home_url")
	local wx = CustomHelper.getOneHallGameConfigValueWithKey("home_wx_id")
	local qq = CustomHelper.getOneHallGameConfigValueWithKey("home_qq_id")
	local userDefault = cc.UserDefault:getInstance();
	if not url then
		url = userDefault:getStringForKey("launchScene_customer_service_url", nil);
	else
		userDefault:setStringForKey("launchScene_customer_service_url",url);
		userDefault:flush();
	end	
	if not wx then
		wx = userDefault:getStringForKey("launchScene_customer_service_wx", nil);
	else
		userDefault:setStringForKey("launchScene_customer_service_wx",wx);
		userDefault:flush();
	end	
	if not qq then
		qq = userDefault:getStringForKey("launchScene_customer_service_qq", nil);
	else
		userDefault:setStringForKey("launchScene_customer_service_qq",qq);
		userDefault:flush();
	end	
	--没有任何数据则不显示按钮
	if not url and not wx and not qq then
		self.btn_CustomerService:setVisible(false)
		return
	end

	--显示按钮
	self.btn_CustomerService:setVisible(true)

	--弹出
	local sc_color_bg = CustomHelper.seekNodeByName(self.customer_service_panel, "sc_color_bg")
	local sc_content_bg = CustomHelper.seekNodeByName(self.customer_service_panel, "sc_content_bg")
	self.btn_CustomerService:addClickEventListener(function()
		self.customer_service_panel:setVisible(true)
		CustomHelper.appearAnimation(sc_content_bg, sc_color_bg)
	end)

	--关闭按钮
	local btn_cs_close = CustomHelper.seekNodeByName(sc_content_bg, "btn_cs_close")
	btn_cs_close:addClickEventListener(function ()
		CustomHelper.disappearAnimation(sc_content_bg, sc_color_bg, function ()
			self.customer_service_panel:setScale(1)
			self.customer_service_panel:setVisible(false)
		end)
	end)

	local cell_url = CustomHelper.seekNodeByName(sc_content_bg,"cell_url")
	local cell_wx = CustomHelper.seekNodeByName(sc_content_bg,"cell_wx")
	local cell_qq = CustomHelper.seekNodeByName(sc_content_bg,"cell_qq")

	--官网
	local text_url = CustomHelper.seekNodeByName(cell_url,"txt_url")
	local btn_url = CustomHelper.seekNodeByName(cell_url, "btn_url")
	text_url:setString(url)
	text_url:setScale(math.min(1,265/text_url:getContentSize().width))
	btn_url:addClickEventListener(function()
		cc.Application:getInstance():openURL(url)
	end)

	--微信
	if not wx then
		cell_wx:setVisible(false)
	else
		cell_wx:setVisible(true)
		local txt_wx = CustomHelper.seekNodeByName(cell_wx,"txt_wx")
		local btn_wx = CustomHelper.seekNodeByName(cell_wx,"btn_wx")
		txt_wx:setString(wx)
		txt_wx:setScale(math.min(1,265/txt_wx:getContentSize().width))
		btn_wx:addClickEventListener(function()
			if CustomHelper.copyStrToShearPlate(wx) then
				MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "微信服务号已复制")
	        end
		end)
	end

	--qq

	if not qq then
		cell_qq:setVisible(false)
	else
		cell_qq:setVisible(true)
		local txt_qq = CustomHelper.seekNodeByName(cell_qq,"txt_qq")
		local btn_qq = CustomHelper.seekNodeByName(cell_qq,"btn_qq")
		txt_qq:setString(qq)
		txt_qq:setScale(math.min(1,265/txt_qq:getContentSize().width))
		btn_qq:addClickEventListener(function()
			if CustomHelper.copyStrToShearPlate(qq) then
				MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "客服QQ已复制")
	        end
		end)
	end
end

function LaunchScene:checkIsNeedUpdateClient()
	-- local isNeedUpdated = GameManager:
	print("checkIsNeedUpdateClient")
	local updateStatus =  GameManager:getInstance():getVersionManager():checkIsUpdateClient()
	if updateStatus == VersionManager.UpdateStatus.Must then --强制更新
		--todo
		print("强制更新:",updateStatus)
		self._newClientTipLayer = CustomHelper.showAlertView(
			"客户端有新版本，前往更新",
			false,
			true,
			function()
				--self._newClientTipLayer:removeSelf()
			end,
			function()
				
				local url = GameManager:getInstance():getVersionManager():getDownloadNewClientUrl()
				print("[LaunchScene] url:%s", url)
				if url then
					cc.Application:getInstance():openURL(url)
				end

				--self._newClientTipLayer:removeSelf()
			end
		);
		self._newClientTipLayer.showDisAppearAnim = false;
	    self._newClientTipLayer:getCloseBtn():setVisible(false)
		return;
	-- elseif updateStatus == VersionManager.UpdateStatus.Need then -- 有更新，但不强制
	-- 		--todo
	-- 	print("有更新，但不强制")
	else -- 不需要更新
		self:checkIsNeedUpdateBeforeEnterHall();
	end
	-- self:checkIsNeedUpdateBeforeEnterHall();
end
function LaunchScene.getNeedPreloadResArray()
	local  needPreloadResArray = {
			--CustomHelper.getFullPath("frame_res/anim/wz03_loading_eff/wz03_loading_eff.ExportJson")
	}
	return needPreloadResArray
end
function LaunchScene:onExit()
	print("LaunchScene:onExit()")
    local needLoadResArray = LaunchScene.getNeedPreloadResArray();
    for i,v in ipairs(needLoadResArray) do
    	if string.find(v,".ExportJson") then
    		--todo
    		ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(v);
    	end
    end
	CustomHelper.unscheduleGlobal(self.schedulerEntry)
    if cc.Director:getInstance():isPaused() then
        cc.Director:getInstance():resume()
    end
	--清除下载数据
	GameManager:getInstance():getDownloaderManager():cleanDonwloadInfoDataWithGroupKey(self.downloaderGroupIndex);
	-- LaunchScene.super.onExit(self);

	if self.customer_service_panel then
		self.customer_service_panel:removeFromParent()
		self.customer_service_panel = nil
	end
end
--检测是否需要更新大厅资源
function LaunchScene:checkIsNeedUpdateBeforeEnterHall()
	local needUpdateInfoTabForHall = GameManager:getInstance():getVersionManager():getNeedUpdateBeforeEnterHall();
	-- dump(needUpdateInfoTabForHall, "needUpdateInfoTabForHall", nesting)
	if needUpdateInfoTabForHall ~= nil and table.nums(needUpdateInfoTabForHall) > 0 then -- 需要更新
		--todo
		print("大厅有更新")
		self.progress_bar_parent:setVisible(true)
		self:updateDownLoadProgress();
		--添加定时器
		if self.schedulerEntry == nil then
			--todo
			self.schedulerEntry = scheduler:scheduleScriptFunc(function(dt)
				self:updateDownLoadProgress(dt)
			end, 0.1, false);
		end
		self.downloadSuccessFunc = function(groupIndex) --下载完成函数
			local seq = cc.Sequence:create(cc.DelayTime:create(0.3),cc.CallFunc:create(function()
				--保存本地常量
				local versionManager = GameManager:getInstance():getVersionManager()
				
				-- dump(versionManager, "versionManager", nesting)
				-- print("before save const for download finish frame:",isNeedRestartGame)
				versionManager:saveConstTabWhenDownloadFinishedBeforeEnterHall();

				--如果下载的资源中有hall_res资源，则删除hall_update_res文件夹下资源,以hall_res下为准
				for i,v in ipairs(needUpdateInfoTabForHall) do
					-- dump(v,"v========", nesting)
					local tempFileName = v["file_name"]
					if string.find(tempFileName,"hall_res") == 1 then
						local writableHallUpdateResPath = cc.FileUtils:getInstance():getWritablePath().."hall/update_res/"
						
						-- cc.FileUtils:getInstance():movef
						-- cc.FileUtils:getInstance():removeDirectory(writableHallUpdateResPath)
						break
					end
				end
				--判断是否需要重启游戏
				local isNeedRestartGame = versionManager:checkIsNeedRestartGame();
				print("isNeedRestartGame2:",isNeedRestartGame)
				if isNeedRestartGame == true then
					--todo
					print("ready hot restart game")
					restartGame()
				else
					print("after save const for download finish frame")
					--调用大厅下载完成
					self:callbackWhenAllDataAndResourceUpdated();
				end
				-- end
			end))
			self:runAction(seq)
		end
		self.downloadErrorFunc = function(asset,errorTab) --下载出错处理函数
            -- dump(errorTab, "errorTab", nesting)
            local errorCode = errorTab["errorCode"] or -1000
			local errorStr = string.format("下载异常,是否重试(%d)",errorCode)
			local downloadErrorTipLayer =  CustomHelper.showAlertView(errorStr,
				false,
				true,
				nil,
				function(tipLayer)
					-- GameManager:getInstance():getDownloaderManager():startDownloadWithAsset(asset);
					self.downloaderGroupIndex = GameManager:getInstance():getDownloaderManager():startDownLoad(
						needUpdateInfoTabForHall,
						self.downloadSuccessFunc,
						self.downloadErrorFunc
					)
					tipLayer:removeSelf();
				end
			);
			downloadErrorTipLayer:getCloseBtn():setVisible(false);
		end

		self.downloaderGroupIndex = GameManager:getInstance():getDownloaderManager():startDownLoad(
			needUpdateInfoTabForHall,
			self.downloadSuccessFunc,
			self.downloadErrorFunc
		);
		--从服务器开始下载
		dump(needUpdateInfoTabForHall, "needUpdateInfoTabForHall", 1000)
	else
		self.progressTipText:setString("100")
		self:showProgressBarPercent(100)
		self.progressBarNode:runAction(
			cc.Sequence:create(
				-- cc.DelayTime:create(0.1),
				cc.CallFunc:create(function()
					self:callbackWhenAllDataAndResourceUpdated();
				end)
			)
		);
	end
end
function LaunchScene:callbackWhenAllDataAndResourceUpdated()
	print("LaunchScene:callbackWhenAllDataAndResourceUpdated()")
	--因为隐藏提示
    local Panel_Progress = CustomHelper.seekNodeByName(self.csNode,"Panel_Progress")
    Panel_Progress:setVisible(false)
	GameManager:getInstance():callbackWhenHallVersionDownloadFinished();
end
--更新下载进度
function LaunchScene:updateDownLoadProgress(dt)
	local downloadInfo = GameManager:getInstance():getDownloaderManager():getDownloadInfoWithGroupKey(self.downloaderGroupIndex);
	-- dump(downloadInfo, "LaunchScene downloadInfo ", nesting)
	if downloadInfo == nil then
		--todo
		return
	end
	local mPer = 1024 * 1024;
	local totalSize = tonumber(downloadInfo[DownloaderManager.kTotalSize])/mPer;
	local totalDownloadSize = tonumber(downloadInfo[DownloaderManager.kTotalDownloadSize])/mPer;
	local percent = totalDownloadSize/totalSize * 100;
	self.progressTipText:setString(string.format("%.0f",percent))
	self:showProgressBarPercent(percent)
end
function LaunchScene:showProgressBarPercent(percent)
	self.tipText:setString("正在加载资源...")
	--print("percent" .. percent)
	self.progressBarNode:setPercent(percent);




	-- self.progressArrow:setScaleX(math.min(1,self.progressBarNode:getContentSize().width * percent / 100 /self.progressArrow:getContentSize().width ))
	-- self.progressArrow:setPositionX(math.min(self.progressBarNode:getContentSize().width * percent / 100 ,self.progressBarNode:getContentSize().width))
	-- self.progressArrow:setVisible(true)--self.progressArrow:getPositionX() > 55)


	-- print("posX:",posX)
	-- dump(self.progressArrow)
	-- self.progressArrow:setPosition(cc.p(self.progressBarNode:getContentSize().width * (self.progressBarNode:getPercent() / 100),
 --            self.progressArrowView:getParent():getContentSize().height / 2))
	-- self._progresscoin:setPosition(cc.p(self.progressBarNode:getContentSize().width * (self.progressBarNode:getPercent() / 100) - 43 ,self.progresssBarNode:getContentSize().height / 2))


end
return LaunchScene;
