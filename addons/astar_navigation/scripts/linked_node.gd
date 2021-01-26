class_name LinkedNode
extends Node


export(Array, NodePath) var link_paths: Array

var links: Array
var id: int


func _ready():
	for i in range(link_paths.size()):
		var to_node: LinkedNode = get_node(link_paths[i])
		
		if not to_node in links:
			links.append(to_node)
		
		if not self in to_node.links:
			to_node.links.append(self)
