local Preset = {
    TPPCar = {
        full = {1.0, 1.0, 1.0},
        faster = {1.0, 1.0, 1.0},
        slow = {1.0, 1.0, 1.0},
        crawl = {1.0, 1.0, 1.0}
    },
    TPPFarCar = {
        full = {1.0, 1.0, 1.0},
        faster = {1.0, 1.0, 1.0},
        slow = {1.0, 1.0, 1.0},
        crawl = {1.0, 1.0, 1.0}
    },
    FPPCar = {
        full = {1.0, 1.0, 1.0},
        faster = {1.0, 1.0, 1.0},
        slow = {1.0, 1.0, 1.0},
        crawl = {1.0, 1.0, 1.0}
    },
    TPPBike = {
        full = {1.0, 1.0, 1.0},
        faster = {1.0, 1.0, 1.0},
        slow = {1.0, 1.0, 1.0},
        crawl = {1.0, 1.0, 1.0}
    },
    TPPFarBike = {
        full = {1.0, 1.0, 1.0},
        faster = {1.0, 1.0, 1.0},
        slow = {1.0, 1.0, 1.0},
        crawl = {1.0, 1.0, 1.0}
    },
    FPPBike = {
        full = {1.0, 1.0, 1.0},
        faster = {1.0, 1.0, 1.0},
        slow = {1.0, 1.0, 1.0},
        crawl = {1.0, 1.0, 1.0}
    },
    MaskingInVehiclesGlobal = {
        enabled = true
    },
    Vectors = {
        VehElements = {
            BikeHandlebars = {
                MultiplyBy = {FPP = 1},
                Offset = {x=0.0, y=0.48, z=0.85},
                Size = {
                    Increment = {x = 32, y = 48},
                    Max = {x = 10540, y = 4000},
                    Min = {x = 7680, y = 1600},
                },
            },
            BikeWheelFront = {
                MultiplyBy = {TPPClose = 2.5, TPPMedium = 1.7, TPPFar = 1},
                Offset = {x=0, y=0.6, z=0.5},
                Size = {
                    Increment = {x = 3, y = 4},
                    Max = {x = 1600, y = 1400},
                    Min = {x = 1300, y = 1200},
                },
            },
            BikeWheelRear = {
                MultiplyBy = {TPPClose = 1.7, TPPMedium = 1.3, TPPFar = 1},
                Offset = {x=0, y=0.5, z=-0.6},
                Size = {
                    Increment = {x = 2, y = 4},
                    Max = {x = 1300, y = 1400},
                    Min = {x = 1100, y = 1200},
                },
            },
            BikeWindshield = {
                MultiplyBy = {FPP = 1},
                Offset = {x=0.0, y=0.56, z=1},
                Size = {
                    Increment = {x = 3, y = 8},
                    Min = {x = 2400, y = 1200},
                },
            },
            CarDiffuser = {
                MultiplyBy = {TPPClose = 2.5, TPPMedium = 1.7, TPPFar = 1},
                Offset = {x=0, y=0.2, z=-1.8},
                Size = {
                    Increment = {x = 3, y = 8},
                    Max = {x = 1500, y = 1300},
                    Min = {x = 1200, y = 900},
                },
            },
            CarFrontBumper = {
                MultiplyBy = {TPPClose = 2.5, TPPMedium = 1.7, TPPFar = 1},
                Offset = {x=0, y=0.2, z=2.0},
                Size = {
                    Increment = {x = 3, y = 16},
                    Max = {x = 1600, y = 1700},
                    Min = {x = 1300, y = 900},
                },
            },
            CarSideMirrors= {
                Left = {
                    MultiplyBy = {FPP = 1},
                    Offset = {x=-0.95, y=0.65, z=0.45},
                    Size = {
                        Increment = {x = 3, y = 8},
                        Min = {x = 1400, y = 1200},
                    },
                },
                Right = {
                    MultiplyBy = {FPP = 1},
                    Offset = {x=1.05, y=0.7, z=0.45},
                    Size = {
                        Increment = {x = 3, y = 8},
                        Min = {x = 800, y = 800},
                    },
                },
            },
        },
        VehMasks = {
            AnchorPoint = {x = 0.5, y = 0.25, yMin = 0.25, yMax = 0.3, yIncrement = 0.001},
            HorizontalEdgeDown = {
                Size = {
                    Base = {x = 4240, y = 1480} -- min size x = 3888
                }
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