class_name AmbitrackManager extends Node

# thing about this...
#@onready var non_positional_audio_player: AudioStreamPlayer = $NonPositionalAudioOut

@onready var debug_text: RichTextLabel = $DebugText

@export var bpm: int = 120
@export var max_number_of_voices: int = 8
@export var is_audio_positional: bool = false

# maybe not needed?
#   enum MEASURE_DURATION {SIXTEENTH, EIGHTH, QUARTER, HALF, WHOLE}
#   @export var measure_duration: MEASURE_DURATION = MEASURE_DURATION.QUARTER
#
#   @export var measure_length: int = 4

var voice_map: Array[AmbitrackCommon.VoiceMetadata] = []
var voices: Array[AmbitrackVoice] = []

var voice_play_requests: Array[AmbitrackCommon.PlayRequest] = []

var _interal_tick_duration: float = 0
var _duration_since_last_tick: float = 0
var _beat: int = 1


@export var DEBUG: bool = false


const SECONDS_IN_A_MINUTE: float = 60


# Called when the node enters the scene tree for the first time.
func _ready():
    add_to_group(AmbitrackCommon.MANAGER_GROUP_NAME)
    set_bpm_tick(bpm)

func set_bpm_tick(bpm_desired: int):
    _interal_tick_duration = SECONDS_IN_A_MINUTE / bpm_desired

# Consider moving this under _physics_process so that the beat is increased at the correct rate...
func _physics_process(delta):
    if _duration_since_last_tick > _interal_tick_duration:
        var new_voice_map: Array[AmbitrackCommon.VoiceMetadata] = []
        for voice in voices:
            new_voice_map.append(voice.process_beat(_beat, voice_map))
        
        
        _duration_since_last_tick = 0
        _beat += 1
            
        voice_map = new_voice_map
        
        process_voice_play_queue()
            
    else:
        _duration_since_last_tick += delta

    if DEBUG:
        debug_text.text = "Current beat: " + str(_beat)

func add_play_to_queue(request: AmbitrackCommon.PlayRequest):
    voice_play_requests.append(request)
    
func process_voice_play_queue():
    voice_play_requests.sort_custom(func(a: AmbitrackCommon.PlayRequest, b: AmbitrackCommon.PlayRequest): return a.priority > b.priority)
    for i in range(min(max_number_of_voices, voice_play_requests.size())):
        voice_play_requests[i].audio_player.play()
    
    voice_play_requests.clear()
    

func register_voice(voice: AmbitrackVoice):
    voices.append(voice)
    voice_map.append(voice.voice_meta)
