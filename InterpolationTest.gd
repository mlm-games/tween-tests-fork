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

var tween: Tween
var timer: Timer

func _ready():
		RenderingServer.viewport_set_clear_mode(get_viewport().get_viewport_rid(), RenderingServer.VIEWPORT_CLEAR_NEVER)
		
		# Create timer
		timer = Timer.new()
		add_child(timer)
		timer.timeout.connect(_on_timer_timeout)
		timer.one_shot = true
		
		for j in range(len(transition_types)):
				var trans_label = Label.new()
				trans_label.text = transition_types[j]
				trans_label.position = Vector2(
						30,
						first_row_height + (get_viewport_rect().size.y - first_row_height) / (len(transition_types)) * j
				)
				add_child(trans_label)
		
		for i in range(len(ease_types)):
				var ease_label = Label.new()
				ease_label.text = ease_types[i]
				ease_label.position = Vector2(
						first_col_width + (get_viewport_rect().size.x - first_col_width) / (len(ease_types)) * i,
						30
				)
				add_child(ease_label)
				
				sprites.append([])
						
				for j in range(len(transition_types)):
						var new_sprite = ColorRect.new()
						add_child(new_sprite)
						new_sprite.position.x = first_col_width + (get_viewport_rect().size.x - first_col_width) / (len(ease_types)) * i - 10
						new_sprite.position.y = first_row_height + (get_viewport_rect().size.y - first_row_height) / (len(transition_types)) * j
						new_sprite.size = Vector2((get_viewport_rect().size.x - first_col_width) / (len(ease_types)) * 0.8 + 50, 10)
						new_sprite.modulate = Color(1, 1, 1, 0.05)
						
						sprites[i].append(ColorRect.new())
						add_child(sprites[i][j])
						sprites[i][j].position.x = first_col_width + (get_viewport_rect().size.x - first_col_width) / (len(ease_types)) * i
						sprites[i][j].position.y = first_row_height + (get_viewport_rect().size.y - first_row_height) / (len(transition_types)) * j - 10
						sprites[i][j].size = Vector2(30, 30)
		
		# Start the animation
		timer.start(0.1)

var back = false
func _on_timer_timeout():
		# Create a new tween for each animation cycle
		tween = create_tween()
		
		for i in range(len(ease_types)):
				for j in range(len(transition_types)):
						var start_x = first_col_width + (get_viewport_rect().size.x - first_col_width) / (len(ease_types)) * (i + (0.8 if back else 0))
						var end_x = first_col_width + (get_viewport_rect().size.x - first_col_width) / (len(ease_types)) * (i + (0 if back else 0.8))
						
						# Convert the old easing and transition indices to the new enum values
						var trans_type = j
						var ease_type = i
						
						# Create a separate tween for each sprite
						var sprite_tween = tween.parallel()
						sprite_tween.tween_property(sprites[i][j], "position:x", end_x, duration)
						sprite_tween.set_trans(trans_type)
						sprite_tween.set_ease(ease_type)
		
		back = not back
		timer.start(duration + pause)
