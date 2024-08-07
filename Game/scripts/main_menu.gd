extends Control
@onready var scene_transition = $scene_transition



func _on_button_button_down():
	scene_transition.change_scene("game")
