require([
  // Application.
  'app',

  // Main Router.
  'router',

  'FastClick',

  'domReady'
],

function(app, Router, FastClick, domReady) {

  // Define your master router on the application namespace and trigger all
  // navigation from this instance.
  app.router = new Router();

  domReady(function() {
    document.addEventListener('deviceready', startWhenReady, false);
  });

  function startWhenReady() {
    new FastClick(document.body);

    $(document).on('click', 'a', function(event) {
      event.preventDefault();
      window.open(event.currentTarget.href, '_blank', 'location=yes');
    });

    navigator.splashscreen.hide()

    app.router.index();
  };
});
