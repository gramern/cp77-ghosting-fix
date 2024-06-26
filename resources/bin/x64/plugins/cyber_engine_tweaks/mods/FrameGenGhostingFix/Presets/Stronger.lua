local Preset = {
  __VERSION_NUMBER = 480,
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
        opacity = 0,
        opacityMax = 0.03,
        Size = {
          Base = {x = 4240, y = 1480} -- min size x = 3888
        },
        Visible = {
          Base = {
            corners = true,
            fill = true,
            fillLock = true,
            tracker = true,
          }
        }
      },
      Opacity = {
        Def = {
          delayDuration = 3,
          delayThreshold = 0.95,
          gain = 3,
          max = 0.05,
          speedFactor = 0.01,
          stepFactor = 0.1
        },
      }
    },
  },
  PresetInfo = {
    name = "Stronger",
    description = "Masks' anti-ghosting strength is slightly greater and\ntheir state change delay on a sudden speed decrease\nis twice as long (3 seconds instead of 1.5).",
    author = nil
  }
}

return Preset