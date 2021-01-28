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


static func quad_formula(a: float, b: float, c: float, neg:=false) -> float:
	return (- b + (1.0 - 2 * float(neg)) * sqrt(b * b - 4 * a * c)) / 2 / a


# These may be useful in the future
#static func calc_polynomial(coeff: Array, x: float) -> float:
#	var sum: float
#
#	for i in range(coeff.size()):
#		sum += coeff[i] * pow(x, i)
#
#	return sum
#
#
#static func calc_derivative(coeff: Array, x: float) -> float:
#	var sum: float
#
#	for i in range(1, coeff.size()):
#		sum += coeff[i] * i * pow(x, i - 1)
#
#	return sum
#
#
#static func newton_solve(coeff: Array, x:=0.0, iterations:=10) -> float:
#	for i in range(iterations):
#		x -= calc_polynomial(coeff, x) / calc_derivative(coeff, x)
#
#	return x
