if Quicko == nil then
    Quicko = {}
end

if Quicko.UI == nil then
    Quicko.UI = {}
end

--[[
Func: ShowMessage(message,title,btntext)
Description: Displays a native wow dialog box with some message.
Params:
	message - message to be displayed, can't be nil
	title - title text,
		values:
			-nil: will not show any title
			-true: will display "Error" as a title, in red color
			-string: if any text will be provided, it will be shown in the title space, use "|cFF<some color>" to color the title
	btntext - text to be displayed on the button, if no text is provided, it will display "OK"
]]--
function Quicko.UI:ShowMessage(name,message,title,btntext)
	if not title then
		title = ""
	end
	if not btntext then
		btntext = ""
	end
	er = false
	name = name.."_DIALOG"
	if type(title) == "boolean" then
		title = "|cFFFF0000Error|r"
		er = true
	end
	StaticPopupDialogs[name] = {
	  text = Quicko.Functions:ternary(title~="","|cFFFFFF00"..title.."|r\n\n"..message,message),
	  button1 = Quicko.Functions:ternary(btntext~="",btntext,"OK"),
	  OnAccept = function()

	  end,
	  showAlert = er,
	  timeout = 0,
	  whileDead = true,
	  hideOnEscape = true,
	  preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
	}
	StaticPopup_Show(name)

	return name
end

--[[
Func: HideMessage()
Description: Hides the shown wow dialog box.
Params:
]]--
function Quicko.UI:HideMessage(name)
	StaticPopup_Hide(name)
end

--[[
Func: NewEditBox(parent,name,x,y,w,anchor)
Description: Creates a new EditBox object, a more compact declaration
Params:
	parent - object's parent. Needs to be either UIParent or a frame (or any object derived from frame). Can't be nil
	name - The name of the object.Needs to be unique or else will cause conflicts. Recommended use: "<parentname>_<some name>". Can't be nil
	x - The x coordinate of the topleft corner relative to the anchor (if provided, "TOPLEFT" if not). Can't be nil
	y - The y coordinate of the topleft corner relative to the anchor (if provided, "TOPLEFT" if not). Can't be nil
	w - The width of the object, does not have height (defaults to 20). Can't be nil
	anchor - Anchor of the object
		values:
			-nil: will default to "TOPLEFT"
			-string
]]--
function Quicko.UI:NewEditBox(parent,name,x,y,w,numeric,maxLength,anchor)
	numeric = numeric or false
	ebox = CreateFrame("EditBox",name,parent,"InputBoxTemplate")
	ebox:SetAutoFocus(false)
	ebox:SetScript("OnEscapePressed",function() ebox:ClearFocus() end)
	ebox:SetHeight(20)
	ebox:SetWidth(w)
	ebox:SetNumeric(numeric)
	if maxLength then
		ebox:SetMaxLetters(maxLength)
	end
	if anchor then
		ebox:SetPoint(anchor,x,y)
	else
		ebox:SetPoint("TOPLEFT",x,y)
	end
	return ebox
end

--[[
Func: NewButton(parent,name,text,x,y,h,w,fanchor,func)
Description: Creates a new EditBox object, a more compact declaration
Params:
	parent - object's parent. Needs to be either UIParent or a frame (or any object derived from frame). Can't be nil
	name - The name of the object.Needs to be unique or else will cause conflicts. Recommended use: "<parentname>_<some name>". Can't be nil
	text - The text to be displayed on the button. Can't be nil
	x - The x coordinate of the topleft corner relative to the anchor (if provided, "TOPLEFT" if not). Can't be nil
	y - The y coordinate of the topleft corner relative to the anchor (if provided, "TOPLEFT" if not). Can't be nil
	h - The height of the object
	w - The width of the object
	fanchor - Anchor of the object
		values:
			-nil: will default to "TOPLEFT"
			-string: set anchor
			-function: function to trigger when button is clicked
	func - If fanchor was not a function, provide it here. Can be nil.
]]--
function Quicko.UI:NewButton(parent,name,text,x,y,h,w,fanchor,func)
	local btn = CreateFrame("Button",name,parent,"UIPanelButtonTemplate")
	btn:SetHeight(h)
	btn:SetWidth(w)
	if fanchor then
		if type(fanchor) == "string" then
			btn:SetPoint(fanchor,x,y)
			if func then
				btn:SetScript("OnClick",func)
			end
		else
			btn:SetPoint("TOPLEFT",x,y)
			btn:SetScript("OnClick",fanchor)
		end
	else
		btn:SetPoint("TOPLEFT",x,y)
		btn:SetScript("OnClick",fanchor)
	end

	btn:SetText(text)
	return btn
