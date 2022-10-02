extends Node2D


export(bool) var debug := false
export var tool_n = 0

signal breakM

var width: float = 100
var height: float = 100

func _enter_tree():
	var registery := get_node("/root/EventRegistery")
	var err = registery.connect("drag_drop", self, "drop_reaction")
	if OK != err:
		print_debug("DragTarget Connect Failed", err)

func _exit_tree():
	var registery := get_node("/root/EventRegistery")
	registery.disconnect("drag_drop", self, "drop_reaction")


func _draw():
	if not debug:
		return
	var rect := Rect2(position, Vector2(width, height))
	draw_rect(rect, Color.red, false)


func drop_reaction(global_pos: Vector2, tool_name: int):
	if is_in_range(global_pos) and is_right_tool(tool_name):
		return _react(global_pos, tool_name)


func is_in_range(global_pos: Vector2) -> bool:
	var local_pos := self.to_local(global_pos)
	if (local_pos.x < 0 or local_pos.y < 0
			or width < local_pos.x or height < local_pos.y):
		return false
	return true


func is_right_tool(tool_name: int) -> bool:
	return tool_n == tool_name


func _ready():
	self.connect("breakM", get_node("../.."), "break_machine")
	

func _react(_pos, _tool):
	emit_signal("breakM")
