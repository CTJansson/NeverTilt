local hideConquestFrameTierAndText = function(self)
    self.Arena2v2.CurrentRating:SetText("");
    self.Arena2v2.Tier:Hide();
    self.Arena3v3.CurrentRating:SetText("");
    self.Arena3v3.Tier:Hide();
    self.RatedBG.CurrentRating:SetText("");
    self.RatedBG.Tier:Hide();
    self.RatedBGBlitz.CurrentRating:SetText("");
    self.RatedBGBlitz.Tier:Hide();
    self.RatedSoloShuffle.CurrentRating:SetText("");
    self.RatedSoloShuffle.Tier:Hide();
end

local hideInspectedRating = function(self)
    InspectPVPFrame.Arena2v2.Rating:SetText("")
    InspectPVPFrame.Arena2v2.Record:SetText("");
    InspectPVPFrame.Arena3v3.Rating:SetText("");
    InspectPVPFrame.Arena3v3.Record:SetText("");
    InspectPVPFrame.RatedBG.Rating:SetText("");
    InspectPVPFrame.RatedBG.Record:SetText("");
    InspectPVPFrame.RatedBGBlitz.Rating:SetText("");
    InspectPVPFrame.RatedBGBlitz.Record:SetText("");
    InspectPVPFrame.RatedSoloShuffle.Rating:SetText("");
    InspectPVPFrame.RatedSoloShuffle.Record:SetText("");
end

local hideTooltip = function() 
    ConquestTooltip:Hide();
end

local hidePVPQueueFrameTier = function()
    PVPQueueFrame.HonorInset.RatedPanel.Tier:Hide();
end

local function OnEvent(self, event, isLogin, isReload)
    local loaded = C_AddOns.IsAddOnLoaded("Blizzard_PVPUI")
    if not loaded then
        C_AddOns.LoadAddOn("Blizzard_PVPUI")
    end

    local canUseRated = C_PvP.CanPlayerUseRatedPVPUI()
    local canUsePremade = C_LFGInfo.CanPlayerUsePremadeGroup()

    if canUseRated then
        PVPQueueFrame_SetCategoryButtonState(PVPQueueFrame.CategoryButton2, true)
        PVPQueueFrame.CategoryButton2.tooltip = nil
    end

    if canUsePremade then
        PVPQueueFrame_SetCategoryButtonState(PVPQueueFrame.CategoryButton3, true)
        PVPQueueFrame.CategoryButton3.tooltip = nil
    end

	if isLogin or isReload then
        hooksecurefunc("ConquestFrame_Update", hideConquestFrameTierAndText);
        hooksecurefunc(PVPQueueFrame.HonorInset.RatedPanel, "Show", hidePVPQueueFrameTier);
        hooksecurefunc("InspectPVPFrame_Update", hideInspectedRating);

        ConquestFrame.Arena2v2:HookScript("OnEnter", hideTooltip);
        ConquestFrame.Arena3v3:HookScript("OnEnter", hideTooltip);
        ConquestFrame.RatedBG:HookScript("OnEnter", hideTooltip);
        ConquestFrame.RatedBGBlitz:HookScript("OnEnter", hideTooltip);
        ConquestFrame.RatedSoloShuffle:HookScript("OnEnter", hideTooltip);

        hooksecurefunc(PVPMatchUtil, "UpdateMatchmakingText", function(fontString)
            fontString:Hide();
        end);

        hooksecurefunc(PVPMatchResults, "InitRatingFrame", function(self)
            self.ratingFrame:Hide();
        end);


    end 
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", OnEvent)