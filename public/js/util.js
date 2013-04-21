define([
  'utilities/window',
  'three'
],function(window) {
  //Adapted from:
  //Copyright 2009 Nicholas C. Zakas. All rights reserved.
  //MIT Licensed
  window.timedChunk = function(particles, positions, fn, context, callback){
    var i = 0;
    var tick = function() {
      var start = new Date().getTime();
      for (; i < positions.length && (new Date().getTime()) - start < 50; i++) {
        fn.call(context, particles[i], positions[i]);
      }

      if (i < positions.length) {
        setTimeout(tick, 25);
      } else {
        callback(positions, particles);
      }
    };
    setTimeout(tick, 25);
  }

  window.toJED = function(d){
    // TODO precompute constants
    return Math.floor((d.getTime() / (1000 * 60 * 60 * 24)) - 0.5) + 2440588;
  }

  window.fromJED = function(jed) {
    return new Date(1000*60*60*24 * (0.5 - 2440588 + jed));
  }

  window.getColorFromPercent = function(value, highColor, lowColor) {
      var r = highColor >> 16;
      var g = highColor >> 8 & 0xFF;
      var b = highColor & 0xFF;

      r += ((lowColor >> 16) - r) * value;
      g += ((lowColor >> 8 & 0xFF) - g) * value;
      b += ((lowColor & 0xFF) - b) * value;

      return (r << 16 | g << 8 | b);
  }

  window.displayColorForObject = function(roid) {
    if (roid.profit > 1e11)
      return new THREE.Color(0xffff00);
    return new THREE.Color(0xffffff);

    /*
    var normal = parseFloat(1e11);
    if (roid.profit < 1)
      return new THREE.Color(0xcccccc);

    var adjustment = roid.profit / normal;
    console.log(adjustment);
    var ret = new THREE.Color(getColorFromPercent(
      adjustment,
      0x00ff00,
      0xcccccc

    ));
    // TODO change size too
    return ret;
    */
  }

  window.getParameterByName = function(name)
  {
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regexS = "[\\?&]" + name + "=([^&#]*)";
    var regex = new RegExp(regexS);
    var results = regex.exec(window.location.search);
    if(results == null)
      return "";
    else
      return decodeURIComponent(results[1].replace(/\+/g, " "));
  }

  window.jed = toJED(new Date());
  window.featured_2012_da14 = getParameterByName('2012_DA14') == '1'
});
