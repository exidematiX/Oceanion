extends CharacterBody3D

# Constants and variables
const SPEED = 10.0
const TURN_SPEED = 1.0
const MAX_ANGLE = 45.0

var score  = 0 
var start_position : Vector3
var lives : int = 3  # 初始化三条命
var invincible : bool = false  # 无敌状态标志

@onready var ray_cast_3d = $RayCast3D
@onready var timer = $Timer
@onready var label = $"../UI/InGame/Money"
@onready var scene_transition = $"../UI/scene_transition"
@onready var distances = $"../UI/InGame/Distance"
@onready var life_sprites = [
	$"../UI/InGame/Life1",
	$"../UI/InGame/Life2",
	$"../UI/InGame/Life3"
]
@onready var collision_shap = $CollisionShape3D

#相机抖动参数
var shake_tim=0#时间
var shake_length=10#总长度
var time_add=1#时间累加
var shake_range=0.1#范围
var freg =0.01#抖动频率


func _ready():
	add_to_group("Player")
	ray_cast_3d.enabled=true
	start_position = global_transform.origin
	update_lives_ui()
	

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
	if ray_cast_3d.is_colliding() and !invincible:
		var collider = ray_cast_3d.get_collider()
		if collider != null:
			if collider.is_in_group("Island"):
				print("island")
				camera_shake()
				lose_life()
			elif collider.is_in_group("Chest"):
				print("Chest")
				score +=10
				update_score()
				collider.queue_free()  # 假设宝箱被收集后销毁
		
		
	#距离更新
	var current_position = global_transform.origin
	var distance = current_position.distance_to(start_position)
	update_distance(distance)

#更新得分
func update_score():
	label.text = "%d"% score

#更新距离
func update_distance(distance):
	distance/=1000
	distances.text=" %.2f km" % distance

#更新生命值
func update_lives_ui():
	for i in range(3):
		if i < lives:
			life_sprites[i].visible = true
		else:
			life_sprites[i].visible = false

#掉血
func lose_life():
	lives -= 1
	update_lives_ui()
	if lives <= 0:
		scene_transition.change_scene("game")
	else:
		set_invincible(3.0)  # 设置无敌时间为3秒

func set_invincible(duration: float):
	invincible = true
	collision_shap.disabled=true
	timer.start(duration)
	print("no")


func _on_timer_timeout():
	invincible = false
	collision_shap.disabled=false
	print("yes")

func camera_shake():
	var cameraPos = $"../Camera3D".global_position
	while shake_tim<shake_length:
		shake_tim+=time_add
		
		var offset = Vector3(
			randf_range(-shake_range, shake_range),
			0,
			randf_range(-shake_range, shake_range)
			)

		print("func")
		var newPos=cameraPos
		newPos+=offset
		$"../Camera3D".global_position=newPos
		await get_tree().create_timer(freg).timeout
	$"../Camera3D".global_position=cameraPos
	shake_tim=0
	
