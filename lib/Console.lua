if Quicko == nil then
    Quicko = {}
end

if Quicko.Console == nil then
    Quicko.Console = {}
end

function Quicko.Console:RegisterSlashCommands(name, commands, callback)
    for index,value in pairs(commands) do
		  _G["SLASH_" .. name .. index] = value;
    end
    SlashCmdList[name] = callback
end

function Quicko.Console:SendChatMessage(msg, type, chan)
	SendChatMessage(msg, type, nil, chan);
end

function Quicko.Console:Print(text)
	DEFAULT_CHAT_FRAME:AddMessage(text)
end
