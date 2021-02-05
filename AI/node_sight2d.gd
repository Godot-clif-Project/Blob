class_name NodeSight2D
extends RayCast2D


signal triggered
signal untriggered

export var target_path: NodePath = "Player"
export var max_distance := 3000.0

var target: Node2D
var target_visible := false


func _ready():
	if target_path == NodePath("Player"):
		target = GlobalData.yield_and_get_group("Player")[0]
	
	elif not target_path.is_empty():
		target = get_node(target_path)


func get_collision_vector() -> Vector2:
	return get_collision_point() - global_transform.origin


func _process(_delta):
	if is_instance_valid(target):
		if get_collider() == target and get_collision_vector().length() <= max_distance:
			if not target_visible:
				emit_signal("triggered")
			
			target_visible = true
		
		else:
			if target_visible:
				emit_signal("untriggered")
			
			target_visible = false
		
		cast_to = to_local(target.global_transform.origin)
	
	else:
		if target_visible:
			emit_signal("untriggered")
		
		target_visible = false
