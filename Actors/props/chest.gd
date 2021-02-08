extends Area2D


var ui: CanvasLayer


func _ready():
	connect("body_entered", self, "_handle_body_entered")
	connect("body_exited", self, "_handle_body_exited")
	set_process_input(false)
	$CanvasLayer/TextureRect.hide()


func _handle_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		set_process_input(true)
		ui = GlobalData.yield_and_get_group("UI")[0]


func _handle_body_exited(body: Node) -> void:
	set_process_input(not body.is_in_group("Player"))
	$CanvasLayer/TextureRect.hide()
#	ui.get_node("RunInventory").show()


func _input(event):
	if event.is_action_pressed("interact"):
		$CanvasLayer/TextureRect.visible = not $CanvasLayer/TextureRect.visible
		$CanvasLayer/TextureRect.other_inventory = ui.get_node("RunInventory")
		$CanvasLayer/TextureRect.other_inventory.other_inventory = $CanvasLayer/TextureRect
#		var player_inventory: TextureRect = ui.get_node("RunInventory")
#		player_inventory.visible = not player_inventory.visible
