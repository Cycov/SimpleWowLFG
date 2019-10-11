if SimpleWowLFG == nil then
    SimpleWowLFG = CreateFrame("Frame", "SimpleWowLFGFrame");
end

local qUI = Quicko.UI

if SimpleWowLFG.BroadcastFrame == nil then
    

	SimpleWowLFG.BroadcastFrame = qUI:NewWindowBasic(
				'BroadcastFrame',
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

	function SimpleWowLFG.BroadcastFrame:OnInit()
		local parent = SimpleWowLFG.BroadcastFrame;
		local basename = parent:GetName();
	
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
	end

	function SimpleWowLFG.BroadcastFrame:OnLoad()

	end

	function SimpleWowLFG.BroadcastFrame:OnEvent(event)

	end
end
