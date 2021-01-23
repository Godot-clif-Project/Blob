class_name BlobBallBody
extends Node2D


export var shape_path: NodePath = "CollisionShape2D"
export(int, LAYERS_2D_PHYSICS) var collision_mask := 3
export var damage := 1

var target: Node2D
var speed := 3000.0
var turning_weight := 6.0
var fade_time := 1.0
var physics_query := Physics2DShapeQueryParameters.new()

onready var shape_node: CollisionShape2D = get_node(shape_path)
onready var direct_space_state := get_world_2d().direct_space_state


func _ready():
	look_at(target.global_transform.origin)
	physics_query.collision_layer = collision_mask
	physics_query.set_shape(shape_node.shape)


func _check_collisions() -> bool:
	var result := direct_space_state.intersect_shape(physics_query)
	
	if result.empty():
		return false
	
	for collision_data in result:
		var damageable: Damageable = collision_data["collider"].get_node_or_null("Damageable")
		
		if damageable != null:
			damageable.damage(damage)
	
	set_physics_process(false)
	var fade := Fade.new(fade_time)
	fade.connect("tween_all_completed", self, "queue_free")
	add_child(fade)
	
	return true


func _physics_process(delta: float):
	var new_transform := global_transform
	var rotation_angle := global_transform.x.angle_to(target.global_transform.origin - global_transform.origin)
	new_transform.x = new_transform.x.rotated(rotation_angle)
	new_transform.y = new_transform.y.rotated(rotation_angle)
	global_transform = global_transform.interpolate_with(new_transform, turning_weight * delta)
	physics_query.transform = shape_node.global_transform
	
	if _check_collisions():
		return
	
	var travel_vector := global_transform.x.normalized() * speed * delta
	physics_query.motion = travel_vector
	var result := direct_space_state.cast_motion(physics_query)
	
	if result.empty() or (result[0] == 1 and result[1] == 1):
		global_transform.origin += travel_vector
	
	else:
		global_transform.origin += travel_vector * result[0]
		_check_collisions()
