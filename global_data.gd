extends Node


signal player_changed
signal navigation_changed

var player: Character2D setget set_player
var navigation setget set_navigation
var enemies: Array


func set_player(node: Character2D) -> void:
	player = node
	emit_signal("player_changed")


func set_navigation(node) -> void:
	navigation = node
	emit_signal("navigation_changed")
