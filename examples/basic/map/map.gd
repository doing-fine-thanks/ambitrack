class_name map extends Node3D

@onready var ambitrack_voice: AmbitrackVoice = $AmbitrackVoice
@onready var ambitrack_audio_stream_player: AudioStreamPlayer3D = $AmbitrackAudioPlayer


var g_note_drone := AmbitrackCommon.VoicePartManifest.new();

# Called when the node enters the scene tree for the first time.
func _ready():
    ambitrack_voice.setup(process_audio, ambitrack_audio_stream_player)
    ambitrack_voice.voice_meta.priority = 999
    ambitrack_voice.voice_meta.voice_name = "map"
    g_note_drone.audio_stream = preload("res://examples/basic/sounds/boomy/0 - G Drone.wav")


func process_audio(beat: int, voices: Array[AmbitrackCommon.VoiceMetadata]):
    if ambitrack_audio_stream_player.stream == null or not ambitrack_audio_stream_player.playing:
        ambitrack_voice.change_sample(g_note_drone, "g-drone")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
