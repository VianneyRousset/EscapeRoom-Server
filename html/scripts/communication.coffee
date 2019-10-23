updates = [

  {
    "nodes": {
      "f": {
        "conditions" : {
          "2": {"state": "done"}
        }
      }
    }
  },

  {
    "nodes": {
      "h": {
        "conditions" : {
          "3": {"state": "done"}
        }
      }
    }
  },

  {
    "nodes": {
      "f": {
        "conditions" : {
          "3": {"state": "done"}
        },
        "state": "done"
      },
      "i": {
        "state": "active"
      }
    }
  },

  {
    "nodes": {
      "e": {
        "conditions" : {
          "2": {"state": "done"}
        },
        "state": "done"
      }
    }
  },

  {},

  {
    "nodes": {
      "i": {
        "conditions" : {
          "2": {"state": "done"}
        }
      }
    }
  },

  {
    "nodes": {
      "h": {
        "conditions" : {
          "2": {"state": "done"}
        },
        "state": "done"
      }
      "j": {
        "state": "active"
      }
    }
  },

  ]

define () ->
  class Communication
    constructor: (@app) ->
      #device_events = new EventSource "/b3/devices"
      #device_events.onmessage = (e) => @app.devices.update(e.data)

    listen: () ->
      @app.devices_list.set({'Alice': {}, 'Bob': {}, 'Catherine': {}})
      @app.server_log.add(['Problem', 'Everything is fine'])
      @app.clues.set_propositions([
        'N\'éteigez pas la lumière',
          'La baguette chambre pour croissant',
          'Pour un poulet le coq ne se réveil pas le matin',
          'L\'astuce est de pointer la lune',
          'Ne repeigner pas l\'ours si son pneu est usé',
          'Chat imbriqué jamais refermé'
      ])

    get_init_tree: () ->
      new Promise (resolve, reject) => (
        setTimeout(
          () => resolve(@tmp_init_tree()),
          2000
        )
      )

    tmp_init_tree: () -> JSON.parse '''{
      "nodes": {

        "a": {
          "i": 0, "j": 1, "title": "Node A", "state": "done",
          "description": "Voici le contenu du noeud dont l'identifiant est a",
          "color_index": 0, "tracks": [
            {"child": "b", "color_index": 0, "djs": []}
          ],
          "conditions": {
            "1": {
              "title": "Condition 1",
              "description": "C'est la condition un",
              "state": "done" 
            },
            "2": {
              "title": "Condition 2",
              "description": "C'est la condition deux",
              "state": "done" 
            },
            "3": {
              "title": "Condition 3",
              "description": "C'est la condition trois",
              "state": "done" 
            }
          }
        },

        "b": {
          "i": 1, "j": 1, "title": "Node B", "state": "done",
          "description": "Voici le contenu du noeud dont l'identifiant est b",
          "color_index": 0, "tracks": [
            {"child": "c", "color_index": 0, "djs": []}
          ],
          "conditions": {
            "1": {
              "title": "Condition 1",
              "description": "C'est la condition un",
              "state": "done" 
            },
            "2": {
              "title": "Condition 2",
              "description": "C'est la condition deux",
              "state": "done" 
            },
            "3": {
              "title": "Condition 3",
              "description": "C'est la condition trois",
              "state": "done" 
            }
          }
        },

        "c": {
          "i": 2, "j": 1, "title": "Node C", "state": "done",
          "description": "Voici le contenu du noeud dont l'identifiant est c",
          "color_index": 0, "tracks": [
            {"child": "d", "color_index": 0, "djs": []},
            {"child": "e", "color_index": 1, "djs": []}
          ],
          "conditions": {
            "1": {
              "title": "Condition 1",
              "description": "C'est la condition un",
              "state": "done" 
            },
            "2": {
              "title": "Condition 2",
              "description": "C'est la condition deux",
              "state": "done" 
            },
            "3": {
              "title": "Condition 3",
              "description": "C'est la condition trois",
              "state": "done" 
            }
          }
        },

        "d": {
          "i": 3, "j": 1, "title": "Node D", "state": "done",
          "description": "Voici le contenu du noeud dont l'identifiant est d",
          "color_index": 0, "tracks": [
            {"child": "f", "color_index": 1, "djs": []},
            {"child": "g", "color_index": 0, "djs": []},
            {"child": "h", "color_index": 2, "djs": []}
          ],
          "conditions": {
            "1": {
              "title": "Condition 1",
              "description": "C'est la condition un",
              "state": "done" 
            },
            "2": {
              "title": "Condition 2",
              "description": "C'est la condition deux",
              "state": "done" 
            },
            "3": {
              "title": "Condition 3",
              "description": "C'est la condition trois",
              "state": "done" 
            }
          }
        },

        "e": {
          "i": 3, "j": 2, "title": "Node E", "state": "active",
          "description": "Voici le contenu du noeud dont l'identifiant est e",
          "color_index": 1, "tracks": [],
          "conditions": {
            "1": {
              "title": "Condition 1",
              "description": "C'est la condition un",
              "state": "done" 
            },
            "2": {
              "title": "Condition 2",
              "description": "C'est la condition deux",
              "state": "active" 
            },
            "3": {
              "title": "Condition 3",
              "description": "C'est la condition trois",
              "state": "done" 
            }
          }
        },

        "f": {
          "i": 4, "j": 0, "title": "Node F", "state": "active",
          "description": "Voici le contenu du noeud dont l'identifiant est f",
          "color_index": 1, "tracks": [
            {"child": "i", "color_index": 1, "djs": []}
          ],
          "conditions": {
            "1": {
              "title": "Condition 1",
              "description": "C'est la condition un",
              "state": "done" 
            },
            "2": {
              "title": "Condition 2",
              "description": "C'est la condition deux",
              "state": "active" 
            },
            "3": {
              "title": "Condition 3",
              "description": "C'est la condition trois",
              "state": "inactive" 
            }
          }
        },

        "g": {
          "i": 4, "j": 1, "title": "Node G", "state": "active",
          "description": "Voici le contenu du noeud dont l'identifiant est g",
          "color_index": 0, "tracks": [
            {"child": "j", "color_index": 0, "djs": []},
            {"child": "k", "color_index": 3, "djs": []}
          ],
          "conditions": {
            "1": {
              "title": "Condition 1",
              "description": "C'est la condition un",
              "state": "done" 
            },
            "2": {
              "title": "Condition 2",
              "description": "C'est la condition deux",
              "state": "done" 
            },
            "3": {
              "title": "Condition 3",
              "description": "C'est la condition trois",
              "state": "inactive" 
            }
          }
        },

        "h": {
          "i": 4, "j": 2, "title": "Node H", "state": "active",
          "description": "Voici le contenu du noeud dont l'identifiant est h",
          "color_index": 2, "tracks": [
            {"child": "j", "color_index": 2, "djs": []}
          ],
          "conditions": {
            "1": {
              "title": "Condition 1",
              "description": "C'est la condition un",
              "state": "done" 
            },
            "2": {
              "title": "Condition 2",
              "description": "C'est la condition deux",
              "state": "active" 
            },
            "3": {
              "title": "Condition 3",
              "description": "C'est la condition trois",
              "state": "inactive" 
            }
          }
        },

        "i": {
          "i": 5, "j": 0, "title": "Node I", "state": "inactive",
          "description": "Voici le contenu du noeud dont l'identifiant est i",
          "color_index": 1, "tracks": [
            {"child": "l", "color_index": 1, "djs": []},
            {"child": "m", "color_index": 1, "djs": []}
          ],
          "conditions": {
            "1": {
              "title": "Condition 1",
              "description": "C'est la condition un",
              "state": "done" 
            },
            "2": {
              "title": "Condition 2",
              "description": "C'est la condition deux",
              "state": "active" 
            },
            "3": {
              "title": "Condition 3",
              "description": "C'est la condition trois",
              "state": "inactive" 
            }
          }
        },

        "j": {
          "i": 5, "j": 1, "title": "Node J", "state": "inactive",
          "description": "Voici le contenu du noeud dont l'identifiant est j",
          "color_index": 0, "tracks": [
            {"child": "m", "color_index": 0, "djs": []}
          ],
          "conditions": {
            "1": {
              "title": "Condition 1",
              "description": "C'est la condition un",
              "state": "done" 
            },
            "2": {
              "title": "Condition 2",
              "description": "C'est la condition deux",
              "state": "active" 
            },
            "3": {
              "title": "Condition 3",
              "description": "C'est la condition trois",
              "state": "inactive" 
            }
          }
        },

        "k": {
          "i": 5, "j": 2, "title": "Node K", "state": "inactive",
          "description": "Voici le contenu du noeud dont l'identifiant est k",
          "color_index": 3, "tracks": [
            {"child": "m", "color_index": 3, "djs": []}
          ],
          "conditions": {
            "1": {
              "title": "Condition 1",
              "description": "C'est la condition un",
              "state": "done" 
            },
            "2": {
              "title": "Condition 2",
              "description": "C'est la condition deux",
              "state": "active" 
            },
            "3": {
              "title": "Condition 3",
              "description": "C'est la condition trois",
              "state": "inactive" 
            }
          }
        },

        "l": {
          "i": 6, "j": 0, "title": "Node L", "state": "inactive",
          "description": "Voici le contenu du noeud dont l'identifiant est l",
          "color_index": 1, "tracks": [],
          "conditions": {
            "1": {
              "title": "Condition 1",
              "description": "C'est la condition un",
              "state": "done" 
            },
            "2": {
              "title": "Condition 2",
              "description": "C'est la condition deux",
              "state": "active" 
            },
            "3": {
              "title": "Condition 3",
              "description": "C'est la condition trois",
              "state": "inactive" 
            }
          }
        },

        "m": {
          "i": 6, "j": 1, "title": "Node M", "state": "inactive",
          "description": "Voici le contenu du noeud dont l'identifiant est m",
          "color_index": 0, "tracks": [],
          "conditions": {
            "1": {
              "title": "Condition 1",
              "description": "C'est la condition un",
              "state": "done" 
            },
            "2": {
              "title": "Condition 2",
              "description": "C'est la condition deux",
              "state": "active" 
            },
            "3": {
              "title": "Condition 3",
              "description": "C'est la condition trois",
              "state": "inactive" 
            }
          }
        }
      }
    }
'''
