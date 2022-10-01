extends Node2D

enum State {OPEN, CLOSING, OPENING}

onready var door = get_node("Fore/Door")
onready var foreground = get_node("Fore")
onready var light = get_node("Light")
onready var time_readout = get_node("TimeReadout")

var door_state = State.OPEN

var door_progress = 0

var open_speed = 1

var close_speed = 0.09

var door_interval

var time_until_open = 10

var first_closing = true

func _ready():
	door_interval = [0, door.texture.get_size().y * door.transform.get_scale().y]
	light.visible = false
	time_readout.visible = false
	
func _process(d):
	if not first_closing:
		time_until_open -= d
		
		time_readout.text = str(floor(time_until_open)) + ":" + str(floor((time_until_open - floor(time_until_open)) / 0.01))
	
	if time_until_open <= 0:
		if door_state == State.CLOSING:
			start_opening()
		time_until_open = 10
		
	elif door_state == State.CLOSING:
		door_progress += close_speed * d
		door.position.y = door_interval[0] + (door_interval[1] - door_interval[0]) * door_progress
		
	elif door_state == State.OPENING:
		door_progress -= open_speed * d
		if door_progress <= 0:
			door_progress = 0
			opening_to_open()
		door.position.y = door_interval[0] + (door_interval[1] - door_interval[0]) / (1 + pow(2, -20 * (door_progress - 0.5)))

func start_timer():
	time_readout.visible = true
	first_closing = false
	time_readout.text = "10:00"

func opening_to_open():
	door_state = State.OPEN
	light.visible = false

func start_opening():
	door_state = State.OPENING
	light.visible = true

func start_closing():
	door_state = State.CLOSING
	light.visible = true

func _on_OpenButton_pressed():
	if door_state == State.OPEN:
		if first_closing:
			start_timer()
		start_closing()
