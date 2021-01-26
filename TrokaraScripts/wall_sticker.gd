class_name WallSticker
extends ClassicCharacter2D


export var reorientation_weight := 8.0
export var falling_reorientation_weight := 4.0
	

func _process(delta):
	if is_on_floor():
		rotate(global_transform.y.angle_to(- floor_collision[SerialEnums.NORMAL]) * reorientation_weight * delta)

	else:
		rotate(global_transform.y.angle_to(down_vector) * falling_reorientation_weight * delta)
