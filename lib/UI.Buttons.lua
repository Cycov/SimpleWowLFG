if Quicko == nil then
    Quicko = {}
end

if Quicko.UI == nil then
    Quicko.UI = {}
end

if Quicko.UI.Buttons == nil then
    Quicko.UI.Buttons = {}
end

function Quicko.UI.Buttons:NewUpButton(parent,name,x,y,h,w,fanchor,func)
	local btn = CreateFrame("Button",name,parent)
	btn:SetHeight(h)
    btn:SetWidth(w)
    btn:SetNormalTexture('Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Up')
    btn:SetPushedTexture('Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Down')
    btn:SetDisabledTexture('Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Disabled')
    btn:SetHighlightTexture('Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Highlight','ADD')
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

function Quicko.UI.Buttons:NewDownButton(parent,name,x,y,h,w,fanchor,func)
	local btn = CreateFrame("Button",name,parent)
	btn:SetHeight(h)
    btn:SetWidth(w)
    btn:SetNormalTexture('Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up')
    btn:SetPushedTexture('Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Down')
    btn:SetDisabledTexture('Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Disabled')
    btn:SetHighlightTexture('Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Highlight','ADD')
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