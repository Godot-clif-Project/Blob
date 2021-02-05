# A data container class for every inventory item
class_name InventoryItem
extends Reference


var icon: Texture
var owner: Node


func _activate_internal(inventory_owner: Node) -> void:
	if owner != null:
		push_error(str(self) + " was activated while having still owned!")
	
	owner = inventory_owner
	_activate()


func _deactivate_internal() -> void:
	owner = null
	_deactivate()


func _activate() -> void:
	return


func _deactivate() -> void:
	return
