// Generated by CoffeeScript 1.9.3
(function() {
  var app, load_scripts;

  app = void 0;

  load_scripts = function() {
    requirejs.config({
      baseUrl: 'scripts/'
    });
    return requirejs(['application', 'lib/tinycolor', 'lib/snap.svg-min', 'lib/jquery-3.4.0.slim.min'], function(Application, tinycolor) {
      window.tinycolor = tinycolor;
      app = new Application();
      return app.init();
    });
  };

  load_scripts();

}).call(this);
