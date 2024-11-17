function rebuildTable(tableBuilder, dataIndex)
	local iconPadding = 2;
	local textPadding = 15;
	
	tableBuilder:Reset();
	tableBuilder:SetDataProvider(C_PvP.GetScoreInfo);
	tableBuilder:SetTableMargins(5);

	local column = tableBuilder:AddColumn();
	column:ConstructHeader("BUTTON", "PVPHeaderIconTemplate", [[Interface/PVPFrame/Icons/prestige-icon-3]], "honorLevel");
	column:ConstrainToHeader();
	column:ConstructCells("FRAME", "PVPCellHonorLevelTemplate");

	column = tableBuilder:AddColumn();
	column:ConstructHeader("BUTTON", "PVPHeaderIconTemplate", [[Interface/PvPRankBadges/PvPRank06]], "class");
	column:ConstrainToHeader(iconPadding);
	column:ConstructCells("FRAME", "PVPCellClassTemplate");

	column = tableBuilder:AddColumn();
	column:ConstructHeader("BUTTON", "PVPHeaderStringTemplate", NAME, "LEFT", "name");
	local fillCoefficient = 1.0;
	local namePadding = 4;
	
	local isSoloShuffle = C_PvP.IsSoloShuffle();
	if isSoloShuffle then
		column:ConstructCells("BUTTON", "PVPSoloShuffleCellNameTemplate", useAlternateColor);
	else
		column:ConstructCells("BUTTON", "PVPCellNameTemplate", useAlternateColor);
	end
	column:SetFillConstraints(fillCoefficient, namePadding);

	local function AddPVPStatColumns(cellStatTemplate)
		local statColumns = C_PvP.GetMatchPVPStatColumns();
		table.sort(statColumns, function(lhs,rhs)
			return lhs.orderIndex < rhs.orderIndex;
		end);

		for columnIndex, statColumn in ipairs(statColumns) do
			if strlen(statColumn.name) > 0 then
				column = tableBuilder:AddColumn();
				local sortType = "stat"..columnIndex;
				column:ConstructHeader("BUTTON", "PVPHeaderStringTemplate", statColumn.name, "CENTER", sortType, statColumn.tooltipTitle, statColumn.tooltip);
				column:ConstrainToHeader(textPadding);
				column:ConstructCells("FRAME", cellStatTemplate, statColumn.pvpStatID, useAlternateColor);
			end
		end
	end

	if isSoloShuffle then
		local cellStatTemplate = "PVPSoloShuffleCellStatTemplate";
		AddPVPStatColumns(cellStatTemplate);
	end

	if C_PvP.CanDisplayKillingBlows() then
		column = tableBuilder:AddColumn();
		column:ConstructHeader("BUTTON", "PVPHeaderStringTemplate", SCORE_KILLING_BLOWS, "CENTER", "kills", KILLING_BLOW_TOOLTIP_TITLE, KILLING_BLOW_TOOLTIP);
		column:ConstrainToHeader(textPadding);
		column:ConstructCells("FRAME", "PVPCellStringTemplate", "killingBlows", useAlternateColor);
	end
	
	if C_PvP.CanDisplayHonorableKills() then
		column = tableBuilder:AddColumn();
		column:ConstructHeader("BUTTON", "PVPHeaderStringTemplate", SCORE_HONORABLE_KILLS, "CENTER", "hk", HONORABLE_KILLS_TOOLTIP_TITLE, HONORABLE_KILLS_TOOLTIP);
		column:ConstrainToHeader(textPadding);
		column:ConstructCells("FRAME", "PVPCellStringTemplate", "honorableKills", useAlternateColor);
	end
	 
	if  C_PvP.CanDisplayDeaths() then
		column = tableBuilder:AddColumn();
		column:ConstructHeader("BUTTON", "PVPHeaderStringTemplate", DEATHS, "CENTER", "deaths", DEATHS_TOOLTIP_TITLE, DEATHS_TOOLTIP);
		column:ConstrainToHeader(textPadding);
		column:ConstructCells("FRAME", "PVPCellStringTemplate", "deaths", useAlternateColor);
	end

	local isAbbreviated = true;
	local hasTooltip = true;

	if C_PvP.CanDisplayDamage() then
		column = tableBuilder:AddColumn();
		column:ConstructHeader("BUTTON", "PVPHeaderStringTemplate", SCORE_DAMAGE_DONE, "CENTER", "damage", DAMAGE_DONE_TOOLTIP_TITLE, DAMAGE_DONE_TOOLTIP);
		column:ConstrainToHeader(textPadding);
		column:ConstructCells("FRAME", "PVPCellStringTemplate", "damageDone", useAlternateColor, isAbbreviated, hasTooltip);
	end

	if C_PvP.CanDisplayHealing() then
		column = tableBuilder:AddColumn();
		column:ConstructHeader("BUTTON", "PVPHeaderStringTemplate", SCORE_HEALING_DONE, "CENTER", "healing", HEALING_DONE_TOOLTIP_TITLE, HEALING_DONE_TOOLTIP);
		column:ConstrainToHeader(textPadding);
		column:ConstructCells("FRAME", "PVPCellStringTemplate", "healingDone", useAlternateColor, isAbbreviated, hasTooltip);
	end

	if not isSoloShuffle then
		local cellStatTemplate = "PVPCellStatTemplate";
		AddPVPStatColumns(cellStatTemplate);
	end

	tableBuilder:Arrange();
end

hooksecurefunc("ConstructPVPMatchTable", rebuildTable)