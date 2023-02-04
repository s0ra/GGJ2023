extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var spawn_ghost = false
var rat = preload("res://scenes/rat.tscn")
var spider = preload("res://scenes/spider.tscn")
var ghost = preload("res://scenes/ghost.tscn")
var spike = preload("res://scenes/spike.tscn")

var priestess = preload("res://scenes/priestess.tscn")
var priestess2 = preload("res://scenes/priestess2.tscn")
var priestess3 = preload("res://scenes/priestess3.tscn")

var minotaur = preload("res://scenes/minotaur.tscn")

var all_cleared : bool = false
var entered_boss_room : bool = false
var not_spawn_spider : bool = false
var special_boss : bool = false

var pool : Array = []
var level_count : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    seed(Time.get_unix_time_from_system())
    pool.resize(60)
    for i in range(60):
        pool[i] = i + 1
    pool.shuffle()
        
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    if get_node("Player").position.y > 48.0 * 24.0 * 14.0 and not all_cleared:
        all_cleared = true
    
    if get_node("Player").position.y > 48.0 * 24.0 * 15.5 and not entered_boss_room:
        entered_boss_room = true
#        get_node("TileMap").set_cell(9, 24 * 15 + 10, 0)
#        get_node("TileMap").set_cell(10,  24 * 15 + 10, 0)
#        get_node("TileMap").set_cell(11, 24 * 15 + 10, 0)
        get_node("Player/BGM").stop()
        get_node("Player/BossMusic").play()
        var new_minotaur = minotaur.instance()
        new_minotaur.position = Vector2(float(13) * 48.0 + 24.0,  48.0 * 24.0 * 15.8 + 24.0)
        if special_boss:
            new_minotaur.special = true
        add_child(new_minotaur)
    
    if get_node("TileMap").get_cell(5, int(stepify(get_node("Player").position.y / 48.0, 48.0)) + 1) == -1 and get_node("Player").position.y > 0.0 and get_node("Player").position.y > get_node("Player").last_depth and not all_cleared:
#        for x in range(11):
#            for y in range(50):
#                get_node("TileMap").set_cell(x + 5, y + int(float(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) - 96), -1)

        var level_id = pool[level_count]
        level_count += 1
        
        print(ceil(get_node("Player").position.y / (24.0 * 48.0)) / 2)
        var scene = load("res://scenes/rooms/room" + str(level_id) + ".tscn").instance()
        var tilemap = scene.get_node("TileMap")
        var roll_wall = randi() % 100 
        var roll_monster = randi() % 100
        
        
        if ceil(get_node("Player").position.y / (24.0 * 48.0)) / 2 == 4:
            scene.free()
            scene = load("res://scenes/rooms/room" + "_pow" + ".tscn").instance()
            tilemap = scene.get_node("TileMap")
        
#        print("level " + str(ceil(get_node("Player").position.y / (24.0 * 48.0))))
            
        for x in range(11):
            for y in range(25):
                var cell : int = tilemap.get_cell(x + 5, y)
                if cell == 0:
                    get_node("TileMap").set_cell(x + 5, int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) + y, 0)
                else:
                    get_node("TileMap").set_cell(x + 5, int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) + y, 3)
                if cell == 1:
                    var new_rat = rat.instance()
                    new_rat.position = Vector2(float(x + 5) * 48.0 + 24.0, float(int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) + y) * 48.0 + 24.0)
                    if not tilemap.is_cell_x_flipped(x + 5, y):
                        new_rat.is_left = true
                    add_child(new_rat)
                if cell == 4 and not not_spawn_spider:
                    var new_spider = spider.instance()
                    new_spider.position = Vector2(float(x + 5) * 48.0 + 24.0, float(int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) + y) * 48.0 + 24.0)
                    add_child(new_spider)
                if cell == 5:
                    var new_ghost = ghost.instance()
                    new_ghost.position = Vector2(float(x + 5) * 48.0 + 24.0, float(int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) + y) * 48.0 + 24.0)
                    add_child(new_ghost)
                if cell == 2:
                    var new_spike = spike.instance()
                    new_spike.position = Vector2(float(x + 5) * 48.0 + 24.0, float(int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) + y) * 48.0 + 24.0)
                    add_child(new_spike)
                if cell == 7 and roll_monster > 20:
                    var new_rat = rat.instance()
                    new_rat.position = Vector2(float(x + 5) * 48.0 + 24.0, float(int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) + y) * 48.0 + 24.0)
                    if not tilemap.is_cell_x_flipped(x + 5, y):
                        new_rat.is_left = true
                    add_child(new_rat)
                if cell == 9 and roll_monster > 20:
                    var new_ghost = ghost.instance()
                    new_ghost.position = Vector2(float(x + 5) * 48.0 + 24.0, float(int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) + y) * 48.0 + 24.0)
                    add_child(new_ghost)
                if cell == 8 and roll_monster > 20 and not not_spawn_spider:
                    var new_spider = spider.instance()
                    new_spider.position = Vector2(float(x + 5) * 48.0 + 24.0, float(int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) + y) * 48.0 + 24.0)
                    add_child(new_spider)
                if cell == 6 and roll_wall > 50:
                    get_node("TileMap").set_cell(x + 5, int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) + y, 0)
                if cell == 11:
                    var new_priestess2 = priestess2.instance()
                    new_priestess2.position = Vector2(float(x + 5) * 48.0 + 24.0, float(int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) + y) * 48.0 + 24.0)
                    add_child(new_priestess2)
                if cell == 12:
                    var new_priestess3 = priestess3.instance()
                    new_priestess3.position = Vector2(float(x + 5) * 48.0 + 24.0, float(int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) + y) * 48.0 + 24.0)
                    add_child(new_priestess3)
                    
        tilemap.queue_free()
        scene.queue_free()
        tilemap.free()
        scene.free()
        
    if get_node("TileMap").get_cell(5, int(stepify(get_node("Player").position.y / 48.0, 48.0)) + 24 + 1) == -1 and get_node("Player").position.y > 0.0 and get_node("Player").position.y > get_node("Player").last_depth and not all_cleared:
        var level_id = pool[level_count]
        level_count += 1
