extends CanvasLayer

func change_scene(target: String) -> void:
	$AnimationPlayer.play("move_in")
	await $AnimationPlayer.animation_finished
	#get_tree().change_scene_to_file(target)
	var scene_tree = get_tree()
	if scene_tree:
		get_tree().change_scene_to_file("res://scene/game.tscn")
	else:
		print("Failed to get the scene tree.")
	$AnimationPlayer.play_backwards("move_in")
