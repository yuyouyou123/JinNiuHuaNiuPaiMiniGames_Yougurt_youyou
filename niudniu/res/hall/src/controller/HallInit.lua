local HallInit = class("HallInit")
-- requireForGameLuaFile("HallGameConfig");
-- requireForGameLuaFile("HallSoundConfig")
-- requireForGameLuaFile("HallUtils");
requireForGameLuaFile("SceneController")
-- HallInit:start();
function HallInit:start()
	SceneController.goLoginScene();
end 
return HallInit;