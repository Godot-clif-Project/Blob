class_name JumpCharm
extends InventoryItem


func _init():
	icon = preload("res://Inventory/items/jump_charm.png")


func _activate():
	owner.get_node("ControllableCharacterJump").extra_jumps = 1


func _deactivate():
	owner.get_node("ControllableCharacterJump").extra_jumps = 0
