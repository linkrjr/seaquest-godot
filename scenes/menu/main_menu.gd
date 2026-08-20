extends Control

@onready var quit_button = $VBoxContainer/QuitButton

func _ready() -> void:
	var platform = OS.get_name()
	if platform == "Web":
		quit_button.hide()

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
