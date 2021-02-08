class_name JumpCharm
extends InventoryItem


func _init():
	name = "JumpCharm"
	icon = preload("res://Inventory/items/jump_charm.png")


func _activate():
	var jump_node: ControllableCharacterJump = owner.get_node("ControllableCharacterJump")
	jump_node.extra_jumps = 1
	
	if owner.is_on_floor():
		jump_node.current_jumps = 1


func _deactivate():
	var jump_node: ControllableCharacterJump = owner.get_node("ControllableCharacterJump")
	jump_node.current_jumps = 0
	jump_node.extra_jumps = 0
