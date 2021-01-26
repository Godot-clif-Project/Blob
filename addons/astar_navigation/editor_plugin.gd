tool
extends EditorPlugin


var plugin: EditorInspectorPlugin = preload("inspector_plugin.gd").new()


func _enter_tree():
	add_inspector_plugin(plugin)


func _exit_tree():
	remove_inspector_plugin(plugin)
