extends Node2D

onready var nav : Navigation2D = $Navigation2D
onready var line : Line2D = $Line2D
onready var character : Sprite = $YSort/Sprite


func _unhandled_input(event) -> void:
	if not event is InputEventMouseButton:
		return
	if not event.button_index == BUTTON_LEFT or not event.pressed:
		return
	print("character pos:")
	print(character.position)
	print("event pos")
	print((event.global_position - position))
	var path : = nav.get_simple_path(character.position, (event.global_position - position))
	print("path:")
	print(path)
	line.points = path
	character.path = path

var _scrollSpeed = 300
var _sprintMulti = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	pass

