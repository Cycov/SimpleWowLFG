if SimpleWowLFG == nil then
    SimpleWowLFG = CreateFrame("Frame", "SimpleWowLFGFrame");
end

local leftBorder = 10;
local checkBoxes = {}
local timer;
local qUI = Quicko.UI
local qTimers = Quicko.Components.Timers

function SimpleWowLFG:Initialize()
	SimpleWowLFG:InitTables();
	SimpleWowLFG:InitUI();
	SimpleWowLFG:RegisterSlashCommands();
	SimpleWowLFG.running = false

	print('Addon ' .. SimpleWowLFG.Constants.Name .. ' loaded');


	-- local btn = CreateFrame("Button",name,UIParent)
	-- btn:SetHeight(50)
	-- btn:SetWidth(50)
	-- btn:SetPoint("CENTER",0,0)
	-- btn:SetNormalTexture("Interface\\PaperDollInfoFrame\\StatSortArrows");

	-- UI:NewWindowDefault("pewwww", "pom")

	Quicko.UI.Manager()
end

function SimpleWowLFG:OnLoad()

	if LFGChannels == nil then
		LFGChannels = {'1'}
	end
	if LFGInterval == nil then
		LFGInterval = 60
	end

	local channels = ''
	for index,value in pairs(LFGChannels) do
		channels = channels .. value .. ','
	end
	SimpleWowLFG.Controls.ChannelsSelectEditBox:SetText(channels)
	SimpleWowLFG.Controls.IntervalEditBox:SetText(LFGInterval)

	if timer == nil then
		timer = qTimers:ScheduleTimer('timer1', tonumber(LFGInterval), true, false, SimpleWowLFG.TimerTick)
	end
end


function SimpleWowLFG:OnDisable()

end

function SimpleWowLFG:RegisterSlashCommands()
	Quicko.Console:RegisterSlashCommands(SimpleWowLFG.Constants.Name, {SimpleWowLFG.Constants.SLASH1, SimpleWowLFG.Constants.SLASH2}, function(msg, editbox)
		if (msg ~= '') then
			if (msg == "") then

			end
		else
			SimpleWowLFG.BroadcastFrame:Show();
		end
	end)
end

function SimpleWowLFG:CheckedChanged(source, object)
    checkBoxes[source] = object:GetChecked()
end

function SimpleWowLFG:SelectedInstanceDropDownClicked(item, checked, index) --self is dropdown
	SimpleWowLFG.BroadcastFrame.SelectedInstance = item.value
end

-- function SimpleWowLFG:

function SimpleWowLFG:TimerTick(sender)
	for index,value in pairs(LFGChannels) do
		Quicko.Console:SendChatMessage('LFM ' .. SimpleWowLFG.BroadcastFrame.SelectedInstance.Abbreviation:upper() .. ' ' ..
												Quicko.Functions:ternary(checkBoxes['dps'],'', 'dps') ..
												Quicko.Functions:ternary(checkBoxes['heal'],'', ', heal') ..
												Quicko.Functions:ternary(checkBoxes['tank'],'', ', tank'),'CHANNEL',tonumber(value))
	end
end

function SimpleWowLFG:SaveDataPressed()
	LFGChannels = Quicko.Functions:splitString(SimpleWowLFG.Controls.ChannelsSelectEditBox:GetText(), ',')
	LFGInterval = tonumber(SimpleWowLFG.Controls.IntervalEditBox:GetText())
	timer:SetInterval(LFGInterval)
	local text = 'Looking for group in channels '
	for index,value in pairs(LFGChannels) do
		text = text .. value .. ', '
	end
	text = text .. ' at an interval of ' .. LFGInterval .. ' seconds'
	Quicko.Console:Print(text)
end

function SimpleWowLFG:ToggleRunningPressed()
	if SimpleWowLFG.running then
		SimpleWowLFG.Controls.ToggleButton:SetText('Run');
		qTimers:DisableTimer(timer);

		SimpleWowLFG.Controls.ChannelsSelectEditBox:Enable()
		SimpleWowLFG.Controls.IntervalEditBox:Enable()
		SimpleWowLFG.SelectedInstanceDropDown:Enable()
		SimpleWowLFG.Controls.SaveButton:Enable()
	else
		SimpleWowLFG.Controls.ToggleButton:SetText('Pause');
		qTimers:EnableTimer(timer, true);

		SimpleWowLFG.Controls.ChannelsSelectEditBox:Disable()
		SimpleWowLFG.Controls.IntervalEditBox:Disable()
		SimpleWowLFG.SelectedInstanceDropDown:Disable()
		SimpleWowLFG.Controls.SaveButton:Disable()
	end
	SimpleWowLFG.running = not SimpleWowLFG.running;
end

SimpleWowLFG:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded
SimpleWowLFG:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_LOGOUT" then
		SimpleWowLFG:OnDisable()
	elseif event == "ADDON_LOADED" then
		SimpleWowLFG:OnLoad()
	end
end)

SimpleWowLFG:Initialize();