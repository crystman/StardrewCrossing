extends Node2D

const NPC = preload("res://Scenes/Character/Character.tscn")

onready var nav : Navigation2D = $Navigation2D
onready var line : Line2D = $Line2D
onready var character : Sprite = $YSort/Sprite

var globalTime: float = 0.0
var hour: int = 0

var npcs = []

var _scrollSpeed = 300
var _sprintMulti = 2

func _ready():
	readCharacters()
	for node in $YSort.get_children():
		if not node is Sprite:
			npcs.append(node)
	pass

func _unhandled_input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
#			print("character pos:")
#			print(character.position)
#			print("event pos")
#			print((event.global_position - position))
			var path : = nav.get_simple_path(character.position, (event.global_position - position))
#			print("path:")
#			print(path)
			line.points = path
			character.path = path
		elif event.button_index == BUTTON_RIGHT and event.pressed:
			var mouse_pos = $Navigation2D/TileMap.get_local_mouse_position()
			var cell_pos = $Navigation2D/TileMap.world_to_map(mouse_pos)
			var tile_id = $Navigation2D/TileMap.get_cellv(cell_pos)
			var tile_name = $Navigation2D/TileMap.tile_set.tile_get_name(tile_id)
			print(tile_name)
			if tile_name == "snow_tile_blocked":
				var snow_tile_id = $Navigation2D/TileMap.tile_set.find_tile_by_name("snow_tile")
				$Navigation2D/TileMap.set_cellv(cell_pos, snow_tile_id)
			elif tile_name == "snow_tile":
				var snow_tile_blocked_id = $Navigation2D/TileMap.tile_set.find_tile_by_name("snow_tile_blocked")
				$Navigation2D/TileMap.set_cellv(cell_pos, snow_tile_blocked_id)
	pass

func _process(delta):
	var multi = _sprintMulti if Input.is_action_pressed("ui_shift") else 1
	if Input.is_action_pressed("ui_up"):
		position.y += (_scrollSpeed * delta * multi)
	if Input.is_action_pressed("ui_down"):
		position.y -= (_scrollSpeed * delta * multi)
	if Input.is_action_pressed("ui_left"):
		position.x += (_scrollSpeed * delta * multi)
	if Input.is_action_pressed("ui_right"):
		position.x -= (_scrollSpeed * delta * multi)
	
	globalTime += delta
	var newHour = int(floor(globalTime))%12
	if hour != newHour:
		hour = newHour
		for i in range(npcs.size()):
			var currentPos = npcs[i].currentPosition()
			var newPos = npcs[i].timeChange(hour)
			if newPos:
				var path = nav.get_simple_path(currentPos, newPos)
				npcs[i].path = path
	pass

var dirPath : String = "res://Assets/Characters/"

func readCharacters():
	var dir = Directory.new()
	if dir.open(dirPath) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var file = File.new()
			var exists = file.file_exists(dirPath + file_name)
			if exists:
				file.open(dirPath + file_name, file.READ)
				var text = file.get_as_text()
				var parsed = JSON.parse(text)
				var npc = NPC.instance()
				npc.create(parsed.result)
				$YSort.add_child(npc)
			file.close()
			file_name = dir.get_next()
	pass