end

--[[
Func: NewButton(parent,name,text,x,y,h,w,fanchor,func)
Description: Creates a new EditBox object, a more compact declaration
Params:
	parent - object's parent. Needs to be either UIParent or a frame (or any object derived from frame). Can't be nil
	name - The name of the object.Needs to be unique or else will cause conflicts. Recommended use: "<parentname>_<some name>". Can't be nil
	text - The text to be displayed on the button. Can't be nil
	x - The x coordinate of the topleft corner relative to the anchor (if provided, "TOPLEFT" if not). Can't be nil
	y - The y coordinate of the topleft corner relative to the anchor (if provided, "TOPLEFT" if not). Can't be nil
	h - The height of the object
	w - The width of the object
	fanchor - Anchor of the object
		values:
			-nil: will default to "TOPLEFT"
			-string: set anchor
			-function: function to trigger when button is clicked
	func - If fanchor was not a function, provide it here. Can be nil.
]]--
function Quicko.UI:NewCheckBox(parent,name,text,tooltip,x,y,callback)
	local chk = CreateFrame("CheckButton", name, parent, "ChatConfigCheckButtonTemplate");
	chk:SetPoint("TOPLEFT", x, y);
	getglobal(chk:GetName() .. 'Text'):SetText(text);
	chk.tooltip = tooltip;
	chk:SetScript("OnClick",callback);
	return chk;
end

--[[
Func: SampleAddon:NewCheckBox(parent,name,text,tooltip,x,y,callback)
Description: Creates a new EditBox object, a more compact declaration
Params:
	parent - object's parent. Needs to be either UIParent or a frame (or any object derived from frame). Can't be nil
	name - The name of the object.Needs to be unique or else will cause conflicts. Recommended use: "<parentname>_<some name>". Can't be nil
	text - The text to be displayed on the button. Can't be nil
	tooltip - ca be nil
	x - The x coordinate of the topleft corner relative to the anchor (if provided, "TOPLEFT" if not). Can't be nil
	callback - If fanchor was not a function, provide it here. Can be nil.
]]--
function Quicko.UI:NewSlider(parent,name,x,y,w,max,min,fanchor,func)
	slider = CreateFrame("Slider",name,parent,"OptionsSliderTemplate")
	slider:SetMinMaxValues(min,max)
	slider:SetWidth(w)
	slider:SetHeight(20)
	slider:SetValueStep(1)
	slider:SetValue(20)
	if fanchor then
		if type(fanchor) == "string" then
			slider:SetPoint(fanchor,x,y)
			if func then
				slider:SetScript("OnValueChanged",func)
			end
		else
			slider:SetPoint("TOPLEFT",x,y)
			slider:SetScript("OnValueChanged",fanchor)
		end
	end
	getglobal(slider:GetName().."Text"):SetText("")
	getglobal(slider:GetName().."Low"):SetText(min);
	getglobal(slider:GetName().."High"):SetText(max);
end

function Quicko.UI:NewLabel(parent,name,text,x,y, size, anchor)
	if size == nil then
		size = 12
	end

	if anchor == nil then
		anchor = 'TOPLEFT'
	end

	if type(size) == 'string' then
		anchor = size
	end

	local label = parent:CreateFontString(name,"BACKGROUND","GameFontNormal");
	label:SetText(text)
	label:SetPoint(anchor,x,y)
	label:SetTextHeight(size)
	return label
end

