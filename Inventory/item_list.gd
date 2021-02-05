# Singleton for items (known as GlobalItemList)
extends Node


# Add pre-existing items here
var items := {
	"JumpCharm": JumpCharm
}


func get_item(item_name: String) -> InventoryItem:
	return items[item_name].new()
