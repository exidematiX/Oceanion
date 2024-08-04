extends Node

var tile_pool
var water_tile
var active_tiles = []
var tile_size = 10.0  # assuming 10x10 tiles
var view_distance = 3  # load tiles within 3-tile distance


func _ready():
	tile_pool = $TilePool
	water_tile = $TilePool/Water

func _process(_delta):
	var player_node = get_node("%Player") 
	if player_node:
		var player_position = player_node.global_transform.origin
		update_active_tiles(player_position)


func update_active_tiles(player_position):
	var rounded_x = player_position.x
	var rounded_z = player_position.z
	water_tile.global_transform.origin = Vector3(rounded_x, 0, rounded_z)
	
	
