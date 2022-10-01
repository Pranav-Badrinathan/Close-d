extends Node
# A fast (but not very clean) way to organize events.
# Meant to be used as an AutoLoad.


# drag_drop(Vector2, int)
signal drag_drop(global_position, tool_name)


func emit_drag_action(global_position: Vector2, tool_name :int):
	emit_signal("drag_drop", global_position, tool_name)
