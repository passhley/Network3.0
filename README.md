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
-- If this is being called on the server, will register a new event if it wasn't previously registered
Network.hookEvent(eventName, eventHandler)
Network.HookEvent(eventName, eventHandler)

-- Connects to the given RemoteFunction, if no RemoteFunction was previously registered, it will do that aswell
-- [SERVER-ONLY]
Network.hookFunction(functionName, functionHandler)
Network.HookFunction(functionName, functionHandler)

-- Fire's the given RemoteEvent
-- If this is being called on the server, will register a new event if it wasn't previously registered
Network.fireEvent(eventName, ...)
Network.FireEvent(eventName, ..)

-- Fire's the given RemoteEvent to every client, if no RemoteEvent was previously registered, it will do that aswell
-- [SERVER-ONLY]
Network.fireAllClients(eventName, ...)
Network.FireAllClients(eventName, ...)

-- Fire's the given RemoteEvent to every client excluding the one passed, if no RemoteEvent was previously registered, it will do that aswell
-- [SERVER-ONLY]
Network.fireAllClientsExcept(eventName, clientExcept, ...)
Network.FireAllClientsExcept(eventName, clientExcept, ...)

-- Invokes the given RemoteFunction
-- [CLIENT-ONLY]
Network.invokeFunction(functionName, ...)
Network.InvokeFunction(functionName, ...)
```