extends Node2D

export (AudioStream) var break_
export (AudioStream) var music_

onready var audio = get_node(".")

func _ready():
	audio.set_bus("NewBus")

func _play():
	audio.stop()
	audio.stream = break_
	audio.play()

func _play2():
	if audio.stream == null:
		audio.stop()
		audio.stream = music_
		audio.play()
