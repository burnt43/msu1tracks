$(document).on('ready turbolinks:load', function(){
  Cookies.remove('archive_complete');
});

$(document).on('click', 'a.download-archive', function(){
  OverlayHelper.show('Generating Archive');

  function check_cookie() {
    setTimeout(function(){
      if (Cookies.get().archive_complete === 'yes') {
        OverlayHelper.hide();
        Cookies.remove('archive_complete');
      } else {
        check_cookie();
      }
    }, 100);
  }

  check_cookie();
});
