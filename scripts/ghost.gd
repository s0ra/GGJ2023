extends KinematicBody2D


func _ready():
    pass

func _process(delta):
    move_and_collide((get_parent().get_node("Player").position - position) * delta)
