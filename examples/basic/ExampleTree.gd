class_name ExampleTree extends Node3D

@onready var ambitrack_voice: AmbitrackVoice = $AmbitrackVoice
@onready var ambitrack_audio_stream_player: AudioStreamPlayer3D = $AmbitrackAudioPlayer

@export var distance_to_sound_threshold: int = 2

var player_reference: Player
var dist_from_player: float = 100000

var g_note := AmbitrackCommon.VoicePartManifest.new();
var a_note := AmbitrackCommon.VoicePartManifest.new();
var b_note := AmbitrackCommon.VoicePartManifest.new();
var c_note := AmbitrackCommon.VoicePartManifest.new();
var d_note := AmbitrackCommon.VoicePartManifest.new();
var e_note := AmbitrackCommon.VoicePartManifest.new();
var fs_note := AmbitrackCommon.VoicePartManifest.new();
var g2_note := AmbitrackCommon.VoicePartManifest.new();

# Called when the node enters the scene tree for the first time.
func _ready():
    ambitrack_voice.setup(process_audio, ambitrack_audio_stream_player)
    ambitrack_voice.voice_meta.voice_name = "tree"
    ambitrack_voice.voice_meta.voice_parent_id = str(get_instance_id())
    
    g_note.audio_stream = preload("res://examples/basic/sounds/boomy/1 - G .wav")
    a_note.audio_stream = preload("res://examples/basic/sounds/boomy/2 - A.wav")
    b_note.audio_stream = preload("res://examples/basic/sounds/boomy/3 - B.wav")
    c_note.audio_stream = preload("res://examples/basic/sounds/boomy/4 - C.wav")
    d_note.audio_stream = preload("res://examples/basic/sounds/boomy/5 - D.wav")
    e_note.audio_stream = preload("res://examples/basic/sounds/boomy/6 - E.wav")
    fs_note.audio_stream = preload("res://examples/basic/sounds/boomy/7 - F#.wav")
    g2_note.audio_stream = preload("res://examples/basic/sounds/boomy/8 - G2.wav")
    
    for tree_sprite in $Sprites.get_children():
        (tree_sprite as Sprite3D).flip_h = randf() > 0.2
        tree_sprite.visible = false
    $Sprites.get_children().pick_random().visible = true
    var size_offset: float =  randf_range(0.8, 1.2)
    scale *= size_offset
    if size_offset < 1:
        position.y *= 0.95
    else:
        position.y *= 1.2
        
    
        
        
    player_reference = get_tree().get_first_node_in_group(Player.PLAYER_GROUP) as Player
        

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    dist_from_player = player_reference.global_position.distance_to(global_position)


func process_audio(beat: int, voices: Array[AmbitrackCommon.VoiceMetadata]):
    var other_tree_voices: Array[AmbitrackCommon.VoiceMetadata] = voices.filter(func (x: AmbitrackCommon.VoiceMetadata): return x.voice_name == ambitrack_voice.voice_meta.voice_name and x.current_note)
    if dist_from_player > distance_to_sound_threshold:
        return null
    elif other_tree_voices.is_empty() or other_tree_voices[0].voice_parent_id == ambitrack_voice.voice_meta.voice_parent_id:
        if beat % 6 == 0:
            ambitrack_voice.change_sample(fs_note, "F#")
        elif ambitrack_voice.voice_meta.current_note == "G":
            ambitrack_voice.change_sample(b_note, "B")
        elif ambitrack_voice.voice_meta.current_note == "B":
            ambitrack_voice.change_sample(d_note, "D")
        else:
            ambitrack_voice.change_sample(g_note, "G")
    else:
        if other_tree_voices[0].current_note == "G":
            ambitrack_voice.change_sample(e_note, "E")
        elif other_tree_voices[0].current_note == "B":
            ambitrack_voice.change_sample(g_note, "G")
        elif other_tree_voices[0].current_note == "F#":
            ambitrack_voice.change_sample(d_note, "D")
    
    return ambitrack_voice.voice_meta
