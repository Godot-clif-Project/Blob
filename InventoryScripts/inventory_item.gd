# A data container class for every inventory item
class_name InventoryItem
extends Reference


var name: String
var icon: Texture
var metadata: Dictionary	# Dynamic container for extra data


func _init(item_name: String, item_icon: Texture, item_metadata: Dictionary):
	name = item_name
	icon = item_icon
	metadata = item_metadata
