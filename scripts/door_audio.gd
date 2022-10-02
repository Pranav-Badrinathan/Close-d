extends Node2D

export (AudioStream) var door_start
export (AudioStream) var door_pause
export (AudioStream) var door_end

onready var door_audio = get_node(".")


func play_door_start():
	play_door_pause()
	door_audio.stream = door_start
	door_audio.play()
	pass

func play_door_pause():
	door_audio.stream = door_pause
	door_audio.play()
	pass

func play_door_end():
	play_door_pause()
	door_audio.stream = door_end
	door_audio.play()
	pass

func play_stop():
	play_door_pause()
	door_audio.stop()
	pass
