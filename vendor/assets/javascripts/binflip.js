/**
 * Usage:
 *
 * Set data-features in the <body> tag -- i.e.:
 *
 *    <body data-features='{"feature_a":true}'>
 *
 * Then in JS, access the Binflip.isActive(feature_name) function:
 *
 *    if (Binflip.isActive("feature_a")) {
 *      // feature is on
 *    }
 *
 */
var Binflip = {
  isActive: function (feature) { 
    var els = document.getElementsByTagName('body');
    if (els.length != 1) {
      throw new Error("Can't find one and onlye one <body> element!");
    }
    
    try {
      if (JSON.parse(els[0].getAttribute('data-features'))[feature]) {
        return true; 
      }
    } catch(err) {
      throw new Error("Could not parse attribute data-features: " + err.message);
    }
    
    return false;
  }
}
