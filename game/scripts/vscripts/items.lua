


function send_unit( event ) 

	local buyer = event.caster
	local playerID = buyer:GetPlayerID() 
	local team = PlayerResource:GetTeam(playerID)
	local unit = event.Creep
	local start = Vector(-5953,6974,0)

	print("unit: " .. unit)



	if (team == DOTA_TEAM_GOODGUYS) then
		local teleport = Entities:FindByName( nil, "player2Teleport"):GetAbsOrigin() + Vector(RandomInt(-200, 200),0,0)
		local spawnedUnit = CreateUnitByName(unit, start, true, buyer, buyer, DOTA_TEAM_NEUTRALS)
		local waypoint = Entities:FindByName( nil, "player2Waypoint"):GetAbsOrigin()
		spawnedUnit:SetHullRadius(18)
		

		Timers:CreateTimer(1, function()
			FindClearSpaceForUnit(spawnedUnit, teleport, false)
			DeepPrintTable(spawnedUnit)
			--spawnedUnit:SetHullRadius(50)
			print("Collision: " .. spawnedUnit:GetCollisionPadding())
			print("Hull: " .. spawnedUnit:GetHullRadius())
			print("Padding: " .. spawnedUnit:GetPaddedCollisionRadius())
			print("Ground move: ", spawnedUnit:HasGroundMovementCapability())
			print("Phased: ", spawnedUnit:IsPhased())
			print("Unit Collision?: ", spawnedUnit:NoUnitCollision())
			spawnedUnit:MoveToPosition(waypoint)
		end)

		Timers:CreateTimer(5, function()
			DeepPrintTable(spawnedUnit)
			--spawnedUnit:SetHullRadius(50)
			print("Collision: " .. spawnedUnit:GetCollisionPadding())
			print("Hull: " .. spawnedUnit:GetHullRadius())
			print("Padding: " .. spawnedUnit:GetPaddedCollisionRadius())
			print("Ground move: ", spawnedUnit:HasGroundMovementCapability())
			print("Phased: ", spawnedUnit:IsPhased())
			print("Unit Collision?: ", spawnedUnit:NoUnitCollision())
		end)
	else 
		local teleport = Entities:FindByName( nil, "player1Teleport"):GetAbsOrigin() + Vector(RandomInt(-200, 200),0,0)
		local spawnedUnit = CreateUnitByName(unit, start, true, buyer, buyer, DOTA_TEAM_NEUTRALS)
		local waypoint = Entities:FindByName( nil, "player1Waypoint"):GetAbsOrigin()
		spawnedUnit:SetHullRadius(18)

		

		Timers:CreateTimer(0.5, function()
			FindClearSpaceForUnit(spawnedUnit, teleport, false)
			DeepPrintTable(spawnedUnit)
			--spawnedUnit:SetHullRadius(50)
			print("Collision: " .. spawnedUnit:GetCollisionPadding())
			print("Hull: " .. spawnedUnit:GetHullRadius())
			print("Padding: " .. spawnedUnit:GetPaddedCollisionRadius())
			print("Ground move: ", spawnedUnit:HasGroundMovementCapability())
			print("Phased: ", spawnedUnit:IsPhased())
			print("Unit Collision?: ", spawnedUnit:NoUnitCollision())
			spawnedUnit:MoveToPosition(waypoint)
		end)

		Timers:CreateTimer(5, function()
			DeepPrintTable(spawnedUnit)
			--spawnedUnit:SetHullRadius(50)
			print("Collision: " .. spawnedUnit:GetCollisionPadding())
			print("Hull: " .. spawnedUnit:GetHullRadius())
			print("Padding: " .. spawnedUnit:GetPaddedCollisionRadius())
			print("Ground move: ", spawnedUnit:HasGroundMovementCapability())
			print("Phased: ", spawnedUnit:IsPhased())
			print("Unit Collision?: ", spawnedUnit:NoUnitCollision())
		end)



		
	end

	local unit_table = GameRules.UnitKV[unit]
    local income = unit_table.Income

	GameRules.LTW.income[team] = GameRules.LTW.income[team] + income
end