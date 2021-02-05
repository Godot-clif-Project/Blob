class_name AutoTeleport
extends VisibilityNotifier2D


export var teleport_range := 6000.0
export var sprite_path: NodePath = "../AnimatedSprite"


onready var sprite := get_node(sprite_path)
onready var original_transform: Transform2D = get_parent().global_transform


func _process(_delta):
	rect = sprite.get_rect()
	
	if not is_on_screen() and get_parent().global_transform.origin.distance_to(original_transform.origin) >= teleport_range:
		var parent := get_parent()
		get_parent().global_transform = original_transform
		parent.hide()
		yield(get_tree(), "idle_frame")
		
		if is_on_screen():
			# warning-ignore:shadowed_variable
			var original_transform := global_transform
			parent.remove_child(self)
			parent.get_parent().add_child(self)
			global_transform = original_transform
			parent.get_parent().remove_child(parent)
			set_process(false)
			yield(self, "screen_exited")
			get_parent().add_child(parent)
			get_parent().remove_child(self)
			parent.add_child(self)
		
		parent.show()
