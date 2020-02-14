extends Node2D

export var showLine = true

var gender := ""
var speed := 0
var schedule := []

var skins = [
	preload("res://Assets/Images/face_man.png"),
	preload("res://Assets/Images/face_manAlternative.png"),
	preload("res://Assets/Images/face_orc.png"),
	preload("res://Assets/Images/face_robot.png"),
	preload("res://Assets/Images/face_soldier.png"),
	preload("res://Assets/Images/face_woman.png"),
	preload("res://Assets/Images/face_womanAlternative.png")
	]

var path := PoolVector2Array() setget set_path
var movement = false

func _ready():
	randomize()
	$Sprite.texture = skins[randi() % skins.size()]
#	makeSchedule()
	$Line2D.visible = showLine

func create(dictionary):
	name = dictionary.name
	gender = dictionary.gender
	speed = dictionary.speed
	schedule = dictionary.schedule
	print("Created Character")
	print(name)
	print(schedule)
	print(typeof(schedule))
#	print(name)
#	for event in schedule:
#		print(event)
#		print(event.time)
#		print(event.locationX)
#		print(event.locationY)
	pass

func _process(delta):
	if (movement): 
		var move_distance = speed * delta
		move_along_path(move_distance)
	pass

func timeChange(time: int):
	print("New Time Change:")
	print(name)
	print(time)
	for event in schedule:
		print("schedule event time:")
		print(event.time)
		if event.time == time:
			print(Vector2(event.locationX, event.locationY))
			return Vector2(event.locationX, event.locationY)
	return false

func currentPosition():
	return $Sprite.position

func move_along_path(distance: float):
	var startPoint = $Sprite.position
	for i in range(path.size()):
		var distance_to_next = startPoint.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0:
			$Sprite.position = startPoint.linear_interpolate(path[0], distance / distance_to_next)
			break
		elif distance < 0:
			$Sprite.position = path[0]
			movement = false
		distance_to_next -= distance_to_next
		startPoint = path[0]
		path.remove(0)
	pass

func set_path(value: PoolVector2Array):
	path = value
	$Line2D.points = path
	if value.size() == 0:
		return
	movement = true
	pass
