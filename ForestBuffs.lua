-- Slash commands that can be used in game to run this addon
SLASH_FORESTBUFFS1, SLASH_FORESTBUFFS2, SLASH_FORESTBUFFS3 = '/fbuffs', '/forestbuffs', '/fb';
GlobalResult = "";

-----------------------------------------
-- Displays informational message when UI is loaded
-----------------------------------------
function ForestBuffs_onload()
	DEFAULT_CHAT_FRAME:AddMessage(	"ForestBuffs loaded" ..
                                        "\nTo run ForestBuffs type /fbuffs, /forestbuffs, or /fb", 1.0, 0.0, 1.0);
end

-----------------------------------------
-- Runs when a slash command (/fbuffs, /forestbuffs, or /fb) is issued in game
-----------------------------------------
function SlashCmdList.FORESTBUFFS(msg, editbox)
	GlobalResult = ForestBuffs_GetBuffList();
	DEFAULT_CHAT_FRAME:AddMessage("You are missing...\n" .. GlobalResult, 1.0, 1.0, 1.0);
end

-----------------------------------------
-- Main function, parses player buffs
-----------------------------------------
function ForestBuffs_GetBuffList()
	-- Initialize string to be displayed
	local result = "Missing:\n\n";
	local worldBuffsResult = "World Buffs: ";
	local raidBuffsResult = "Raid Buffs: ";
	local consumeBuffsResult = "Consumes: ";
	local selfBuffsResult = "Self Buffs: ";
	
	--All: Weapon Buff, Elixir of Fortitude, Well Fed, Rumsey Rum/Gordok Green Grog, 3x prot pot
	hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges = GetWeaponEnchantInfo()
	local hasElixirOfFortitutde = false; --INV_Potion_44
	local hasWellFed = false; --spell_misc_food
	local hasRum = false --inv_drink_03/inv_drink_04
	--local hasFireProtPot = false; --Interface\\Icons\\Spell_Fire_FireArmor
	--local hasNatureProtPot = false; --Interface\\Icons\\Spell_Nature_SpiritArmor
	
	--WBuffs: Rallying Cry, Spirit of Zandalar, Fengus's Ferocity, Mol'dar's Moxie, Slip'kik's Savvy, Songflower Serenade, Spirit of Zanza
	local hasRallyingCry = false; --Interface\\Icons\\INV_Misc_Head_Dragon_01
	local hasSpiritOfZandalar = false; --ability_creature_poison_05
	local hasFengusFerocity = false; --spell_nature_undyingstrength
	local hasMoldarsMoxie = false; --spell_nature_massteleport
	local hasSlipkiksSavvy = false; --spell_holy_lesserheal02
	local hasSongflower = false; --Interface\\Icons\\Spell_Holy_MindVision
	local hasSpiritOfZanza = false; --inv_potion_30
	
	--Raid Buffs: Fortitutde, Shadow Prot, Divine Spirit, Mark of the Wild, Kings, Might, Light, Wisdom, Sanctuary, Salv, Arcane Int
	local hasPrayerFort = false; --Interface\\Icons\\Spell_Holy_WordFortitude
	local hasDivineSpirit = false; --Interface\\Icons\\Spell_Holy_DivineSpirit
	local hasShadowProtection = false; --Interface\\Icons\\Spell_Shadow_AntiShadow
	local hasMarkOfWild = false; --Interface\\Icons\\Spell_Nature_Regeneration
	local hasBlessingKings = false; --Interface\\Icons\\Spell_Magic_MageArmor
	local hasBlessingMight = false; --Interface\\Icons\\Spell_Holy_FistOfJustice
	local hasBlessingLight = false; --Interface\\Icons\\Spell_Holy_FistOfJustice
	local hasBlessingWis = false; --Interface\\Icons\\Spell_Holy_SealOfWisdom
	local hasBlessingSanc = false; --Interface\\Icons\\Spell_holy_greaterblessingofsanctuary
	local hasBlessingSalv = false; -- Interface\\Icons\\Spell_Holy_SealOfSalvation
	local hasArcaneInt = false;	-- Interface\\Icons\\Spell_Holy_MagicalSentry
	
	--Rogue: Elixir of the Mongoose, Juju Might, Juju Power, Trueshot Aura
	local hasMongoose = false; --inv_potion_32
	local hasJujuMight = false; --inv_misc_monsterscales_07
	local hasJujuPower = false; --inv_misc_monsterscales_11
	local hasTrueshotAura = false; --ability_trueshot
	local hasFlaskTitans = false; --INV_Potion_62
	
	--Warrior: Elixir of the Mongoose, Juju Might, Juju Power, Trueshot Aura
	hasMongoose = false;
	hasJujuMight = false;
	hasJujuPower = false;
	hasTrueshotAura = false;
	
	--Hunter: Elixir of the Mongoose, Juju Might, Trueshot Aura
	hasMongoose = false;
	hasJujuMight = false;
	hasTrueshotAura = false;
	
	--Warlock: Greater Arcane Elixir, Elixir of Shadow Power, Flask of Surpreme Power, Demon Skin
	local hasGreaterArcaneElixir = false; --inv_potion_25
	local hasElixirOfShadowPower = false; --inv_potion_46
	local hasFlaskOfSurpremePower = false; --inv_potion_41
	local hasDemonSkin = false; --spell_shadow_ragingscream
	local hasIntFood = false; --INV_Misc_Organ_03
	
	--Mage: Mage Armor/Ice Armor, Flask of Supreme Power, Greater Arcane Elixir, Flask of Surpreme Power
	hasGreaterArcaneElixir = false;
	hasFlaskOfSurpremePower = false;
	local hasMageArmor = false; -- "Interface\\Icons\\Spell_MageArmor"
	hasIntFood = false;
	--Paladin: Nightfin Soup, Mageblood Potion
	local hasNightfinSoup = false; --?
	local hasMagebloodPotion = false; --inv_potion_45
	local hasFlaskDistilledWisdom = false; --INV_Potion_97
	
	--Druid: Nightfin Soup, Mageblood Potion
	hasNightfinSoup = false;
	hasMagebloodPotion = false;
	
	--Priest Nightfin Soup, Mageblood Potion, Inner Fire
	hasNightfinSoup = false;
	hasMagebloodPotion = false;
	local hasInnerFire = false; --spell_holy_innerfire	
	
	
	for i=0,50 do -- Just looping 1 to 50 because you cant have 50 buffs
		if UnitBuff("player", i) ~= nil then
			-- ~~~~~~~~~~~~~~~ WORLD BUFFS ~~~~~~~~~~~~~~~
		
			-- Onyxia / Nefarian buff
			if string.find(UnitBuff("player",i), "Interface\\Icons\\INV_Misc_Head_Dragon_01") then
				hasRallyingCry = true;
				DEFAULT_CHAT_FRAME:AddMessage(hasRallyingCry);
			end
			-- Hakkar heart buff
			if string.find(UnitBuff("player",i), "Interface\\Icons\\ability_creature_poison_05") then
				hasSpiritOfZandalar = true;
			end
			-- DM tribute AP buff
			if string.find(UnitBuff("player",i), "Interface\\Icons\\spell_nature_undyingstrength") then
				hasFengusFerocity = true;
			end
			-- DM tribute Stam buff
			if string.find(UnitBuff("player",i), "Interface\\Icons\\spell_nature_massteleport") then
				hasMoldarsMoxie = true;
			end
			-- DM tribute spell crit buff
			if string.find(UnitBuff("player",i), "Interface\\Icons\\spell_holy_lesserheal02") then
				hasSlipkiksSavvy = true;
			end
			-- Songflower felwood buff
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_MindVision") then
				hasSongflower = true;
			end
		
			
			-- ~~~~~~~~~~~~~~~ RAID BUFFS ~~~~~~~~~~~~~~~
			
			-- Power Word: Fortitude | Prayer of Fortitude
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_WordFortitude") or string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_PrayerOfFortitude") then 
				hasPrayerFort = true;
			end
		
			-- Shadow Protection | Prayer of Shadow Protection
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Shadow_AntiShadow") or string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_PrayerofShadowProtection")then 
				hasShadowProtection = true;
			end
			-- Mark of the Wild | Gift of the Wild
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Nature_Regeneration") then 
				hasMarkOfWild = true;
			end
			-- Blessing of Kings | Greater Blessing of Kings
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Magic_MageArmor") or string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Magic_GreaterBlessingofKings")then 
				hasBlessingKings = true;
			end
			-- Blessing of Might | Greater Blessing of Might
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_FistOfJustice") or string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_GreaterBlessingofKings")then 
				hasBlessingMight = true;
			end
			-- Blessing of Light | Greater Blessing of Light
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_PrayerOfHealing02") or string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_GreaterBlessingofLight")then 
				hasBlessingLight = true;
			end
			-- Blessing of Wisdom | Greater Blessing of Wisdom
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_SealOfWisdom") or string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_GreaterBlessingofWisdom")then 
				hasBlessingWis = true;
			end
			-- Greater Blessing of Sanctuary
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_holy_greaterblessingofsanctuary") then
				hasBlessingSanc = true;
			end
			-- Blessing of Salvation | Greater Blessing of Salvation
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_SealOfSalvation") or string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_GreaterBlessingofSalvation")then 
				hasBlessingSalv = true;
			end
			-- Arcane Intellect | Arcane Brilliance
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_MagicalSentry")  or string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Holy_ArcaneIntellect") then
				hasArcaneInt = true;
			end
			-- Trueshot Aura
			if string.find(UnitBuff("player",i), "Interface\\Icons\\ability_trueshot") then
				hasTrueshotAura = true;
			end
		
			
			-- ~~~~~~~~~~~~~~~ CONSUMABLES ~~~~~~~~~~~~~~~
			
			-- Elixir of Fortitude
			if string.find(UnitBuff("player",i), "Interface\\Icons\\INV_Potion_44") then
				hasElixirOfFortitutde = true;
			end
			-- Well Fed
			if string.find(UnitBuff("player",i), "Interface\\Icons\\spell_misc_food") then
				hasWellFed = true;
			end
			-- Rum (stam)
			if string.find(UnitBuff("player",i), "Interface\\Icons\\inv_drink_03") or string.find(UnitBuff("player",i), "Interface\\Icons\\inv_drink_04") then
				hasRum = true;
			end
			-- Spirit of Zanza Potion (stam/spirit)
			if string.find(UnitBuff("player",i), "Interface\\Icons\\inv_potion_30") then
				hasSpiritOfZanza = true;
			end
			-- Mongoose
			if string.find(UnitBuff("player",i), "Interface\\Icons\\inv_potion_32") then
				hasMongoose = true;
			end
			-- Juju Might (Green JuJu, raw AP)
			if string.find(UnitBuff("player",i), "Interface\\Icons\\inv_misc_monsterscales_07") then
				hasJujuMight = true;
			end
			-- Juju Power (Black JuJu, srength)
			if string.find(UnitBuff("player",i), "Interface\\Icons\\inv_misc_monsterscales_11") then
				hasJujuPower = true;
			end
			-- Greater Arcane Elixir (raw spell dmg)
			if string.find(UnitBuff("player",i), "Interface\\Icons\\inv_potion_25") then
				hasGreaterArcaneElixir = true;
			end
			-- Elixir of Shadow Power (shadow spell dmg)
			if string.find(UnitBuff("player",i), "Interface\\Icons\\inv_potion_46") then
				hasElixirOfShadowPower = true;
			end
			-- Flask of Surpeme Power (raw spell dmg)
			if string.find(UnitBuff("player",i), "Interface\\Icons\\inv_potion_41") then
				hasFlaskOfSurpremePower = true;
			end
			-- Flask of the Titans (HP)
			if string.find(UnitBuff("player",i), "Interface\\Icons\\inv_potion_62") then
				hasFlaskTitans = true;
			end
			-- Flask of Distilled Wisdom (Mana)
			if string.find(UnitBuff("player",i), "Interface\\Icons\\inv_potion_97") then
				hasFlaskDistilledWisdom = true;
			end
			-- Nightfin Soup
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_Nature_ManaRegenTotem") then 
				hasNightfinSoup = true;
			end
			-- Mageblood Potion
			if string.find(UnitBuff("player",i), "Interface\\Icons\\inv_potion_45") then 
				hasMagebloodPotion = true;
			end
		
			-- ~~~~~~~~~~~~~~~ SELF BUFFS ~~~~~~~~~~~~~~~
			
			-- Demon Skin (Warlock buff)
			if string.find(UnitBuff("player",i), "Interface\\Icons\\spell_shadow_ragingscream") then 
				hasDemonSkin = true;
			end
			-- Mage Armor (Mage buff)
			if string.find(UnitBuff("player",i), "Interface\\Icons\\Spell_MageArmor") then 
				hasMageArmor = true;
			end
			-- Inner Fire (Priest Buff)
			if string.find(UnitBuff("player",i), "Interface\\Icons\\spell_holy_innerfire") then 
				hasInnerFire = true;
			end	
		
		end
	end
	-- ****************************** Begin to build result string ******************************
			
	-- ~~~~~~~~~~~~~~~ WORLD BUFFS ~~~~~~~~~~~~~~~
	if not hasRallyingCry then
		worldBuffsResult = worldBuffsResult .. "Ony, ";
	end
	if not hasSpiritOfZandalar then
		worldBuffsResult = worldBuffsResult .. "ZG, ";
	end
	if not hasFengusFerocity then
		worldBuffsResult = worldBuffsResult .. "DM AP, ";
	end
	if not hasMoldarsMoxie then
		worldBuffsResult = worldBuffsResult .. "DM Stam, ";
	end
	if not hasSlipkiksSavvy then
		worldBuffsResult = worldBuffsResult .. "DM Spell Crit, ";
	end
	if not hasSongflower then
		worldBuffsResult = worldBuffsResult .. "Songflower, ";
	end
	
	-- ~~~~~~~~~~~~~~~ RAID BUFFS ~~~~~~~~~~~~~~~
	if not hasPrayerFort then
		raidBuffsResult = raidBuffsResult .. "Fort, ";
	end
	if not hasDivineSpirit then
		raidBuffsResult = raidBuffsResult .. "Spirit, ";
	end
	if not hasShadowProtection then
		raidBuffsResult = raidBuffsResult .. "Shadow Prot, ";
	end
	if not hasMarkOfWild then
		raidBuffsResult = raidBuffsResult .. "Mark, ";
	end
	if not hasBlessingKings then
		raidBuffsResult = raidBuffsResult .. "Kings, ";
	end
	if (not hasBlessingMight) and (UnitClass("player") == "Warrior" or UnitClass("player") == "Rogue") then
		raidBuffsResult = raidBuffsResult .. "Might, ";
	end
	if not hasBlessingLight then
		raidBuffsResult = raidBuffsResult .. "Light, ";
	end
	if (not hasBlessingWis) and (UnitClass("player") == "Hunter" or UnitClass("player") == "Druid" or UnitClass("player") == "Priest" or UnitClass("player") == "Paladin" or UnitClass("player") == "Warlock" or UnitClass("player") == "Mage") then
		raidBuffsResult = raidBuffsResult .. "Wisdom, ";
	end
	if not hasBlessingSanc then
		raidBuffsResult = raidBuffsResult .. "Sanc, ";
	end
	if not hasBlessingSalv then
		raidBuffsResult = raidBuffsResult .. "Salv, ";
	end
	if (not hasArcaneInt) and (UnitClass("player") == "Hunter" or UnitClass("player") == "Druid" or UnitClass("player") == "Priest" or UnitClass("player") == "Paladin" or UnitClass("player") == "Warlock" or UnitClass("player") == "Mage") then
		raidBuffsResult = raidBuffsResult .. "Int, ";
	end
	if (not hasTrueshotAura) and (UnitClass("player") == "Warrior" or UnitClass("player") == "Rogue" or UnitClass("player")=="Hunter") then
		raidBuffsResult = raidBuffsResult .. "Trueshot, ";
	end
	
	-- ~~~~~~~~~~~~~~~ CONSUMABLES ~~~~~~~~~~~~~~~
	if not hasMainHandEnchant then
		consumeBuffsResult = consumeBuffsResult .. "Weapon Enchant, ";
	end
	if not hasElixirOfFortitutde then
		consumeBuffsResult = consumeBuffsResult .. "Elixir of Fort, ";
	end
	if (not hasWellFed) and (UnitClass("player") == "Warrior" or UnitClass("player") == "Rogue" or UnitClass("player")=="Hunter")then 
		consumeBuffsResult = consumeBuffsResult .. "Food buff, ";
	end
	if not hasRum then
		consumeBuffsResult = consumeBuffsResult .. "Rumsey Rum,  ";
	end
	if not hasSpiritOfZanza then
		consumeBuffsResult = consumeBuffsResult .. "Zanza potion, ";
	end
	if (not hasMongoose) and (UnitClass("player") == "Warrior" or UnitClass("player") == "Rogue" or UnitClass("player")=="Hunter") then
		consumeBuffsResult = consumeBuffsResult .. "Mongoose, ";
	end
	if (not hasJujuMight) and (UnitClass("player") == "Warrior" or UnitClass("player") == "Rogue" or UnitClass("player")=="Hunter") then
		consumeBuffsResult = consumeBuffsResult .. "Black JuJu, ";
	end
	if (not hasJujuPower) and (UnitClass("player") == "Warrior" or UnitClass("player") == "Rogue") then
		consumeBuffsResult = consumeBuffsResult .. "Green JuJu, ";
	end
	if (not hasGreaterArcaneElixir) and (UnitClass("player") == "Mage" or UnitClass("player") == "Warlock") then
		consumeBuffsResult = consumeBuffsResult .. "Greater Arcane Elixir, ";
	end
	if (not hasElixirOfShadowPower) and (UnitClass("player") == "Warlock") then
		consumeBuffsResult = consumeBuffsResult .. "Greater Arcane Elixir, ";
	end
	if (not hasFlaskOfSurpremePower) and (not hasFlaskTitans) and (not hasFlaskDistilledWisdom) then
		consumeBuffsResult = consumeBuffsResult .. "Flask, ";
	end
	if (not hasNightfinSoup) and (UnitClass("player") == "Druid" or UnitClass("player") == "Priest" or UnitClass("player")=="Paladin") then
		consumeBuffsResult = consumeBuffsResult .. "Nightfin, ";
	end
	if (not hasMagebloodPotion) and (UnitClass("player") == "Druid" or UnitClass("player") == "Priest" or UnitClass("player")=="Paladin") then
		consumeBuffsResult = consumeBuffsResult .."Mageblood, ";
	end
	if (not hasIntFood) and (UnitClass("player")=="Mage" or UnitClass("player")=="Warlock") then
		consumeBuffsResult = consumeBuffsResult .. "Int food, ";
	end
	
	-- ~~~~~~~~~~~~~~~ SELF BUFFS ~~~~~~~~~~~~~~~
	if (not hasDemonSkin) and (UnitClass("player")=="Warlock") then
		selfBuffsResult = selfBuffsResult .. "Demon Skin"
	end
	if (not hasMageArmor) and (UnitClass("player")=="Mage") then
		selfBuffsResult = selfBuffsResult .. "Mage Armor"
	end
	if (not hasInnerFire) and (UnitClass("player")=="Priest") then
		selfBuffsResult = selfBuffsResult .. "Inner Fire"
	end
	
	return  worldBuffsResult .. "\n" .. raidBuffsResult .. "\n" .. consumeBuffsResult .. "\n" .. selfBuffsResult;
end
