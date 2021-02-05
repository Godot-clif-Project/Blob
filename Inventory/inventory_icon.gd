# A visible icon to represent an item from the parent inventory
class_name InventoryIcon
extends TextureRect


# fill in when highlight icon is available
#const highlight_icon

onready var inventory: Inventory = get_parent()


func _ready():
	# warning-ignore-all:return_value_discarded
	inventory.connect("items_updated", self, "_handle_updated")


func _handle_updated() -> void:
	if get_index() < inventory.inventory.size():
		var item: InventoryItem = inventory.inventory[get_index()]
		if item != null:
			texture = item.icon
	
	else:
		texture = null


func remove_item() -> void:
	inventory.inventory.erase(get_index())
	texture = null
