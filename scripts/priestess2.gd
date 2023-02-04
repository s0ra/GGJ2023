extends Node2D

var relic1 : int = -1
var relic2 : int = -1

var started = true

var descriptions : Array = ["Gain a Shield that'll be recharged every 3 seconds",
                            "Gain 3 maximum HP",
                            "Gain the ability to double jump",
                            "Spider doesn't appear anymore",
                            "Boss loses half of his HP, but can summon rats now"
                            ]

func _ready():
    relic1 = randi() % 5 
    relic2 = (relic1 + 1) % 5

func _process(delta):
    if started and get_parent().get_node("Priestess3") != null:
        started = false
        get_parent().get_node("Priestess3").relic2 = relic2
        get_node("Label").text = descriptions[relic1]
        get_parent().get_node("Priestess3").get_node("Label").text = descriptions[relic2]

func _on_Priestess2_body_entered(body):
    if body.has_method("damaged_by"):
        if relic1 == 0:
            get_parent().get_node("Player").has_shield = true
            get_parent().get_node("Player").is_shield = true
        if relic1 == 1:
            get_parent().get_node("Player").max_hp += 3
            get_parent().get_node("Player").hp = min(8, get_parent().get_node("Player").hp + 3)
            get_parent().get_node("CanvasLayer/HP").text = "HP: " + str(get_parent().get_node("Player").hp)
        if relic1 == 2:
            get_parent().get_node("Player").double_jump = true
        if relic1 == 3:
            get_parent().not_spawn_spider = true
        if relic1 == 4:
            get_parent().special_boss = true
            
        get_parent().get_node("Priestess3").queue_free()
        queue_free()
