# A node containing multiple items
class_name Inventory
extends Node


signal items_updated

export var inventory_size := 3 setget set_inventory_size
export var activate_items := false

var inventory := [null, null, null]
var inventory_item_names := ["", "", ""]


func set_inventory_size(value: int) -> void:
	# warning-ignore-all:return_value_discarded
	inventory_size = value
	
	if inventory_size > inventory.size():
		for _i in range(inventory.size(), inventory_size):
			inventory.append(null)
			inventory_item_names.append("")
	
	else:
		for _i in range(inventory_size, inventory.size()):
			inventory.remove(inventory_size)
			inventory_item_names.remove(inventory_size)


func has_item_name(item_name: String) -> bool:
	return item_name in inventory_item_names


func has_item(item: InventoryItem) -> bool:
	return item in inventory


func has_space() -> bool:
	return null in inventory


func is_empty() -> bool:
	return inventory.count(null) == inventory_size


func add_item(item: InventoryItem) -> int:
	var idx := inventory.find(null)
	
	if idx != -1:
		item._activate_internal(owner)
		inventory[idx] = item
		inventory_item_names[idx] = item.name
		emit_signal("items_updated")
	
	return idx


func erase_item(item: InventoryItem) -> void:
	var idx := inventory.find(item)
	
	if idx == -1:
		push_error(item.name + " is not an item in inventory " + name)
		return
	
	remove_index(idx)


func remove_index(idx: int) -> InventoryItem:
	var item: InventoryItem = inventory[idx]
	
	if item != null:
		item._deactivate_internal()
		inventory_item_names[idx] = ""
		inventory[idx] = null
		emit_signal("items_updated")
	
	return item
