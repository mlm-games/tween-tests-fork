extends Control

var ease_types = [
	"EASE_IN",
	"EASE_OUT",
	"EASE_IN_OUT",
	"EASE_OUT_IN"
]

var transition_types = [
	"TRANS_LINEAR",
	"TRANS_SINE",
	"TRANS_QUINT",
	"TRANS_QUART",
	"TRANS_QUAD",
	"TRANS_EXPO",
	"TRANS_ELASTIC",
	"TRANS_CUBIC",
	"TRANS_CIRC",
	"TRANS_BOUNCE",
	"TRANS_BACK"
]

var sprites = []

const first_row_height = 100
const first_col_width = 200

const duration = 1.5
const pause = .5

func _ready():
	VisualServer.viewport_set_clear_mode(get_viewport().get_viewport_rid(),VisualServer.VIEWPORT_CLEAR_NEVER)
	for j in range(len(transition_types)):
		
		var trans_label = Label.new()
		trans_label.text = transition_types[j]
		trans_label.rect_position = Vector2(
			30,
			first_row_height + (get_viewport_rect().size.y - first_row_height) / (len(transition_types) ) * (j )
		)
		add_child(trans_label)
	
	for i in range(len(ease_types)):
		var ease_label = Label.new()
		ease_label.text = ease_types[i]
		ease_label.rect_position = Vector2(
			first_col_width + (get_viewport_rect().size.x - first_col_width) / (len(ease_types) ) * (i ),
			30
		)
		add_child(ease_label)
		
		sprites.append([])
			
		for j in range(len(transition_types)):
			
			var new_sprite = ColorRect.new()
			add_child(new_sprite)
			new_sprite.rect_position.x = first_col_width + (get_viewport_rect().size.x - first_col_width) / (len(ease_types) ) * (i) - 10
			new_sprite.rect_position.y = first_row_height + (get_viewport_rect().size.y - first_row_height) / (len(transition_types) ) * (j)
			new_sprite.rect_size = Vector2((get_viewport_rect().size.x - first_col_width) / (len(ease_types) ) * (0.8) + 50, 10)
			new_sprite.modulate = Color(1,1,1,0.05)
			
			sprites[i].append(ColorRect.new())
			add_child(sprites[i][j])
			sprites[i][j].rect_position.x = first_col_width + (get_viewport_rect().size.x - first_col_width) / (len(ease_types) ) * (i)
			sprites[i][j].rect_position.y = first_row_height + (get_viewport_rect().size.y - first_row_height) / (len(transition_types) ) * (j) - 10
			sprites[i][j].rect_size = Vector2(30, 30)
			
			

var back = false
func _on_Timer_timeout():
	
	for i in range(len(ease_types)):
		for j in range(len(transition_types)):
			
			$Tween.interpolate_property(sprites[i][j], "rect_position:x",
				first_col_width + (get_viewport_rect().size.x - first_col_width) / (len(ease_types) ) * (i + (0.8 if back else 0)),
				first_col_width + (get_viewport_rect().size.x - first_col_width) / (len(ease_types) ) * (i + (0 if back else 0.8)),
				duration,j,i
			)
			$Tween.start()
	
	back = not back
	$Timer.start(duration + pause)
