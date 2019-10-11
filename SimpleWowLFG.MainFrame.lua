if SimpleWowLFG == nil then
    SimpleWowLFG = CreateFrame("Frame", "SimpleWowLFGFrame");
end

local qUI = Quicko.UI

if SimpleWowLFG.MainFrame == nil then
	SimpleWowLFG.MainFrame = qUI:NewWindowDefault(basename,'Existing groups', nil, nil, true)

    function SimpleWowLFG.BroadcastFrame:OnInit()
		local parent = SimpleWowLFG.MainFrame;
        local basename = parent:GetName();
        
        
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

        
        -- SimpleWowLFG.MainFrame.TrackedDungeonsFilter = qUI:NewDropDown(SimpleWowLFG.MainFrame, basename .. 'TrackedDungeonsFilter', instances, 0, -25, SimpleWowLFG.MainFrame:GetWidth() - 50, 
        -- function(dropdown, item, checked, index)
        -- 	print('-------------')
        -- 	for k,v in pairs(dropdown.selectedItems) do
        -- 		print(k .. '-' .. v.value.text)
        -- 	end
        -- end, true, 'Tracked dungeons')
	end

	function SimpleWowLFG.BroadcastFrame:OnLoad()

	end

	function SimpleWowLFG.BroadcastFrame:OnEvent(event)

	end
end
