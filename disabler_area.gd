class_name DisablerArea
extends Area2D


onready var child := get_child(0)


func _ready():
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")
	var is_visible := false
	
	for node in get_overlapping_areas():
		if node.is_in_group("CameraArea"):
			is_visible = true
			break
	
	if not is_visible:
		remove_child(child)
	
	# warning-ignore-all:return_value_discarded
	connect("area_entered", self, "_handle_area_entered")
	connect("area_exited", self, "_handle_area_exited")


func _handle_area_entered(area: Area2D) -> void:
	if area.is_in_group("CameraArea"):
		add_child(child)
		move_child(child, 0)


func _handle_area_exited(area: Area2D) -> void:
	if area.is_in_group("CameraArea"):
		remove_child(child)
