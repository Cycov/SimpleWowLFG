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
	  text = Functions:ternary(title~="","|cFFFFFF00"..title.."|r\n\n"..message,message),
	  button1 = Functions:ternary(btntext~="",btntext,"OK"),
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

	dd:ClearAllPoints()
	dd:SetPoint("TOPLEFT", x, y)
	UIDropDownMenu_SetWidth(dd, width, 0)

	dd.count = 0
	dd.items = {}
	UIDropDownMenu_Initialize(dd,
		function(self,level)
			local info = UIDropDownMenu_CreateInfo()
	
			for k,v in pairs(items) do
			  if dd.selected == nil then
				dd.selected = v
			  end

			  info = UIDropDownMenu_CreateInfo()
			  info.text = v
			  info.value = v
			  info.arg1 = k
			  info.arg2 = false
			  info.checked = false
			  info.func = function(self, arg1, arg2, checked)
					if not checkmarks then
						UIDropDownMenu_SetSelectedID(dd, arg1)
					else
						if self.arg2 then
							self.arg2 = false
						else
							self.arg2 = true
						end				
					end
					dd.selected = {
						index = arg1,
						value = self.value
					}
					dd.items[arg1] = self
					if callback then
						callback(arg1, self.value, dd)
					end
				end
			  info.isNotRadio = checkmarks
			  table.insert(dd.items, info)
			  UIDropDownMenu_AddButton(info, level)
			  dd.count = dd.count + 1
			end
	   end)

	
	if checkmarks then
		UIDropDownMenu_SetText(dd,text)
	else
		UIDropDownMenu_SetSelectedID(dd, 1)
	end

	function dd:SetSelected(index)
		UIDropDownMenu_SetSelectedID(dd, index);
	end

	function dd:AddItem(text, value)
		local info = UIDropDownMenu_CreateInfo()
		info.text = text
		info.value = value
		info.func = function() UIDropDownMenu_SetSelectedID(dd, dd.count); callback(dd.count, v, dd) end
		UIDropDownMenu_AddButton(info, nil)
		dd.count = dd.count + 1
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
                    UI:ShowMessage(name,helpAction,"About")
                end);
            else
                window.HelpButton:SetScript("OnClick",helpClickedCallback)
            end
        end
	end

	return window
end

function Quicko.UI:NewWindowDefault(name, title, height, width)
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
	return window
end