function Quicko.UI:NewLinkLabel(parent,name,text,x,y,itemlink,anchor,hasicon,iconSize,iconTexture)
	if not anchor then
		anchor = "TOPLEFT"
	end
	local icon
	local LinkFakeButton = CreateFrame("Button",name.."Button",parent)
	LinkFakeButton:EnableMouse(true)
	LinkFakeButton:SetPoint(anchor,x,y)
	local LinkLabel = LinkFakeButton:CreateFontString(name.."Label","BACKGROUND","GameFontNormal");
	LinkLabel:SetPoint("TOPLEFT",0,0);
	LinkLabel:SetText(text)
	if not iconSize then
		iconSize = LinkLabel:GetHeight()
	end
	LinkFakeButton:SetHeight(iconSize)
	LinkFakeButton:SetScript("OnEnter",function()
		if (LinkLabel:GetText() ~= "" and LinkLabel:GetText() ~= nil) then
			GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
			GameTooltip:SetHyperlink(itemlink)
			--GameTooltip:AddLine("")
			GameTooltip:Show()
		end
	end)
	LinkFakeButton:SetScript("OnLeave",function()
		GameTooltip:Hide()
		GameTooltip:ClearLines()
	end)
	LinkFakeButton:SetScript("OnClick",function()
		if (LinkLabel:GetText() ~= "" and LinkLabel:GetText() ~= nil) then
			if IsShiftKeyDown() then
				ChatEdit_InsertLink(itemlink)
			else
				name, link = ItemRefTooltip:GetItem()
				if not name then
					name = ""
				end
				if not link then
					link = ""
				end
				ItemRefTooltip:SetOwner(parent, "ANCHOR_PRESERVE",x,y)
				if (ItemRefTooltip:IsVisible() == 1 and link == itemlink) then
					ItemRefTooltip:Hide()
				else
					ItemRefTooltip:SetHyperlink(itemlink)
					ItemRefTooltip:Show()
				end
				--ItemRefTooltip:Show()
				--ItemRefTooltip:AddLine("") --here you can add some extra text
			end
		end
	end)

	if hasicon then
		icon = CreateFrame("Frame",name.."Icon",LinkFakeButton);
		icon:SetFrameStrata(parent:GetFrameStrata())
		icon:SetBackdrop({
		 bgFile=itemTexture,
		 tile=false,
		 insets = {
			left=0,
			right=0,
			top=0,
			bottom=0
		  }
		})
		icon:SetPoint("TOPLEFT",0,0)
		LinkLabel:SetPoint("TOPLEFT",iconSize+3,-(math.floor(iconSize/2)-math.floor(LinkLabel:GetHeight()/2)));
		LinkFakeButton:SetWidth(LinkLabel:GetWidth()+iconSize)
		icon:SetWidth(iconSize)
		icon:SetHeight(iconSize)
	else
		LinkFakeButton:SetWidth(LinkLabel:GetWidth())
	end

	LinkFakeButton.SetLink = function(itemLink)
		itemlink = itemLink
	end

	LinkFakeButton.SetIcon = function(texture)

	end

	LinkFakeButton.SetText = function(text)

	end

	return LinkFakeButton
end

function Quicko.UI:NewDropDown(parent,name,items,x,y,width,callback,checkmarks,text)
	local dd = CreateFrame("Button", name, parent, "UIDropDownMenuTemplate")

	if checkmarks == nil then
		checkmarks = false
	end

	dd.checkmarks = checkmarks
	dd.count = 0
	dd.items = {}
	dd:ClearAllPoints()
	dd:SetPoint("TOPLEFT", x, y)
	UIDropDownMenu_SetWidth(dd, width, 0)

	dd.ButtonClickedCheckmarks = function(self, arg1, arg2, checked)
		if ( UIDropDownMenuButton_GetChecked(self) ) then
			table.insert(dd.selectedItems, self)
			dd.items[arg1].checked = true
		else
			table.remove(dd.selectedItems, Quicko.Functions:FindIndex(dd.selectedItems, self))
			dd.items[arg1].checked = false
		end
		if callback then
			callback(dd, self, UIDropDownMenuButton_GetChecked(self), arg1)
		end
	end

	dd.ButtonClicked = function(self, arg1, arg2, checked)
		UIDropDownMenu_SetSelectedID(dd, arg1)
		if self.arg2 == name then			
			dd.selectedItem = self
			dd.selectedItem.index = arg1
			Quicko.Functions:SetProprety(dd.items, 'checked', false, self)
			if callback then
				callback(dd, self, UIDropDownMenuButton_GetChecked(self), arg1) -- function(item, checked, index), self - dropdown
			end
		end
	end

	dd.AddItem = function(self, item, index)
		if index == nil then
			index = dd.count
		end
		local info = {}
		if (type(item) == 'table') then
		  info.text = item.text
		  info.value = item
		else
		  info.text = item
		  info.value = item
		end

		info.arg1 = index
		info.arg2 = name

		if checkmarks == true then
		    dd.selectedItems = {}
			if type(item) == 'table' and item.checked == true then
				info.checked = true
			else
				info.checked = false
			end
			info.keepShownOnClick = 1;
			info.classicChecks = true;
			info.func = dd.ButtonClickedCheckmarks
		else
			dd.selectedItem = dd.selectedItem or {
				index = 0,
				text = item.text,
				value = item
			}
			info.checked = false
			info.func = dd.ButtonClicked
		end
		table.insert(dd.items, info)
		dd.count = dd.count + 1
	end


	for k,v in pairs(items) do
		dd:AddItem(v, k)
	end

	UIDropDownMenu_Initialize(dd,
		function(self,level)
			for k,v in pairs(dd.items) do
				UIDropDownMenu_AddButton(v, level)
			end
	   end)


	function dd:SetSelected(index, selected)
		if checkmarks == false then
			UIDropDownMenu_SetSelectedID(dd, index);
		else
			dd.items.checked = selected
		end
	end

	if checkmarks then
		if text then
			UIDropDownMenu_SetText(dd,text)
		else
			UIDropDownMenu_SetText(dd,'Mixed')
		end
	else
		UIDropDownMenu_SetSelectedID(dd, 1)
	end

	return dd
