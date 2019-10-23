// dependencies:
// - snap.svg -> check licensing

class Interface {
  
  constructor() {
    this.state = new State(this);
    this.metro =  new Metro(this);
    this.inspector = new Inspector(this);
  }
}

function init() {
  var interface = new Interface();
}

class Style {

  constructor(metro, {geometry, palette, node, track, shadow} = {}) {
    this.metro = metro;
    this.palette = this.create_palette(palette);
    this.geometry = this.create_geometry(geometry);
    this.track = this.create_track_style(track);
    this.node = this.create_node_style(node);
    this.create_shadow_filter(shadow);
  }

  create_palette({palette = ['#226597ff', '#f8b739ff', '#a6cb12ff']} = {}) {
    return palette;
  }

  create_geometry({margins = [40, 40], scale = [80, 80]} = {}) {
    return {margins: margins, scale: scale};
  }

  create_node_style({radius = 16, stroke_width = 2, stroke_color = '#ffffff'} = {}) {
    return {radius: radius, stroke_width: stroke_width, stroke_color: stroke_color};
  }

  create_track_style({width = 4, smooth_factor = 0.5} = {}) {
    return {width: width, smooth_factor: smooth_factor};
  }

  create_shadow_filter({x = 0, y = 0, blur = 32, opacity = 1} = {}) {
    var f = this.metro.svg.filter(Snap.filter.shadow(0, 0, 8, '#000000', 0.9));
    this.metro.svg.attr({
      filter: f,
    }); 
  }

  tox(i) {
    return this.geometry.margins[0] + i*this.geometry.scale[0];
  }

  toy(j) {
    return this.geometry.margins[1] + j*this.geometry.scale[1];
  }

}

class Grid {

  constructor(metro) {
    this.metro = metro;
    this.content = new Set();
    this.lines = new Set();
    this.redraw_grid(this.metro.svg);
  }

  place(element, i, j) {
    this.content.add(element);
    element.index = [i, j];
  }

  insert(element) {
    var imax = this.get_boundaries()[0];
    this.place(element, imax+1, 0);
  }

  get(i, j) {
    if (!j && i instanceof Array)
      [i, j] = i;
    for (let n of this.content) {
      if (n.i === i && n.j === j)
        return n;
    }
    return null;
  }

  get_all_nodes() {
    var nodes = new Set();
    for (let n of this.content) {
      if (n instanceof Node)
        nodes.add(n);
    }
    return nodes;
  }

  get_boundaries() {
    var maxi = 0, maxj = 0;
    for (let n of this.content) {
      maxi = n.i > maxi ? n.i : maxi;
      maxj = n.j > maxj ? n.j : maxj;
    }
    return [maxi, maxj];
  }

  draw_nodes(paper) {
    for (let n of this.get_all_nodes()) {
      n.draw(paper);
    }
  }

  redraw_grid(paper) {
    for (let l of this.lines) {
      this.lines.delete(l);
      l.remove();
    }
    var boundaries = this.get_boundaries();
    var maxi = boundaries[0], maxj = boundaries[1];
    for (var i = 0; i <= maxi; i++) {
      var x0 = this.metro.style.tox(-0.5);
      var y0 = this.metro.style.toy(i);
      var x1 = this.metro.style.tox(0.5 + maxj);
      var y1 = y0;
      this.draw_line(paper, x0, y0, x1, y1);
    }
    for (var j = 0; j <= maxj; j++) {
      var x0 = this.metro.style.tox(j);
      var y0 = this.metro.style.toy(-0.5);
      var x1 = x0;
      var y1 = this.metro.style.toy(0.5 + maxi);
      this.draw_line(paper, x0, y0, x1, y1);
    }
  }

  draw_line(paper, x0, y0, x1, y1) {
    var path = paper.path('M' + x0 + ' ' + y0 + 'L' + x1 + ' ' + y1);
    path.attr({
      fill: 'none',
      stroke: '#ffffff44',
      strokeWidth : 0.5,
    });
    this.lines.add(path);
  }
}

class Track {
  
