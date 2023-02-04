extends Area2D

var hit_player : bool = false
var entered : bool = false

func _ready():
    pass

func _physics_process(delta):
    if get_node("Reset").is_stopped() and get_node("SpikeUp").is_stopped():
        get_node("Sprite").frame = 0
    elif not get_node("Reset").is_stopped() and not get_node("SpikeUp").is_stopped():
        get_node("Sprite").frame = 1
    elif not get_node("Reset").is_stopped() and get_node("SpikeUp").is_stopped():
        get_node("Sprite").frame = 2
        if entered:
            var kb = Vector2.ZERO
            kb.y = 0.0
            kb.x += 1.0 * 48.0 * sign(position.x - get_parent().get_node("Player").position.x) * delta
            get_parent().get_node("Player").damaged_by(1, kb)
            print("hit by spike")
            
#    if not get_node("VisibilityNotifier2D").is_on_screen():
#        queue_free()

func _on_Spike_body_entered(body):
    if body.has_method("damaged_by"):
        print("entered spike")
        entered = true
    
        if get_node("Reset").is_stopped():
            get_node("SpikeUp").start(1.0)
            get_node("Reset").start(1.5)

func _on_Spike_body_exited(body):
    if body.has_method("damaged_by"):
        entered = false
