local Card = class("Card", cc.Node)

-- local function addSearchPath()
-- 	local tempPath = 'res/'
-- 	cc.FileUtils:getInstance():addSearchPath(tempPath);
-- end

local Map = {
	{
		number = 1,
		imagePath = "image/ico/1.png"
	},
	{
		number = 2,
		imagePath = "image/ico/2.png"
	},
	{
		number = 3,
		imagePath = "image/ico/3.png"
	},
	{
		number = 4,
		imagePath = "image/ico/4.png"
	},
	{
		number = 5,
		imagePath = "image/ico/5.png"
	},
	{
		number = 6,
		imagePath = "image/ico/6.png"
	},
	{
		number = 7,
		imagePath = "image/ico/7.png"
	},
	{
		number = 8,
		imagePath = "image/ico/8.png"
	},
	{
		number = 9,
		imagePath = "image/ico/9.png"
	},
	{
		number = 10,
		imagePath = "image/ico/10.png"
	},
	{
		number = 11,
		imagePath = "image/ico/11.png"
	},
	{
		number = 12,
		imagePath = "image/ico/12.png"
	},
}




local defClosepng = "image/ico/niubei.png"

local scaleSpeed = 0.2

local startEnum = {
	-- None = 1,
	Open = 2,
	-- Runing = 3,
	Close = 4,
}

local allPokers = {
}

local lastCard = nil


local winCallbackMian;
local lastCallbackMian;

-------public
--清除所有的牌
function Card.P_setWinCallbackMian( callback )
	winCallbackMian = callback
end

function Card.P_setLastCallbackMian( callback )
	lastCallbackMian = callback
end

function Card.P_getAllMap()
	return Map
end


function Card.P_cleanAllCards()
	for _,card in ipairs(allPokers) do
		card:removeSelf()
	end
	allPokers = {}
end

--获取没有翻开的牌
function Card.P_getAllCloseCards()
	local closeCards = {}
	for _,card in ipairs(allPokers) do
		if card._cardStart == startEnum.Close then
			table.insert(closeCards, card)
		end
	end
	return closeCards
end

--获取翻开的牌
function Card.P_getAllOpenCards()
	local openCards = {}
	for _,card in ipairs(allPokers) do
		if card._cardStart == startEnum.Open then
			table.insert(openCards, card)
		end
	end
	return openCards
end

--翻开牌后的回调（正面）
function Card.P_openCardCallback(card)
	if lastCard then
		if lastCard:getNumber() == card:getNumber() then
			print('回调界面2个相同')

			if winCallbackMian then
				winCallbackMian()
			end
		else
			lastCard:showClose()
			card:showClose()
			print('回调界面2个不相同')
			if lastCallbackMian then
				lastCallbackMian()
			end
		end
		lastCard = nil
	else
		lastCard = card
	end
end

--获取所有的牌
function Card.P_getAllCards()
	return allPokers
end

--翻开所有的牌
function Card.P_checkAllCards()
	for _,card in ipairs(allPokers) do
		local startCall = function()
			card._isOnTouch = false
			card._cardStart = startEnum.Open
		end
		local endCall = function()
			local startCall_1 = function()
				card._cardStart = startEnum.Close
			end
			local endCall_1 = function()
				card._isOnTouch = true
			end
			card:runAction(cc.Sequence:create(
					cc.DelayTime:create(1),
					cc.CallFunc:create(function()
						card:flopAction(startCall_1,endCall_1)
					end)
				)
			)
		end
		card:flopAction(startCall,endCall)
	end
end
-------public EDN

function Card:addPoker()
	table.insert(allPokers,self)
end
function Card:onCreate(number)
	return Card.new(number)
end

function Card:ctor(number)
	-- self._sprite = cc.Sprite:create(defClosepng)
	self._sprite = ccui.ImageView:create(defClosepng)
		:addTo(self)
		:setAnchorPoint(cc.p(0.5,0.5))
		:setPosition(cc.p(0,0))
		:setTouchEnabled(true)
		:onTouch(handler(self,self.touch))
	self._size = self._sprite:getContentSize()
	self:setNumber(number)

	self._isOnTouch = true
	self._cardStart = startEnum.Close
	self:addPoker()
end

function Card:touch(event)
	if event.name == 'ended' and self._isOnTouch then
		self:showOpen()
		-- local testCallback = function(card)
		-- 	card:runAction(
		-- 		cc.Sequence:create(
		-- 			cc.DelayTime:create(2),
		-- 			cc.CallFunc:create(function()
		-- 				card:showClose()
		-- 			end)
		-- 		)
		-- 	)
		-- end
		-- self:setFlopCallback(testCallback)
	end
end

function Card:getSprite()
	return self._sprite
end

function Card:setNumber(number)
	self._number = number
	-- self.openPath = "image/poker_0_3.png" --正面显示的图片

	local cardMap = Map[number]
	self.openPath = cardMap.imagePath
end

function Card:getNumber()
	return self._number
end

function Card:showOpen()
	local startCall = function()
		self._isOnTouch = false
		self._cardStart = startEnum.Open
	end
	local endCall = function()
		Card.P_openCardCallback(self)
	end
	self:flopAction(startCall,endCall)
end

function Card:showClose()
	local startCall = function()
		self._cardStart = startEnum.Close
	end
	local endCall = function()
		self._isOnTouch = true
	end
	self:flopAction(startCall,endCall)
end

function Card:flopAction(startCall,endCall)
	local action = {}
	action[#action + 1] = cc.CallFunc:create(function()
		-- self._cardStart = startEnum.Runing
		-- self._isOnTouch = false
		if startCall then
			startCall(self)
		end
	end)
	action[#action + 1] = cc.ScaleTo:create(scaleSpeed,0,1,1)
	action[#action + 1] = cc.CallFunc:create(function()
		self:_setSprite()
	end)
	action[#action + 1] = cc.ScaleTo:create(scaleSpeed,1,1,1)
	action[#action + 1] = cc.DelayTime:create(0.5)
	action[#action + 1] = cc.CallFunc:create(function()
		if endCall then
			endCall(self)
		end
	end)
	self._sprite:runAction(
		cc.Sequence:create(
			action
		)
	)
end


function Card:setFlopCallback(callback)
	self.flopCallback = callback or function(card) print(card) end
end

function Card:_setSprite(path)
	local pngPath
	if path then
		pngPath = path
	else
		pngPath = self._cardStart == startEnum.Close and defClosepng or self.openPath
	end
	self._sprite:loadTexture(pngPath)
end

function Card:getContentSize()
	return self._sprite:getContentSize()
end

return Card