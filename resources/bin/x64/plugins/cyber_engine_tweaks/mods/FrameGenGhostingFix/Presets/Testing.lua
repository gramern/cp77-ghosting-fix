local Preset = {
  __VERSION_NUMBER = 484,
  MaskingGlobal = {
    enabled = true
  },
  Vectors = {
    VehElements = {
      BikeSpeedometer = {
        Offset = {x=0.0, y=0.45, z=0.8},
        rotation = 180,
        Size = {x = 6120, y = 1600},
        visible = true,
      },
      BikeHandlebars = {
        Left = {
          Offset = {x=-0.6, y=0.48, z=0.7},
          rotation = 0,
          Size = {x = 3000, y = 1800},
          visible = true,
        },
        Right = {
          Offset = {x=0.6, y=0.48, z=0.7},
          rotation = 0,
          Size = {x = 3000, y = 1800},
          visible = true,
        }
      },
      BikeWindshield = {
        Offset = {x=0.0, y=0.54, z=1},
        rotation = 0,
        Size = {x = 3600, y = 1200},
        visible = true,
      },
      CarDoors = {
        Left = {
          Offset = {x=-1.2, y=0, z=0.55},
          rotation = 140,
          Size = {x = 3000, y = 2000},
          visible = true,
        },
        Right = {
          Offset = {x=1.2, y=0, z=0.55},
          rotation = -160,
          Size = {x = 2250, y = 1500},
          visible = true,
        },
      },
      CarSideMirrors = {
        Left = {
          Offset = {x=-1, y=0.65, z=0.45},
          rotation = 40,
          Size = {x = 1400, y = 1200},
          visible = true,
        },
        Right = {
          Offset = {x=1.05, y=0.65, z=0.45},
          rotation = 145,
          Size = {x = 800, y = 800},
          visible = true,
        },
      },
    },
    VehMasks = {
      AnchorPoint = {x = 0.5, y = 0.5},
      HorizontalEdgeDown = {
        Opacity = {
          Def = {
            max = 1,
          }
        },
        Size = {
          Def = {
            lock = true,
            x = 4240, -- min size x = 3888
            y = 1480
          },
        },
        Visible = {
          Def = {
            corners = true,
            fill = true,
            fillLock = false,
            tracker = true,
          }
        }
      },
      Opacity = {
        Def = {
          delayDuration = 1,
          delayThreshold = 1,
          gain = 1,
          max = 1,
          speedFactor = 1,
          stepFactor = 0.1
        },
      }
    },
  },
  PresetInfo = {
    name = "Testing",
    description = "Testing preset, all masks visible.",
    author = nil
  }
}

return Preset