extends Node3D

## Demonstrates all features of the Get Node By Type plugin.
## Run this scene and check the Output panel for results.

# --- @onready with Get: find nodes by type instead of by path ---
@onready var camera: Camera3D = Get.node_by_type(self, Camera3D, true)
@onready var light: DirectionalLight3D = Get.node_by_type(self, DirectionalLight3D, true)
@onready var all_labels: Array = Get.nodes_by_type(%UILayer, Label, true)

# --- Traditional approach for comparison ---
@onready var camera_by_path: Camera3D = $Camera3D


func _ready() -> void:
	_print_header("Get Node By Type - Example Scene")

	_test_single_node_lookup()
	_test_multi_node_lookup()
	_test_custom_class_lookup()
	_test_string_type_lookup()
	_test_recursive_vs_direct()
	_test_not_found()

	_print_header("Example Complete")

	var results_label: Label = Get.node_by_type(%ResultsContainer, Label)
	if results_label:
		results_label.text = "Done! Check the Output panel for results."


func _test_single_node_lookup() -> void:
	_print_header("1. Single Node Lookup — node_by_type()")

	var found_camera := Get.node_by_type(self, Camera3D, true)
	_log("Camera3D -> %s" % _describe(found_camera))

	var found_light := Get.node_by_type(self, DirectionalLight3D, true)
	_log("DirectionalLight3D -> %s" % _describe(found_light))


func _test_multi_node_lookup() -> void:
	_print_header("2. Multi Node Lookup — nodes_by_type()")

	var labels := Get.nodes_by_type(%UILayer, Label, true)
	_log("Labels in UILayer: %d found" % labels.size())
	for label in labels:
		_log("  - '%s' text='%s'" % [label.name, label.text.substr(0, 50)])

	var boxes := Get.nodes_by_type(self, CSGBox3D, true)
	_log("CSGBox3D in scene: %d found" % boxes.size())


func _test_custom_class_lookup() -> void:
	_print_header("3. Custom class_name Lookup")

	# Find a single custom component
	var comp := Get.node_by_type(%Entities, CustomComponent, true)
	_log("First CustomComponent -> %s" % _describe(comp))
	if comp:
		_log("  -> label='%s', value=%s" % [comp.label, comp.value])

	# Find all custom components
	var all_comps := Get.nodes_by_type(%Entities, CustomComponent, true)
	_log("All CustomComponents: %d found" % all_comps.size())
	for c in all_comps:
		_log("  - '%s' label='%s' value=%s" % [c.name, c.label, c.value])


func _test_string_type_lookup() -> void:
	_print_header("4. String Type Lookup")

	# Native type as string
	var found := Get.node_by_type(self, "Camera3D", true)
	_log("\"Camera3D\" (string) -> %s" % _describe(found))

	# Custom class_name as string
	var found_custom := Get.node_by_type(%Entities, "CustomComponent", true)
	_log("\"CustomComponent\" (string) -> %s" % _describe(found_custom))


func _test_recursive_vs_direct() -> void:
	_print_header("5. Recursive vs Direct Children")

	# Direct children of Entities — only finds top-level nodes
	var direct := Get.nodes_by_type(%Entities, CustomComponent, false)
	_log("Direct children of Entities: %d CustomComponents" % direct.size())

	# Recursive — finds nested components too
	var recursive := Get.nodes_by_type(%Entities, CustomComponent, true)
	_log("Recursive under Entities: %d CustomComponents" % recursive.size())

	# Direct children of root — Camera3D is a direct child
	var direct_camera := Get.node_by_type(self, Camera3D, false)
	_log("Camera3D (direct child of root): %s" % _describe(direct_camera))

	# Direct children of root — CustomComponent is NOT a direct child
	var direct_comp := Get.node_by_type(self, CustomComponent, false)
	_log("CustomComponent (direct child of root): %s" % _describe(direct_comp))


func _test_not_found() -> void:
	_print_header("6. Not Found — returns null / empty array")

	var missing := Get.node_by_type(self, AudioStreamPlayer3D, true)
	_log("AudioStreamPlayer3D -> %s" % _describe(missing))

	var empty := Get.nodes_by_type(self, AudioStreamPlayer3D, true)
	_log("All AudioStreamPlayer3D -> %d results" % empty.size())


# --- Helpers ---

func _describe(node: Node) -> String:
	if not node:
		return "null"
	return "'%s' (%s)" % [node.name, node.get_class()]


func _print_header(title: String) -> void:
	print("")
	print("=== %s ===" % title)


func _log(msg: String) -> void:
	print("  %s" % msg)
