if LookingForGroup == nil then
    LookingForGroup = CreateFrame("Frame", "LookingForGroupFrame");
end

local leftBorder = 10;
local checkBoxes = {}
local timer;
local qUI = Quicko.UI
local qTimers = Quicko.Components.Timers

function LookingForGroup:Initialize()
	LookingForGroup:InitTables();
	LookingForGroup:InitUI();
	LookingForGroup:RegisterSlashCommands();
	LookingForGroup.running = false

	print('Addon ' .. LookingForGroup.Constants.Name .. ' loaded');


	-- local btn = CreateFrame("Button",name,UIParent)
	-- btn:SetHeight(50)
	-- btn:SetWidth(50)
	-- btn:SetPoint("CENTER",0,0)
	-- btn:SetNormalTexture("Interface\\PaperDollInfoFrame\\StatSortArrows");

	-- UI:NewWindowDefault("pewwww", "pom")
end

function LookingForGroup:OnLoad()

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
	LookingForGroup.ChannelsTbox:SetText(channels)
	LookingForGroup.IntervalTbox:SetText(LFGInterval)

	if timer == nil then
		timer = qTimers:ScheduleTimer('timer1', LFGInterval, true, false, LookingForGroup.TimerTick)
	end
end


function LookingForGroup:OnDisable()

end

function LookingForGroup:RegisterSlashCommands()
	Quicko.Console:RegisterSlashCommands(LookingForGroup.Constants.Name, {LookingForGroup.Constants.SLASH1, LookingForGroup.Constants.SLASH2}, function(msg, editbox)
		if (msg ~= '') then
			if (msg == "") then

			end
		else
			LookingForGroup.BroadcastFrame:Show();
		end
	end)
end

function LookingForGroup:InitUI()
	local paddingTop = 0
	local basename = 'BroadcastFrame';

	LookingForGroup.BroadcastFrame = qUI:NewWindowBasic(
				basename,
				LookingForGroup.Constants.MainFrame.Title,
				LookingForGroup.Constants.MainFrame.Height + paddingTop,
				LookingForGroup.Constants.MainFrame.Width,
				LookingForGroup.Constants.MainFrame.FrameStrata,
				LookingForGroup.Constants.MainFrame.Help,
				"|cFFFF0000"..LookingForGroup.Constants.DisplayName.." |cFF40FF40Version "..LookingForGroup.Constants.Version:GetVersion()..
					"|r\nMade by "..LookingForGroup.Constants.Author.Name..
					Quicko.Functions:ternary(LookingForGroup.Constants.Author.AltName ~= ""," aka "..LookingForGroup.Constants.Author.AltName,"")..
					Quicko.Functions:ternary(LookingForGroup.Constants.Author.Email ~= "","\nFor any information mail me at "..LookingForGroup.Constants.Author.Email,"")
			);
	table.insert(UISpecialFrames,basename);
	LookingForGroup.BroadcastFrame:Hide()
	local parent = LookingForGroup.BroadcastFrame;

	local instances = {}

	for dungeonName,dungeonData in pairs(LookingForGroup.Constants.Dungeons) do
		table.insert(instances, dungeonData:GetColor() .. dungeonName)
	end
	
    LookingForGroup.SelectedInstanceDropDown = qUI:NewDropDown(parent,basename .. "_SELECTEDINSTANCE",instances,-2,-17 - paddingTop,130)
    qUI:NewCheckBox(parent,basename .. "_TOGGLEDPS",'dps',nil,165,-35 - paddingTop,function(obj) LookingForGroup:CheckedChanged('dps', obj) end)
    qUI:NewCheckBox(parent,basename .. "_TOGGLEHEAL",'heal',nil,165,-55 - paddingTop,function(obj) LookingForGroup:CheckedChanged('heal', obj) end)
    qUI:NewCheckBox(parent,basename .. "_TOGGLETANK",'tank',nil,165,-75 - paddingTop,function(obj) LookingForGroup:CheckedChanged('tank', obj) end)
	qUI:NewLabel(parent, basename .. "_STATICLABEL1",'Channels',17,-53 - paddingTop)
	LookingForGroup.ChannelsTbox = qUI:NewEditBox(parent,basename .. "_CHANNELSTBOX",78,-50 - paddingTop,83, false, 10)
	qUI:NewLabel(parent, basename .. "_STATICLABEL2",'Interval',17,-78 - paddingTop)
	LookingForGroup.IntervalTbox = qUI:NewEditBox(parent,basename .. "_INTERVALTBOX",78,-75 - paddingTop,30, true, 3)
    qUI:NewButton(parent,basename .. "_INTERVALSAVEBTN",'Save',115,-75 - paddingTop,20,50, LookingForGroup.SaveDataPressed)
	LookingForGroup.ToggleBtn = qUI:NewButton(parent,basename .. "_TOGGLERUNNING",'Run',15,-100 - paddingTop,20,200,LookingForGroup.ToggleRunningPressed)
	
	basename = LookingForGroup.Constants.MainFrame.Name
	LookingForGroup.MainFrame = qUI:NewWindowDefault(basename,'Existing groups')
	-- qUI:NewAccordion(basename .. 'Accordion1', LookingForGroup.MainFrame, 'Accordion1', 0, -45,100, LookingForGroup.MainFrame:GetWidth(), 'TOP')
	qUI:NewAccordionCollection(basename .. 'AccordionCollection1', LookingForGroup.MainFrame, 0, -45, LookingForGroup.MainFrame:GetWidth(), 'TOP', {
		{
			text = 'pew1',
			height = 100
		},
		{
			text = 'pew2',
			height = 100
		},
		{
			text = 'pew3',
			height = 200
		},
	})
end

function LookingForGroup:CheckedChanged(source, object)
    checkBoxes[source] = object:GetChecked()
end

function LookingForGroup:TimerTick(sender)
	for index,value in pairs(LFGChannels) do
		Console:SendChatMessage('LFM ' .. LookingForGroup.SelectedInstanceDropDown.selected.value .. ' ' ..
												Functions:ternary(checkBoxes['dps'],'', 'dps') ..
												Functions:ternary(checkBoxes['heal'],'', ', heal') ..
												Functions:ternary(checkBoxes['tank'],'', ', tank'),'CHANNEL',tonumber(value))
	end
end

function LookingForGroup:SaveDataPressed()
	LFGChannels = Functions:splitString(LookingForGroup.ChannelsTbox:GetText(), ',')
	LFGInterval = LookingForGroup.IntervalTbox:GetText()
	local text = 'Looking for group in channels '
	for index,value in pairs(LFGChannels) do
		text = text .. value .. ', '
	end
	text = text .. ' at an interval of ' .. LFGInterval .. ' seconds'
	Console:Print(text)
end

function LookingForGroup:ToggleRunningPressed()
	if LookingForGroup.running then
		LookingForGroup.ToggleBtn:SetText('Run');
		Components.Timers:DisableTimer(timer);
	else
		LookingForGroup.ToggleBtn:SetText('Pause');
		Components.Timers:EnableTimer(timer);
	end
	LookingForGroup.running = not LookingForGroup.running;
end

LookingForGroup:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded
LookingForGroup:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_LOGOUT" then
		LookingForGroup:OnDisable()
	elseif event == "ADDON_LOADED" then
		LookingForGroup:OnLoad()
	end
end)

LookingForGroup:Initialize();