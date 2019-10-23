Function::property = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc

class Style
  constructor: (@app) ->
    @palette = ['#226597', '#f8b739', '#a6cb12', '#a380dc']
    @inactive_opacity = 0.3
    @geometry =
      margins: [40, 40]
      scale: [70, 90]
    @track =
      width: 10,
      smooth_factor: 0.6
    @node =
      radius: 16
      stroke_width: 8
      fill: '#ffffff'
      highlight: {
        x: 0
        y: 0
        blur: 8
        opacity: 0.9
      }
      completion: {
        opacity: 0.7
        duration: 1000
        angle_offset: -90
      }
    @shadow =
      x: 0
      y: 0
      color: '#000000'
      blur: 4
      opacity: 0.4

  @property 'smooth_distance',
    get: () -> @track.smooth_factor * @geometry.scale[0]

  tox: (j) -> @geometry.margins[0] + j*@geometry.scale[0]
  toy: (i) -> @geometry.margins[1] + i*@geometry.scale[1]


define ['navigation', 'metro', 'communication', 'node', 'inspector', 'devices_list', 'server_log', 'clues'], (Navigation, Metro, Communication, Node, Inspector, DevicesList, ServerLog, Clues) ->
  class Application
    constructor: () ->
      @style = new Style this
      @metro = new Metro this, 'metro-svg'
      @inspector = new Inspector this
      @devices_list = new DevicesList this
      @server_log = new ServerLog this
      @clues = new Clues this
      @nav = new Navigation this
      @com = new Communication this
      @com.listen()

    init: () ->
      setTimeout((() => @nav.set_game_is_running(false)), 2000)
      await @load_metro_nodes()

    set_game_is_running: (is_running) ->
      @nav.set_game_is_running is_running

    update: (upt) ->
     @metro.update upt.nodes
     @inspector.update()

    load_metro_nodes: () ->
      $('#metro-svg').hide()
      $('.metro .loading').show()
      init_tree = await @com.get_init_tree()
      for id, n of init_tree['nodes']
        @metro.grid[id] = new Node(this, id, n)
      for id, n of init_tree['nodes']
        @metro.grid[id].set_tracks n.tracks
      @metro.update_size()
      $('#metro-svg').show()
      $('.metro .loading').hide()

