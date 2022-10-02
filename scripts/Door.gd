extends Node2D

enum State {OPEN, CLOSING, OPENING, FALLING}

onready var door = get_node("Door")
onready var light = get_node("Machine/MachineSprite/Light")
onready var time_readout = get_node("TimeReadout")
onready var machine = get_node("Machine")
onready var audio = get_node("Audio")

var door_state = State.OPEN
var door_progress = 0
var door_interval
var peak_progress = 1
var time_until_open = 10
var time_until_fall = 1

signal door_start
signal door_end
signal stop

export var door_speed = 10
export (Texture) var light_on
export (Texture) var light_off

var open_speed = 1
var close_speed = 0.09
var falling_speed = 0
var falling_acceleration = 5

var first_closing = true

func _ready():
	door_interval = [0, door.texture.get_size().y * door.transform.get_scale().y]
	light.texture = light_off
	time_readout.visible = false
	
	self.connect("door_start", audio, "play_door_start")
	self.connect("door_end", audio, "play_door_end")
	self.connect("stop", audio, "play_stop")
	
func _process(d):
	if not first_closing:
		time_until_open -= d
		
		time_readout.text = str(floor(time_until_open)) + ":" + str(floor((time_until_open - floor(time_until_open)) / 0.01))
	
	if time_until_open <= 0:
		if door_state == State.CLOSING:
			start_opening()
		time_until_open = 10
		
	elif door_state == State.FALLING:
		time_until_fall -= d
		if time_until_fall <= 0:
			door_progress += falling_speed * d +  pow(falling_acceleration * d, 2) / 2
			falling_speed += falling_acceleration * d
			if door_progress >= 1:
				door_progress = 1
				#you win
			door.position.y = door_interval[0] + (door_interval[1] - door_interval[0]) * door_progress
		
	elif door_state == State.CLOSING:
		door_progress += close_speed * d
		door.position.y = door_interval[0] + (door_interval[1] - door_interval[0]) * door_progress
		
	elif door_state == State.OPENING:
		door_progress -= open_speed * d
		if door_progress <= 0:
			door_progress = 0
			opening_to_open()
		
		door.position.y = door_interval[0] + peak_progress * (door_interval[1] - door_interval[0]) / (1 + pow(2, -20 * (door_progress / peak_progress - 0.5)))

func start_timer():
	time_readout.visible = true
	first_closing = false
	time_readout.text = "10:00"

func opening_to_open():
	door_state = State.OPEN
	light.texture = light_off
	emit_signal("stop")

func start_opening():
	door_state = State.OPENING
	light.texture = light_on
	peak_progress = door_progress
	emit_signal("door_end")

func start_closing():
	door_state = State.CLOSING
	light.texture = light_on
	emit_signal("door_start")

func _on_OpenButton_pressed():
	if door_state == State.OPEN:
		if first_closing:
			start_timer()
		start_closing()
		
func break_machine():
	machine.gravity_scale = 50
	light.texture = light_off
	door_state = State.FALLING
	time_readout.visible = false
