-- The following three functions are necessary for building helper.

function build( keys )
    local player = keys.caster:GetPlayerOwner()
    local pID = player:GetPlayerID()
    local ability = keys.ability

    -- We don't want to charge the player resources at this point
    -- This is only relevent for abilities that use AbilityGoldCost
    local goldCost = keys.ability:GetGoldCost(-1)
    PlayerResource:ModifyGold(pID, goldCost, false, 7) 
    ability:EndCooldown()

    BuildingHelper:AddBuilding(keys)

    keys:OnBuildingPosChosen(function(vPos)
        --print("OnBuildingPosChosen")
        -- in WC3 some build sound was played here.
    end)

    keys:OnPreConstruction(function ()
        -- Use this function to check/modify player resources before the construction begins
        -- Return false to abort the build. It cause OnConstructionFailed to be called
        if PlayerResource:GetGold(pID) < goldCost then
            return false
        end

        PlayerResource:ModifyGold(pID, -1 * goldCost, false, 7)
    end)

    keys:OnConstructionStarted(function(unit)
    	local point = unit:GetAbsOrigin()
		local groundProp = CreateUnitByName("npc_ground_prop", point, false, nil, nil, DOTA_TEAM_NEUTRALS)
		groundProp.isGround = true
		unit.ground = groundProp
        -- This runs as soon as the building is created
        FindClearSpaceForUnit(keys.caster, keys.caster:GetAbsOrigin(), true)
        ability:StartCooldown(ability:GetCooldown(-1))

    end)
    keys:OnConstructionCompleted(function(unit)
		unit.isBuilding = true
        -- Play construction complete sound.
        -- Give building its abilities
        -- add the mana
        unit:SetMana(unit:GetMaxMana())
    end)

    -- These callbacks will only fire when the state between below half health/above half health changes.
    -- i.e. it won't unnecessarily fire multiple times.
    keys:OnBelowHalfHealth(function(unit)
    end)

    keys:OnAboveHalfHealth(function(unit)

    end)

    keys:OnConstructionFailed(function( building )
        -- This runs when a building cannot be placed, you should refund resources if any. building is the unit that would've been built.
    end)

    keys:OnConstructionCancelled(function( building )
        -- This runs when a building is cancelled, building is the unit that would've been built.
    end)

    -- Have a fire effect when the building goes below 50% health.
    -- It will turn off it building goes above 50% health again.
    keys:EnableFireEffect("modifier_jakiro_liquid_fire_burn")
end

function building_canceled( keys )
	BuildingHelper:CancelBuilding(keys)
end

function create_building_entity( keys )
	BuildingHelper:InitializeBuildingEntity(keys)
end

function SellBuilding( keys )
	local caster = keys.caster
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	local pID = hero:GetPlayerID()
	local player = PlayerResource:GetPlayer(pID)
	
	local name = caster:GetUnitName()
	local unit_table = GameRules.UnitKV[name]
	local sellBounty = unit_table.SellBounty
	print("unit name: " .. name)
	print("sell bounty: " .. sellBounty)

	-- if (not caster.ready) then
	-- 	print("not ready")
	-- 	return
	-- end

	if sellBounty ~= 0 then
		hero:SetGold(hero:GetGold() + sellBounty, false)

		-- Add gold instead

		--player.lumber = player.lumber + sellBounty
		
		--print("Lumber Gained. " .. hero:GetUnitName() .. " is currently at " .. player.lumber)
		--FireGameEvent('cgm_player_lumber_changed', { player_ID = pID, lumber = player.lumber })
		--PopupLumber(caster, sellBounty)
		PopupGoldGain(caster, sellBounty)
	end

	Timers:CreateTimer(0.06, function() 
		caster:RemoveBuilding(true) 
		--caster.ground:ForceKill(true) 
        caster.ground:RemoveSelf() 
        --DoEntFireByInstanceHandle(caster.ground, "Disable", "1", 0, nil, nil)
        --DoEntFireByInstanceHandle(caster.ground, "Kill", "1", 1, nil, nil)
	end)
