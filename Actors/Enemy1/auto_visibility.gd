class_name AutoTeleport
extends VisibilityNotifier2D


export var teleport_range := 6000.0
export var sprite_path: NodePath = "../AnimatedSprite"


onready var sprite := get_node(sprite_path)
onready var original_transform: Transform2D = get_parent().global_transform


func _process(delta):
	rect = sprite.get_rect()
	
	if not is_on_screen() and get_parent().global_transform.origin.distance_to(original_transform.origin) >= teleport_range:
		get_parent().global_transform = original_transform
