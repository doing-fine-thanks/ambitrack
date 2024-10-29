class_name ExampleTree extends Node3D

@onready var ambitrack_voice: AmbitrackVoice = $AmbitrackVoice
@onready var ambitrack_audio_stream_player: AudioStreamPlayer3D = $AmbitrackAudioPlayer

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
    
    g_note.audio_stream = preload("res://examples/basic/sounds/plucky/1 - G.wav")
    a_note.audio_stream = preload("res://examples/basic/sounds/plucky/2 - A.wav")
    b_note.audio_stream = preload("res://examples/basic/sounds/plucky/3 - B.wav")
    c_note.audio_stream = preload("res://examples/basic/sounds/plucky/4 - C.wav")
    d_note.audio_stream = preload("res://examples/basic/sounds/plucky/5 - D.wav")
    e_note.audio_stream = preload("res://examples/basic/sounds/plucky/6 - E.wav")
    fs_note.audio_stream = preload("res://examples/basic/sounds/plucky/7 - F#.wav")
    g2_note.audio_stream = preload("res://examples/basic/sounds/plucky/8 - G2.wav")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    pass


func process_audio(beat: int, voices: Array[AmbitrackCommon.VoiceMetadata]):
    print("got beat " + str(beat) + " @ " + str(get_path()))
    
    if voices[0] == ambitrack_voice.voice_meta:
        if beat % 6 == 0:
            ambitrack_voice.change_sample(fs_note, "F#")
        elif ambitrack_voice.voice_meta.current_note == "G":
            ambitrack_voice.change_sample(b_note, "B")
        elif ambitrack_voice.voice_meta.current_note == "B":
            ambitrack_voice.change_sample(d_note, "D")
        else:
            ambitrack_voice.change_sample(g_note, "G")
    else:
        if voices[0].current_note == "G":
            ambitrack_voice.change_sample(e_note, "E")
        elif voices[0].current_note == "B":
            ambitrack_voice.change_sample(g_note, "G")
        elif voices[0].current_note == "F#":
            ambitrack_voice.change_sample(d_note, "D")
    
    #if not voices[0].current_note:
    #    ambitrack_voice.change_sample(c_note, "C")
    #else:
    #    ambitrack_voice.change_sample(a_note, "A")

    print(ambitrack_voice.voice_meta.current_note)
    return ambitrack_voice.voice_meta
