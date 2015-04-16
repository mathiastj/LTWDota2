


function send_unit( event ) 

	local buyer = event.caster
	local playerID = buyer:GetPlayerID() 
	local team = PlayerResource:GetTeam(playerID)
	local unit = event.Creep

	print("unit: " .. unit)



	if (team == DOTA_TEAM_GOODGUYS) then
		local teleport = Entities:FindByName( nil, "player2Teleport"):GetAbsOrigin() + Vector(RandomInt(-200, 200),0,0)
		local spawnedUnit = CreateUnitByName(unit, teleport, true, buyer, buyer, DOTA_TEAM_NEUTRALS)
		local waypoint = Entities:FindByName( nil, "player2Waypoint"):GetAbsOrigin()
		

		Timers:CreateTimer(0.06, function()
			spawnedUnit:MoveToPosition(waypoint)
		end)
	else 
		local teleport = Entities:FindByName( nil, "player1Teleport"):GetAbsOrigin() + Vector(RandomInt(-200, 200),0,0)
		local spawnedUnit = CreateUnitByName(unit, teleport, true, buyer, buyer, DOTA_TEAM_NEUTRALS)
		local waypoint = Entities:FindByName( nil, "player1Waypoint"):GetAbsOrigin()
		spawnedUnit:SetHullRadius(18)

		

		Timers:CreateTimer(0.06, function()
			spawnedUnit:MoveToPosition(waypoint)
		end)
	end

	local unit_table = GameRules.UnitKV[unit]
    local income = unit_table.Income

	GameRules.LTW.income[team] = GameRules.LTW.income[team] + income
end