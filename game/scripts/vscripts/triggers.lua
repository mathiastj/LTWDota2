function playerOne(trigger)
	--DeepPrintTable(trigger)
	local unit = trigger.activator

	if(not string.find(unit:GetUnitName(), "hero")) then
		print("is not hero")
		if(not string.find(unit:GetUnitName(), "anti")) then
			GameRules.LTW.lives[DOTA_TEAM_GOODGUYS] = GameRules.LTW.lives[DOTA_TEAM_GOODGUYS] - 1
			GameRules.LTW.lives[unit.team] = GameRules.LTW.lives[unit.team] + 1
		end

		local teleport = Entities:FindByName( nil, "player1Teleport"):GetAbsOrigin()
		FindClearSpaceForUnit(unit, teleport, false)

		local waypoint = Entities:FindByName( nil, "player1Waypoint"):GetAbsOrigin()
		if (string.find(unit:GetUnitName(), "demolition")) then
			unit:MoveToPositionAggressive(waypoint + Vector(RandomInt(-400, 400),0,0))
		else
			unit:MoveToPosition(waypoint + Vector(RandomInt(-400, 400),0,0))
		end
		
		print("player1 lives: " .. GameRules.LTW.lives[DOTA_TEAM_GOODGUYS])
	end
	
	if(GameRules.LTW.lives[DOTA_TEAM_GOODGUYS] == 0) then
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	end
	
end

function playerTwo(trigger)
	--DeepPrintTable(trigger)
	local unit = trigger.activator

	if(not string.find(unit:GetUnitName(), "hero")) then
		print("is not hero")
		if(not string.find(unit:GetUnitName(), "anti")) then
			GameRules.LTW.lives[DOTA_TEAM_BADGUYS] = GameRules.LTW.lives[DOTA_TEAM_BADGUYS] - 1
			GameRules.LTW.lives[unit.team] = GameRules.LTW.lives[unit.team] + 1
		end

		local teleport = Entities:FindByName( nil, "player2Teleport"):GetAbsOrigin()
		FindClearSpaceForUnit(unit, teleport, false)

		local waypoint = Entities:FindByName( nil, "player2Waypoint"):GetAbsOrigin()
		if (string.find(unit:GetUnitName(), "demolition")) then
			unit:MoveToPositionAggressive(waypoint + Vector(RandomInt(-400, 400),0,0))
		else
			unit:MoveToPosition(waypoint + Vector(RandomInt(-400, 400),0,0))
		end
		print("player2 lives: " .. GameRules.LTW.lives[DOTA_TEAM_BADGUYS])
	end

	if(GameRules.LTW.lives[DOTA_TEAM_BADGUYS] == 0) then
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end
end

function tech_trigger(trigger)
	--DeepPrintTable(trigger)
	local unit = trigger.activator

	if(not string.find(unit:GetUnitName(), "hero")) then
		print("is not hero")
		if(not string.find(unit:GetUnitName(), "anti")) then
			GameRules.LTW.lives[DOTA_TEAM_BADGUYS] = GameRules.LTW.lives[DOTA_TEAM_BADGUYS] - 1
			GameRules.LTW.lives[unit.team] = GameRules.LTW.lives[unit.team] + 1
		end

		local teleport = Entities:FindByName( nil, "player2Teleport"):GetAbsOrigin()
		FindClearSpaceForUnit(unit, teleport, false)

		local waypoint = Entities:FindByName( nil, "player2Waypoint"):GetAbsOrigin()
		if (string.find(unit:GetUnitName(), "demolition")) then
			unit:MoveToPositionAggressive(waypoint + Vector(RandomInt(-400, 400),0,0))
		else
			unit:MoveToPosition(waypoint + Vector(RandomInt(-400, 400),0,0))
		end
		print("player2 lives: " .. GameRules.LTW.lives[DOTA_TEAM_BADGUYS])
	end

	if(GameRules.LTW.lives[DOTA_TEAM_BADGUYS] == 0) then
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end
end

function fire_one_tech_trigger(trigger)
	print("fire_one_trigger")
	--DeepPrintTable(trigger)
	local unit = trigger.activator

	--local hero = unit:GetOwner()
	local player = unit:GetPlayerOwner()

	player.tech["fire"] = 1 

	local i = 0
	for k,tower in pairs(player.towers) do
		CheckAbilityRequirements( tower, player )
		--i = i + 1
		--print(i)
	end

end

function ice_one_tech_trigger(trigger)
	print("ice_one_trigger")
	--DeepPrintTable(trigger)
	local unit = trigger.activator

	--local hero = unit:GetOwner()
	local player = unit:GetPlayerOwner()

	player.tech["ice"] = 1 

	local i = 0
	for k,tower in pairs(player.towers) do
		CheckAbilityRequirements( tower, player )
		--i = i + 1
		--print(i)
	end

end