extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var on_ground : bool = false
var vec_v : float = 0.0
var was_pulling : bool = false

var jumped : bool = false
var is_pressing_jump : bool = false

var has_moved : bool = false
var last_depth : float = 0.0

var old_mask
var old_layer

export var max_hp : int = 5
export var hp : int = 5

var game_over : bool = false

var has_shield : bool = false
var is_shield : bool = false

var double_jump : bool = false
var second_jump : bool = false
var third_jump : bool = false

func _ready():
    old_mask = collision_mask
    old_layer = collision_layer
#    get_node("GameStart").play()

func _physics_process(delta):
    has_moved = false
    get_node("Sword/Sprite").flip_h = false
    get_node("Sword/Sprite").position.x = 5.0
    
    if is_on_ceiling() and vec_v < 0.0:
        vec_v = 0.0
    
    if (get_node("RayCast2D1").is_colliding() or get_node("RayCast2D2").is_colliding()):
        vec_v = 0.0
        on_ground = true
        jumped = false
        second_jump = true
        third_jump = false
        get_node("Sword").rotation_degrees = 0.0
        get_node("Sword").position.x = 5.0
        get_node("Sword").position.y = 0.0
    else:
        on_ground = false
        if vec_v < 80.0:
            vec_v += 6.0
        has_moved = true
        second_jump = false
        get_node("Sword").rotation_degrees = 135.0
        get_node("Sword").position.x = 0.0
        get_node("Sword").position.y = 25.0
    
    
        
    if not game_over and double_jump and not third_jump and Input.is_action_just_pressed("action_jump") and not on_ground and not second_jump and not was_pulling:
        vec_v = -60.0
        get_node("Jump").play()
        has_moved = true
        jumped = true
        second_jump = true
        third_jump = true
        
    if not game_over and (Input.is_action_pressed("action_left") or Input.is_action_pressed("_action_left")) and on_ground and not was_pulling:
        move_and_collide(Vector2(-10.0, 0.0))
        get_node("Sword/Sprite").flip_h = true
        get_node("Sword/Sprite").position.x = -5.0
        has_moved = true
    if not game_over and (Input.is_action_pressed("action_left") or Input.is_action_pressed("_action_left")) and not on_ground and not was_pulling:
        move_and_collide(Vector2(-8.0, 0.0))
        has_moved = true
    if not game_over and (Input.is_action_pressed("action_right") or Input.is_action_pressed("_action_right")) and on_ground and not was_pulling:
        move_and_collide(Vector2(10.0, 0.0))
        has_moved = true
    if not game_over and (Input.is_action_pressed("action_right") or Input.is_action_pressed("_action_right")) and not on_ground and not was_pulling:
        move_and_collide(Vector2(8.0, 0.0))
        has_moved = true
    if not game_over and not Input.is_action_pressed("action_jump") and was_pulling and not is_pressing_jump:
        was_pulling = false
    if not game_over and last_depth < position.y:
        last_depth = position.y
    if not game_over and Input.is_action_pressed("action_pulled") and get_parent().get_node("Path").rope.size() > 1: # and stepify(last_depth - 2000.0, 48.0) < position.y:
        was_pulling = true
        vec_v = 0.0
        get_parent().get_node("Path").rope_pulling()
        get_parent().get_node("Path").rope_pulling()
        get_parent().get_node("Path").rope_pulling()
        get_parent().get_node("Path").rope_pulling()
        get_parent().get_node("Path").rope_pulling()
        get_parent().get_node("Path").rope_pulling()
        get_parent().get_node("Path").rope_pulling()
        get_parent().get_node("Path").rope_pulling()
        get_parent().get_node("Path").rope_pulling()
        get_parent().get_node("Path").rope_pulling()
        get_parent().get_node("Path").rope_pulling()
        
        get_parent().get_node("Path").rope_pulling()
        get_parent().get_node("Path").rope_pulling()
        get_parent().get_node("Path").rope_pulling()
        get_parent().get_node("Path").rope_pulling()
        get_parent().get_node("Path").rope_pulling()
        get_parent().get_node("Path").rope_pulling()
        get_parent().get_node("Path").rope_pulling()
        get_parent().get_node("Path").rope_pulling()
        get_parent().get_node("Path").rope_pulling()
        get_parent().get_node("Path").rope_pulling()
        get_parent().get_node("Path").rope_pulling()
        
        get_parent().get_node("Path").rope_pulling()
        get_parent().get_node("Path").rope_pulling()
        get_parent().get_node("Path").rope_pulling()
        get_parent().get_node("Path").rope_pulling()
        get_parent().get_node("Path").rope_pulling()
        
        get_node("Sword").position.x = 0.0
        get_node("Sword").position.y = 0.0
        get_node("Sword").look_at(get_parent().get_node("Path").rope[get_parent().get_node("Path").rope_count - 1])
        get_node("Sword").rotation_degrees += 45.0
        has_moved = false
    if not game_over and not Input.is_action_pressed("action_jump"):
        is_pressing_jump = false
        
    if not game_over and has_moved and get_parent().get_node("Path").rope.size() > 0:
        var last_moved : Vector2 = get_parent().get_node("Path").rope[get_parent().get_node("Path").rope_count - 1]
        for i in range(int(position.distance_to(last_moved) / 1.0)):
            get_parent().get_node("Path").add_rope_point(last_moved.linear_interpolate(position, float(i) / int((position.distance_to(last_moved) / 1.0))))
    
    if not game_over and not is_pressing_jump and Input.is_action_just_pressed("action_jump") and on_ground and not was_pulling:
        vec_v -= 60.0
        get_node("Jump").play()
        is_pressing_jump = true
        on_ground = false
        has_moved = true
        jumped = true
    
    if Input.is_action_just_pressed("action_restart") or Input.is_action_just_pressed("_action_restart"):
        get_tree().reload_current_scene()
    
    move_and_collide(Vector2(0.0, vec_v))
    
    get_node("Camera2D").global_position.x = get_viewport().size.x / 2.0