end

function Quicko.UI:NewImage(name, parent, x, y, height, width, texture, anchor, texCoordinates)
	if anchor == nil then
		anchor = 'TOPLEFT'
	end

	local img = CreateFrame('Frame', name, parent)
	img:SetPoint(anchor,x,y)
	img:SetHeight(height)
	img:SetWidth(width)
	local tex = img:CreateTexture(name .. 'Texture', "BACKGROUND")
	tex:SetTexture(texture)
	tex:SetAllPoints(img)
	if texCoordinates then
		tex:SetTexCoord(texCoordinates.left, texCoordinates.right, texCoordinates.top, texCoordinates.bottom)
	end
	img.texture = tex

	return img
end


function Quicko.UI:NewAccordion(name, parent, text, x, y, height, width, anchor)
	if anchor == nil then
		anchor = 'TOPLEFT'
	end

	local accord = CreateFrame('Frame', name, parent)
	accord.closedHeight = 16
	accord.openedHeight = height
	accord.padding = 15
	accord.closed = true
	accord.callbacks = {}
	accord.anchor = anchor

	accord:SetWidth(width)
	accord:SetHeight(accord.closedHeight)
	accord:SetPoint(anchor, x, y)

	local topBorder = CreateFrame('Frame', name .. 'BorderTop', accord)
	topBorder:SetWidth(width - accord.padding * 2)
	topBorder:SetHeight(accord.closedHeight * 3)
	topBorder:SetPoint('TOP', 0, topBorder:GetHeight() / 2)
	topBorder:SetFrameLevel(3)

	local tex = topBorder:CreateTexture(name .. 'TopBorderMiddleTexture', "BACKGROUND")
	tex:SetTexture('Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame')
	tex:SetAllPoints(topBorder)
	tex:SetTexCoord(0.1953125, 0.8046875, 0 ,1)

	local dropButtonOpen = Quicko.UI.Buttons:NewDownButton(topBorder, name .. 'BorderTopButton',10,1,35,35,'RIGHT')
	local dropButtonClose = Quicko.UI.Buttons:NewUpButton(topBorder, name .. 'BorderTopButton',10,1,35,35,'RIGHT')
	dropButtonClose:Hide()
	Quicko.UI:NewImage(name .. 'BorderTopLeft', topBorder, -20,0,topBorder:GetHeight(), 25, 'Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame', 'LEFT',{
		left = 0,
		right = 0.1953125,
		top = 0,
		bottom = 1
	})

	Quicko.UI:NewLabel(topBorder,name .. 'BorderTopTitle',text,10,0,12,'LEFT')

	-- the actual content frame
	accord.contentFrame = CreateFrame('Frame', name .. 'ContentFrame', accord, 'InsetFrameTemplate3')
	accord.contentFrame:SetHeight(height)
	accord.contentFrame:SetWidth(width - 28)
	accord.contentFrame:SetPoint('TOP', 0, 0)
	accord.contentFrame:SetFrameStrata('DIALOG')
	accord.contentFrame:SetFrameLevel(2)
	accord.contentFrame:Hide()

	accord.Toggle = function()
		if accord.closed then
			accord:Open()
		else
			accord:Close()
		end
	end

	accord.Open = function()
		accord.contentFrame:Show()
		accord:SetHeight(accord.openedHeight)
		dropButtonClose:Show()
		dropButtonOpen:Hide()
		accord.closed = false
		accord.OnToggle(false)
	end

	accord.Close = function()
		accord.contentFrame:Hide()
		accord:SetHeight(accord.closedHeight)
		dropButtonClose:Hide()
		dropButtonOpen:Show()
		accord.closed = true
		accord.OnToggle(true)
	end

	accord.OnToggle = function(closed)
		Quicko.Events:TriggerEvent(accord,'Toggle', closed)
	end

	dropButtonOpen:SetScript('OnClick', accord.Open)
	dropButtonClose:SetScript('OnClick', accord.Close)

	return accord
