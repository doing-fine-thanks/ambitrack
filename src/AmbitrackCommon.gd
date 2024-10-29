class_name AmbitrackCommon extends Node


static var GROUP_NAME: String = "Ambitrack"
static var MANAGER_GROUP_NAME: String = "AmbitrackManager"

class VoiceMetadata:
    var priority: int = 0

    var current_note: String
    var current_played_duration: int
    var current_sample_name: String

    var last_note: String
    var last_duration_played: int
    var last_sample_name: String
    
    
class VoicePartManifest:
    # TODO: most of this is disabled because of: https://github.com/godotengine/godot/issues/64775
    #var beginning_timestamp: float
    #var beginning_end_timestamp: float
    #var sustain_timestamp: float
    #var sustain_loop_point_timestamp: float
    
   # var end_time_stamp:float
    
    var audio_stream: AudioStream;
