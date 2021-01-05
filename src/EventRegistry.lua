local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local IS_SERVER = RunService:IsServer()
local IS_CLIENT = RunService:IsClient()

local EventRegistry = {
	_events = {};
	_functions = {};
	_folder = ReplicatedStorage:FindFirstChild("_NETWORK")
}

function EventRegistry.Init()
	local missingFolder = EventRegistry._folder == nil
	if missingFolder then
		if IS_SERVER then
			local folder = Instance.new("Folder")
			folder.Name = "_NETWORK"
			folder.Parent = ReplicatedStorage
			EventRegistry._folder = folder
		elseif IS_CLIENT then
			local folder = ReplicatedStorage:WaitForChild("_NETWORK")
			EventRegistry._folder = folder
		end
	end

	for _, object in ipairs(EventRegistry._folder:GetChildren()) do
		if object:IsA("RemoteEvent") then
			EventRegistry.registerEvent(object.Name, object)
		elseif object:IsA("RemoteFunction") then
			EventRegistry.registerFunction(object.Name, object)
		end
	end

	EventRegistry._folder.ChildAdded:Connect(function(object)
		if object:IsA("RemoteEvent") then
			EventRegistry.registerEvent(object.Name, object)
		elseif object:IsA("RemoteFunction") then
			EventRegistry.registerFunction(object.Name, object)
		end
	end)
end

function EventRegistry.registerEvent(name, instance)
	local eventIsntRegistered = not EventRegistry._events[name]
	assert(eventIsntRegistered, string.format("[Network] - RemoteEvent %s has already been registered", name))

	if instance then
		EventRegistry._events[name] = instance
	else
		assert(IS_SERVER, "[Network] - registerEvent must be called on the server")

		local instance = Instance.new("RemoteEvent")
		instance.Name = name
		instance.Parent = EventRegistry._folder
		EventRegistry._events[name] = instance
	end

	if IS_CLIENT then
		EventRegistry._events[name].Name = HttpService:GenerateGUID(false)
	end
end

function EventRegistry.registerFunction(name, instance)
	local functionIsntRegistered = not EventRegistry._functions[name]
	assert(functionIsntRegistered, string.format("[Network] - RemoteFunction %s has already been registered", name))

	if instance then
		EventRegistry._functions[name] = instance
	else
		assert(IS_SERVER, "[Network] - registerFunction must be called on the server")

		local instance = Instance.new("RemoteFunction")
		instance.Name = name
		instance.Parent = EventRegistry._folder
		EventRegistry._functions[name] = instance
	end

	if IS_CLIENT then
		EventRegistry._functions[name].Name = HttpService:GenerateGUID(false)
	end
end

function EventRegistry.hookEvent(name, handler)
	local event = EventRegistry._events[name]
	assert(handler, "[Network] - Must pass a handler function while calling hookEvent")
	assert(typeof(handler) == "function", "[Network] - Handler must be a valid function while calling hookEvent")

	if event then
		local connectionType = IS_SERVER and "OnServerEvent" or IS_CLIENT and "OnClientEvent"
		local connection = event[connectionType]:Connect(handler)

		return function()
			connection:Disconnect()
			connection = nil
		end
	else
		if IS_SERVER then
			EventRegistry.registerEvent(name)
			return EventRegistry.hookEvent(name, handler)
		elseif IS_CLIENT then
			error(string.format("[Network] - Could not find RemoteEvent %s while calling hookEvent", name))
		end
	end
end

function EventRegistry.hookFunction(name, handler)
	local func = EventRegistry._functions[name]
	assert(IS_SERVER, "[Network] - hookFunction can only be used on the server")
	assert(handler, "[Network] - Must pass a handler function while calling hookEvent")
	assert(typeof(handler) == "function", "[Network] - Handler must be a valid function while calling hookEvent")

	if func then
		func.OnServerInvoke = handler
	else
		EventRegistry.registerFunction(name)
		EventRegistry.hookFunction(name, handler)
	end
end

function EventRegistry.fireEvent(name, ...)
	local event = EventRegistry._events[name]

	if event then
		if IS_SERVER then
			event:FireClient(...)
		elseif IS_CLIENT then
			event:FireServer(...)
		end
	else
		if IS_SERVER then
			EventRegistry.registerEvent(name)
			EventRegistry.fireEvent(name, ...)
		elseif IS_CLIENT then
			error(string.format("[Network] - Could not find RemoteEvent %s while calling fireEvent", name))
		end
	end
end

function EventRegistry.fireAllClients(name, ...)
	assert(IS_SERVER, "[Network] - fireAllClients must be called on the server")
	local event = EventRegistry._events[name]

	if event then
		event:FireAllClients(...)
	else
		EventRegistry.registerEvent(name)
		EventRegistry.fireAllClients(name, ...)
	end
end

function EventRegistry.fireAllClientsExcept(name, clientExcept, ...)
	assert(IS_SERVER, "[Network] - fireAllClients must be called on the server")
	local event = EventRegistry._events[name]

	if event then
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= clientExcept then
				EventRegistry.fireEvent(name, player, ...)
			end
		end
	else
		EventRegistry.registerEvent(name)
		EventRegistry.fireAllClientsExcept(name, clientExcept, ...)
	end
end

function EventRegistry.invokeFunction(name, ...)
	assert(IS_CLIENT, "[Network] - invokeFunction must be called on the client")
	local func = EventRegistry._functions[name]

	if func then
		func:InvokeServer(...)
	else
		error(string.format("[Network] - Could not find RemoteFunction %s while calling invokeFunction", name))
	end
end

return EventRegistry