end

function UpgradeBuilding( keys )
	
	local caster = keys.caster
	local pID = caster:GetPlayerOwnerID()
	local player = PlayerResource:GetPlayer(pID)
	local pos = caster:GetAbsOrigin()
	local hero = PlayerResource:GetSelectedHeroEntity(pID)
	local squares = caster.squaresOccupied
	local blockers = caster.blockers
	local abilityName = keys.ability:GetAbilityName()
	local ability_table = GameRules.AbilityKV[abilityName]
	local buildCost = ability_table.AbilityGoldCost
	local ground = caster.ground

	-- if (not caster.ready) then
	-- 	print("not ready - returning gold")
	-- 	hero:SetGold(hero:GetGold() + buildCost, false) 
	-- 	return
	-- end
	
	caster:RemoveSelf()

	unit = CreateUnitByName(keys.Building, pos, false, hero, nil, hero:GetTeamNumber())
	unit.blockers = blockers
	unit:SetOwner(hero)
	unit:SetControllableByPlayer(pID, true)
	unit:SetAbsOrigin(pos)
	unit.squaresOccupied = squares
	unit.ready = true
	unit.isBuilding = true
	unit.building = true
	unit.ground = ground

	  function unit:RemoveBuilding( bForcedKill )
	    if unit.blockers ~= nil then
	      for k, v in pairs(unit.blockers) do
	        DoEntFireByInstanceHandle(v, "Disable", "1", 0, nil, nil)
	        DoEntFireByInstanceHandle(v, "Kill", "1", 1, nil, nil)
	      end

	      if bForcedKill then
	        unit:ForceKill(bForcedKill)
	      end
	    end
	  end
	
	--player.lumber = player.lumber - keys.LumberCost
	--print("Lumber Spend. " .. hero:GetUnitName() .. " is currently at " .. player.lumber)
	--FireGameEvent('cgm_player_lumber_changed', { player_ID = pID, lumber = player.lumber })
end

function CheckFlyingAttack( event )
	local target = event.target -- The target of the attack
	local attacker = event.attacker
	local range = attacker:GetAttackRange()
	local maxTargets = 1
	local count = 0
	local units = FindUnitsInRadius(target:GetTeam(), attacker:GetOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	
	if target and target:GetName() ~= "" and target:HasFlyMovementCapability() then
		if not attacker:HasAbility("ability_attack_flying") then

			-- Send a stop order.
			ExecuteOrderFromTable({ UnitIndex = attacker:GetEntityIndex(), 
									OrderType = DOTA_UNIT_ORDER_STOP, 
									TargetIndex = target:GetEntityIndex(), 
									Position = target:GetAbsOrigin(), 
									Queue = false
								}) 
		end

		-- Find a valid target and attack it
	    for _, unit in pairs(units) do
	        if unit ~= target and not unit:HasFlyMovementCapability() then
	            attacker:PerformAttack(unit, true, true, false, false)
	            count = count + 1
	            if count >= maxTargets then
	                return
	            end
	        end
	    end
	end
end

function builder_queue( keys )
    local ability = keys.ability
    local caster = keys.caster

    if caster.ProcessingBuilding ~= nil then
        -- caster is probably a builder, stop them
        player = PlayerResource:GetPlayer(caster:GetMainControllingPlayer())
        player.activeBuilding = nil
        if player.activeBuilder and IsValidEntity(player.activeBuilder) then
            if player.activeBuilder == caster then
                player.activeBuilder:ClearQueue()
                player.activeBuilder:Stop()
                player.activeBuilder.ProcessingBuilding = false
            else
                player.activeBuilder = caster
                player.activeBuilder:ClearQueue()
                player.activeBuilder.ProcessingBuilding = false
            end
        end
    end
end

