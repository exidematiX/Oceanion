# TilePool.gd
extends Node

var water_tile_scene = preload("res://scene/world/water.tscn")
var island_tile_scene = preload("res://scene/world/island_middle_green_0.tscn")

var water_tiles = []
var island_tiles = []

func _ready():
	_init_pool()

func _init_pool():
	for i in range(10):
		var water_tile = water_tile_scene.instantiate()
		var island_tile = island_tile_scene.instantiate()
		
		water_tile.hide()
		island_tile.hide()
		
		water_tiles.append(water_tile)
		island_tiles.append(island_tile)
		
		add_child(water_tile)
		add_child(island_tile)

func get_water_tile():
	for tile in water_tiles:
		if not tile.is_visible():
			tile.show()
			return tile
	return null

func get_island_tile():
	for tile in island_tiles:
		if not tile.is_visible():
			tile.show()
			return tile
	return null

func free_tile(tile):
	tile.hide()
