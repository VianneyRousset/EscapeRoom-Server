Function::property = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc

class Point

  constructor: (@app, @i, @j) ->

  @property 'index',
    get: -> [@i, @j]
    set: (index) -> [@i, @j] = index

  @property 'x',
    get: -> @app.style.tox(@j)

  @property 'y',
    get: -> @app.style.toy(@i)

  @property 'pos',
    get: -> [@x, @y]


class SelectablePoint extends Point

  constructor: (app, i, j) ->
    super app, i, j
    @_selected = false

  set_event_handlers: (element) ->
    element.hover(
      ((e) => @onhover(e))
      ((e) => @unhover(e)))
    element.click((e) => @onclick(e))

  @property 'selected',
    get: -> @_selected
    set: (s) ->
      if @selected and not s
        @app.inspector.unset()
      if not @selected and s
        @app.inspector.set(this)

      @_selected = s
      @update_drawing()

  select: ->
    @app.metro.unselect_all()
    @selected = true

  unselect: ->
    @selected = false

  toggle_select: ->
    if @selected then @unselect() else @select()

  draw: () ->

  update_drawing: () ->

  onhover: (e) ->

  unhover: (e) ->

  onclick: (e) ->


class TrackSegment extends Point

  constructor: (app, @track, i1, j1, @i2, @j2) ->
    super app, i1, j1
    @draw()
    @track.group.add @path

  draw: () ->
    @path = @app.metro.svg.path @get_path_str()
    @path.attr({
      fill: 'none', stroke: @track.color, strokeWidth: 8
    })

  get_path_str: () ->
    r = 0.95 * @app.style.node.radius
    d = @app.style.geometry.scale[1] * @app.style.track.smooth_factor
    x1 = @app.style.tox(@j)
    y1 = @app.style.toy(@i) + r
    x2 = @app.style.tox(@j2)
    y2 = @app.style.toy(@i2) - r
    path = "M #{x1},#{y1} C #{x1},#{y1+d} #{x2},#{y2-d} #{x2},#{y2}"


class Track extends Point

  constructor: (app, start, @end, djs, @color_index) ->
    super app, start.i, start.j
    @start = start
    @group = @app.metro.svg.group()
    @segments = @create_segments(djs)
    @update_group()

  update_group: () ->
    if @start.state is 'done' and @end.is_active
      @app.metro.groups.active_tracks.add(@group)
    else
      @app.metro.groups.inactive_tracks.add(@group)

  create_segments: (djs) ->
    segments = []
    i1 = @start.i
    j1 = @start.j
    for k in [0...djs.length]
      i2 = i1 + 1
      j2 = j1 + djs[k]
      segments.push new TrackSegment @app, this, i1, j1, i2, j2
      i1 = i2
      j1 = j2
    i2 = @end.i
    j2 = @end.j
    segments.push new TrackSegment @app, this, i1, j1, i2, j2
    segments

  @property 'color',
    get: () ->
      @app.style.palette[@color_index]


define () ->

  class Node extends SelectablePoint
    constructor: (app, @id, {i, j, @title, state, @color_index, @description, @conditions} = {}) ->
      super app, i, j
      @draw()
      @set_event_handlers(@group)
      @update_drawing()
      @state = state
      @is_hover = false

    update: (upt) ->
      if upt.title isnt undefined then @title = upt.title
      if upt.description isnt undefined then @description = upt.description
      if upt.conditions isnt undefined
        for id, u of upt.conditions
          c = @conditions[id]
          if u.title isnt undefined then c.title = u.title
          if u.description isnt undefined then c.description = u.description
          if u.state isnt undefined then @set_conditions_states(id, u.state)
      if upt.state isnt undefined
        @state = upt.state
          

    update_tracks: () -> t.update_group() for t in @tracks


    set_tracks: (tracks) ->
      @tracks = (new Track(@app, this, @app.metro.grid[t.child], t.djs, t.color_index) for t in tracks)

    set_conditions_states: (id, state) ->
      comp_old = @completion

      if state isnt @conditions[id].state
        r0 = @app.style.node.radius
        rescale = (s) =>
          m = new Snap.Matrix()
          m.scale s, s, @x, @y
          @group.transform(m)
        Snap.animate(1, 1.2, rescale, 200, mina.easeout)
        Snap.animate(1.2, 1, rescale, 400, mina.easeout)

      @conditions[id].state = state
      comp_new = @completion
      Snap.animate(comp_old * 359.99, comp_new * 359.99, (angle) =>
        @completion_circle.attr {
          d: @create_completion_circle @x, @y, @app.style.node.radius, @app.style.node.completion.angle_offset, angle
        }
      , @app.style.node.completion.duration, mina.easeout)


    draw: () ->
      @circle = @app.metro.svg.circle @x, @y, @app.style.node.radius
      @circle.attr {
        strokeWidth: @app.style.node.stroke_width
      }
      path = @create_completion_circle @x, @y, @app.style.node.radius, @app.style.node.completion.angle_offset, @completion * 359.99
      @completion_circle = @app.metro.svg.path path
      @completion_circle.attr {
        opacity: @app.style.node.completion.opacity
      }
      @group = @app.metro.svg.group()
      @group.add @circle
      @group.add @completion_circle
      @group.node.style.cursor = 'pointer'
      
    update_drawing: () ->
      color = tinycolor(@color)
      color = '#' + (if @is_hover then color.lighten() else color).toHex()
      s = @app.style.node.highlight
      highlight = ''
      if @selected
        highlight = @app.metro.svg.filter Snap.filter.shadow(s.x, s.y,  s.blur, @color, s.opacity)
      @circle.attr {
        fill: @app.style.node.fill, stroke: color,
        filter: highlight
      }
      @completion_circle.attr {
        fill: color
      }

    create_completion_circle: (cx, cy, r, start, angle) ->

      p_start =
        x: cx + r * Math.cos(Math.PI * start / 180)
        y: cy + r * Math.sin(Math.PI * start / 180)

      p_end =
        x: cx + r * Math.cos(Math.PI * (start + angle) / 180)
        y: cy + r * Math.sin(Math.PI * (start + angle) / 180)

      is_large_arc = if angle > 180 then 1 else 0
      path = "M#{cx},#{cy}
              L#{p_start.x},#{p_start.y}
              A#{r},#{r} 0 #{is_large_arc},1 #{p_end.x},#{p_end.y}
              L#{cx},#{cy}
              Z"

    @property 'color',
      get: () -> @app.style.palette[@color_index]

    @property 'state',
      get: () -> @_state
      set: (s) ->
        @_state = s
        if @is_active
          @app.metro.groups.active_nodes.add(@group)
        else
          @app.metro.groups.inactive_nodes.add(@group)

    @property 'is_active',
      get: () -> @state is "active" or @state is "done"

    @property 'completion',
      get: () ->
        done = (c for _, c of @conditions when c.state is 'done')
        total = (c for _, c of @conditions)
        completion = done.length / total.length

    onhover: (e) ->
      @is_hover = true
      @update_drawing()

    unhover: (e) ->
      @is_hover = false
      @update_drawing()

    onclick: (e) ->
      @toggle_select()
