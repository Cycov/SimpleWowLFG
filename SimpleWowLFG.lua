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

function SimpleWowLFG:InitUI()
	local paddingTop = 15
	local basename = 'BroadcastFrame';

	SimpleWowLFG.BroadcastFrame = qUI:NewWindowBasic(
				basename,
				SimpleWowLFG.Constants.MainFrame.Title,
				SimpleWowLFG.Constants.MainFrame.Height + paddingTop,
				SimpleWowLFG.Constants.MainFrame.Width,
				SimpleWowLFG.Constants.MainFrame.FrameStrata,
				SimpleWowLFG.Constants.MainFrame.Help,
				"|cFFFF0000"..SimpleWowLFG.Constants.DisplayName.." |cFF40FF40Version "..SimpleWowLFG.Constants.Version:GetVersion()..
					"|r\nMade by "..SimpleWowLFG.Constants.Author.Name..
					Quicko.Functions:ternary(SimpleWowLFG.Constants.Author.AltName ~= ""," aka "..SimpleWowLFG.Constants.Author.AltName,"")..
					Quicko.Functions:ternary(SimpleWowLFG.Constants.Author.Email ~= "","\nFor any information mail me at "..SimpleWowLFG.Constants.Author.Email,"")
			);
	table.insert(UISpecialFrames,basename);
	SimpleWowLFG.BroadcastFrame:Hide()
	local parent = SimpleWowLFG.BroadcastFrame;

	local instances = {}

	for _,dungeon in pairs(SimpleWowLFG:GetDungeonsSorted()) do
		dungeon.text = dungeon:GetColor(dungeon) .. dungeon.Name .. ' ' .. dungeon.MinLevel .. '-' .. dungeon.MaxLevel
		dungeon.checked = true
		table.insert(instances, dungeon)
	end
	SimpleWowLFG.Controls = {}
    SimpleWowLFG.SelectedInstanceDropDown = qUI:NewDropDown(parent,basename .. "_SELECTEDINSTANCE",instances,-2,-17 - paddingTop,183, SimpleWowLFG.SelectedInstanceDropDownClicked)
    SimpleWowLFG.Controls.ToggleDpsCheckBox = qUI:NewCheckBox(parent,basename .. "_TOGGLEDPS",'dps',nil,165,-45 - paddingTop,function(obj) SimpleWowLFG:CheckedChanged('dps', obj) end)
    SimpleWowLFG.Controls.ToggleHealCheckBox = qUI:NewCheckBox(parent,basename .. "_TOGGLEHEAL",'heal',nil,165,-65 - paddingTop,function(obj) SimpleWowLFG:CheckedChanged('heal', obj) end)
    SimpleWowLFG.Controls.ToggleTankCheckBox = qUI:NewCheckBox(parent,basename .. "_TOGGLETANK",'tank',nil,165,-85 - paddingTop,function(obj) SimpleWowLFG:CheckedChanged('tank', obj) end)
	qUI:NewLabel(parent, basename .. "_STATICLABEL1",'Channels',17,-53 - paddingTop)
	SimpleWowLFG.Controls.ChannelsSelectEditBox = qUI:NewEditBox(parent,basename .. "_CHANNELSTBOX",78,-50 - paddingTop,83, false, 10)
	qUI:NewLabel(parent, basename .. "_STATICLABEL2",'Interval',17,-78 - paddingTop)
	SimpleWowLFG.Controls.IntervalEditBox = qUI:NewEditBox(parent,basename .. "_INTERVALTBOX",78,-75 - paddingTop,30, true, 3)
    SimpleWowLFG.Controls.SaveButton = qUI:NewButton(parent,basename .. "_INTERVALSAVEBTN",'Save',115,-75 - paddingTop,20,50, SimpleWowLFG.SaveDataPressed)
	SimpleWowLFG.Controls.ToggleButton = qUI:NewButton(parent,basename .. "_TOGGLERUNNING",'Run',15,-110 - paddingTop,20,200,SimpleWowLFG.ToggleRunningPressed)


	basename = SimpleWowLFG.Constants.MainFrame.Name
	SimpleWowLFG.MainFrame = qUI:NewWindowDefault(basename,'Existing groups', nil, nil, true)
	-- SimpleWowLFG.MainFrame.TrackedDungeonsFilter = qUI:NewDropDown(SimpleWowLFG.MainFrame, basename .. 'TrackedDungeonsFilter', instances, 0, -25, SimpleWowLFG.MainFrame:GetWidth() - 50, 
	-- function(dropdown, item, checked, index)
	-- 	print('-------------')
	-- 	for k,v in pairs(dropdown.selectedItems) do
	-- 		print(k .. '-' .. v.value.text)
	-- 	end
	-- end, true, 'Tracked dungeons')
	-- SimpleWowLFG.MainFrame:Hide()
	local accord = qUI:NewAccordionCollection(basename .. 'AccordionCollection1', scrollframe, -45, -15, SimpleWowLFG.MainFrame.scrollframe:GetWidth(), 'TOP', {
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
	SimpleWowLFG.MainFrame.scrollframe:SetScrollChild(accord)
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