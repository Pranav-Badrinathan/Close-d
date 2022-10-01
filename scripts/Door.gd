extends Node2D



onready var slide = get_node("Slide")
onready var foreground = get_node("Foreground")
onready var light = get_node("Light")
onready var time_readout = get_node("TimeReadout")

var door_state = "open"

var door_progress = 0

var open_speed = 1

var slide_interval = [0, 230]

var time_until_open = 10

func _ready():
	light.hide()
	
func _process(d):
	time_until_open -= d
	
	time_readout.text = str(floor(time_until_open)) + ":" + str(floor((time_until_open - floor(time_until_open)) / 0.01))
	
	if door_state == "closing" and time_until_open <= 0:
		closing_to_opening()
		time_until_open = 10
	
	elif door_state == "opening":
		door_progress -= open_speed * d
		if door_progress <= 0:
			door_progress = 0
			opening_to_open()
		slide.position.y = slide_interval[0] + (slide_interval[1] - slide_interval[0]) / (1 + pow(2, -20 * (door_progress - 0.5)))

func opening_to_open():
	door_state = "open"
	light.visible = false

func closing_to_opening():
	door_state = "opening"
	light.visible = true

func test_close():
	door_state = "closing"
	door_progress = 1
	slide.position.y = slide_interval[0] + door_progress * (slide_interval[1] - slide_interval[0])


func _on_Button_pressed():
	if door_state == "open":
		test_close()
