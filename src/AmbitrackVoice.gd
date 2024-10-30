class_name AmbitrackVoice extends Node

@export var audio_player: AudioStreamPlayer3D

var sample_name: String = ""

var _assigned_beat_func: Callable = func(_x): pass
var _manager: AmbitrackManager
var _has_been_setup: bool = false

var _current_voice_parts_manifest := AmbitrackCommon.VoicePartManifest.new();

var voice_meta: AmbitrackCommon.VoiceMetadata = AmbitrackCommon.VoiceMetadata.new()

# Called when the node enters the scene tree for the first time.
func _ready():
    add_to_group(AmbitrackCommon.GROUP_NAME)
    get_tree().root.ready.connect(_register_after_initialization_of_scene)
    #call_deferred("_register_after_initialization_of_scene")
    
func _physics_process(_delta):
    pass
    # TODO: FFS: https://github.com/godotengine/godot/issues/64775
    #
    #if _current_voice_parts_manifest and audio_player.playing:
    #    print(audio_player.get_playback_position())
    #    if audio_player.get_playback_position() > _current_voice_parts_manifest.sustain_loop_point_timestamp:
    #        audio_player.seek(_current_voice_parts_manifest.sustain_timestamp)
    #    else:
    #        print("not resetting...")
            

func _register_after_initialization_of_scene():
    _manager = get_tree().get_first_node_in_group(AmbitrackCommon.MANAGER_GROUP_NAME)
    _manager.register_voice(self)

func set_beat_function(beat_heuristic_function: Callable):
    _assigned_beat_func = beat_heuristic_function

func set_audio_player(audio_player_to_use: AudioStreamPlayer3D):
    audio_player = audio_player_to_use
    voice_meta.audio = audio_player_to_use

func setup(beat_heuristic_function: Callable, audio_player_to_use: AudioStreamPlayer3D):
    set_audio_player(audio_player_to_use)
    set_beat_function(beat_heuristic_function)
    _has_been_setup = true


func change_sample(new_voice_parts_manifest: AmbitrackCommon.VoicePartManifest, note: String):
    voice_meta.last_sample_name = voice_meta.current_sample_name
    voice_meta.last_duration_played = voice_meta.current_played_duration
    voice_meta.last_note = voice_meta.current_note

    voice_meta.current_note = note
    voice_meta.current_played_duration = 0
    
    print("last note changed to: " +  voice_meta.last_note)
    print("current note changed to: " +  voice_meta.current_note)

    _current_voice_parts_manifest = new_voice_parts_manifest

    if _current_voice_parts_manifest != null and _current_voice_parts_manifest.audio_stream != null:
        audio_player.stream = _current_voice_parts_manifest.audio_stream
        # audio_player.play(_current_voice_parts_manifest.beginning_timestamp)
        # todo: blend the fade_out of the old track with the new
        
        var request := AmbitrackCommon.PlayRequest.new()
        request.priority = voice_meta.priority
        request.audio_player = audio_player
        _manager.add_play_to_queue(request)

        voice_meta.current_sample_name = str(audio_player.get_parent().get_instance_id())
    else:
        voice_meta.current_sample_name = "null"



func process_beat(beat: int, voice_metadata_map: Array):
    if not _has_been_setup:
        push_error("Ambitrack voice has not been setup yet @ path: " + str(get_path()))

    _assigned_beat_func.call(beat, voice_metadata_map)
    
    voice_meta.current_played_duration += 1

    return voice_meta
