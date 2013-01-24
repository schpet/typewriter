class SoundManager

  SOUND_BASE: 'sounds/'

  options:
    volume: 0.75
    target: '#text'

  constructor: ->
    @loadAudioFiles()
    @setupDom()
    @keystrokeCount = 0

  loadAudioFiles: ->
    @sounds =
      standard:
        timeout: 0
        files: [ "k1p.wav", "k2p.wav", "k3p.wav", "k4p.wav" ]
      space:
        timeout: 250
        files: [ "spacebar.wav" ]
      enter:
        timeout: 700
        files: [ "returncarriage.wav" ]
      backspace:
        timeout: 200
        files: [ "backspace.wav" ]

    # load each soundfile 5 times
    bufferSize = 5
    for name, sound of @sounds
      @sounds[name].sounds = []
      for i in [0..bufferSize - 1] # better for loop?
        for file in sound.files
          audioObj = new Audio(@SOUND_BASE + file)
          audioObj.volume = @options.volume
          @sounds[name].sounds.push audioObj
          @sounds[name].lastPlayed = 0

  _withinRange: (sample, min, max)->
    return sample > min and sample < max

  _playSound: (soundName)->
    sound = @sounds[soundName]
    time = new Date().getTime()

    if !sound.timeLastPlayed? or time - sound.timeLastPlayed > sound.timeout
      sounds = sound.sounds
      playable = sounds[@keystrokeCount % sounds.length]
      playable.play()
      sound.timeLastPlayed = time
      return true

    return false

  # TODO make this more generic, as an option you
  # can pass in
  setupDom: ->
    $txt = $(@options.target)
    $txt.on 'keydown', (e)=>
      @keystrokeCount++

      # alphanumeric and punctuation
      if @_withinRange(e.keyCode, 48, 90) or @_withinRange(e.keyCode, 186, 222)
        played = @_playSound 'standard'
      else
        switch e.keyCode
          when 13 then played = @_playSound 'enter'
          when 32 then played = @_playSound 'space'
          when 8 then played = @_playSound 'backspace'

        if !played
          e.preventDefault()

    $(document).on 'click', -> $txt.focus()
    $txt.focus()

new SoundManager()
