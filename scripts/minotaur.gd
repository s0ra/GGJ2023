extends KinematicBody2D

var to_move : Vector2 = Vector2.ZERO
var go_up = false
var is_left = true

var is_ghost = true

var hp = 3

func _ready():
    get_node("Mode").start(3.0)
    pass

func _physics_process(delta):
    var hitting_data : KinematicCollision2D
    translate((get_parent().get_node("Player").position - position).normalized() * delta * 200.0)
    hitting_data = move_and_collide((get_parent().get_node("Player").position - position).normalized() * 1.0)
#    if get_parent().get_node("Player").vec_v != 0.0:
    if get_node("Invincibility").is_stopped() and hitting_data != null and hitting_data.collider.has_method("damaged_by") and not is_queued_for_deletion():
        var kb = Vector2.ZERO
        kb.y = 0.0
        kb.x += 1.0 * 48.0 * sign(position.x - get_parent().get_node("Player").position.x) * delta
        
        get_parent().get_node("Player").damaged_by(1, kb)
        to_move = (-get_parent().get_node("Player").position + position * 2.0) * 1.2
        to_move.y = min(to_move.y, get_parent().get_node("Player").position.y)
    
    if is_ghost and to_move != Vector2.ZERO:
        translate((to_move - position).normalized() * 500.0 * delta)
        if to_move.distance_to(position) < 1.0:
            to_move = Vector2.ZERO
   
    if not is_ghost:
        move_and_collide(Vector2(0.0, 20.0))
        
    if not is_ghost and get_node("RayCast2D").get_collider() is KinematicBody2D and to_move == Vector2.ZERO:
        get_node("Attack").start(0.2)
        var next_move = get_parent().get_node("Player").position - (position - get_parent().get_node("Player").position).normalized() * 20.0
        to_move = get_parent().get_node("Player").position
        get_node("Reset").start(3.0)
    elif not is_ghost and not get_node("RayCast2D").get_collider() is KinematicBody2D and to_move == Vector2.ZERO and is_on_floor():
        get_node("Attack").start(1.0)
        if is_left:
            to_move = position
            to_move.x += -48.0 * 2.0
        elif not is_left:
            to_move = position
            to_move.x += 48.0 * 2.0
        is_left = not is_left
        get_node("Reset").start(3.0)
        
    if position.x > get_parent().get_node("Player").position.x:
        get_node("RayCast2D").rotation_degrees = 90.0
    else:
        get_node("RayCast2D").rotation_degrees = 270.0
    
    if not get_node("Invincibility").is_stopped():
        collision_layer = 0
    elif is_ghost:
        collision_layer = 2
    elif not is_ghost:
        collision_layer = 4
        
    if get_node("Mode").is_stopped() and get_parent().get_node("TileMap").get_cell(get_parent().get_node("TileMap").world_to_map(position).x, get_parent().get_node("TileMap").world_to_map(position).y) == 3:
        is_ghost = not is_ghost
        get_node("Mode").start(6.0)
#        print("changed")

        
func take_damage(damage):
    if get_node("Invincibility").is_stopped():
        collision_layer = 0
        hp -= damage
#        print("hit boss")
        get_node("Invincibility").start(3.0)
        if hp <= 0:
            get_parent().get_node("CanvasLayer/YouWin").visible = true
            queue_free()
