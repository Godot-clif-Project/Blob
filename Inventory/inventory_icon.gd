# A visible icon to represent an item from the parent inventory
class_name InventoryIcon
extends TextureRect


# fill in when highlight icon is available
#const highlight_icon

var selectable := false

onready var inventory: Inventory = get_parent()


func _ready():
	# warning-ignore-all:return_value_discarded
	inventory.connect("items_updated", self, "_handle_updated")
	inventory.connect("linked_to_inventory", self, "enable_selectable")
	connect("visibility_changed", self, "_handle_visibility_changed")


func _handle_updated() -> void:
	if get_index() < inventory.inventory.size():
		var item: InventoryItem = inventory.inventory[get_index()]
		if item == null:
			texture = null
		
		else:
			texture = item.icon
	
	else:
		texture = null


func _handle_visibility_changed() -> void:
	if not visible:
		set_process_input(false)
		selectable = false


func enable_selectable() -> void:
	selectable = true


func _gui_input(event):
	if selectable and inventory.other_inventory.has_space() and event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		var item := inventory.remove_index(get_index())
		
		if item != null:
			inventory.other_inventory.add_item(item)
