local Preset = {
    TPPCar = {
        full = {0.03, 0.07, 0.07},
        faster = {0.02, 0.05, 0.05},
        slow = {0.01, 0.035, 0.035},
        crawl = {0.005, 0.02, 0.02}
    },
    TPPFarCar = {
        full = {0.03, 0.07, 0.07},
        faster = {0.02, 0.05, 0.05},
        slow = {0.01, 0.035, 0.035},
        crawl = {0.005, 0.02, 0.02}
    },
    FPPCar = {
        full = {0.03, 0.07, 0.04},
        faster = {0.02, 0.05, 0.03},
        slow = {0.01, 0.035, 0.02},
        crawl = {0.005, 0.02, 0.02}
    },
    TPPBike = {
        full = {0.03, 0.07, 0.07},
        faster = {0.02, 0.05, 0.05},
        slow = {0.01, 0.035, 0.035},
        crawl = {0.005, 0.02, 0.02}
    },
    TPPFarBike = {
        full = {0.03, 0.07, 0.07},
        faster = {0.02, 0.05, 0.05},
        slow = {0.01, 0.035, 0.035},
        crawl = {0.005, 0.02, 0.02}
    },
    FPPBike = {
        full = {0.03, 0.07, 0.07},
        faster = {0.02, 0.05, 0.05},
        slow = {0.01, 0.035, 0.035},
        crawl = {0.005, 0.02, 0.02},
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
                    Increment = {x = 48, y = 64},
                    Max = {x = 11540, y = 5000},
                    Min = {x = 7680, y = 1600},
                },
            },
            BikeWheelFront = {
                MultiplyBy = {TPPClose = 2.5, TPPMedium = 1.7, TPPFar = 1},
                Offset = {x=0, y=0.6, z=0.5},
                Size = {
                    Increment = {x = 3, y = 4},
                    Max = {x = 1600, y = 1500},
                    Min = {x = 1300, y = 1300},
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
                    Increment = {x = 3, y = 4},
                    Max = {x = 1600, y = 1600},
                    Min = {x = 1300, y = 1400},
                },
            },
            CarFrontBumper = {
                MultiplyBy = {TPPClose = 2.5, TPPMedium = 1.7, TPPFar = 1},
                Offset = {x=0, y=0.2, z=2.0},
                Size = {
                    Increment = {x = 3, y = 16},
                    Max = {x = 1800, y = 1700},
                    Min = {x = 1500, y = 900},
                },
            },
            CarSideMirrors= {
                Left = {
                    MultiplyBy = {FPP = 1},
                    Offset = {x=-0.95, y=0.65, z=0.45},
                    Size = {
                        Increment = {x = 3, y = 8},
                        Min = {x = 1400, y = 1300},
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
                    Base = {x = 4000, y = 1680} -- min size x = 3888
                }
            }
        },
    },
	PresetInfo = {
        name = "Stronger",
		description = "Increases size of anti-ghosting masks for vehicles by ~8%.\nWorks with all types of screens supported by Ghosting 'Fix'.\nRecommended as default for 4:3.",
        author = nil
	}
}

return Preset