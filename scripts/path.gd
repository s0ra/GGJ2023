extends Node2D

var rope : Array = []

func _ready():
    rope.append(get_parent().get_node("Player").position)

func add_rope_point(point):
    rope.append(point)

func rope_pulling():
    if rope.size() > 1:
        var pulled = rope.pop_back()
        get_parent().get_node("Player").position = pulled

func _process(delta):
    update()
    
func _draw():
    for i in range(rope.size() - 1):
        draw_line(rope[i], rope[i + 1], Color.red)
