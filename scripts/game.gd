extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var spawn_ghost = false

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if get_node("TileMap").get_cell(5, int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 25.0)) == -1:
        print(int(ceil(get_node("Player").position.y / (24.0 * 48.0))))
        for i in range(40):
            for j in range(24):
                get_node("TileMap").set_cell(i, int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) + j, get_node("TileMap").get_cell(i, j))
        for i in range(40):
            for j in range(24):
                get_node("TileMap").set_cell(i, int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0 + 24) + j, get_node("TileMap").get_cell(i, j))
    if spawn_ghost:
        spawn_ghost = false
        for i in range(6):
            var new_ghost = get_node("Ghost").duplicate()
            add_child(new_ghost)
            new_ghost.position.x += 10.0 * i
            
    get_node("Block").position.y = stepify(get_node("Player").last_depth - 2000.0, 48.0) - 72.0
