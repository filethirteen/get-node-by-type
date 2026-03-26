@tool
extends Node
## Get components by class_name or native class type
##
## Allows you to get a node by class_name or native class type instead of using 
## get_node() with a path (or the shorthand with $), using a unique name, or by manually 
## assigning references using the inspector.

func _matches_type(node: Node, type_ref) -> bool:
	if typeof(type_ref) == TYPE_STRING:
		var script := node.get_script()
		if script and script.get_global_name() == type_ref:
			return true
		return node.is_class(type_ref)
	else:
		if is_instance_of(node, type_ref):
			return true
	return false

## Get a node by type, search direct children of searchRoot. Returns the first node of type 
## type_ref. Like Unity's GetComponent<T>().
## recursive = true is like Unity's GetComponentInChildren<T>().
func node_by_type(searchRoot: Node, type_ref, recursive: bool = false) -> Node:
	if not searchRoot:
		return null
	
	if recursive:
		for node in searchRoot.find_children("*", "", true):
			if _matches_type(node, type_ref):
				return node
	else:
		for node in searchRoot.get_children():
			if _matches_type(node, type_ref):
				return node
	return null

## Get an array of nodes by type, search only direct children of searchRoot. 
## Like Unity's GetComponents<T>().
## recursive = true is like Unity's GetComponentsInChildren<T>().
func nodes_by_type(searchRoot: Node, type_ref, recursive: bool = false) -> Array:
	if not searchRoot:
		return []
		
	var results: Array = []
	if recursive:
		for node in searchRoot.find_children("*", "", true):
			if _matches_type(node, type_ref):
				results.append(node)
	else:
		for node in searchRoot.get_children():
			if _matches_type(node, type_ref):
				results.append(node)
	return results