end
--[[
Func: SampleAddon:NewCheckBox(parent,name,text,tooltip,x,y,callback)
Description: Creates a new EditBox object, a more compact declaration
Params:
	parent - object's parent. Needs to be either UIParent or a frame (or any object derived from frame). Can't be nil
	name - The name of the object.Needs to be unique or else will cause conflicts. Recommended use: "<parentname>_<some name>". Can't be nil
	items - {value1, value2} Items to populate
	x - The x coordinate of the topleft corner relative to the anchor (if provided, "TOPLEFT" if not). Can't be nil
	y - The y coordinate of the topleft corner relative to the anchor (if provided, "TOPLEFT" if not). Can't be nil
	callback - function(index, value, [sender])
]]--

function Quicko.UI:NewAccordionCollection(name, parent, x, y, width, anchor, elements)
	if anchor == nil then
		anchor = 'TOPLEFT'
	end

	local accCol = CreateFrame('Frame', name, parent)
	accCol.items = {}
	accCol.count = 0
	local spacing = 10

	accCol:SetPoint(anchor, x, y)
	accCol:SetWidth(width)

	accCol.ChildToggled = function(self, closed)
		if closed then
			accCol:SetHeight(accCol:GetHeight() - self.openedHeight + self.closedHeight)
			for i=self.index + 1,accCol.count do
				local item = accCol.items[i]
				local _, _, relativePoint, xOfs, yOfs = item:GetPoint()
				item:SetPoint(relativePoint, xOfs, yOfs + self.openedHeight - spacing)
			end
		else
			accCol:SetHeight(accCol:GetHeight() + self.openedHeight - self.closedHeight)
			for i=self.index + 1,accCol.count do
				local item = accCol.items[i]
				local _, _, relativePoint, xOfs, yOfs = item:GetPoint()
				item:SetPoint(relativePoint, xOfs, yOfs - self:GetHeight() + spacing)
			end
		end
	end

	for index,value in pairs(elements) do
		if value.name == nil then
			value.name = name .. 'Child' .. accCol.count
		end
		-- TODO: instead of constant -16 do smth else
		local accord = Quicko.UI:NewAccordion(value.name, accCol, value.text, 0, (-16 - spacing) * (index - 1), value.height , width, 'TOP')
		Quicko.Events:RegisterEventCallback(accord, 'Toggle', accCol.ChildToggled)
		accord.index = index
		accCol:SetHeight(accCol:GetHeight() + accord.closedHeight + spacing)
		accCol.count = accCol.count + 1
		table.insert(accCol.items, accord)
	end

	accCol.AddItem = function(item)
		accCol.count = accCol.count + 1
		if item.name == nil then
			item.name = name .. 'Child' .. accCol.count
		end

		local accord = UI:NewAccordion(item.name, accCol, item.text, 0, -1 * accCol:GetHeight(), width, 'TOP')
		accord:RegisterToggle(accCol.ChildToggled)
		accCol:SetHeight(accCol:GetHeight() + accord.closedHeight + spacing)
		table.insert(accord.items, item)

		return accord
	end

	accCol.RemoveItem = function(itemName)
		local found
		for k,v in pairs(accord.items) do
			if v.name == itemName then
				found = k
			end
		end

		accCol:SetHeight(accCol:GetHeight() - accord.items[found]:GetHeight() - spacing)
		return table.remove( accord.items, found )
	end

	return accCol
end


