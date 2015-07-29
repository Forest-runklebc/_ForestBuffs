-- Slash commands that can be used in game to run this addon
SLASH_FORESTBUFFS1, SLASH_FORESTBUFFS2, SLASH_FORESTBUFFS3 = '/fbuffs', '/forestbuffs', '/fb';
ForestBuffsVersion = "_ForestBuffs: Version(v1.0)";
GlobalResult = "";

-----------------------------------------
-- Displays informational message when UI is loaded
-----------------------------------------
function ForestBuffs_onload()
	DEFAULT_CHAT_FRAME:AddMessage(	ForestBuffsVersion .. " loaded" ..
                                        "\nTo run ForestBuffs type /fbuffs, /forestbuffs, or /fb", 1.0, 0.0, 1.0);
end

-----------------------------------------
-- Runs when a slash command (/fbuffs, /forestbuffs, or /fb) is issued in game
-----------------------------------------
function SlashCmdList.FORESTBUFFS(msg, editbox)
	GlobalResult = ForestBuffs_GetBuffList();
	ForestBuffs_Toggle();
end

-----------------------------------------
-- Main function, parses player buffs
-----------------------------------------
function ForestBuffs_GetBuffList()
	-- Initialize string to be displayed
	local result = "Missing:\n\n";
	
	-- Declare all buffs as missing until seen
	local hasMageArmor = false;
	local hasArcaneInt = false;
	local hasMarkOfWild = false;
	local hasThorns = false;
	local hasPrayerFort = false;	
	local hasDivineSpirit = false;
	local hasShadowProtection = false;
	local hasBlessingWis = false;
	local hasBlessingSalv = false;
	local hasBlessingMight = false;
	local hasBlessingKings = false;
	local hasBlessingLight = false;
	local hasDetectInvis = false;
	local hasUnderwaterBreath = false;
	local hasGiantsElixir = false
	local hasHolyProtPot = false;
	local hasShadowProtPot = false;
	local hasFireProtPot = false;
	local hasFrostProtPot = false;
	local hasNatureProtPot = false;
	local hasGreaterArcaneProtPot = false;
	local hasGreaterFireProtPot = false;
	local hasInfallibleMind = false;
	local hasDampenMagic = false;
	local hasNightfinSoup = false;
	local hasRallyingCry = false;
	local hasSongflower = false;
	local hasSlipkikSavvy = false;
	local hasScrollOfProtection = false;
	local hasScrollOfAgility = false;
	local hasScrollOfStrength = false;
	
	--[[
	
	 Official buff names can be located by:
	 	1) Going to http://www.wowhead.com
		2) Searching for the in game spell/item you want to find
		3) Go to spell/item sub-page
		4) Clicking on the spell icon image(this will bring up a page that says something like Spell_Nature_Regeneration.png, this is the offical buff name - not accurate for all buffs)
	
	 Overview: Loop through all buffs on player (self) and check for existing buffs (Side note: can't track individual ranks of spells since the icons are the same)
		1) 0 to 50 just because we should never have 50 buffs
		2) Check if we have any buffs at all
		3) Check if the buffs we are tracking are on player (self)
	
	 UnitBuff explanation: UnitBuff takes as arguments (UnitBuff(playerToCheck, buffSlot), PathToOfficialBuffName)
	 
	--]]

	for i=0,50 do 
		if UnitBuff("player", i) ~= nil then
			-- Mage Armor
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_MageArmor") then
				hasMageArmor = true;
			end
			-- Arcane Intellect | Arcane Brilliance
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_MagicalSentry")  or string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_ArcaneIntellect") then
				hasArcaneInt = true;
			end
			-- Mark of the Wild | Gift of the Wild
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Nature_Regeneration") then 
				hasMarkOfWild = true;
			end
			-- Thorns
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Nature_Thorns") then 
				hasThorns = true;
			end
			-- Power Word: Fortitude | Prayer of Fortitude
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_WordFortitude") or string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_PrayerOfFortitude") then 
				hasPrayerFort = true;
			end			
			-- Divine Spirit | Prayer of Spirit
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_DivineSpirit") or string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_PrayerofSpirit")then 
				hasDivineSpirit = true;
			end
			-- Shadow Protection | Prayer of Shadow Protection
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Shadow_AntiShadow") or string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_PrayerofShadowProtection")then 
				hasShadowProtection = true;
			end
			-- Blessing of Wisdom | Greater Blessing of Wisdom
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_SealOfWisdom") or string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_GreaterBlessingofWisdom")then 
				hasBlessingWis = true;
			end
			-- Blessing of Salvation | Greater Blessing of Salvation
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_SealOfSalvation") or string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_GreaterBlessingofSalvation")then 
				hasBlessingSalv = true;
			end
			-- Blessing of Might | Greater Blessing of Might
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_FistOfJustice") or string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_GreaterBlessingofKings")then 
				hasBlessingSalv = true;
			end
			-- Blessing of Kings | Greater Blessing of Kings
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Magic_MageArmor") or string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Magic_GreaterBlessingofKings")then 
				hasBlessingKings = true;
			end
			-- Blessing of Light | Greater Blessing of Light
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_PrayerOfHealing02") or string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_GreaterBlessingofLight")then 
				hasBlessingLight = true;
			end	
			-- Detect Lesser Invisibility
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Shadow_DetectLesserInvisibility") then 
				hasDetectInvis = true;
			end
			-- Underwater Breathing
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Shadow_DemonBreath") then 
				hasUnderwaterBreath = true;
			end
			-- Elixir of the Giants
			if string.find(UnitBuff("player",i), "Interface\\Icons\\INV_Potion_61") then 
				hasGiantsElixir = true;
			end
			-- Holy Protection Potion
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_BlessingOfProtection") then 
				hasHolyProtPot = true;
			end
			-- Shadow Protection Potion
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Shadow_Ragingscream") then 
				hasShadowProtPot = true;
			end
			-- Fire Protection Potion
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Fire_FireArmor") then 
				hasFireProtPot = true;
			end
			-- Frost Protection Potion
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Frost_FrostArmor02") then 
				hasFireProtPot = true;
			end
			-- Nature Protection Potion
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Nature_SpiritArmor") then 
				hasNatureProtPot = true;
			end
			-- Greater Arcane Protection Potion
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_PrayerOfHealing02") then 
				hasGreaterArcaneProtPot = true;
			end
			-- Greater Fire Protection Potion
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Fire_FireArmor") then 
				hasGreaterFirePot = true;
			end
			-- Infallible Mind
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Ice_Lament") then 
				hasInfallibleMind = true;
			end
			-- Dampen Magic
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Nature_AbolishMagic") then 
				hasDampenMagic = true;
			end
			-- Nightfin Soup
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Nature_ManaRegenTotem") then 
				hasNightfinSoup = true;
			end
			-- Rallying Cry of the Dragonslayer
			if string.find(UnitBuff("player",i), "Interface\\Icons\\INV_Misc_Head_Dragon_01") then 
				hasRallyingCry = true;
			end
			-- Songflower Serenade
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_MindVision") then 
				hasSongflower = true;
			end
			-- Slipkik's Savvy
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_LesserHeal02") then 
				hasSlipkikSavvy = true;
			end
			-- Scroll of Protection
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Ability_Warrior_DefensiveStance") then 
				hasScrollOfProtection = true;
			end
			-- Scroll of Agility
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_BlessingOfAgility") then 
				hasScrollOfAgility = true;
			end
			-- Scroll of Strength
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Nature_Strength") then 
				hasScrollOfStrength = true;
			end
		end
	end
	
	-- For each buff missing, add it to the result to be displayed
	if not hasMageArmor then
		result = result .. "Mage Armor\n";
	end
	if not hasArcaneInt then
		result = result .. "Arcane Intellect\n";
	end
	if not hasMarkOfWild then
		result = result .. "Mark of the Wild\n";
	end
	if not hasThorns then
		result = result .. "Thorns\n";
	end
	if not hasPrayerFort then
		result = result .. "Power Word: Fortitude\n";
	end
	if not hasDivineSpirit then
		result = result .. "Divine Spirit\n";
	end
	if not hasShadowProtection then
		result = result .. "Shadow Protection\n";
	end
	if not hasBlessingWis then
		result = result .. "Blessing of Wisdom\n";
	end
	if not hasBlessingKings then
		result = result .. "Blessing of Kings\n";
	end
	if not hasBlessingSalv then
		result = result .. "Blessing of Salvation\n";
	end
        if not hasBlessingMight then
		result = result .. "Blessing of Might\n";
	end
	if not hasBlessingLight then
		result = result .. "Blessing of Light\n";
	end
	if not hasDetectInvis then
		result = result .. "Detect Lesser Invisibility\n";
	end
	if not hasUnderwaterBreath then
		result = result .. "Underwater Breathing\n";
	end
	if not hasGiantsElixir then
		result = result .. "Elixir of the Giants\n";
	end
	if not hasHolyProtPot then
		result = result .. "Holy Protection Potion\n";
	end
	if not hasShadowProtPot then
		result = result .. "Shadow Protection Potion\n";
	end
	if not hasFireProtPot then
		result = result .. "Fire Protection Potion\n";
	end
	if not hasFrostProtPot then
		result = result .. "Frost Protection Potion\n";
	end
	if not hasNatureProtPot then
		result = result .. "Nature Protection Potion\n";
	end
	if not hasGreaterArcaneProtPot then
		result = result .. "Greater Arcane Protection Potion\n";
	end
	if not hasGreaterFireProtPot then
		result = result .. "Greater Fire Protection Potion\n";
	end
	if not hasInfallibleMind then
		result = result .. "Infallible Mind\n";
	end
	if not hasDampenMagic then
		result = result .. "Dampen Magic\n";
	end
	if not hasNightfinSoup then
		result = result .. "Nightfin Soup\n";
	end
	if not hasRallyingCry then
		result = result .. "Rallying Cry of the Dragonslayer\n";
	end
	if not hasSongflower then
		result = result .. "Songflower Serenade\n";
	end
	if not hasSlipkikSavvy then
		result = result .. "Slipkik\'s Savvy\n";
	end
	if not hasScrollOfProtection then
		result = result .. "Scroll of Protection\n";
	end
	if not hasScrollOfAgility then
		result = result .. "Scroll of Agility\n";
	end
	if not hasScrollOfStrength then
		result = result .. "Scroll of Strength\n";
	end	

	-- No buffs are missing. Simply output 'Missing: None'
	if result == "Missing\n\n" then
		result = result .. "None";
	end
	
	return result;
end

-----------------------------------------
-- Updates buff list
-----------------------------------------
function ForestBuffs_Refresh()
	GlobalResult = ForestBuffs_GetBuffList();
	ForestBuffs_Text_Status_BuffList:SetText(GlobalResult);
end

-----------------------------------------
-- Toggles the showing/hiding of the Menu
-----------------------------------------
function ForestBuffs_Toggle()
	if ( ForestBuffs_Menu:IsVisible() ) then
		ForestBuffs_Menu:Hide();
	else
		ForestBuffs_Menu:Show();
	end
end

----------------------------------
-- Parse out option from / Command
----------------------------------
function ForestBuffs_options(msg)
        -- Show Config Menu
	if (msg == "") then
         	ForestBuffs_Toggle();
        end
end
