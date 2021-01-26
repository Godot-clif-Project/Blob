class_name PathTrigger2D
extends Area2D


export var goto_name := "Goto"
export var _linked_node_path: NodePath
export var constant_update := false setget set_constant_update

onready var linked_node: LinkedNode = get_node(_linked_node_path)


func set_constant_update(value: bool) -> void:
	constant_update = value
	set_process(value)


func _ready():
	set_process(constant_update)
	connect("body_entered", self, "_check_body")


func _process(_delta):
	for body in get_overlapping_bodies():
		_check_body(body)


func _check_body(body: Node) -> void:
	var goto: AStarGoto = body.get_node_or_null(goto_name)
	if is_instance_valid(goto) and not goto.id_path.empty() and (goto.id_path[0] == linked_node.id or (goto.id_path.size() > 1 and goto.id_path[0] == get_parent().id and goto.id_path[1] == linked_node.id)):
		_triggered(body)


func _triggered(variant) -> void:
	return
