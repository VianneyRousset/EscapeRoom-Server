// Generated by CoffeeScript 1.9.3
(function() {
  define(function() {
    var DevicesList;
    DevicesList = (function() {
      function DevicesList(app) {
        this.app = app;
        this.event_source;
      }

      return DevicesList;

    })();
    return {
      subscribe: function(path) {
        this.event_source = new EventSource(path);
        return event_source.onmessage = function(event) {
          return this.update(event.data);
        };
      },
      update: function(devices) {
        var device, results, uid;
        results = [];
        for (uid in devices) {
          device = devices[uid];
          results.push(console.log(device));
        }
        return results;
      }
    };
  });

}).call(this);
