extends Node


func yield_and_get_group(group: String) -> Array:
	# this function allows a node to try and get the nodes in a group
	# it will wait until the group exists
	var tree := get_tree()
	
	while not tree.has_group(group):
		yield(tree, "node_added")
	
	return tree.get_nodes_in_group(group)


func _input(event):
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
	
	elif event.is_action_pressed("ui_cancel"):
		get_tree().quit()


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
