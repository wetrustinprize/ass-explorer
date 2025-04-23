extends Control

@onready var item_scene: PackedScene = preload("res://item.tscn")
@onready var items_list_scroll: Control = %ItemsListScroll
@onready var items_list: VBoxContainer = %ItemsList;

func _ready() -> void:
    Ass.on_files_updated.connect(_files_updated)
    Ass.on_path_changed.connect(_path_changed)

func _path_changed(_path: String) -> void:
    pass

func _files_updated(new_items: Array[String]) -> void:
    # FIXME: 32 is a magic number, the min size for the Items
    var max_items = items_list_scroll.size.y / 32

    for path in new_items:
        if items_list.get_child_count() >= max_items:
            break

        var item: Item = item_scene.instantiate()
        items_list.add_child(item)

        item.setup(path)