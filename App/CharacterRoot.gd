extends Node2D

class ScheduleSorter:
	static func sort(a, b):
		if a[0] < b[0]:
			return true
		return false

export var showLine = true

var schedule = [] #[time: int, position: Vector2]

var skins = [
	preload("res://Assets/Images/face_man.png"),
	preload("res://Assets/Images/face_manAlternative.png"),
	preload("res://Assets/Images/face_orc.png"),
	preload("res://Assets/Images/face_robot.png"),
	preload("res://Assets/Images/face_soldier.png"),
	preload("res://Assets/Images/face_woman.png"),
	preload("res://Assets/Images/face_womanAlternative.png")
	]

var speed := 400
var path := PoolVector2Array() setget set_path
var movement = false

func _ready():
	randomize()
	$Sprite.texture = skins[randi() % skins.size()]
	makeSchedule()
	$Line2D.visible = showLine

func makeSchedule():
	var count = randi()%10+5
	for i in count:
		schedule.append([randi()%12, randomVec2()])
	schedule.sort_custom(ScheduleSorter, "sort")

func randomVec2():
	var x = randi()%2500-800
	var y = randi()%1500-400
	return Vector2(x, y)

func _process(delta):
	if (movement): 
		var move_distance = speed * delta
		move_along_path(move_distance)

func timeChange(time: int):
	for event in schedule:
		if event[0] == time:
			return event[1]
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
			$Sprite.position - path[0]
			movement = false
		distance_to_next -= distance_to_next
		startPoint = path[0]
		path.remove(0)

func set_path(value: PoolVector2Array):
	path = value
	$Line2D.points = path
	if value.size() == 0:
		return
	movement = true
