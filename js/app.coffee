window.keys =
  ENTER: 13
  SPACE: 32
  BACKSPACE: 8

class KeyTools

  @normal: (keyCode)=>
    return @_withinRange(keyCode, 48, 90) or @_withinRange(keyCode, 186, 222)

  @_withinRange: (sample, min, max)->
    return sample >= min and sample <= max


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
      if KeyTools.normal(e.keyCode)
        played = @_playSound 'standard'
      else
        switch e.keyCode
          when keys.ENTER then played = @_playSound 'enter'
          when keys.SPACE then played = @_playSound 'space'
          when keys.BACKSPACE then played = @_playSound 'backspace'

    $(document).on 'click', -> $txt.focus()
    $txt.focus()

new SoundManager()

class Paper
  constructor: (id)->
    @canvas = document.getElementById(id)
    @$canvas = $(@canvas)
    @ctx = @canvas.getContext '2d'

    @ctx.fillStyle = "rgba(255, 50, 50, 0.7)"
    @ctx.font = "20px monospace"

    @charWidth = 15
    @lineHeight = 30

    @col = 0
    @row = 0

    $(document).on 'keydown', @adjustPosition
    $(document).on 'keypress', @printCharacter

  adjustPosition: (e)=>
    switch e.keyCode
      when keys.ENTER
        @adjustRow(1)
      when keys.SPACE
        @adjustCol(1)
      when keys.BACKSPACE
        @adjustCol(-1)
      else
        @adjustCol(1) if KeyTools.normal(e.keyCode)

  adjustRow: (value)=>
    @row += value
    @col = 0
    @$canvas.css('-webkit-transform', "translate(0,#{-@row * @lineHeight}px)")

  adjustCol: (value)=>
    if @col + value >= 0
      @col += value
      @left -= value * @charWidth
      @$canvas.css('-webkit-transform', "translate(#{-@col * @charWidth}px,#{-@row * @lineHeight}px)")

  printCharacter: (e)=>
    @ctx.fillText(String.fromCharCode(e.charCode), @charWidth * @col, @lineHeight * @row + @lineHeight)

new Paper('paper')


