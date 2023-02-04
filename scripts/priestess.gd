extends Node2D

var healed : bool = false

func _ready():
    pass
    
func _process(delta):    
    if get_parent().entered_boss_room and not healed:
        healed = true
        get_parent().get_node("Player").hp = get_parent().get_node("Player").max_hp
        get_parent().get_node("CanvasLayer/HP").text = "HP: " + str(get_parent().get_node("Player").hp)
        get_node("Label").visible = true
