if LTW == nil then
	--print ( '[SAMPLERTS] creating samplerts game mode' )
	LTW = class({})
end

function LTW:InitLTW()
	LTW = self

	self.lives = {}
	for i = DOTA_TEAM_GOODGUYS, DOTA_TEAM_CUSTOM_8 do
    	self.lives[i] = 25
	end

	self.income = {}
	for i = DOTA_TEAM_GOODGUYS, DOTA_TEAM_CUSTOM_8 do
    	self.income[i] = 10
	end

	GameRules:GetGameModeEntity():SetThink( "GrantIncome", self, 20 ) 

	local topLeftPoint = {}
	topLeftPoint.x = -3328
	topLeftPoint.y = 5696

	local tLP = {}
	tLP.x = -2240 
	tLP.y = 4992

	local topRightPoint = {}
	topRightPoint.x = -1280
	topRightPoint.y = 5696

	local tRP = {}
	tRP.x = -192 
	tRP.y = 4992

	local botLeftPoint = {}
	botLeftPoint.x = -3328
	botLeftPoint.y = -1024

	local bLP = {}
	bLP.x = -2240 
	bLP.y = -1792

	local botRightPoint = {}
	botRightPoint.x = -1280
	botRightPoint.y = -1024

	local bRP = {}
	bRP.x = -192 
	bRP.y = -1792

	BuildingHelper:BlockRectangularArea(topLeftPoint, tLP)
	BuildingHelper:BlockRectangularArea(topRightPoint, tRP)
	BuildingHelper:BlockRectangularArea(botLeftPoint, bLP)
	BuildingHelper:BlockRectangularArea(botRightPoint, bRP)

	print("LTW INITED")	
end


function LTW:GrantIncome()
	GameRules:SendCustomMessage("You get income! Next income in 20 secs", 0, 0)
	for i = DOTA_TEAM_GOODGUYS, DOTA_TEAM_CUSTOM_8 do
		

    	local playerID = PlayerResource:GetNthPlayerIDOnTeam(i, 1)
		local player = PlayerResource:GetPlayer(playerID)
		if (player ~= nil) then
			local hero = player:GetAssignedHero()
			if (hero ~= nil) then
	    		hero:SetGold(hero:GetGold() + self.income[i], false)
	    	end
		end
	end
	return 20
end


function LTW:OnGameRulesStateChange(keys)
	--print("[SAMPLERTS] GameRules State Changed")
	--PrintTable(keys)

	local newState = GameRules:State_Get()

	if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		
	end
end






