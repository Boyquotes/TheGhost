extends Label3D

class TextObject:
	var text_value : String
	var time : float

var text_queue : Array[TextObject]

var locked = false

func _process(_delta):
	if (text_queue.size() >= 1) && !locked :
		clean_text()
		if (!locked):
			fill_text()
	elif !locked:
		clean_text()

func add_to_queue(new_text : String, display_time : float = 0.0):
	var text_object = TextObject.new()
	text_object.text_value = new_text
	text_object.time = display_time
	text_queue.append(text_object)

func clean_text():
	locked = true
	var clear_delta = 0.05
	while text.length() >= 1:
		text = text.left(-1)
		await get_tree().create_timer(clear_delta).timeout
		clear_delta = lerpf(clear_delta, 0.02, 0.75)
	locked = false

func fill_text():
	locked = true
	var next_text = text_queue.pop_front()
	for c in next_text.text_value:
		text += c
		await get_tree().create_timer(0.08).timeout
	if next_text.time:
		await get_tree().create_timer(next_text.time).timeout
	locked = false

func purge():
	text_queue.clear()
	clean_text()
