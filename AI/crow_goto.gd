# A pathfinder which heads straight for the target (as the crow flies)
class_name CrowGoto
extends Node


signal finished

export var speed := 1000.0
export var enabled := false setget set_enabled
export var one_shot := true									# if true, will disable once the target is reached
export(float, 0, 1) var halting_tolerance := 0.99			# if at any point the goto is stuck moving into a wall or floor, this setting will be able to cancel that problem (keep as high as possible)

var target_origin
var path

var _is_ready := false

onready var _last_origin = get_parent().global_transform.origin


func _ready():
	_is_ready = true


func set_enabled(value: bool) -> void:
	enabled = value
	
	if not _is_ready:
		yield(self, "ready")
	
	if not value:
		get_parent().movement_vector *= 0
	
	set_process(value)


func _process(_delta):
	if target_origin == null:
		return
	
	var current_origin = get_parent().global_transform.origin
	path = [current_origin, target_origin]
	get_parent().movement_vector = (target_origin - current_origin).normalized() * speed
	
	if one_shot:
		if (_last_origin - target_origin).normalized().dot((current_origin - target_origin).normalized()) <= 0 or \
		(get_parent().is_on_floor() and get_parent().movement_vector.normalized().dot(- get_parent().floor_collision[Character2D.SerialEnums.NORMAL]) >= halting_tolerance) or \
		(get_parent().is_on_wall() and get_parent().movement_vector.normalized().dot(- get_parent().wall_collision[Character2D.SerialEnums.NORMAL]) >= halting_tolerance):
			set_enabled(false)
			emit_signal("finished")
		
		else:
			_last_origin = current_origin
