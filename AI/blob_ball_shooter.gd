class_name BlobBallShooter
extends Node


export var trigger_node_path: NodePath
export var reload_time := 3.0
export var loop := true
export var blob_ball_scene: PackedScene
export(int, LAYERS_2D_PHYSICS) var blob_ball_mask: int

var current_reload := 0.0

onready var trigger_node := get_node(trigger_node_path)


func _ready():
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
