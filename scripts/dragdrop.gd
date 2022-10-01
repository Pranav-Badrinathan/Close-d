extends Node2D

var dragging = false
var pos_from_centre = Vector2()
var _velocity = Vector2()

enum Tool {SCREWDRIVER, WRENCH, SLEDGEHAMMER, PLIERS, AXE}
export (Tool) var _tool

export (Texture) var image
export var fall_speed = 0

func _ready():
	get_node("Texture").set_texture(image)

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("LClick"):
		pos_from_centre = get_global_mouse_position() - position
		dragging = true
		get_tree().set_input_as_handled()
	print("JHEDYFFFDMLAXS")

func _physics_process(_delta):
	if dragging: position = get_global_mouse_position() - pos_from_centre


func _input(event):
	if event.is_action_released("LClick"): 
		dragging = false
		pos_from_centre = Vector2()
