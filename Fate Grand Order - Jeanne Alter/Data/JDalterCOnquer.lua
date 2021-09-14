function JDAlter_OnCityConquered(iVictoriousPlayer, iNewCityID)
	print("Jeanne D'Arc Alter Test Activated.")
	local pVictoriousPlayer = Players[iVictoriousPlayer]
	if not pVictoriousPlayer then return end

	local playerConfig = PlayerConfigurations[iVictoriousPlayer]
	local leaderType = playerConfig:GetLeaderTypeName()
	local civilizationType = playerConfig:GetCivilizationTypeName()
	
	if leaderType == "LEADER_FATE_JEANNE_ALTER" then
	    local pThisCity = CityManager.GetCity(iVictoriousPlayer, iNewCityID)
		if not pThisCity then return end
		print("City Name: "..pThisCity:GetName())
		if pThisCity:GetOriginalOwner() ~= iVictoriousPlayer then
			print("City Original Owner is not Dragon Witch.\n")
			local CityPopulationConstant = (pThisCity:GetPopulation()-1) * 3;
			for ii, pUnit in pUnits:Members() do
			if (pUnit ~= nil) then
				local typeName:string = GameInfo.Units[pUnit:GetType()].FormationClass;
				if (typeName ~= "FORMATION_CLASS_CIVILIAN") then
					local Damage = pUnit:GetDamage();
					if Damage > CityPopulationConstant then
					   pUnit:ChangeDamage(-1*CityPopulationConstant);
					else
					   pUnit:SetDamage(0);
					end
				end
			end
		    end
			pThisCity:ChangePopulation(-(pThisCity:GetPopulation()-1));
		end
	end
	
	
end


function JDAlter_remove_city_reward(iPlayer, CityID)
    local pPlayer = Players[iPlayer]
	if not pPlayer then return end
	print("City removed detected.");
	local playerConfig = PlayerConfigurations[iPlayer]
	local leaderType = playerConfig:GetLeaderTypeName()
	local civilizationType = playerConfig:GetCivilizationTypeName()
	
    if leaderType == "LEADER_FATE_JEANNE_ALTER" then
	    local pUnits = pPlayer:GetUnits();
		local UnitNumber = table.getn(pUnits);
		local PlayerFaith = pPlayer:GetReligion():GetFaithBalance();
		local Experience = PlayerFaith/UnitNumber;
		for ii, pUnit in pUnits:Members() do
			if (pUnit ~= nil) then
				local typeName:string = GameInfo.Units[pUnit:GetType()].FormationClass;
				if (typeName ~= "FORMATION_CLASS_CIVILIAN") then
					pUnit:GetExperience():ChangeExperience(Experience);
				end
			end
		end
	end

end

Events.CityInitialized.Add(JDAlter_OnCityConquered);
Events.CityRemovedFromMap.Add(JDAlter_remove_city_reward);

