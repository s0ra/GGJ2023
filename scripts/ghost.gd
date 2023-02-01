extends KinematicBody2D

var to_move : Vector2 = Vector2.ZERO

func _ready():
    pass

func _physics_process(delta):
    var hitting_data : KinematicCollision2D
    translate((get_parent().get_node("Player").position - position).normalized() * delta * 200.0)
    hitting_data = move_and_collide((get_parent().get_node("Player").position - position).normalized() * 1.0)
#    if get_parent().get_node("Player").vec_v != 0.0:
    if hitting_data != null and hitting_data.collider.has_method("damaged_by") and not is_queued_for_deletion():
        get_parent().get_node("Player").damaged_by(1, (position - get_parent().get_node("Player").position) * delta)
        to_move = (-get_parent().get_node("Player").position + position * 2.0) * 1.2
    
    if to_move != Vector2.ZERO:
        translate((to_move - position).normalized() * 500.0 * delta)
        if to_move.distance_to(position) < 1.0:
            to_move = Vector2.ZERO
            
    if not get_node("VisibilityNotifier2D").is_on_screen():
        queue_free()
        
