# We rewrite shape collisions from scratch because that way the player won't collide with the blob ball
# If we just did a KinematicBody2D, even with layers set to 0, the player can still collide with the ball
class_name SpitBallBody
extends Node2D


export var shape: Shape2D
export var speed := 10000.0
export(int, LAYERS_2D_PHYSICS) var collision_mask := 3
export var damage := 1
export var damage_only_target := true
export var target_prediction := true		# If true, this node will aim for where the target will be

var target: Node2D
var fade_time := 1.0
var physics_query := Physics2DShapeQueryParameters.new()
var gravity_acceleration: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var down_vector: Vector2 = ProjectSettings.get_setting("physics/2d/default_gravity_vector")
var gravity_vector: Vector2 = down_vector * gravity_acceleration
var linear_velocity: Vector2

onready var direct_space_state := get_world_2d().direct_space_state


func _ready():
	var travel_vector: Vector2
	
	if target_prediction:
		hide()
		set_physics_process(false)
		
		var last_origin: Vector2 = target.global_transform.origin - global_transform.origin
		var last_time := OS.get_system_time_msecs()
		yield(get_tree(), "idle_frame")
		travel_vector = target.global_transform.origin - global_transform.origin
		var target_velocity := (travel_vector - last_origin) / (OS.get_system_time_msecs() - last_time) * 1000.0
		
		if target_velocity.length() > 0:
			travel_vector += GlobalData.quad_formula(target_velocity.length_squared() - speed * speed, 2 * target_velocity.dot(travel_vector), travel_vector.length_squared(), true) * target_velocity
		
		show()
		set_physics_process(true)
	
	else:
		travel_vector = target.global_transform.origin - global_transform.origin
	
	linear_velocity = travel_vector.normalized() * speed + Vector2.UP * gravity_acceleration * travel_vector.length() / speed / 2
	
	physics_query.collision_layer = collision_mask
	physics_query.set_shape(shape)


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
	var rotation_angle := global_transform.x.angle_to(linear_velocity)
	# Rotates only the basis (godot should have a method for this already!)
	global_transform.x = global_transform.x.rotated(rotation_angle)
	global_transform.y = global_transform.y.rotated(rotation_angle)
	physics_query.transform = global_transform
	
	if _check_collisions():
		return
	
	linear_velocity += gravity_vector * delta
	var travel_vector := linear_velocity * delta
	physics_query.motion = travel_vector
	var result := direct_space_state.cast_motion(physics_query)
	
	if result.empty() or (result[0] == 1 and result[1] == 1):
		global_transform.origin += travel_vector
	
	else:
		global_transform.origin += travel_vector * result[0]
		# warning-ignore:return_value_discarded
		_check_collisions()
