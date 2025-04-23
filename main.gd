extends Control

@onready var item_scene: PackedScene = preload("res://item.tscn")
@onready var items_list_scroll: Control = %ItemsListScroll
@onready var items_list: VBoxContainer = %ItemsList;
@onready var filter_input: LineEdit = %Search;

func _ready() -> void:
	Ass.on_files_filtered.connect(_files_updated)
	Ass.on_filter_changed.connect(_on_filter_changed)

	filter_input.text_changed.connect(_text_changed)

func _text_changed(text: String) -> void:
	Ass.set_filter(text)

func _on_filter_changed(_filter: String) -> void:
	for child in items_list.get_children():
		child.queue_free()

func _files_updated(new_items: Array[Dictionary]) -> void:
	# FIXME: 32 is a magic number, the min size for the Items
	var max_items = items_list_scroll.size.y / 32
	var changed = false

	for path in new_items:
		if items_list.get_child_count() >= max_items:
			break

		var item = item_scene.instantiate()
		items_list.add_child(item)
		changed = true

		item.setup(path)

	if not changed:
		return

	var children = items_list.get_children()
	children.sort_custom(func(a,b): return a.my_path.score > b.my_path.score)

	for child in children:
		items_list.remove_child(child)
		items_list.add_child(child)
