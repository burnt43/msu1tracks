var OverlayHelper = (function(){
  function show (message) {
    var overlay = $('<div class="overlay" id="overlay"></div>');

    overlay.css('position','fixed');
    overlay.css('top','0');
    overlay.css('left','0');
    overlay.css('width','100%');
    overlay.css('height','100%');
    overlay.css('background-color','#000');
    overlay.css('filter','alpha(opacity=50)');
    overlay.css('-moz-opacity','0.5');
    overlay.css('-khtml-opacity','0.5');
    overlay.css('opacity','0.5');
    overlay.css('z-index','10000');
    overlay.css('cursor','wait');

    var text = $('<div class="overlay"><i class="fa fa-spinner fa-3x fa-pulse"></i> <h1 style="display: inline;">'+message+'</h1></div>')

    text.css('border-radius','25px');
    text.css('position','fixed');
    text.css('top','50%');
    text.css('left','50%');
    text.css('transform','translate(-50%, -50%)');
    text.css('background-color','#fff');
    text.css('z-index','10001');
    text.css('padding','20px 20px');

    overlay.appendTo(document.body);
    text.appendTo(document.body);
  }

  function hide () {
    $('.overlay').remove();
  }

  function active () {
    return $('.overlay').is(':visible');
  }

  return {
    show: show,
    hide: hide,
    active: active,
  }
})();

$(document).on('page:before-unload', function () {
  OverlayHelper.hide();
});
