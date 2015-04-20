


function send_unit( event ) 

	local buyer = event.caster
	local playerID = buyer:GetPlayerID() 
	local player = PlayerResource:GetPlayer(playerID)
	local hero = player:GetAssignedHero()
	local team = PlayerResource:GetTeam(playerID)
	local unit = event.Creep
	local item = event.Item
	local nums = 3
	local item_table = GameRules.ItemKV[item]
	local cost = item_table.ItemCost
	local spawnedUnits = {}

	if GameRules.LTW.units[team] >= 100 then
		FireGameEvent( 'custom_error_show', { player_ID = playerID, _error = "You have too many units right now" } )
		hero:SetGold(hero:GetGold() + cost, false)
		return
	end



	print("unit: " .. unit)

	if(string.find(unit, "boss")) then
		nums = 1
	end

	if (team == DOTA_TEAM_GOODGUYS) then
		teleport = Entities:FindByName( nil, "player2Teleport"):GetAbsOrigin()
		waypoint = Entities:FindByName( nil, "player2Waypoint"):GetAbsOrigin()
	else
		teleport = Entities:FindByName( nil, "player1Teleport"):GetAbsOrigin()
		waypoint = Entities:FindByName( nil, "player1Waypoint"):GetAbsOrigin()
	end
		for i = 1, nums do
			spawnedUnits[i] = CreateUnitByName(unit, teleport  + Vector(RandomInt(-400, 400),0,0), true, buyer, buyer, DOTA_TEAM_NEUTRALS)
			spawnedUnits[i].team = team
		end
		Timers:CreateTimer(0.18, function()
			for i = 1, nums do
				if (string.find(unit, "demolition")) then
					spawnedUnits[i]:MoveToPositionAggressive(waypoint)
				else 
					spawnedUnits[i]:MoveToPosition(waypoint)
				end
			end		
		end)

	local unit_table = GameRules.UnitKV[unit]
    local income = unit_table.Income

	GameRules.LTW.income[team] = GameRules.LTW.income[team] + income
	GameRules.LTW.units[team] = GameRules.LTW.units[team] + nums
end