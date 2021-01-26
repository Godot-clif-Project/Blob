# This script should be used by Area (2D and 3D), to cause the bodies inside to jump
class_name JumpZone
extends PathTrigger2D


export var jump_node_name := "CharacterJump"
export var jump_height := INF
export var jump_in_air := false
export var max_angle_to_next_degrees := 360.0 setget set_max_angle_to_next_degrees

var max_angle_to_next: float = TAU setget set_max_angle_to_next
var jumped_bodies: Array


func set_max_angle_to_next(value: float) -> void:
	max_angle_to_next_degrees = rad2deg(value)
	max_angle_to_next = value


func set_max_angle_to_next_degrees(value: float) -> void:
	max_angle_to_next_degrees = value
	max_angle_to_next = deg2rad(value)


func _ready():
	set_constant_update(true)
	connect("body_exited", self, "_remove_jumped_body")


func _check_body(body: Node) -> void:
	if body in jumped_bodies:
		return
	
	if not "linear_velocity" in body:
		return
	
	var goto: AStarGoto = body.get_node_or_null(goto_name)
	if not is_instance_valid(goto):
		return
	
	var jump_node: CharacterJump = body.get_node_or_null(jump_node_name)
	if not is_instance_valid(jump_node):
		return
	
	if not (not jump_in_air and not body.is_on_slope()) and \
	(not goto.id_path.empty() and ((goto.id_path.size() > 1 and goto.id_path[0] == get_parent().id and goto.id_path[1] == linked_node.id) or goto.id_path[0] == linked_node.id)):
		if goto.id_path[0] == get_parent().id:
			if abs(goto.get_parent().linear_velocity.angle_to(goto.path[2] - goto.path[1])) <= max_angle_to_next:
				_triggered([body, jump_node])
		
		elif abs(goto.get_parent().linear_velocity.angle_to(goto.path[1] - goto.path[0])) <= max_angle_to_next:
			_triggered([body, jump_node])


func _triggered(variant) -> void:
	var body = variant[0]
	var jump_node: CharacterJump = variant[1]
	jump_node.jump_to(jump_height)
	jumped_bodies.append(body)
	
	if jump_in_air:
		yield(jump_node, "falling")
	
	else:
		yield(body, "landed")
	
	_remove_jumped_body(body)


func _remove_jumped_body(body: Node) -> void:
	if body in jumped_bodies:
		jumped_bodies.erase(body)
