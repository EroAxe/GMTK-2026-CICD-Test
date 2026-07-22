extends Node

var _subscribers: Dictionary = {}


func subscribe(event_type: String, handler: Callable) -> void:
	if not _subscribers.has(event_type):
		_subscribers[event_type] = []

	var handlers: Array = _subscribers[event_type]
	if not handlers.has(handler):
		handlers.append(handler)


func unsubscribe(event_type: String, handler: Callable) -> void:
	if not _subscribers.has(event_type):
		return

	var handlers: Array = _subscribers[event_type]
	handlers.erase(handler)


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


func clear(event_type: String) -> void:
	_subscribers.erase(event_type)
