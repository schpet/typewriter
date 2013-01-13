// Generated by CoffeeScript 1.4.0
(function() {
  var $txt, chosenSound, snd, sounds, withinRange;

  snd = [new Audio("sounds/k1.wav"), new Audio("sounds/k2.wav"), new Audio("sounds/k3.wav"), new Audio("sounds/k4.wav"), new Audio("sounds/k1.wav"), new Audio("sounds/k2.wav"), new Audio("sounds/k3.wav"), new Audio("sounds/k4.wav")];

  sounds = {
    32: new Audio("sounds/spacebar.wav"),
    13: new Audio("sounds/returncarriage.wav"),
    8: new Audio("sounds/backspace.wav")
  };

  chosenSound = 0;

  withinRange = function(sample, min, max) {
    return sample > min && sample < max;
  };

  console.log('sup');

  $txt = $('#text');

  $txt.on('keydown', function(e) {
    console.log('supx');
    if (withinRange(e.keyCode, 48, 90) || withinRange(e.keyCode, 186, 222)) {
      chosenSound = ++chosenSound % snd.length;
      snd[chosenSound].play();
      return;
    }
    if (e.keyCode in sounds) {
      if (e.keyCode === 13 && !sounds[e.keyCode].paused) {
        return e.preventDefault();
      }
      return sounds[e.keyCode].play();
    }
  });

  $(document).on('click', function() {
    return $txt.focus();
  });

  $txt.focus();

}).call(this);
