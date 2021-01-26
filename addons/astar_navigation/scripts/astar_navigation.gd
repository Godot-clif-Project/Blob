class_name AStarNavigation
extends Node


enum Dimensions {TWO_DIMENSIONAL, THREE_DIMENSIONAL}

export(Dimensions) var dimension := Dimensions.TWO_DIMENSIONAL

var nodes: Dictionary

onready var a_star = AStar2D.new() if dimension == Dimensions.TWO_DIMENSIONAL else AStar.new()


func _ready():
	update_nodes()


func update_nodes() -> void:
	a_star.clear()
	var tmp_nodes := _get_nodes()
	
	for node in tmp_nodes:
		node.id = a_star.get_available_point_id()
		a_star.add_point(node.id, node.global_transform.origin)
		nodes[node.id] = node
	
	for node in tmp_nodes:
		for link in node.links:
			a_star.connect_points(node.id, link.id)


func update_node_position(node: LinkedNode) -> void:
	a_star.set_point_position(node.id, node.global_transform.origin)


func get_id_path(start, end) -> PoolIntArray:
	var id_path: PoolIntArray = a_star.get_id_path(a_star.get_closest_point(start), a_star.get_closest_point(end))
	
	var start_segment := get_closest_segment(start)
	if id_path.size() > 1 and not start_segment.empty() and start_segment[1] == id_path[1]:
		# removes the first point in the path of it is behind the start
		# ie. if the start_segment is pointing to the next point after
		id_path.remove(0)
	
	var end_segment := get_closest_segment(end)
	if not end_segment.empty():
		# remove the last point IF
		# the start and end are in the same segment OR
		# the last node is past the end (backtracking)
		if (not start_segment.empty() and (end_segment == start_segment or (end_segment[1] == start_segment[0] and end_segment[0] == start_segment[1]))) or \
		(id_path.size() > 1 and (id_path[-1] == end_segment[0] and id_path[-2] == end_segment[1])):
			id_path.remove(id_path.size() - 1)
	
	return id_path


func id_path_to_vector_path(id_path: PoolIntArray):
	var path = PoolVector2Array() if dimension == Dimensions.TWO_DIMENSIONAL else PoolVector3Array()
	
	for id in id_path:
		path.append(a_star.get_point_position(id))
	
	return path


func get_simple_path(start, end):
	var path = id_path_to_vector_path(get_id_path(start, end))
	path.insert(0, start)
	path.append(end)
	return path


func get_actual_node(idx: int) -> LinkedNode:
	return nodes[idx]


func get_closest_point(to_point):
	return a_star.get_closest_position_in_segment(to_point)


func get_closest_segment(position) -> PoolIntArray:
	var closest_id: int = a_star.get_closest_point(position)
	var closest_point = a_star.get_point_position(closest_id)
	var rel_vec = (position - closest_point).normalized()
	
	var highest := - INF
	var highest_id := closest_id
	
	for id in a_star.get_point_connections(closest_id):
		var product: float = rel_vec.dot((a_star.get_point_position(id) - closest_point).normalized())
		
		if product > highest:
			highest = product
			highest_id = id
	
	return PoolIntArray([closest_id, highest_id])


func _get_nodes(node=self) -> Array:
	var children: Array
	
	for child in node.get_children():
		if child is LinkedNode:
			children.append(child)
			children += _get_nodes(child)
	
	return children
