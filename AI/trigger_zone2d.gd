class_name TriggerZone2D
extends Area2D


signal triggered
signal untriggered

export var target_path: NodePath = "Player"

var target: Node2D
var target_visible := false


func _ready():
	if target_path == NodePath("Player"):
		if not is_instance_valid(GlobalData.player):
			yield(GlobalData, "player_changed")
		
		target = GlobalData.player
	
	elif not target_path.is_empty():
		target = get_node(target_path)
	
	connect("body_entered", self, "_handle_body_entered")
	connect("body_exited", self, "_handle_body_exited")


func _handle_body_entered(body: Node) -> void:
	if body == target:
		emit_signal("triggered")
		target_visible = true


func _handle_body_exited(body: Node) -> void:
	if body == target:
		emit_signal("untriggered")
		target_visible = false
