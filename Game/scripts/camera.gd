# CameraPivot.gd

extends Marker3D

@export var player_path: NodePath
var initial_offset = Vector3()

func _ready():
	assert(player_path != null, "Player path not set for CameraPivot")
	var player = get_node(player_path)
	initial_offset = global_transform.origin - player.global_transform.origin

func _physics_process(_delta):
	var player = get_node(player_path)
	global_transform.origin = player.global_transform.origin + initial_offset
