if Quicko == nil then
    Quicko = {}
end


if Quicko.Components == nil then
	Quicko.Components = CreateFrame('Frame')
end

Quicko.Components.Timers = {}
Quicko.Components.Timers.activeTimers = {}

function Quicko.Components.Timers:ScheduleTimer(name, interval, repeating, enabled, callback)
	local timer = Quicko.Components.Timers:GetTimer(name)
	if enabled == nil then
		enabled = true
	end
	if type(interval) ~= 'number' then
		error('Expected number got ' .. type(interval) .. ' for parameter "interval"')
	end

	if timer then
		print('Timer ' .. name .. ' already exists')
	else
		timer = {}
		timer.name = name;
		timer.total = 0;
		timer.interval = interval;
		timer.repeating = repeating;
		timer.callback = callback;
		timer.enabled = enabled;
		table.insert(Quicko.Components.Timers.activeTimers, timer);
	end

	timer.Enable = function(self)
		Quicko.Components.Timers:EnableTimer(self)
	end

	timer.Disable = function(self)
		Quicko.Components.Timers:DisableTimer(self)
	end

	timer.SetInterval = function(self, interval)
		Quicko.Components.Timers:ChangeInterval(self, interval)
	end

	return timer
end

function Quicko.Components.Timers:GetTimer(name)
	if name == nil then
		error('Expected timer, got nil')
	end

	for index,value in pairs(Quicko.Components.Timers.activeTimers) do
		if (value.name == name) then
			return value
		end
	end
	return nil
end

function Quicko.Components.Timers:RemoveTimer(name)
	if name == nil then
		error('Expected timer, got nil')
	end

	local found = nil
	for index,value in pairs(Components.Timers.activeTimers) do
		if (value.name == value.name) then
			found = index;
		end
	end
	if found then
		table.remove(Components.Timers.activeTimers, found)
	else
		print('Timer ' .. name .. ' does not exist');
	end
end

function Quicko.Components.Timers:DisableTimer(timer)
	if timer == nil then
		error('Expected timer, got nil')
	end
	if type(timer) ~= 'table' then
		error('Expected timer object, got ' .. type(timer))
	end

	for index,value in pairs(Quicko.Components.Timers.activeTimers) do
		if (value.name == timer.name) then
			value.enabled = false
			value.total = 0
			Quicko.Components.Timers.activeTimers[index] = value
		end
	end
end

function Quicko.Components.Timers:EnableTimer(timer, trigger)
	if timer == nil then
		error('Expected timer, got nil')
	end
	if type(timer) ~= 'table' then
		error('Expected timer object, got ' .. type(timer))
	end

	for index,value in pairs(Quicko.Components.Timers.activeTimers) do
		if (value.name == timer.name) then
			value.enabled = true
			value.total = 0
			if trigger then
				value.callback(value)
			end
			Quicko.Components.Timers.activeTimers[index] = value
		end
	end
end

function Quicko.Components.Timers:ChangeInterval(timer, interval)
	if timer == nil then
		error('Expected timer, got nil')
	end
	if type(interval) ~= 'number' then
		error('Expected number got ' .. type(interval) .. ' for parameter "interval"')
	end

	for index,value in pairs(Quicko.Components.Timers.activeTimers) do
		if (value.name == timer.name) then
			value.total = 0
			value.interval = interval
			Quicko.Components.Timers.activeTimers[index] = value
		end
	end
end

function Quicko.Components.Timers:ExecuteTimerFunctions(elapsed)
	for index,value in pairs(Quicko.Components.Timers.activeTimers) do
		value.index = index
		value.total = value.total + elapsed;
		if (value.enabled == true and value.total >= value.interval) then
			value.callback(value)
			value.total = 0;
		end
		Quicko.Components.Timers.activeTimers[index] = value
	end
end

function Quicko.Components.onUpdate(self,elapsed)
	Quicko.Components.Timers:ExecuteTimerFunctions(elapsed);
end
Quicko.Components:SetScript("OnUpdate", Quicko.Components.onUpdate)