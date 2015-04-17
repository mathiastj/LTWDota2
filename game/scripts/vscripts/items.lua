


function send_unit( event ) 

	local buyer = event.caster
	local playerID = buyer:GetPlayerID() 
	local team = PlayerResource:GetTeam(playerID)
	local unit = event.Creep
	local nums = 3
	local spawnedUnits = {}

	print("unit: " .. unit)

	if(string.find(unit, "boss")) then
		nums = 1
	end

	if (team == DOTA_TEAM_GOODGUYS) then
		local teleport = Entities:FindByName( nil, "player2Teleport"):GetAbsOrigin()
		local waypoint = Entities:FindByName( nil, "player2Waypoint"):GetAbsOrigin()
		for i = 1, nums do
			spawnedUnits[i] = CreateUnitByName(unit, teleport  + Vector(RandomInt(-200, 200),0,0), true, buyer, buyer, DOTA_TEAM_NEUTRALS)
		end
		Timers:CreateTimer(0.18, function()
			for i = 1, nums do
				spawnedUnits[i]:MoveToPosition(waypoint)
			end		
		end)
	else 
		local teleport = Entities:FindByName( nil, "player1Teleport"):GetAbsOrigin()
		local waypoint = Entities:FindByName( nil, "player1Waypoint"):GetAbsOrigin()
		for i = 1, nums do
			spawnedUnits[i] = CreateUnitByName(unit, teleport  + Vector(RandomInt(-200, 200),0,0), true, buyer, buyer, DOTA_TEAM_NEUTRALS)
		end
		Timers:CreateTimer(0.18, function()
			for i = 1, nums do
				spawnedUnits[i]:MoveToPosition(waypoint)
			end		
		end)
	end

	local unit_table = GameRules.UnitKV[unit]
    local income = unit_table.Income

	GameRules.LTW.income[team] = GameRules.LTW.income[team] + income
end