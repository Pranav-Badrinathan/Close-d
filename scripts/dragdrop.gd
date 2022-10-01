extends Node2D

var dragging = false
var pos_from_centre = Vector2()

func _on_Draggable_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("LClick"):
		get_tree().set_input_as_handled()
		dragging = true
		pos_from_centre = get_global_mouse_position() - position

func _physics_process(_delta):
	if dragging: position = get_global_mouse_position() - pos_from_centre

func _input(event):
	if event.is_action_released("LClick"): 
		dragging = false
		pos_from_centre = Vector2()
