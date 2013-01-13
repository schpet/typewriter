snd = [
  new Audio("sounds/k1.wav")
  new Audio("sounds/k2.wav")
  new Audio("sounds/k3.wav")
  new Audio("sounds/k4.wav")
  new Audio("sounds/k1.wav")
  new Audio("sounds/k2.wav")
  new Audio("sounds/k3.wav")
  new Audio("sounds/k4.wav")
]

sounds =
  32: new Audio("sounds/spacebar.wav")
  13: new Audio("sounds/returncarriage.wav")
  8: new Audio("sounds/backspace.wav")

chosenSound = 0

withinRange = (sample, min, max)->
  return sample > min and sample < max

$txt = $('#text')
$txt.on 'keydown', (e)->
  # alphanumeric and punctuation
  if withinRange(e.keyCode, 48, 90) or withinRange(e.keyCode, 186, 222)
    chosenSound = ++chosenSound % snd.length

    snd[chosenSound].play()
    return

  # todo play backspace and other sounds if they jam the
  # keys a bunch
  # maybe a nice closure or somehting to keep the incrementors
  if e.keyCode of sounds
    # force people to be patient with the return carriage
    if e.keyCode == 13 and not sounds[e.keyCode].paused
      return e.preventDefault()

    sounds[e.keyCode].play()


$(document).on 'click', -> $txt.focus()
$txt.focus()
