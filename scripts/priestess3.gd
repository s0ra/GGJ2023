extends Node2D

var relic2 : int = -1

func _ready():
    pass
    
func _on_Priestess3_body_entered(body):
    if body.has_method("damaged_by"):
        if relic2 == 0:
            get_parent().get_node("Player").has_shield = true
            get_parent().get_node("Player").is_shield = true
        if relic2 == 1:
            get_parent().get_node("Player").max_hp += 3
            get_parent().get_node("Player").hp = min(8, get_parent().get_node("Player").hp + 3)
            get_parent().get_node("CanvasLayer/HP").text = "HP: " + str(get_parent().get_node("Player").hp)
        if relic2 == 2:
            get_parent().get_node("Player").double_jump = true
        if relic2 == 3:
            get_parent().not_spawn_spider = true
        if relic2 == 4:
            get_parent().special_boss = true
            
        get_parent().get_node("Priestess2").queue_free()
        queue_free()
