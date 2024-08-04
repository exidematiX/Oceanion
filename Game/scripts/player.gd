extends CharacterBody3D

# Constants and variables
const SPEED = 10.0
const TURN_SPEED = 1.0
const MAX_ANGLE = 45.0

var score  = 0 

@onready var ray_cast_3d = $RayCast3D
@onready var timer = $Timer
@onready var label = $"../UI/InGame/Label"
@onready var scene_transition = $"../UI/scene_transition"



func _ready():
	add_to_group("Player")
	ray_cast_3d.enabled=true

func _physics_process(delta):
	# Always move forward
	velocity = -transform.basis.z * SPEED

	var current_rotation = rotation_degrees.y
	var rotation_delta = 0.0

	# Input handling
	if Input.is_action_pressed("turn_left"):
		rotation_delta += TURN_SPEED
	if Input.is_action_pressed("turn_right"):
		rotation_delta -= TURN_SPEED
	if Input.is_action_pressed("brake"):
		velocity = Vector3.ZERO

	# Apply a scaling factor based on proximity to the maximum turning angle
	var scale_factor = 1.0 - abs(current_rotation) / MAX_ANGLE
	rotation_delta *= scale_factor

	rotation_degrees.y += rotation_delta

	# Limit the turning angle to +/- MAX_ANGLE
	rotation_degrees.y = clamp(rotation_degrees.y, -MAX_ANGLE, MAX_ANGLE)

	# Apply the velocity
	move_and_collide(velocity * delta)

	# Sync camera position with CameraPivot
	var camera = get_node("/root/Main/Camera3D")  # Replace with the actual path to your camera
	var pivot = get_node("/root/Main/CameraPivot")
	camera.global_transform.origin = pivot.global_transform.origin
	
	
	#射线检测
	if ray_cast_3d.is_colliding():
		var collider = ray_cast_3d.get_collider()
		if collider != null:
			if collider.is_in_group("Island"):
				print("island")
				scene_transition.change_scene("game")
				timer.start()
			elif collider.is_in_group("Chest"):
				print("Chest")
				score +=10
				update_score()
				collider.queue_free()  # 假设宝箱被收集后销毁
		


func _on_timer_timeout():
	get_tree().reload_current_scene()


func update_score():
	label.text = "%d"% score



