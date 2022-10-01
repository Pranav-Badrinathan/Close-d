extends Control

var game_scene = preload ("res://scenes/scene.tscn")


func _on_StartButton_pressed():
	var game = game_scene.instance()
	get_tree().get_root().add_child(game)
	hide()