  constructor(node_start, node_end) {
    this.node_start = node_start;
    this.node_end = node_end;
    this.node_start.start_tracks.add(this);
    this.node_end.end_tracks.add(this);
    this.points = new Map();
    this.draw();
  }

  draw() {
    this.path = metro.svg.path('');
    this.update();
  }

  update() {
    for (var i = this.node_start.i + 1; i < this.node_end.i; i++) {
      if (!this.points.has(i)) {
        this.points.set(i, new TrackPoint(i, 0));
      }
    }
  }

  draw_line(start, end) {
    var x0 = start.x;
    var y0 = start.y;
    var x1 = end.x;
    var y1 = end.y;
    this.path.remove();
    this.path = metro.svg.path('M' + x0 + ' ' + y0 + 'L' + x1 + ' ' + y1);
    this.path.attr({
      fill: 'none',
      stroke: this.node_start.get_color(),
      strokeWidth : 20,
    });
  }
}

class TrackPoint extends Point {

  constructor(i, j) {
  }

}


class Inspector {

  constructor(id='inspector') {
    this.dom = this.get_dom(id);
    metro.state = 'normal';

    this.selection = new Set();
    this.update_header();
  }

  get_dom(id) {

    // inspector
    var dom = {inspector: document.getElementById(id)};

    // header
    for (let n of dom.inspector.children) {
      if (n.className === 'header') {
        dom.header = n;
        break;
      }
    }

    // title
    for (let n of dom.header.children) {
      if (n.tagName === 'H1') {
        dom.title = n;
        break;
      }
    }

    // content 
    for (let n of dom.inspector.children) {
      if (n.className === 'content') {
        dom.content = n;
        break;
      }
    }

    // conditions 
    for (let n of dom.content.children) {
      if (n.className === 'conditions') {
        dom.conditions = n;
        break;
      }
    }

    return dom;

  }

  get state() {
    return this._state;
  }

  set state(state) {
    this._state = state;
    switch (state) {
      case 'peak_node':
        this.dom.button_add.innerHTML = 'Selectionner un noeud';
        break;
      case 'normal':
        this.dom.button_add.innerHTML = '<img src="img/plus-circle.svg">Nouvelle condition';
        break;
    }
    metro.state = state;
  }

  select(element) {
    this.selection.add(element);
    this.update_header();
    this.update_conditions();
  }

  unselect(element) {
    this.selection.delete(element);
    this.update_header();
    this.update_conditions();
  }

  update_header() {
    if (this.selection.size === 1) {
      var e = this.selection.values().next().value;
      this.set_color(e.get_color());
      this.dom.header.style.display = 'flex';
      this.dom.title.innerHTML = e.name;
    } else {
      this.dom.header.style.display = 'none';
      this.set_color('#f2f4fb');
    }
  }

  update_conditions() {
    if (this.selection.size === 1) {
      var e = this.selection.values().next().value;

      // clear
      while (this.dom.conditions.firstChild)
        this.dom.conditions.removeChild(this.dom.conditions.firstChild)

      // h2 "Conditions"
      var h2 = document.createElement('H2');
      h2.innerHTML = 'Conditions';
      this.dom.conditions.appendChild(h2);

      // condition list
      for (let n of e.conditions.keys()) {
        var li = document.createElement('li');
        li.innerHTML = n.name;
        li.style.background = '#' + tinycolor(n.get_color()).brighten().toHex();
        this.dom.conditions.appendChild(li);
      }

      // button_add
      this.dom.button_add = document.createElement('li');
      this.dom.button_add.className = 'add';
      this.dom.button_add.innerHTML = '<img src="img/plus-circle.svg">Nouvelle condition';
      this.dom.button_add.addEventListener('click', function() {
        inspector.state = 'peak_node';
      });
      this.dom.conditions.appendChild(this.dom.button_add);
      this.dom.conditions.style.display = 'block';
    } else {
      this.dom.conditions.style.display = 'none';
    }
  }

  set_color(color) {
    color = tinycolor(color);
    this.dom.header.style.background = '#' + color.toHex();
  }

  add_condition(e) {
    for (let n of this.selection) {
      n.conditions.set(e, new Track(e, n));
      console.log(n.conditions);
    }
    this.update_conditions();
  }
}
