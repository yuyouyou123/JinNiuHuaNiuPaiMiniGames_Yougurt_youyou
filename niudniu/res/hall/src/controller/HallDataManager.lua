--[[
	大厅数据管理器
]]
HallDataManager = class("HallDataManager");
function HallDataManager:ctor()
end
function HallDataManager:resetServerIndex()
end
function HallDataManager:getConnectionStatus()
end
-- 设置连接状态
function HallDataManager:setConnectionStatus(status)
end
--根据http请求返回的大厅数据 初始化数据
function HallDataManager:initDataWithServerConfig(hallInfoTab)
end
--刷新服务器地址
function HallDataManager:refreshTCPIPAndPort()
end
--得到hall config tab中某个key的值
function HallDataManager:getOneHallGameConfigValueWithKey(key)
end
--处理从服务器返回的 服务器列表信息,将其转化为1种游戏对应多个2级房间
function HallDataManager:dealWithServerList(infoTab)
end

--获取一个常用玩家帐号详细信息(最近登陆的)
function HallDataManager:getOnePlayerAccountOftenUsed()
end

--获取一个玩家帐号详细信息
function HallDataManager:getOnePlayerAccount(account)
end


--保存一个玩家账号详细信息
function HallDataManager:saveOnePlayerAccount(playerInfo)
end

--删除一个玩家账号
function HallDataManager:deleteOnePlayerAccount(account)
end

--获取帐号列表
function HallDataManager:getPlayerAccountList()
end

--保存帐号列表
function HallDataManager:savePlayerAccountList(listJson)
end

function HallDataManager:savaShowPrivacy(showPrivacy)
end

function HallDataManager:getSavaShowPrivacy()
end
function HallDataManager:callbackWhenCSGetTime()
end
--在收到sc_time时设置ping值
function HallDataManager:on_SC_Time(msgTab)
end
function HallDataManager:checkIsNeedRefreshPing()
end
function HallDataManager:getSignalStrength()
end
function HallDataManager:reset()
end
function HallDataManager:getServerTime()
end
--
function HallDataManager:getMarqueeArrayFromServer()
end
function HallDataManager:setMarqueeArrayFromServer(marueeInfoArray)
end

--添加公告
function HallDataManager:addNewNotice( msg )
end
--增加一条跑马灯消息
function HallDataManager:addOneMarqueeInfo(marqueeInfo)
end
--[[
message GameNotice{
	optional int32 first_game_type = 1;				// 一级菜单
	optional int32 second_game_type = 2;			// 二级菜单	
	optional int32 number = 3;						// 轮播次数
	optional int32 interval_time = 4;				// 轮播时间间隔（秒）
	repeat string param = 5;						// 消息参数1
}
// 跑马灯
message Marquee{
	optional int32  id = 1;							// 编号
	optional string content = 4;					// 消息内容
}

--]]
function HallDataManager:parseGameBonusPoolMarquee(marqueeInfo)
end

function HallDataManager:parseGameRedPacketMarquee(marqueeInfo)
end

--解析游戏普通赢钱跑马灯
function HallDataManager:parseGameNormalMarquee(marqueeInfo)
end
--增加一条中奖跑马灯消息
function HallDataManager:addOneGameMarqueeInfo(marqueeInfo)
end
--得到下一条需要显示的
function HallDataManager:getNextNeedShowMarqueeInfo(index)
end
--显示完成后
function HallDataManager:callbackWhenOneMarqueeShowFinished(marqueeInfo)
end
--检测是否有需要显示的跑马灯
function HallDataManager:checkIsHasNeedShowMarqueeInfo(index)
end

function HallDataManager:checkIsHasNeedShowNotice()
end
--保存每日公告读取时间
function HallDataManager:saveDayNoticeReadTime(noticeID)
end
--获取保存的每日公告上次读取时间
function HallDataManager:getDayNoticeReadTime(noticeID)
end
--更新玩家游戏列表 如果玩家进入某个游戏的累计次数大于两次，则将之放置最前面
function HallDataManager:updatePlayerHallGameList(gameID)
end
function HallDataManager:saveMyOrderInfoArrayToFile(gameOrderInfoArray,saveKey)
end
--
function HallDataManager:getMyHallGameList( ... )
end
function HallDataManager:checkIsNeedHiddeGame()
end
--检测是否有需要检测隐藏的游戏
function HallDataManager:getNeedCheckHideGameInfoTab(needHiddeGameTab)
end
--保存已经完成的隐藏检测
function HallDataManager:saveFinishHideCheck(k,v)
end

--秒刷新函数
function HallDataManager:refreshByOneSecond()
end
function HallDataManager:on_SC_Charge_Rate(msgTab)
end
--得到代理充值開啟資訊
function HallDataManager:getChargeRate()
end
--設定代理充值開啟資訊
function HallDataManager:setChargeRate(Data)
  
end
--检测是否显示
function HallDataManager:checkIsOpenPromotionBtn()
end
function HallDataManager:setAllExchangeSwitchTab(msgTab)
end
function HallDataManager.isHaveLuckBouns(infoTab)
end

function HallDataManager:isHaveRedPacket()
end

function HallDataManager:getRedPacketListSort( )
end

function HallDataManager:getPrizePoolGetMoney()
end

function HallDataManager:getPrizePoolPlayerMoney()
end

---  return 1 普通红包，  return 2 世界杯红包
function HallDataManager:getRedpacketSkinType()
end

function HallDataManager:setRequestPlayerVipInfo(msgTab)
end

--得到所有开放的游戏
function HallDataManager:getOpenGames()
end

--得到某个开放的游戏
function HallDataManager:getOneOpenGame(gameId)
end

--得到某个开放的游戏的房间最低限制金额
function HallDataManager:getOneOpenGameLeastLimitMoney(gameId)
end
return HallDataManager;