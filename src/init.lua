local EventRegistry = require(script.EventRegistry)
EventRegistry.Init()

return {
	registerEvent = EventRegistry.registerEvent;
	registerFunction = EventRegistry.registerFunction;
	hookEvent = EventRegistry.hookEvent;
	hookFunction = EventRegistry.hookFunction;
	fireEvent = EventRegistry.fireEvent;
	fireAllClients = EventRegistry.fireAllClients;
	fireAllClientsExcept = EventRegistry.fireAllClientsExcept;
	invokeFunction = EventRegistry.invokeFunction;

	RegisterEvent = EventRegistry.registerEvent;
	RegisterFunction = EventRegistry.registerFunction;
	HookEvent = EventRegistry.hookEvent;
	HookFunction = EventRegistry.hookFunction;
	FireEvent = EventRegistry.fireEvent;
	FireAllClients = EventRegistry.fireAllClients;
	FireAllClientsExcept = EventRegistry.fireAllClientsExcept;
	InvokeFunction = EventRegistry.invokeFunction;
}