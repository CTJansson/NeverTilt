local hideConquestFrameTierAndText = function(self)
    self.Arena2v2.CurrentRating:SetText(nil);
    self.Arena2v2.Tier:Hide();
    self.Arena3v3.CurrentRating:SetText(nil);
    self.Arena3v3.Tier:Hide();
    self.RatedBG.CurrentRating:SetText(nil);
    self.RatedBG.Tier:Hide();
    self.RatedBGBlitz.CurrentRating:SetText(nil);
    self.RatedBGBlitz.Tier:Hide();
    self.RatedSoloShuffle.CurrentRating:SetText(nil);
    self.RatedSoloShuffle.Tier:Hide();
end

local hideInspectedRating = function(self)
    InspectPVPFrame.Arena2v2.Rating:SetText(nil)
    InspectPVPFrame.Arena2v2.Record:SetText(nil);
    InspectPVPFrame.Arena3v3.Rating:SetText(nil);
    InspectPVPFrame.Arena3v3.Record:SetText(nil);
    InspectPVPFrame.RatedBG.Rating:SetText(nil);
    InspectPVPFrame.RatedBG.Record:SetText(nil);
    InspectPVPFrame.RatedBGBlitz.Rating:SetText(nil);
    InspectPVPFrame.RatedBGBlitz.Record:SetText(nil);
    InspectPVPFrame.RatedSoloShuffle.Rating:SetText(nil);
    InspectPVPFrame.RatedSoloShuffle.Record:SetText(nil);
end

local hideTooltip = function() 
    ConquestTooltip:Hide();
end

local hidePVPQueueFrameTier = function()
    PVPQueueFrame.HonorInset.RatedPanel.Tier:Hide();
end

local addonName, addonNS = ...;
 
local PvPUI_Loaded = false;
local Addon_Loaded = false;
local Player_EnteredWorld = false;
local UiHidden = false;
 
local function CheckUsage(event)
    local canUseRated, failureReason = C_PvP.CanPlayerUseRatedPVPUI()
    local canUsePremade = C_LFGInfo.CanPlayerUsePremadeGroup()

    if PvPUI_Loaded and not UiHidden then
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

    if canUseRated then
        PVPQueueFrame_SetCategoryButtonState(PVPQueueFrame.CategoryButton2, true);
        PVPQueueFrame.CategoryButton2.tooltip = nil;
    end

    if canUsePremade then
        PVPQueueFrame_SetCategoryButtonState(PVPQueueFrame.CategoryButton3, true);
        PVPQueueFrame.CategoryButton3.tooltip = nil;
    end
end
 
local function OnEvent(self, event, ...)
    local args = { ... }
    
    if event == "ADDON_LOADED" then
        if args[1] == addonName then
            Addon_Loaded = true
            PvPUI_Loaded = C_AddOns.IsAddOnLoaded("Blizzard_PVPUI")
            if not PvPUI_Loaded then
                C_AddOns.LoadAddOn("Blizzard_PVPUI")
            end
            
        elseif args[1] == "Blizzard_PVPUI" then
            PvPUI_Loaded = true
            
            if Player_EnteredWorld then
                CheckUsage(event)
            end
            
        end
        
    elseif event == "PLAYER_ENTERING_WORLD" then
        local Player_EnteredWorld = true
        
        if Addon_Loaded and PvPUI_Loaded then
            CheckUsage(event)
        end
    elseif event == "PLAYER_LEVEL_CHANGED" then
        if Addon_Loaded and PvPUI_Loaded then
            CheckUsage(event)
        end
        
    elseif event == "UPDATE_BATTLEFIELD_STATUS" then
        if Addon_Loaded and PvPUI_Loaded then
            CheckUsage(event)
        end
    elseif event == "ZONE_CHANGED_NEW_AREA" then
        if Addon_Loaded and PvPUI_Loaded then
            CheckUsage(event)
        end
    elseif event == "ZONE_CHANGED" then
        if Addon_Loaded and PvPUI_Loaded then
            CheckUsage(event)
        end
        
    end
    
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("PLAYER_LEVEL_CHANGED")
events:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
events:RegisterEvent("ZONE_CHANGED_NEW_AREA")
events:RegisterEvent("ZONE_CHANGED")
events:SetScript("OnEvent",OnEvent)