extends Node

var new_path: String = Ass.path
var find_cache: Array[String] = []

var thread: Thread
var kill_thread: bool = false
var find_pid: int = -1

func _ready() -> void:
    thread = Thread.new()
    thread.start(_thread_seek)

func _exit_tree() -> void:
    kill_thread = true
    thread.wait_to_finish()

func _thread_seek():
    var execute_dict: Dictionary = {}

    while true:
        if kill_thread:
            if find_pid != -1:
                OS.kill(find_pid)
            break

        if not new_path.is_empty():
            var path = new_path
            new_path = ""

            if find_pid != -1:
                OS.kill(find_pid)
            find_pid = -1
            find_cache = []

            # FIXME: Make this compatible with other OS
            execute_dict = OS.execute_with_pipe("find", [path]);

            if not execute_dict.is_empty():
                find_pid = execute_dict.pid
        
        if not execute_dict.is_empty():
            var text = execute_dict.stdio.get_line()

            if not text.is_empty():
                find_cache.append(text)