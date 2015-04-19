if LTW == nil then
	--print ( '[SAMPLERTS] creating samplerts game mode' )
	LTW = class({})
end

function LTW:InitLTW()
	LTW = self

	self.incomeTimer = 10

	self.lives = {}
	for i = DOTA_TEAM_GOODGUYS, DOTA_TEAM_CUSTOM_8 do
    	self.lives[i] = 25
	end

	self.income = {}
	for i = DOTA_TEAM_GOODGUYS, DOTA_TEAM_CUSTOM_8 do
    	self.income[i] = 25
	end

	self.units = {}
	for i = DOTA_TEAM_GOODGUYS, DOTA_TEAM_CUSTOM_8 do
    	self.units[i] = 0
	end

	self.maxUnits = 100

	BlockSpawns()

	GameRules:SetCustomGameEndDelay( 0 )
	

	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(LTW, 'OnGameRulesStateChange'), self)
	ListenToGameEvent("entity_killed", Dynamic_Wrap(LTW, 'On_entity_killed'), self)


	self:CreateQuest()



	print("LTW INITED")	
end

function LTW:On_entity_killed(data)
  --print("[LTW] entity_killed")
  --PrintTable(data)
  	--DeepPrintTable(data)
  	local unit = EntIndexToHScript( data.entindex_killed )
  	local team = unit.team

  	self.units[team] = self.units[team] - 1

  	print("Units: " .. self.units[team] .. " for team: " .. team )

end


function LTW:GrantIncome()
	--GameRules:SendCustomMessage("You get income! Next income in" .. self.incomeTimer .. " secs", 0, 0)
	self.secsUntilIncome = self.incomeTimer

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
	return self.incomeTimer
end

function LTW:IncomeTiming() 
	self._entKillCountSubquest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, self.secsUntilIncome )
	self.secsUntilIncome = self.secsUntilIncome - 1
	return 1
end

function LTW:OnGameRulesStateChange(keys)
	--print("[LTW] GameRules State Changed")
	--PrintTable(keys)

	local newState = GameRules:State_Get()

	if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self.secsUntilIncome = self.incomeTimer
		self._entKillCountSubquest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, self.secsUntilIncome )
		Timers:CreateTimer(10, function() 
			GameRules:GetGameModeEntity():SetThink( "IncomeTiming", self, 0 ) 
			GameRules:GetGameModeEntity():SetThink( "GrantIncome", self, 10 ) 
			for i = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
				player = PlayerResource:GetPlayer(i)
				if (player ~=nil) then
					hero = player:GetAssignedHero()
					if (hero ~=nil) then
						hero:SetGold(40, false)
					end
				end
			end
			return
		end
		)
	end
end

function LTW:CreateQuest()
	self._entQuest = SpawnEntityFromTableSynchronous( "quest", {
		name = "income",
		title =  "Next Income: "
	})
	self._entQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_ROUND, 1 )
	self._entQuest:SetTextReplaceString( "test" )

	self._entKillCountSubquest = SpawnEntityFromTableSynchronous( "subquest_base", {
		show_progress_bar = true,
		progress_bar_hue_shift = -119
	} )
	self._entQuest:AddSubquest( self._entKillCountSubquest )
	self._entKillCountSubquest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, self.incomeTimer )
end

function BlockSpawns()
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
end






