extends Node2D

var rope : Array = []

var rope_count = 0

func _ready():
    rope.resize(10000000)
    rope_count = 1
    rope[0] = get_parent().get_node("Player").position
#    print(rope.size())

func add_rope_point(point):
    if rope_count < 10000000:
        rope[rope_count] = point
        rope_count += 1
#    else:
#        print("game over")

func rope_pulling():
    if rope_count > 1:
        if not get_parent().get_node("Player").test_move(get_parent().get_node("Player").transform, (get_parent().get_node("Player").position - rope[rope_count - 1]).normalized() * 0.01):
            var pulled = rope[rope_count - 1]
            get_parent().get_node("Player").position = pulled
            rope_count -= 1

func _physics_process(delta):
    update()
    
func _draw():
    for i in range(max(0, int(stepify(rope_count, 10000) - 20000)), rope_count - 1):
        draw_line(rope[i], rope[i + 1], Color.red)
