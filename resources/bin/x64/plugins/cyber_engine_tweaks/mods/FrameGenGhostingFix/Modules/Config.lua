local UIText = require('Modules/UIText')

local Config = {
  __EDITION = "IV",
  __VERSION_NUMBER = 484,
  __VERSION_SUFFIX = "xl",
  MaskingGlobal = {
    enabled = true,
    ironsightController = false,
    masksController = "gameuiCrosshairContainerController",
    Widgets = {
      hedCorners = "horizontaledgedowncorners",
      hedFill = "horizontaledgedownfill",
      hedTracker = "horizontaledgedowntracker",
      mask1 = "mask1",
      mask2 = "mask2",
      mask3 = "mask3",
      mask4 = "mask4",
      maskEditor = "mask_editor",
    }
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
            max = 0.03,
          }
        },
        Size = {
          Def = {
            lock = false,
            x = 4240,
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
          delayDuration = 1.5,
          delayThreshold = 0.95,
          gain = 1,
          max = 0.05,
          speedFactor = 0.01,
          stepFactor = 0.1
        },
      }
    }
  },
  Customize = {
    PresetInfo = {
      file = "Customize.lua",
      --name is the name of the preset its like before (but not visible on UI it's system only)
      name = "Customize",
      --display is the name of the preset if a translation is available (visible on UI only)
      display = UIText.Presets.Customize.name,
      description = UIText.Presets.Customize.description,
      author = nil
    },
  },
  Default = {
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
              max = 0.03,
            }
          },
          Size = {
            Def = {
              lock = false,
              x = 4240,
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
            delayDuration = 1.5,
            delayThreshold = 0.95,
            gain = 1,
            max = 0.05,
            speedFactor = 0.01,
            stepFactor = 0.1
          },
        }
      }
    },
    PresetInfo = {
      file = "Default.lua",
      --name is the name of the preset its like before (but not visible on UI it's system only)
      name = "Default",
      --display is the name of the preset if a translation is available (visible on UI only)
      display = UIText.Presets.Default.name,
      description = UIText.Presets.Default.description,
    },
  },
}

return Config