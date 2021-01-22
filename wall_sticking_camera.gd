extends Camera2D


export var on_wall_zoom := 5.0

onready var original_zoom := zoom.x


func _process(delta):
	var new_zoom: float = lerp(on_wall_zoom, original_zoom, get_parent().global_transform.y.normalized().dot(Vector2.DOWN))
	zoom.x = new_zoom
	zoom.y = new_zoom
