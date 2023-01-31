extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var on_ground : bool = false
var vec_v : float = 0.0
var was_pulling : bool = false

var jumped : bool = false
var is_pressing_jump : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _process(delta):    
    var has_moved : bool = false
    
    if (get_node("RayCast2D1").is_colliding() or get_node("RayCast2D2").is_colliding()):
        vec_v = 0.0
        on_ground = true
        jumped = false
        get_node("Sword").rotation_degrees = 0.0
        get_node("Sword").position.x = 5.0
        get_node("Sword").position.y = 0.0
    else:
        on_ground = false
        vec_v += 6.0
        has_moved = true
        get_node("Sword").rotation_degrees = 135.0
        get_node("Sword").position.x = 0.0
        get_node("Sword").position.y = 25.0
    
    if Input.is_action_pressed("action_left") and on_ground and not was_pulling:
        move_and_collide(Vector2(-10.0, 0.0))
        has_moved = true
    if Input.is_action_pressed("action_left") and not on_ground and not was_pulling:
        move_and_collide(Vector2(-8.0, 0.0))
        has_moved = true
    if Input.is_action_pressed("action_right") and on_ground and not was_pulling:
        move_and_collide(Vector2(10.0, 0.0))
        has_moved = true
    if Input.is_action_pressed("action_right") and not on_ground and not was_pulling:
        move_and_collide(Vector2(8.0, 0.0))
        has_moved = true
    if Input.is_action_pressed("action_pulled"):
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
        get_node("Sword").position.x = 0.0
        get_node("Sword").position.y = 0.0
        get_node("Sword").look_at(get_parent().get_node("Path").rope.back())
        get_node("Sword").rotation_degrees += 45.0
        has_moved = false
    if not Input.is_action_pressed("action_jump") and was_pulling and not is_pressing_jump:
        was_pulling = false
    if not Input.is_action_pressed("action_jump"):
        is_pressing_jump = false
    if Input.is_action_just_pressed("action_jump") and on_ground and not was_pulling:
        vec_v -= 60.0
        is_pressing_jump = true
        on_ground = false
        has_moved = true
        jumped = true
        
    if has_moved and get_parent().get_node("Path").rope.size() > 0:
        var last_moved : Vector2 = get_parent().get_node("Path").rope.back()
        for i in range(int(position.distance_to(last_moved) / 2.0)):
            get_parent().get_node("Path").add_rope_point(last_moved.linear_interpolate(position, float(i) / int((position.distance_to(last_moved) / 2.0))))
    
    move_and_collide(Vector2(0.0, vec_v))
    
    get_node("Camera2D").global_position.x = get_viewport().size.x / 2.0
    
    if get_node("Sword/RayCast2D").get_collider() != null:
        if get_node("Sword/RayCast2D").get_collider() is KinematicBody2D:
            print(true)
            get_node("Sword/RayCast2D").get_collider().queue_free()
