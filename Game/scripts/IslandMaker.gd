extends Node3D

@onready var node = $"."

var island_scene = preload("res://scene/world/island_middle_green_0.tscn")
var chest_scene = preload("res://scene/entities/chest.tscn")

# 生成数量和区域大小
@export var Island_1 : int = 1
@export var Island_2 : int = 1
@export var chest_count : int = 4

@export var chunk_size : float = 10.0


func _ready():
	generate_chunk()
	
	
func generate_chunk():
	var positions=[]
	
	#生成岛屿
	for i in range(Island_1):
		var position_radom = Vector3(randf_range(-chunk_size / 2,chunk_size/2),0,randf_range(-chunk_size / 2,chunk_size/2))
		#while is_overlapping(position_radom,positions):
		#	position_radom = Vector3(randf_range(-chunk_size / 2, chunk_size / 2), 0, randf_range(-chunk_size / 2, chunk_size / 2))
		var island = island_scene.instantiate()
		island.global_transform.origin = node.global_transform.origin + position_radom
		island.rotate_y(randf_range(0,PI*2))#随机y轴旋转
		add_child(island)
		positions.append(island.global_transform.origin)
		
	
	#生成宝箱
	for i in range(chest_count):
		var position_radom = Vector3(randf_range(-chunk_size ,chunk_size),-0.5,randf_range(-chunk_size ,chunk_size))
		while is_overlapping(position_radom, positions):
			position_radom = Vector3(randf_range(-chunk_size , chunk_size ), -0.5, randf_range(-chunk_size , chunk_size ))
		
		var chest = chest_scene.instantiate()
		chest.global_transform.origin = node.global_transform.origin + position_radom
		chest.rotate_y(randf_range(0,PI*2))
		add_child(chest)
		positions.append(chest.global_transform.origin)




func is_overlapping(_position,positions):
	for pos in positions:
		if _position.distance_to(pos)<5.0 :#这是阈值
			return true
	return false
	




