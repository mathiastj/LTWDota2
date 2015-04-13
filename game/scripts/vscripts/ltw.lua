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






