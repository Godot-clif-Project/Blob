# A node containing multiple items
class_name Inventory
extends Node


signal items_updated

export var inventory_size := 3 setget set_inventory_size

var inventory: Dictionary


func set_inventory_size(value: int) -> void:
	inventory_size = value
	
	if inventory_size > inventory.size():
		for i in range(inventory.size(), inventory_size):
			inventory[i] = null
	
	else:
		for i in range(inventory_size, inventory.size()):
			inventory.erase(i)


func update_children() -> void:
	emit_signal("items_updated")
