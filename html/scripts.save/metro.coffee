Function::property = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc


define () ->

  class Metro
    constructor: (@app, id) ->
      @grid = {}
      @svg = Snap('#' + id)
      @dom = $('#' + id)
      @groups = @create_groups()
      document.onkeydown = (e) -> @key_down(e)

    update: (upt) ->
      for id, u of upt
        @grid[id].update(u)
      for _, n of @grid # TODO not updating all tracks but only required
        n.update_tracks()

    update_size: () ->
      b = @boundaries
      w = @app.style.tox(b[1]) + @app.style.geometry.margins[0]
      h = @app.style.toy(b[0]) + @app.style.geometry.margins[1]
      @dom.css 'width', w
      @dom.css 'height', h
      $('.metro').css 'min-width', w

    @property 'selection',
      get: () -> return n for n of @grid when n.is_selected

    @property 'boundaries',
      get: () ->
        maxi = maxj = 0
        for _, n of @grid
          maxi = if n.i > maxi then n.i else maxi
          maxj = if n.j > maxj then n.j else maxj
        [maxi, maxj]

    create_groups: () ->
      groups =
        active: @svg.group()
        inactive: @svg.group()
        active_nodes: @svg.group()
        active_tracks: @svg.group()
        inactive_nodes: @svg.group()
        inactive_tracks: @svg.group()
        shadow: @svg.group()
        grid: @svg.group()

      groups.active.add(groups.active_tracks)
      groups.active.add(groups.active_nodes)
      groups.inactive.add(groups.inactive_tracks)
      groups.inactive.add(groups.inactive_nodes)
      groups.inactive.attr {opacity: @app.style.inactive_opacity}

      groups.shadow.add(groups.inactive)
      groups.shadow.add(groups.active)
      @set_shadow(groups.shadow)

      groups

    key_down: (e) ->
      e = e || window.event
      if e.key is 'Escape'
        @unselect_all()
        @app.inspector.update()

    unselect_all: () ->
      e.unselect() for _,e of @grid

    set_shadow: (e) ->
      s = @app.style.shadow
      f = @svg.filter Snap.filter.shadow(s.x, s.y,  s.blur, s.color, s.opacity)
      e.attr {
        filter: f
      }