function Quicko.UI:NewWindowBasic(name, title, height, width, frameStrata, displayHelp, helpAction)
    frameStrata = frameStrata or 'MEDIUM'
    displayHelp = displayHelp or false

    --MainFrame init
    local window = CreateFrame("Frame",nil,UIParent);
    window:SetFrameStrata(frameStrata)
    window:SetWidth(width)
    window:SetHeight(height)

    window:SetBackdrop({
    bgFile="Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
    tile=true,
    tileSize=32,
    edgeSize= 16,
    insets = {
        left=3,
        right=3,
        top=3,
        bottom=3
    }
    })



    window:SetMovable(true)
    window:EnableMouse(true)
    window:RegisterForDrag("LeftButton")
    window:SetScript("OnDragStart", window.StartMoving)
    window:SetScript("OnDragStop",window.StopMovingOrSizing)
    window:SetPoint("CENTER",0,0)
    window:RegisterEvent("PLAYER_LOGOUT")


    --close button
    window.CloseButton = CreateFrame("Button",name.."_CloseBtn",window,"UIPanelCloseButton")
    window.CloseButton:SetPoint("TOPRIGHT",-1,-2)
    window.CloseButton:SetScript("OnClick",function() window:Hide() end)
    window.CloseButton:Show();

    --Title
    window.Title = CreateFrame("Frame", name .. "_Title",window);
    window.Title:SetFrameStrata(frameStrata)
    window.Title:SetPoint("TOP",0,13)
    window.Title:SetBackdrop({
    bgFile="Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
    tile=true,
    tileSize=32,
    edgeSize= 16,
    insets = {
        left=3,
        right=3,
        top=3,
        bottom=3
    }
    })

    window.TitleLabel = window.Title:CreateFontString(name.."_TitleLabel","BACKGROUND","GameFontNormal");
    window.TitleLabel:SetText(title)
    window.TitleLabel:SetPoint("CENTER",0,0)
    window.TitleLabel:SetTextHeight(12)

    window.Title:SetWidth(window.TitleLabel:GetWidth()+15)
    window.Title:SetHeight(window.TitleLabel:GetHeight()+15)

    if displayHelp then
        window.HelpButton = CreateFrame("Button",name.."_AboutBtn",window)
        window.HelpButton:SetPoint("TOPRIGHT",-28,-10)
        window.HelpButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight");
        window.HelpButton:SetNormalTexture("Interface\\GossipFrame\\ActiveQuestIcon");
        window.HelpButton:SetHeight(16);
        window.HelpButton:SetWidth(16)
        window.HelpButton:Show();
        if helpAction then
            if type(helpAction) == 'string' then
                window.HelpButton:SetScript("OnClick",function()
                    Quicko.UI:ShowMessage(name,helpAction,"About")
                end);
            else
                window.HelpButton:SetScript("OnClick",helpClickedCallback)
            end
        end
	end
	window:Hide()
	table.insert(UISpecialFrames,window:GetName())
	return window
end

function Quicko.UI:NewWindowDefault(name, title, height, width, scrollable)
	local window = CreateFrame("Frame", name, UIParent, "UIPanelDialogTemplate");

	height = height or 425
	width = width or 335

    window:SetWidth(width)
    window:SetHeight(height)


    window:SetMovable(true)
    window:EnableMouse(true)
    window:RegisterForDrag("LeftButton")
    window:SetScript("OnDragStart", window.StartMoving)
    window:SetScript("OnDragStop",window.StopMovingOrSizing)
	window:SetPoint("CENTER",0,0)
	window:SetFrameStrata('DIALOG')

    window.TitleLabel = window:CreateFontString(name.."_TitleLabel","BACKGROUND","GameFontNormal");
    window.TitleLabel:SetText(title)
    window.TitleLabel:SetPoint("TOP",0,-10)
	window.TitleLabel:SetTextHeight(12)

	if scrollable then
		scrollframe = CreateFrame("ScrollFrame", nil, window)
		scrollframe:SetPoint("TOPLEFT", 12, -32)
		scrollframe:SetPoint("BOTTOMRIGHT", 0, 12)
		window.scrollframe = scrollframe

		-- local texture = content:CreateTexture()
		-- texture:SetAllPoints()
		-- texture:SetTexture("Interface\\GLUES\\MainMenu\\Glues-BlizzardLogo")

		--scrollbar
		scrollbar = CreateFrame("Slider", nil, scrollframe, "UIPanelScrollBarTemplate")
		scrollbar:SetPoint("TOPLEFT", scrollframe, "TOPRIGHT", -25, -15)
		scrollbar:SetPoint("BOTTOMLEFT", scrollframe, "BOTTOMRIGHT", -25, 15)
		scrollbar:SetMinMaxValues(1, 200)
		scrollbar:SetValueStep(1)
		scrollbar.scrollStep = 1
		scrollbar:SetValue(0)
		scrollbar:SetWidth(16)
		scrollbar:SetScript("OnValueChanged",
			function (self, value)
				self:GetParent():SetVerticalScroll(value)
			end)
		window.scrollbar = scrollbar

		--content frame
		local content = CreateFrame("Frame", nil, scrollframe)
		content:SetSize(scrollframe:GetHeight(), scrollframe:GetWidth())

		window.contentFrame = content
		scrollframe:SetScrollChild(content)
	end
	return window
end