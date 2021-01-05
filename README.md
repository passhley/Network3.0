# Network 3.0
Easily allows you to create and manage RemoteEvents and RemoteFunctions

## Api
```lua
	-- Add's a new RemoteEvent to the network's registry
	-- [SERVER-ONLY]
	Network.registerEvent(eventName)
	Network.RegisterEvent(eventName)

	-- Add's a new RemoteFunction to the network's registry
	-- [SERVER-ONLY]
	Network.registerFunction(functionName)
	Network.RegisterFunction(functionName)

	-- Connects to the given RemoteEvent, returns a function to later disconnect with
	Network.hookEvent(eventName, eventHandler)
	Network.HookEvent(eventName, eventHandler)

	-- Connects to the given RemoteFunction
	-- [SERVER-ONLY]
	Network.hookFunction(functionName, functionHandler)
	Network.HookFunction(functionName, functionHandler)
```