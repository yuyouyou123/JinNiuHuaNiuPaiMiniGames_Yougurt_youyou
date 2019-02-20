
local MainScene = class("MainScene", cc.load('mvc').ViewBase)

local csbFilePath = 'niudniuScene.csb'

local Card = require("Card")



local function shuffle(t)
    if type(t)~="table" then
        return
    end
    local tab={}
    local index=1
    while #t~=0 do
        local n=math.random(0,#t)
        if t[n]~=nil then
            tab[index]=t[n]
            table.remove(t,n)
            index=index+1
        end
    end
    return tab
end

local maxBlood = 12


local icoCount = 24


function MainScene:onCreate()
    self._csbNode = cc.CSLoader:createNode(csbFilePath)
    self._csbNode:addTo(self)


    self.backButton = self._csbNode:getChildByName("Layout"):getChildByName("MainGame"):getChildByName("Button_Back")
    self._csbNode:getChildByName("Sprite_1"):setVisible(false)
    self._csbNode:getChildByName("Sprite_14"):setVisible(false)

    self.icoNodes = self._csbNode:getChildByName("Layout"):getChildByName("MainGame"):getChildByName("Node_Icos")
    --getChildByName("Start"):addClickEventListener(handler(self,self.createAllIco))

    self.rigthBar = self._csbNode:getChildByName("Layout"):getChildByName("MainGame"):getChildByName("RightBar"):getChildByName("Image")
    self.leftBar = self._csbNode:getChildByName("Layout"):getChildByName("MainGame"):getChildByName("LeftBar"):getChildByName("Image")

    self.redbull = self._csbNode:getChildByName("Layout"):getChildByName("MainGame"):getChildByName("hongniu_3")
    self.blackbull = self._csbNode:getChildByName("Layout"):getChildByName("MainGame"):getChildByName("heiniu_2")


    self.welcomePanel = self._csbNode:getChildByName("Layout"):getChildByName("GameSelected")

    self._csbNode:getChildByName("Layout"):getChildByName("GameSelected"):getChildByName("Button_Selected_1"):addClickEventListener(handler(self,self.button_Selected_1))
    self._csbNode:getChildByName("Layout"):getChildByName("GameSelected"):getChildByName("Button_Selected_2"):addClickEventListener(handler(self,self.button_Selected_2))
    self._csbNode:getChildByName("Layout"):getChildByName("GameSelected"):getChildByName("Button_Selected_3"):addClickEventListener(handler(self,self.button_Selected_3))
	self.backButton:addClickEventListener(handler(self,self.showWelcomePanel))



    self.bloodSize = self.leftBar:getContentSize()

    -- self:createAllIco()

    self.welcomeOpen = true

    GameManager:getInstance():getMusicAndSoundManager():playMusicWithFile("audio/BGM.mp3", true)
    GameManager:getInstance():getMusicAndSoundManager():setBackgroundMusicVolume(100)
    GameManager:getInstance():getMusicAndSoundManager():setEffectsVolume(100)


	Card.P_setWinCallbackMian(handler(self, self.win))
	Card.P_setLastCallbackMian(handler(self, self.loset))
end

function MainScene:button_Selected_1()
	icoCount = 24 - 6 * 2
	self:hideWelcomePanel()
	
end

function MainScene:button_Selected_2()
	icoCount = 24 - 6 * 1
	self:hideWelcomePanel()
	
end

function MainScene:button_Selected_3()
	icoCount = 24
	self:hideWelcomePanel()

end

function MainScene:showWelcomePanel()
	if self.welcomeOpen then
		return
	end
	self.welcomeOpen = true
	local actions = {}

	actions[#actions + 1] = cc.MoveBy:create(0.2,cc.p(0,display.height))
	-- actions[#actions + 1] = cc.DelayTime:create(0.1)
	-- actions[#actions + 1] = cc.CallFunc:create(handler(self, self.createAllIco))


	self.welcomePanel:runAction(cc.Sequence:create(actions))
end
function MainScene:hideWelcomePanel()
	if not self.welcomeOpen then
		return
	end
	self.welcomeOpen = false
	local actions = {}

	actions[#actions + 1] = cc.MoveBy:create(0.2,cc.p(0,-display.height))
	actions[#actions + 1] = cc.DelayTime:create(0.2)
	actions[#actions + 1] = cc.CallFunc:create(handler(self, self.createAllIco))


	self.welcomePanel:runAction(cc.Sequence:create(actions))
end

function MainScene:movePosCards()
    local tempMap = Card.P_getAllMap()

    local indexX = 1
    local indexY = 1
    local maxX = icoCount / 3
    
    local cards = shuffle(clone(Card.P_getAllCloseCards()))

    local actions = {}
	local size


	local offsetX = 40
    for _index,card in ipairs(cards) do
    	local pos
    	if not size then
	   		size = card:getContentSize()
    	end

    	local tempIndexX = indexX - maxX / 2 


		local x,y = 0,0
    	--Y
    	y = ( indexY - 2 ) * 122
		--


		--X--
    	if tempIndexX == 0 then
    		x = 0 - offsetX / 2 - size.width / 2
    	elseif tempIndexX < 0 then
    		x = (offsetX + size.width) * tempIndexX - offsetX / 2 - size.width / 2
    	elseif tempIndexX > 0 then
    		x = (offsetX + size.width) * (tempIndexX - 1) + offsetX / 2 + size.width / 2
    	end
    	pos = cc.p(x,y)
		indexX = indexX + 1
		if indexX > maxX then
			indexY = indexY + 1
			indexX = 1
		end
		if _index == #cards then
			card:runAction(cc.Sequence:create(
					cc.MoveBy:create(0.2,pos),
					cc.DelayTime:create(0.1),
					cc.CallFunc:create(Card.P_checkAllCards)
				)
			)
		else
			card:runAction(cc.MoveBy:create(0.2,pos))
		end
    end
end



function MainScene:createAllIco()
	Card.P_cleanAllCards()
    local tempMap = shuffle(clone(Card.P_getAllMap()))
    for _index,cardData in ipairs(tempMap) do
    	for y = 1,2 do
	    	local card = Card:onCreate(cardData.number)
	    		:addTo(self.icoNodes)
	    		:setPosition(0, 0)
    	end
    	if _index == icoCount / 2 then
    		break
    	end
    end
    maxBlood = icoCount / 2

    self.rigthBar:setTag(maxBlood)
    self.leftBar:setTag(maxBlood)

    self.rigthBar:setContentSize(self.bloodSize)
    self.leftBar:setContentSize(self.bloodSize)
    self:movePosCards()
end

function MainScene:win()
	local size = self.bloodSize
	local width = size.width
	local height = size.height
	self.rigthBar:setTag(tonumber(self.rigthBar:getTag()) - 1)
	local blood = self.rigthBar:getTag()

	local actions_1 = {}
	actions_1[#actions_1 + 1] = cc.MoveBy:create(0.2, cc.p(60,0))
	actions_1[#actions_1 + 1] = cc.CallFunc:create(function()
		local actions_2 = {}
		actions_2[#actions_2 + 1] = cc.MoveBy:create(0.2, cc.p(60,0))
		actions_2[#actions_2 + 1] = cc.MoveBy:create(0.2, cc.p(-60,0))
		if blood >= 0 then
			self.rigthBar:setContentSize(cc.size(width * (blood / maxBlood), height))
		end
		self.blackbull:runAction(cc.Sequence:create(actions_2))
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile("audio/Hit.mp3")
	end)
	actions_1[#actions_1 + 1] = cc.MoveBy:create(0.2, cc.p(60,0))
	actions_1[#actions_1 + 1] = cc.MoveBy:create(0.2, cc.p(-60,0))
	actions_1[#actions_1 + 1] = cc.MoveBy:create(0.2, cc.p(-60,0))
	if blood == 0 then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile("audio/Win.mp3")
		actions_1[#actions_1 + 1] = cc.CallFunc:create(handler(self, self.gameWinAction))
		-- self:showWelcomePanel()
	end

	self.redbull:runAction(cc.Sequence:create(actions_1))
end

function MainScene:gameWinAction()
	if self.welcomeOpen then
		return
	end
	local sprite = cc.Sprite:create('image/ying.png')
		:addTo(self)
		:setPosition(cc.p(display.cx,display.cy))
		:setScale(0.1)

	local actions = {}
	-- actions[#actions + 1] = cc.CallFunc:create(function()
	-- 	self.backButton:setVisible(false)
	-- end)
	actions[#actions + 1] = cc.ScaleTo:create(0.2, 1, 1, 1)
	actions[#actions + 1] = cc.DelayTime:create(0.5)
	actions[#actions + 1] = cc.ScaleTo:create(0.2, 2, 2, 2)
	actions[#actions + 1] = cc.CallFunc:create(function()
		sprite:removeSelf()
		self:showWelcomePanel()
	end)

	sprite:runAction(cc.Sequence:create(actions))
end

function MainScene:gameLostAction()
	if self.welcomeOpen then
		return
	end
	local sprite = cc.Sprite:create('image/shu.png')
		:addTo(self)
		:setPosition(cc.p(display.cx,display.cy))
		:setScale(0.1)

	local actions = {}
	-- actions[#actions + 1] = cc.CallFunc:create(function()
	-- 	self.backButton:setVisible(false)
	-- end)
	actions[#actions + 1] = cc.ScaleTo:create(0.2, 1, 1, 1)
	actions[#actions + 1] = cc.DelayTime:create(0.5)
	actions[#actions + 1] = cc.ScaleTo:create(0.2, 2, 2, 2)
	actions[#actions + 1] = cc.CallFunc:create(function()
		sprite:removeSelf()
		self:showWelcomePanel()
	end)

	sprite:runAction(cc.Sequence:create(actions))
end

function MainScene:loset()
	local size = self.bloodSize
	local width = size.width
	local height = size.height
	self.leftBar:setTag(tonumber(self.leftBar:getTag()) - 1)
	local blood = self.leftBar:getTag()

	local actions_1 = {}
	actions_1[#actions_1 + 1] = cc.MoveBy:create(0.2, cc.p(-60,0))
	actions_1[#actions_1 + 1] = cc.CallFunc:create(function()
		local actions_2 = {}
		actions_2[#actions_2 + 1] = cc.MoveBy:create(0.2, cc.p(-60,0))
		actions_2[#actions_2 + 1] = cc.MoveBy:create(0.2, cc.p(60,0))
		if blood >= 0 then
			self.leftBar:setContentSize(cc.size(width * (blood / maxBlood), height))
		end
		self.redbull:runAction(cc.Sequence:create(actions_2))
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile("audio/Hit.mp3")
	end)
	actions_1[#actions_1 + 1] = cc.MoveBy:create(0.2, cc.p(-60,0))
	actions_1[#actions_1 + 1] = cc.MoveBy:create(0.2, cc.p(60,0))
	actions_1[#actions_1 + 1] = cc.MoveBy:create(0.2, cc.p(60,0))
	if blood == 0 then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile("audio/Lose.mp3")
		actions_1[#actions_1 + 1] = cc.CallFunc:create(handler(self, self.gameLostAction))
		-- self:showWelcomePanel()
	end

	self.blackbull:runAction(cc.Sequence:create(actions_1))
end

return MainScene
