if Quicko == nil then
    Quicko = {}
end

if Quicko.Events == nil then
    Quicko.Events = {}
end
if Quicko.Events.Bus == nil then
    Quicko.Events.Bus = {}
end

function Quicko.Events:RegisterEventCallback(object, event, callback)
	if type(object) ~= 'table' then
		error('Expected object, got ' .. type(object))
	end

    if object.callbacks == nil then
        object.callbacks = {}
    end

    if object.callbacks[event] == nil then
        object.callbacks[event] = {}
    end

    table.insert(object.callbacks[event], callback)
end

function Quicko.Events:TriggerEvent(object, event, ...)
    local arg = {...}
    if object.callbacks ~= nil and object.callbacks[event] ~= nil then
        for k,v in pairs(object.callbacks[event]) do
            v(object, unpack(arg))
        end        
    end    
end

function Quicko.Events.Bus:SubscribeEvent(event, callback)
    Quicko.Events:RegisterEventCallback(self, event, callback)
end

function Quicko.Events.Bus:PublishEvent(event, ...)
    Quicko.Events:TriggerEvent(self, event, ...)
end