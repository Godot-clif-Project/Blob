# A node which launches a blob ball from the parent
class_name BlobBallShooter
extends Node


export var trigger_node_path: NodePath						# the node which will trigger this launcher
export var reload_time := 3.0								# the amount of time before another blob ball can be launched
export var loop := true										# if true, the launcher will always launch while the target is in sight (if false, will only launch the moment the target is sighted and never again until the target is unsighted and sighted again)
export var blob_ball_scene: PackedScene						# the scene containing the blob ball
export(int, LAYERS_2D_PHYSICS) var blob_ball_mask: int		# the collision mask of the blob ball (if 0, will default to the blob's original mask)

var current_reload := 0.0

onready var trigger_node := get_node(trigger_node_path)


func _ready():
	# warning-ignore:return_value_discarded
	trigger_node.connect("triggered", self, "trigger")
	set_process(false)


func trigger() -> void:
	set_process(true)


func _process(delta):
	if current_reload <= 0:
		if loop and trigger_node.target_visible:
			current_reload = reload_time
			var ball := blob_ball_scene.instance()
			ball.target = trigger_node.target
			
			if blob_ball_mask > 0:
				ball.collision_mask = blob_ball_mask
			
			ball.transform.origin = get_parent().global_transform.origin
			get_tree().current_scene.add_child(ball)
			current_reload = reload_time
		
		else:
			set_process(false)
	
	else:
		current_reload -= delta
