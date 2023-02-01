extends KinematicBody2D

var to_move : Vector2 = Vector2.ZERO
export var is_left = false

func _ready():
    pass

func _process(delta):
    if to_move != Vector2.ZERO and get_node("Attack").is_stopped():
#        if not test_move(transform, (to_move - position).normalized() * 500.0):
        translate((to_move - position).normalized() * 500.0 * delta)
        translate(Vector2(0.0, -1500.0) * delta)
        move_and_slide((to_move - position).normalized(), Vector2.UP)
        if to_move.distance_to(position) < 32.0 or get_node("Reset").is_stopped() or is_on_wall():
            to_move = Vector2.ZERO
#            print("cleared to zero")

    var hitting_data : KinematicCollision2D
    move_and_collide(Vector2(0.0, 20.0))
    if test_move(transform, (get_parent().get_node("Player").position - position).normalized() * delta * 10.0):
        hitting_data = move_and_collide((get_parent().get_node("Player").position - position).normalized() * delta * 10.0)
#    if get_parent().get_node("Player").vec_v != 0.0:
    if hitting_data != null and hitting_data.collider.has_method("damaged_by") and not is_queued_for_deletion():
        print("hit")
        var kb = Vector2.ZERO
        kb.y = 0.0
        kb.x += 1.0 * 48.0 * sign(position.x - get_parent().get_node("Player").position.x) * delta
        if position.y < get_parent().get_node("Player").position.y:
#            var stomp = position
##            stomp.y = 0.0
#            print("stomp")
#            stomp.y -= 48.0 * 6.0
#            stomp.x += sign((position - get_parent().get_node("Player").position).x) * 48.0
#            to_move = stomp
#            get_node("Attack").start(0.0)
#            get_node("Reset").start(0.5)
#            kb = Vector2.ZERO
            move_and_collide(Vector2(0.0, -48.0))
        get_parent().get_node("Player").damaged_by(1, kb)
#        to_move = (-get_parent().get_node("Player").position + position * 2.0) * 1.2
    
    move_and_slide(Vector2(0.0, 2.0), Vector2.UP)
    if get_node("RayCast2D").get_collider() is KinematicBody2D and to_move == Vector2.ZERO:
        get_node("Attack").start(0.2)
        var next_move = get_parent().get_node("Player").position - (position - get_parent().get_node("Player").position).normalized() * 20.0
        to_move = get_parent().get_node("Player").position
        get_node("Reset").start(3.0)
    elif not get_node("RayCast2D").get_collider() is KinematicBody2D and to_move == Vector2.ZERO and is_on_floor():
        get_node("Attack").start(1.0)
        if is_left:
            to_move = position
            to_move.x += -48.0 * 3.0
        elif not is_left:
            to_move = position
            to_move.x += 48.0 * 3.0
        is_left = not is_left
        get_node("Reset").start(3.0)
        
    if position.x > get_parent().get_node("Player").position.x:
        get_node("RayCast2D").rotation_degrees = 90.0
    else:
        get_node("RayCast2D").rotation_degrees = 270.0
