# A node containing multiple items
class_name Inventory
extends Node


signal items_updated

export var inventory_size := 3 setget set_inventory_size
export var activate_items := false

var inventory := [null, null, null]
var inventory_item_names: Array


func set_inventory_size(value: int) -> void:
	# warning-ignore-all:return_value_discarded
	inventory_size = value
	
	if inventory_size > inventory.size():
		for i in range(inventory.size(), inventory_size):
			inventory.append(null)
	
	else:
		for i in range(inventory_size, inventory.size()):
			inventory.remove(inventory_size)


func has_item(item_name: String) -> bool:
	return item_name in inventory_item_names


func add_item(item_name: String) -> bool:
	for i in range(inventory_size):
		if inventory[i] == null:
			var item: InventoryItem = GlobalItemList.items[item_name]
			inventory[i] = item
			
			if activate_items:
				item._activate_internal(owner)
			
			update_children()
			return true
	
	return false


func erase_item(item_name: String) -> void:
	var idx := inventory_item_names.find(item_name)
	
	if idx == -1:
		push_error(item_name + " is not an item in inventory " + name)
		return
	
	inventory[idx]._deactivate_internal()
	inventory[idx] = null


func remove_index(idx: int) -> void:
	inventory.erase(idx)
	update_children()


func update_children() -> void:
	emit_signal("items_updated")
