extends Node2D

enum State {OPEN, CLOSING, OPENING}


onready var door = get_node("Fore/Door")
onready var foreground = get_node("Fore")
onready var light = get_node("Light")
onready var time_readout = get_node("TimeReadout")

var door_state = State.OPEN

var door_progress = 0

var open_speed = 1

var door_interval

var time_until_open = 10

func _ready():
	door_interval = [0, door.texture.get_size().y * door.transform.get_scale().y]
	light.hide()
	
func _process(d):
	time_until_open -= d
	
	time_readout.text = str(floor(time_until_open)) + ":" + str(floor((time_until_open - floor(time_until_open)) / 0.01))
	
	if door_state == State.CLOSING and time_until_open <= 0:
		closing_to_opening()
		time_until_open = 10
	
	elif door_state == State.OPENING:
		door_progress -= open_speed * d
		if door_progress <= 0:
			door_progress = 0
			opening_to_open()
		door.position.y = door_interval[0] + (door_interval[1] - door_interval[0]) / (1 + pow(2, -20 * (door_progress - 0.5)))

func opening_to_open():
	door_state = State.OPEN
	light.visible = false

func closing_to_opening():
	door_state = State.OPENING
	light.visible = true

func test_close():
	door_state = State.CLOSING
	door_progress = 1
	door.position.y = door_interval[0] + door_progress * (door_interval[1] - door_interval[0])


func _on_Button_pressed():
	if door_state == State.OPEN:
		test_close()
