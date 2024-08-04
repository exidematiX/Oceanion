extends Node3D

var chunk_scene = preload("res://scene/world/filed_generator.tscn")#用于生成地图的场景

@export var chunk_size : float =60.0#块的大小
@export var view_distance : int = 2 # 玩家视野范围内的块数

var chunks : Dictionary = {}#存储当前激活的块
var player : CharacterBody3D
var player_chunk_coord : Vector2 = Vector2.ZERO

func _ready():
	player =  get_node("%Player") 
	update_chunks()
	

func _process(_delta):
		var new_player_chunk_coord=Vector2(int(player.global_transform.origin.x/chunk_size),int(player.global_transform.origin.z / chunk_size))
		if new_player_chunk_coord != player_chunk_coord:
			player_chunk_coord = new_player_chunk_coord
			update_chunks()
			
	
func update_chunks():
	var current_chunks=[]
	for chunk_coord in  chunks.keys():
		current_chunks.append(chunk_coord)
	
	for y_offset in range(-view_distance,view_distance+1):
		for x_offset in range(-view_distance,view_distance+1):
			var chunk_coord = player_chunk_coord + Vector2(x_offset,y_offset)
			
			if not chunks.has(chunk_coord):
				var new_chunk = chunk_scene.instantiate()
				if new_chunk:
					add_child(new_chunk)
					# 使用 call_deferred 在节点加载到场景树后设置位置
					new_chunk.call_deferred("set_global_transform", Transform3D(Basis(), Vector3(chunk_coord.x * chunk_size, 0, chunk_coord.y * chunk_size)))
					chunks[chunk_coord] = new_chunk
				else:
					print("Error: new_chunk is not a Node3D")
			else:
				current_chunks.erase(chunk_coord)
	
	for chunk_coord in current_chunks:
		var chunk = chunks[chunk_coord]
		chunk.queue_free()#销毁对象
		chunks.erase(chunk_coord)
