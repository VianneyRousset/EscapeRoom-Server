// Generated by CoffeeScript 2.3.2
var DevicesList, List,
  indexOf = [].indexOf;

import './lib/jquery-3.4.1.js';

List = class List {
  constructor(id) {
    this.state = 'none';
    this.list_node = document.querySelector(id);
    this.template_node = this.list_node.querySelector('template');
    this.loading_node = this.list_node.querySelector('.loading');
    this.error_node = this.list_node.querySelector('.error');
    this.event_source = null;
  }

  subscribe(path) {
    this.set_state('loading');
    this.event_source = new EventSource(path);
    this.event_source.onmessage = (event) => {
      this.update(JSON.parse(event.data));
      return this.set_state('good');
    };
    return this.event_source.onerror = (error) => {
      console.log(error);
      return this.set_state('error');
    };
  }

  update(datas) {
    var data, i, item_node, len, results, uid, uids;
    uids = (function() {
      var i, len, ref, results;
      ref = this.items_nodes();
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        item_node = ref[i];
        results.push(item_node.getAttribute('uid'));
      }
      return results;
    }).call(this);
    for (i = 0, len = uids.length; i < len; i++) {
      uid = uids[i];
      if (!(uid in datas)) {
        this.item_node(uid).remove();
      }
    }
    results = [];
    for (uid in datas) {
      data = datas[uid];
      uids = (function() {
        var j, len1, ref, results1;
        ref = this.items_nodes();
        results1 = [];
        for (j = 0, len1 = ref.length; j < len1; j++) {
          item_node = ref[j];
          results1.push(item_node.getAttribute('uid'));
        }
        return results1;
      }).call(this);
      if (indexOf.call(uids, uid) < 0) {
        results.push(this.add_row(uid, data));
      } else {
        results.push(this.update_item(this.item_node(uid), data));
      }
    }
    return results;
  }

  add_row(uid, data) {
    var clone, item;
    clone = document.importNode(this.template_node.content, true);
    this.list_node.appendChild(clone);
    item = this.item_node('');
    item.style.display = 'none';
    item.setAttribute('uid', uid);
    this.update_item(item, data);
    return item.style.display = 'block';
  }

  set_state(state) {
    var i, item_node, j, k, len, len1, len2, ref, ref1, ref2;
    if (state === 'loading') {
      this.error_node.style.display = 'none';
      ref = this.items_nodes;
      for (i = 0, len = ref.length; i < len; i++) {
        item_node = ref[i];
        item.style.display = 'none';
      }
      return this.loading_node.style.display = 'block';
    } else if (state === 'good') {
      this.loading_node.style.display = 'none';
      this.error_node.style.display = 'none';
      ref1 = this.items_nodes;
      for (j = 0, len1 = ref1.length; j < len1; j++) {
        item_node = ref1[j];
        item.style.display = 'block';
      }
      return console.log('good');
    } else if (state === 'error') {
      ref2 = this.items_nodes;
      for (k = 0, len2 = ref2.length; k < len2; k++) {
        item_node = ref2[k];
        item.style.display = 'none';
      }
      this.loading_node.style.display = 'none';
      return this.error_node.style.display = 'block';
    }
  }

  //TODO sort list alphabetically
  items_nodes() {
    return this.list_node.querySelectorAll('.item');
  }

  item_node(uid) {
    return this.list_node.querySelector('.item[uid="' + uid + '"]');
  }

};

DevicesList = class DevicesList extends List {
  constructor() {
    super('#devices-list');
  }

  set_game(game_name) {
    return this.subscribe('/' + game_name + '/devices');
  }

  update_item(item, data) {
    return item.querySelector('summary').textContent = data['name'];
  }

};

//TODO state, online/offline
window.addEventListener('load', function() {
  var devices_list;
  devices_list = new DevicesList;
  return devices_list.set_game('b3');
});
