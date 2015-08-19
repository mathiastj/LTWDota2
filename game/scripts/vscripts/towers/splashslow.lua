function SplashSlow(keys)
	local caster = keys.caster
	local radius = keys.radius
	local target = keys.target
	local ability = keys.ability

	local targets = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

	for i = 1, #targets do
		ability:ApplyDataDrivenModifier(caster, targets[i], "modifier_slow", {})
	end
end