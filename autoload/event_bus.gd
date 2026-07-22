extends Node
## Global pub/sub bus. Events are grouped into string-keyed channels,
## each with its own list of subscribed handlers.

var _subscribers: Dictionary = {}


## Registers [param handler] to receive events fired on [param event_type].
## Ignored if [param handler] is already subscribed to that channel.
func subscribe(event_type: String, handler: Callable) -> void:
	if not _subscribers.has(event_type):
		_subscribers[event_type] = []

	var handlers: Array = _subscribers[event_type]
	if not handlers.has(handler):
		handlers.append(handler)


## Removes [param handler] from [param event_type]. No-op if it wasn't subscribed.
func unsubscribe(event_type: String, handler: Callable) -> void:
	if not _subscribers.has(event_type):
		return

	var handlers: Array = _subscribers[event_type]
	handlers.erase(handler)


## Invokes every handler subscribed to [param event_type], passing [param event_data].
## Handlers whose target has been freed are pruned automatically.
func fire(event_type: String, event_data = null) -> void:
	if not _subscribers.has(event_type):
		return

	var handlers: Array = _subscribers[event_type]
	for i in range(handlers.size() - 1, -1, -1):
		var handler: Callable = handlers[i]
		if handler.is_valid():
			handler.call(event_data)
		else:
			handlers.remove_at(i)


## Removes all subscribers for [param event_type].
func clear(event_type: String) -> void:
	_subscribers.erase(event_type)
