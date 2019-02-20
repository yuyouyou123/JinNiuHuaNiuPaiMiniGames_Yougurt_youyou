HallManager = class("HallManager");

function HallManager:ctor()
end
function HallManager:init()
end
function HallManager:start()
	local HallInit = requireForGameLuaFile("HallInit");
	HallInit:start()
end

function HallManager:callbackWhenReceiveTCPConnectionStatusModiy(status)
end
---处理收到的消息
function HallManager:dealWithWhenReceiveOneFullTCPMsg(msgID,dataStr)
end
---处理网络状态变化的
function HallManager:dealWithWhenReceiveNetworkStatusChanged(connectType)
end
--app状态变化
function HallManager:applicationDidEnterBackground()
end
function HallManager:applicationWillEnterForeground()
end
--登录处理完成
function HallManager:callbackWhenLoginFinished()
end
function HallManager:reset()
end
--进入某个游戏
function HallManager:enterOneGameWithGameInfoTab(infoTab)
end
--玩家某个游戏一局结束时
function HallManager:callbackWhenOneGamePlayOver(gameID)
end
--退出游戏时，只加载大厅pb文件
function HallManager:onlyReloadPBFilesForHall()
end
--初始化子游戏通用搜索路径
function HallManager:initSubGameSearchPath(gameID)
end
function HallManager:clearLoadedOneGameFiles(  )
end

function HallManager:refreshByOneSecond()
end
--游戏静默下载
function HallManager:startSilentDownloadForGame()
end
function HallManager:reportErrorLog(errorLog)
end
return HallManager;
--





































