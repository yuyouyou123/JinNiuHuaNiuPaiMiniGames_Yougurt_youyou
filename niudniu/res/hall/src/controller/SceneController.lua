SceneController = class("SceneController");
--去登录场景
function SceneController.goLoginScene()


    local packageRootPath = 'niudniu/'
    cc.FileUtils:getInstance():purgeCachedEntries();

    --还原为初始化，防止在重复添加
    if global_initSearchPathBeforeEnterGame == nil then
        global_initSearchPathBeforeEnterGame = cc.FileUtils:getInstance():getSearchPaths();
    end
    cc.FileUtils:getInstance():setSearchPaths(global_initSearchPathBeforeEnterGame)
    local needSearchPath = {
        "src",
        "res",
    }
    local writablePath = cc.FileUtils:getInstance():getWritablePath();
    local resRootPath = "res/";
    for i,v in ipairs(needSearchPath) do
        local tempPath = packageRootPath .. v
        cc.FileUtils:getInstance():addSearchPath(resRootPath .. tempPath, true); 
        cc.FileUtils:getInstance():addSearchPath(writablePath .. tempPath, true);
    end

    local loginScene = requireForGameLuaFile("MainScene").create():showWithScene()
end