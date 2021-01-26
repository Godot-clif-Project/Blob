extends EditorProperty


var to_node_paths: Array
var menu := MenuButton.new()
var popup := menu.get_popup()

onready var node: LinkedNode = get_edited_object()


func _ready():
#	var remove: Array
#	for path in node.link_paths:
#		if node.get_node_or_null(path) == null:
#			remove.append(path)
#
#	var new_link_paths := node.link_paths.duplicate()
#	for path in remove:
#		new_link_paths.erase(path)
#
#	emit_changed("link_paths", new_link_paths)
	
	if node.get_parent() is LinkedNode:
		to_node_paths.append("..")
	
	for to_node in node.get_parent().get_children():
		if to_node != node and to_node is LinkedNode:
			to_node_paths.append(node.get_path_to(to_node))
	
	for to_node in node.get_children():
		if to_node is LinkedNode:
			to_node_paths.append(to_node.name)
	
	popup.hide_on_checkable_item_selection = false
	popup.connect("index_pressed", self, "_handle_checked")
	for i in range(to_node_paths.size()):
		var path: NodePath = to_node_paths[i]
		popup.add_check_item(path)
		if path in node.link_paths:
			popup.set_item_checked(i, true)
	
	menu.text = "Edit Links"
	add_child(menu)


func _handle_checked(idx: int) -> void:
	var new_link_paths := node.link_paths.duplicate()
	var path: NodePath = to_node_paths[idx]
	
	if popup.is_item_checked(idx):
		popup.set_item_checked(idx, false)
		if path in new_link_paths:
			new_link_paths.erase(path)
	
	else:
		popup.set_item_checked(idx, true)
		if not path in new_link_paths:
			new_link_paths.append(path)
	
	emit_changed("link_paths", new_link_paths)