#        print(level_id)

        var scene2 = load("res://scenes/rooms/room" + str(level_id) + ".tscn").instance()
        var tilemap2 = scene2.get_node("TileMap")
        print(ceil(get_node("Player").position.y / (24.0 * 48.0)) / 2)
        if ceil(get_node("Player").position.y / (24.0 * 48.0)) / 2 == 7:
            scene2.free()
            scene2 = load("res://scenes/rooms/room" + "_boss" + ".tscn").instance()
            tilemap2 = scene2.get_node("TileMap")
        
        var roll_wall = randi() % 100 
        var roll_monster = randi() % 100
        
        for x in range(11):
            for y in range(25):
                var cell : int = tilemap2.get_cell(x + 5, y)
                if cell == 0:
                    get_node("TileMap").set_cell(x + 5, int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) + y + 24, 0)
                else:
                    get_node("TileMap").set_cell(x + 5, int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) + y + 24, 3)
                if cell == 1:
                    var new_rat = rat.instance()
                    new_rat.position = Vector2(float(x + 5) * 48.0 + 24.0, float(int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) + y + 24.0) * 48.0 + 24.0)
                    if not tilemap2.is_cell_x_flipped(x + 5, y):
                        new_rat.is_left = true
                    add_child(new_rat)
                if cell == 4 and not not_spawn_spider:
                    var new_spider = spider.instance()
                    new_spider.position = Vector2(float(x + 5) * 48.0 + 24.0, float(int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) + y + 24.0) * 48.0 + 24.0)
                    add_child(new_spider)
                if cell == 5:
                    var new_ghost = ghost.instance()
                    new_ghost.position = Vector2(float(x + 5) * 48.0 + 24.0, float(int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) + y + 24.0) * 48.0 + 24.0)
                    add_child(new_ghost)
                if cell == 2:
                    var new_spike = spike.instance()
                    new_spike.position = Vector2(float(x + 5) * 48.0 + 24.0, float(int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) + y + 24.0) * 48.0 + 24.0)
                    add_child(new_spike)
                if cell == 7 and roll_monster > 20:
                    var new_rat = rat.instance()
                    new_rat.position = Vector2(float(x + 5) * 48.0 + 24.0, float(int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) + y + 24.0) * 48.0 + 24.0)
                    if not tilemap2.is_cell_x_flipped(x + 5, y):
                        new_rat.is_left = true
                    add_child(new_rat)
                if cell == 9 and roll_monster > 20:
                    var new_ghost = ghost.instance()
                    new_ghost.position = Vector2(float(x + 5) * 48.0 + 24.0, float(int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) + y + 24.0) * 48.0 + 24.0)
                    add_child(new_ghost)
                if cell == 8 and roll_monster > 20 and not not_spawn_spider:
                    var new_spider = spider.instance()
                    new_spider.position = Vector2(float(x + 5) * 48.0 + 24.0, float(int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) + y + 24.0) * 48.0 + 24.0)
                    add_child(new_spider)
                if cell == 6 and roll_wall > 50:
                    get_node("TileMap").set_cell(x + 5, int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0 + 24.0) + y, 0)
                if cell == 10:
                    var new_priestess = priestess.instance()
                    new_priestess.position = Vector2(float(x + 5) * 48.0 + 24.0, float(int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) + y + 24.0) * 48.0 + 24.0)
                    add_child(new_priestess)
                    
        tilemap2.queue_free()
        scene2.queue_free()
        tilemap2.free()
        scene2.free()
#        for i in range(40):
#            for j in range(24):
#                get_node("TileMap").set_cell(i, int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0) + j, get_node("TileMap").get_cell(i, j))
#        for i in range(40):
#            for j in range(24):
#                get_node("TileMap").set_cell(i, int(ceil(get_node("Player").position.y / (24.0 * 48.0)) * 24.0 + 24) + j, get_node("TileMap").get_cell(i, j))

#    if spawn_ghost:
#        spawn_ghost = false
#        for i in range(6):
#            var new_ghost = get_node("Ghost").duplicate()
#            add_child(new_ghost)
#            new_ghost.position.x += 10.0 * i
            
#    get_node("Block").position.y = stepify(get_node("Player").last_depth - 2000.0, 48.0) - 72.0
