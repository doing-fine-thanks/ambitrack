class_name ExampleRock extends Node3D

@onready var ambitrack_voice: AmbitrackVoice = $AmbitrackVoice
@onready var ambitrack_audio_stream_player: AudioStreamPlayer3D = $AmbitrackAudioPlayer

@export var distance_to_sound_threshold: int = 2

var player_reference: Player

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
    ambitrack_voice.voice_meta.voice_name = "rock"
    ambitrack_voice.voice_meta.voice_parent_id = str(get_instance_id())
    ambitrack_voice.voice_meta.priority = 5
    
    g_note.audio_stream = preload("res://examples/basic/sounds/bongy/1 - G.wav")
    a_note.audio_stream = preload("res://examples/basic/sounds/bongy/2 - A.wav")
    b_note.audio_stream = preload("res://examples/basic/sounds/bongy/3 - B.wav")
    c_note.audio_stream = preload("res://examples/basic/sounds/bongy/4 - C.wav")
    d_note.audio_stream = preload("res://examples/basic/sounds/bongy/5 - D.wav")
    e_note.audio_stream = preload("res://examples/basic/sounds/bongy/6 - E.wav")
    fs_note.audio_stream = preload("res://examples/basic/sounds/bongy/7 - F#.wav")
    g2_note.audio_stream = preload("res://examples/basic/sounds/bongy/8 - G2.wav")
    
    var size_offset: float =  randf_range(0.8, 1.2)
    scale *= size_offset
    if size_offset < 1:
        position.y *= 0.95
    else:
        position.y *= 1.1
        
        
    player_reference = get_tree().get_first_node_in_group(Player.PLAYER_GROUP) as Player


func process_audio(beat: int, voices: Array[AmbitrackCommon.VoiceMetadata]):
    print("got beat " + str(beat) + " @ " + str(get_path()))
    
    var other_rock_voices: Array[AmbitrackCommon.VoiceMetadata] = voices.filter(func (x: AmbitrackCommon.VoiceMetadata): return x.voice_name == ambitrack_voice.voice_meta.voice_name and not x.current_note.is_empty())
        
    if player_reference.global_position.distance_to(global_position) > distance_to_sound_threshold or other_rock_voices.size() > 1:
        return null
    elif other_rock_voices.is_empty() or ambitrack_voice.voice_meta.current_note == "E":
        ambitrack_voice.change_sample(g_note, "G")
    elif ambitrack_voice.voice_meta.current_note == "G" and ambitrack_voice.voice_meta.current_played_duration == 2:
         ambitrack_voice.change_sample(b_note, "B")
    elif ambitrack_voice.voice_meta.current_note == "B":
         ambitrack_voice.change_sample(fs_note, "F#")
    elif ambitrack_voice.voice_meta.current_note == "F#"  and ambitrack_voice.voice_meta.current_played_duration == 2:
         ambitrack_voice.change_sample(d_note, "D")
    elif ambitrack_voice.voice_meta.current_note == "D":
         ambitrack_voice.change_sample(e_note, "E")
    
    
    return ambitrack_voice.voice_meta
