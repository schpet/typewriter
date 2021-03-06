"use strict"

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
    $(document).on 'keydown', (e)=>
      return if (e.metaKey || e.ctrlKey || e.altKey )

      @keystrokeCount++

      # alphanumeric and punctuation
      if KeyTools.normal(e.keyCode)
        played = @_playSound 'standard'
      else
        switch e.keyCode
          when keys.ENTER then played = @_playSound 'enter'
          when keys.SPACE then played = @_playSound 'space'
          when keys.BACKSPACE then played = @_playSound 'backspace'

      true


class Paper

  options:
    maxColumns: 32
    maxRows: 32
    charWidth: 15
    lineHeight: 30

  constructor: (containerId, options = {})->
    container = document.getElementById containerId
    @canvas = document.createElement 'canvas'

    @canvas.width = @options.maxColumns * @options.charWidth
    @canvas.height = @options.maxRows * @options.lineHeight
    container.appendChild @canvas

    @$canvas = $(@canvas)
    @ctx = @canvas.getContext '2d'

    @ctx.fillStyle = "rgba(255,255,204, 0.9)"
    #@ctx.fillStyle = "rgb(200, 0, 0)"
    @ctx.fillRect(0, 0, @canvas.width, @canvas.height)

    @ctx.fillStyle = "rgba(55, 80, 0, 0.7)"
    @ctx.font = "20px Cutive Mono"


    @col = 0
    @row = 0

    @dontPrint = false

    $(document).on 'keydown', @adjustPosition
    $(document).on 'keypress', @printCharacter

  adjustPosition: (e)=>
    return if (e.metaKey || e.ctrlKey || e.altKey )

    switch e.keyCode
      when keys.ENTER
        @adjustRow(1)

      when keys.SPACE
        @adjustCol(1)
      when keys.BACKSPACE
        @adjustCol(-1)
      else
        @adjustCol(1) if KeyTools.normal(e.keyCode)

    true

  adjustRow: (value)=>
    @row += value
    @col = 0
    @$canvas.css('transform', "translate(0,#{-@row * @options.lineHeight}px)")

  adjustCol: (value)=>
    adjusted = @col + value

    if adjusted < 0
      @adjustRow(-1)
      return

    if adjusted > @options.maxColumns
      @dontPrint = true
      return

    @dontPrint = false if @dontPrint

    @col = adjusted
    @left -= value * @options.charWidth
    @$canvas.css('transform', "translate(#{-@col * @options.charWidth}px,#{-@row * @options.lineHeight}px)")

  printCharacter: (e)=>
    if @dontPrint
      return

    @ctx.save()
    @ctx.translate(@options.charWidth * @col, @options.lineHeight * @row + @options.lineHeight)

    rotationRange = 0.05
    rotation = -(rotationRange / 2) + Math.random() * rotationRange

    @ctx.rotate(rotation)
    @ctx.fillText(String.fromCharCode(e.charCode), 0, 0)
    @ctx.restore()

    true

$txt = $('#text')
$(document).on 'click', -> $txt.focus()
$txt.focus()

sounds = new SoundManager()
paper = new Paper('paper-container')