#    get_node("Camera2D").position.y = max(position.y, last_depth - 2000.0 + get_viewport_rect().size.y / 2.0)
    
    if get_node("Sword/RayCast2D1").get_collider() != null and ((not on_ground and vec_v > 0.0) or was_pulling):
        if get_node("Sword/RayCast2D1").get_collider() is KinematicBody2D:
            print(true)
            get_node("Sword/RayCast2D1").get_collider().take_damage(1)
            get_node("Punch").play()
    
    if get_node("Sword/RayCast2D2").get_collider() != null and ((not on_ground and vec_v > 0.0) or was_pulling):
        if get_node("Sword/RayCast2D2").get_collider() is KinematicBody2D:
            print(true)
            get_node("Sword/RayCast2D2").get_collider().take_damage(1)
            get_node("Punch").play()
    
    if get_node("Sword/RayCast2D3").get_collider() != null and ((not on_ground and vec_v > 0.0) or was_pulling):
        if get_node("Sword/RayCast2D3").get_collider() is KinematicBody2D:
            print(true)
            get_node("Sword/RayCast2D3").get_collider().take_damage(1)
            get_node("Punch").play()
            
#    if not get_node("Invincibility").is_stopped() and collision_mask != 4:
#        old_mask = collision_mask
#        old_layer = collision_layer
#        collision_mask = 4
#        collision_layer = 4
#    elif get_node("Invincibility").is_stopped():
#        collision_mask = old_mask
#        collision_layer = old_layer
    if hp <= 0 and not game_over:
        get_node("GameOver").play()
        game_over = true
        get_parent().get_node("CanvasLayer/GameOver").visible = true
    
    if has_shield and get_node("ShieldTime").is_stopped() and not is_shield:
        is_shield = true
    
    update()

func damaged_by(damage : int, hit_dir : Vector2):
    if get_node("Invincibility").is_stopped() and not is_shield:
        get_node("Hurt").play()
        hp -= damage
#        print(hp)
        get_parent().get_node("CanvasLayer/HP").text = "HP: " + str(hp)
        get_node("Invincibility").start(0.75)
        if not test_move(transform, -hit_dir * 100.0):
            move_and_collide(-hit_dir * 100.0)
    if is_shield:
        get_node("ShieldTime").start(3.0)
        is_shield = false
#        else:
#            translate(hit_dir * 100.0)

func _draw():
    if is_shield:
        draw_arc(Vector2.ZERO, 24.0, 0.0, 360.0, 360, Color.white, 0.2)
