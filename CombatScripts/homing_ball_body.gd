# We rewrite shape collisions from scratch because that way the player won't collide with the blob ball
# If we just did a KinematicBody2D, even with layers set to 0, the player can still collide with the ball
class_name HomingBallBody
extends Node2D


export var shape: Shape2D
export var speed := 3000.0
export(int, LAYERS_2D_PHYSICS) var collision_mask := 3
export var damage := 1
export var damage_only_target := true
export var target_prediction := true

var target: Node2D
var turning_weight := 6.0
var fade_time := 1.0
var physics_query := Physics2DShapeQueryParameters.new()

var _last_origin: Vector2

onready var direct_space_state := get_world_2d().direct_space_state


func _ready():
	look_at(target.global_transform.origin)
	physics_query.collision_layer = collision_mask
	physics_query.set_shape(shape)


func _predict_target_position(delta: float) -> Vector2:
	var new_origin := target.global_transform.origin
	var target_velocity := (new_origin - _last_origin) / delta
	
	if target_velocity.length() > 0:
		var o := new_origin - global_transform.origin
		var a := target_velocity.length_squared() - speed * speed
		var b := 2 * target_velocity.dot(o)
		var c := o.length_squared()
		var lead_time := (- b - sqrt(b * b - 4 * a * c)) / 2 / a
		return new_origin + lead_time * target_velocity
	
	return new_origin


func _check_collisions() -> bool:
	# Checks if the ball is intersecting any shape when called
	# Returns true if collision detected
	# Also handles collisions with damageable nodes
	var result := direct_space_state.intersect_shape(physics_query)
	
	if result.empty():
		return false
	
	for collision_data in result:
		var collider: Node = collision_data["collider"]
		
		if damage_only_target and collider != target:
			continue
		
		var damageable: Damageable = collider.get_node_or_null("Damageable")
		
		if damageable != null:
			damageable.health -= damage
	
	set_physics_process(false)
	var fade := Fade.new(fade_time)
	# warning-ignore:return_value_discarded
	fade.connect("tween_all_completed", self, "queue_free")
	add_child(fade)
	
	return true


func _physics_process(delta: float):
	var new_transform := global_transform
	var rotation_angle := global_transform.x.angle_to((_predict_target_position(delta) if target_prediction else target.global_transform.origin) - global_transform.origin)
	# Rotates only the basis (godot should have a method for this already!)
	new_transform.x = new_transform.x.rotated(rotation_angle)
	new_transform.y = new_transform.y.rotated(rotation_angle)
	global_transform = global_transform.interpolate_with(new_transform, turning_weight * delta)
	physics_query.transform = global_transform
	
	if _check_collisions():
		return
	
	var travel_vector := global_transform.x.normalized() * speed * delta
	physics_query.motion = travel_vector
	var result := direct_space_state.cast_motion(physics_query)
	
	if result.empty() or (result[0] == 1 and result[1] == 1):
		global_transform.origin += travel_vector
	
	else:
		global_transform.origin += travel_vector * result[0]
		# warning-ignore:return_value_discarded
		_check_collisions()
	
	_last_origin = target.global_transform.origin
