app = undefined

load_scripts = () ->
  requirejs.config { baseUrl: 'scripts/' }
  requirejs ['application', 'lib/tinycolor', 'lib/snap.svg-min', 'lib/jquery-3.4.0.slim.min'],
  (Application, tinycolor) ->
    window.tinycolor = tinycolor
    app = new Application()
    app.init()


# window.addEventListener 'load', load_scripts # TODO why not working
load_scripts()

