class_name AStarGoto
extends Node


signal targeted
signal untargeted

export var speed := 5.0
export var simplify_distance := 0.1
export var stop_on_arrival := false

var target: Node setget set_target
var override_target: Node setget set_override_target
var id_path: PoolIntArray
var path

onready var character := get_parent()


func set_target(node: Node) -> void:
	target = node
	if is_instance_valid(target):
		set_process(true)
		emit_signal("targeted")
	
	else:
		set_process(false)
		emit_signal("untargeted")


func set_override_target(node: Node) -> void:
	if is_instance_valid(target):
		override_target = node
	
	else:
		set_target(override_target)


func _ready():
	set_process(false)


func update_path():
	var character_origin = character.global_transform.origin
	var character_origin_on_segment = GlobalData.navigation.a_star.get_closest_position_in_segment(character_origin)
	var target_origin
	
	if is_instance_valid(override_target):
		target_origin = override_target.global_transform.origin
	
	else:
		target_origin = target.global_transform.origin
	
	if (stop_on_arrival or is_instance_valid(override_target)) and character_origin_on_segment.distance_to(GlobalData.navigation.a_star.get_closest_position_in_segment(target_origin)) <= simplify_distance:
		if is_instance_valid(override_target):
			override_target = null
		
		else:
			set_target(null)
		
		return
	
	id_path = GlobalData.navigation.get_id_path(character_origin, target_origin)
	path = GlobalData.navigation.id_path_to_vector_path(id_path)
	path.insert(0, character_origin)
	path.append(target_origin)
	
	if path.size() > 2:
		var to = (path[1] - character_origin).normalized()
		var out = (path[2] - path[1]).normalized()
		var bisector = to.linear_interpolate(out, 0.5)
		
		if typeof(bisector) == TYPE_VECTOR2:
			bisector = bisector.rotated(PI / 2)
		
		else:
			bisector = to.cross(out).cross(bisector).normalized()
		
		if abs(bisector.dot(character_origin_on_segment - path[1])) <= simplify_distance:
			path.remove(1)
	
	character.movement_vector = (path[1] - character_origin).normalized() * speed


func _process(_delta):
	update_path()
