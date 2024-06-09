//Thanks to djkovrik and psiberx for help and redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

//FrameGen Ghosting 'Fix' 4.8.0xl-alpha4, 2024 gramern (scz_g) 2024

@addField(gameuiCrosshairContainerController) public let m_isMaskingInVehiclesEnabledFGGF: Bool = true;
@addField(gameuiCrosshairContainerController) public let m_isVehicleMountedFGGF: Bool = false;
@addField(gameuiCrosshairContainerController) public let m_hedCornersPath: CName = n"fgfixcars/horizontaledgedowncorners";
@addField(gameuiCrosshairContainerController) public let m_hedFillPath: CName = n"fgfixcars/horizontaledgedownfill";
@addField(gameuiCrosshairContainerController) public let m_hedTrackerPath: CName = n"fgfixcars/horizontaledgedowntracker";
@addField(gameuiCrosshairContainerController) public let m_mask1Path: CName = n"fgfixcars/mask1";
@addField(gameuiCrosshairContainerController) public let m_mask2Path: CName = n"fgfixcars/mask2";
@addField(gameuiCrosshairContainerController) public let m_mask3Path: CName = n"fgfixcars/mask3";
@addField(gameuiCrosshairContainerController) public let m_mask4Path: CName = n"fgfixcars/mask4";

@addField(gameuiCrosshairContainerController) public let m_hedCornersDone: Bool = false;
@addField(gameuiCrosshairContainerController) public let m_hedFillDone: Bool = false;
@addField(gameuiCrosshairContainerController) public let m_mask1Done: Bool = false;
@addField(gameuiCrosshairContainerController) public let m_mask2Done: Bool = false;
@addField(gameuiCrosshairContainerController) public let m_mask3Done: Bool = false;

@addField(DriveEvents) public let m_carCameraContextFGGF: vehicleCameraPerspective;
@addField(DriveEvents) public let m_bikeCameraContextFGGF: vehicleCameraPerspective;
@addField(DriveEvents) public let m_vehicleCurrentTypeFGGF: gamedataVehicleType;
@addField(DriveEvents) public let m_vehicleCurrentSpeedFGGF: Float;
@addField(DriveEvents) public let m_vehicleCurrentSpeedCallbackFGGF: ref<CallbackHandle>;
// @addField(DriveEvents) public let m_hedOpacity: Float;
// @addField(DriveEvents) public let m_hedOpacityMax: Float = 0.03;
// @addField(DriveEvents) public let m_masksOpacity: Float;
// @addField(DriveEvents) public let m_masksOpacityMax: Float = 0.06;

@addField(DriverCombatEvents) public let m_carCameraContextFGGF: vehicleCameraPerspective;
@addField(DriverCombatEvents) public let m_bikeCameraContextFGGF: vehicleCameraPerspective;
@addField(DriverCombatEvents) public let m_vehicleCurrentTypeFGGF: gamedataVehicleType;
@addField(DriverCombatEvents) public let m_vehicleCurrentSpeedFGGF: Float;
@addField(DriverCombatEvents) public let m_vehicleCurrentSpeedCallbackFGGF: ref<CallbackHandle>;
// @addField(DriverCombatEvents) public let m_hedOpacity: Float;
// @addField(DriverCombatEvents) public let m_hedOpacityMax: Float = 0.03;
// @addField(DriverCombatEvents) public let m_masksOpacity: Float;
// @addField(DriverCombatEvents) public let m_masksOpacityMax: Float = 0.06;

//Mounting/unmounting events---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
private cb func OnFrameGenGhostingFixMountingEvent(evt: ref<MountingEvent>) -> Bool {
  this.m_isVehicleMountedFGGF = true;
}

@addMethod(gameuiCrosshairContainerController)
private cb func OnFrameGenGhostingFixUnmountingEvent(evt: ref<UnmountingEvent>) -> Bool {
  
  this.m_isVehicleMountedFGGF = false;

  let deactivationEvent: ref<FrameGenGhostingFixDeactivationHEDVehicleEvent>;
  this.OnFrameGenGhostingFixDeactivationHEDVehicleEvent(deactivationEvent);
}

//Global toggle for transtions, called in the main loop---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected final func FrameGenFrameGenGhostingFixVehicleToggleEvent() -> Void {
  this.FrameGenGhostingFixVehicleToggle(true);
}

@addMethod(gameuiCrosshairContainerController)
protected final func FrameGenGhostingFixVehicleToggle(maskingInVehicles: Bool) -> Void {
  this.m_isMaskingInVehiclesEnabledFGGF = maskingInVehicles;
}

//Setting transformation for specific masks---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
private cb func OnFrameGenGhostingFixTransformationHEDCorners(setMaskPath: CName, setMaskMargin: Vector2, setMaskSize: Vector2, setMaskOpacity: Float, setMaskVisible: Bool) -> Bool {
  this.FrameGenGhostingFixSetSimpleTransformation(setMaskPath, setMaskMargin, setMaskSize, setMaskOpacity, setMaskVisible);
}

@addMethod(gameuiCrosshairContainerController)
private cb func OnFrameGenGhostingFixTransformationHEDFill(setMaskPath: CName, setMaskMargin: Vector2, setMaskSize: Vector2, setMaskOpacity: Float, setMaskVisible: Bool) -> Bool {
  this.FrameGenGhostingFixSetSimpleTransformation(setMaskPath, setMaskMargin, setMaskSize, setMaskOpacity, setMaskVisible);
}

@addMethod(gameuiCrosshairContainerController)
private cb func OnFrameGenGhostingFixTransformationHEDTracker(setMaskPath: CName, setMaskMargin: Vector2, setMaskSize: Vector2, setMaskOpacity: Float, setMaskVisible: Bool) -> Bool {
  this.FrameGenGhostingFixSetSimpleTransformation(setMaskPath, setMaskMargin, setMaskSize, setMaskOpacity, setMaskVisible);
}

@addMethod(gameuiCrosshairContainerController)
private cb func OnFrameGenGhostingFixTransformationMask1(setMaskPath: CName, setMaskMargin: Vector2, setMaskSize: Vector2, setMaskRotation: Float, setMaskShear: Vector2, setMaskAnchorPoint: Vector2, setMaskOpacity: Float, setMaskVisible: Bool) -> Bool {
  this.FrameGenGhostingFixSetTransformation(setMaskPath, setMaskMargin, setMaskSize, setMaskRotation, setMaskShear, setMaskAnchorPoint, setMaskOpacity, setMaskVisible);
}

@addMethod(gameuiCrosshairContainerController)
private cb func OnFrameGenGhostingFixTransformationMask2(setMaskPath: CName, setMaskMargin: Vector2, setMaskSize: Vector2, setMaskRotation: Float, setMaskShear: Vector2, setMaskAnchorPoint: Vector2, setMaskOpacity: Float, setMaskVisible: Bool) -> Bool {
  this.FrameGenGhostingFixSetTransformation(setMaskPath, setMaskMargin, setMaskSize, setMaskRotation, setMaskShear, setMaskAnchorPoint, setMaskOpacity, setMaskVisible);
}

@addMethod(gameuiCrosshairContainerController)
private cb func OnFrameGenGhostingFixTransformationMask3(setMaskPath: CName, setMaskMargin: Vector2, setMaskSize: Vector2, setMaskRotation: Float, setMaskShear: Vector2, setMaskAnchorPoint: Vector2, setMaskOpacity: Float, setMaskVisible: Bool) -> Bool {
  this.FrameGenGhostingFixSetTransformation(setMaskPath, setMaskMargin, setMaskSize, setMaskRotation, setMaskShear, setMaskAnchorPoint, setMaskOpacity, setMaskVisible);
}

@addMethod(gameuiCrosshairContainerController)
private cb func OnFrameGenGhostingFixTransformationMask4(setMaskPath: CName, setMaskMargin: Vector2, setMaskSize: Vector2, setMaskRotation: Float, setMaskShear: Vector2, setMaskAnchorPoint: Vector2, setMaskOpacity: Float, setMaskVisible: Bool) -> Bool {
  this.FrameGenGhostingFixSetTransformation(setMaskPath, setMaskMargin, setMaskSize, setMaskRotation, setMaskShear, setMaskAnchorPoint, setMaskOpacity, setMaskVisible);
}

//Setting masks when changing cameras in a car---------------------------------------------------------------------------------------
//TPP Car---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
private cb func OnFrameGenGhostingFixCameraTPPCarEvent(evt: ref<FrameGenGhostingFixCameraTPPCarEvent>) -> Bool {

  let hedMargin: Vector2 = new Vector2(1920.0, 2280.0);
  let hedSize: Vector2 = new Vector2(4240.0, 1440.0);

  this.OnFrameGenGhostingFixTransformationHEDCorners(this.m_hedCornersPath, hedMargin, hedSize, 0.03, true);
  this.OnFrameGenGhostingFixTransformationHEDFill(this.m_hedFillPath, hedMargin, hedSize, 0.03, true);

  let hedTrackerMargin: Vector2 = new Vector2(1920.0, 1920.0);
  let hedTrackerSize: Vector2 = new Vector2(2400.0, 1200.0);

  this.OnFrameGenGhostingFixTransformationHEDTracker(this.m_hedTrackerPath, hedTrackerMargin, hedTrackerSize, 0.0, false);

  let mask1Margin: Vector2 = new Vector2(1920.0, 2000.0);
  let mask1Size: Vector2 = new Vector2(7680.0, 1200.0);
  let mask1Shear: Vector2 = new Vector2(0.0, 0.0);
  let mask1AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

  this.OnFrameGenGhostingFixTransformationMask2(this.m_mask1Path, mask1Margin, mask1Size, 0.0, mask1Shear, mask1AnchorPoint, 0.07, true);
  
  let mask2Margin: Vector2 = new Vector2(1920.0, 1900.0);
  let mask2Size: Vector2 = new Vector2(5120.0, 1200.0);
  let mask2Shear: Vector2 = new Vector2(0.0, 0.0);
  let mask2AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

  this.OnFrameGenGhostingFixTransformationMask2(this.m_mask2Path, mask2Margin, mask2Size, 0.0, mask2Shear, mask2AnchorPoint, 0.07, true);

  let mask3Margin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask3Size: Vector2 = new Vector2(2800.0, 1200.0);
  let mask3Shear: Vector2 = new Vector2(0.0, 0.0);
  let mask3AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

  this.OnFrameGenGhostingFixTransformationMask2(this.m_mask3Path, mask3Margin, mask3Size, 0.0, mask3Shear, mask3AnchorPoint, 0.07, true);

    let mask4Margin: Vector2 = new Vector2(0.0, 0.0);
  let mask4Size: Vector2 = new Vector2(0.0, 0.0);
  let mask4Shear: Vector2 = new Vector2(0.0, 0.0);
  let mask4AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

  this.OnFrameGenGhostingFixTransformationMask2(this.m_mask4Path, mask4Margin, mask4Size, 0.0, mask4Shear, mask4AnchorPoint, 0.0, false);
}

//TPP Far Car---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
private cb func OnFrameGenGhostingFixCameraTPPFarCarEvent(evt: ref<FrameGenGhostingFixCameraTPPFarCarEvent>) -> Bool {

  let hedMargin: Vector2 = new Vector2(1920.0, 2280.0);
  let hedSize: Vector2 = new Vector2(4240.0, 1440.0);

  this.OnFrameGenGhostingFixTransformationHEDCorners(this.m_hedCornersPath, hedMargin, hedSize, 0.03, true);
  this.OnFrameGenGhostingFixTransformationHEDFill(this.m_hedFillPath, hedMargin, hedSize, 0.03, true);

  let hedTrackerMargin: Vector2 = new Vector2(1920.0, 1920.0);
  let hedTrackerSize: Vector2 = new Vector2(2400.0, 1200.0);

  this.OnFrameGenGhostingFixTransformationHEDTracker(this.m_hedTrackerPath, hedTrackerMargin, hedTrackerSize, 0.0, false);

  let mask1Margin: Vector2 = new Vector2(1920.0, 2000.0);
  let mask1Size: Vector2 = new Vector2(7680.0, 1200.0);
  let mask1Shear: Vector2 = new Vector2(0.0, 0.0);
  let mask1AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

  this.OnFrameGenGhostingFixTransformationMask2(this.m_mask1Path, mask1Margin, mask1Size, 0.0, mask1Shear, mask1AnchorPoint, 0.07, true);
  
  let mask2Margin: Vector2 = new Vector2(1920.0, 1900.0);
  let mask2Size: Vector2 = new Vector2(5120.0, 1200.0);
  let mask2Shear: Vector2 = new Vector2(0.0, 0.0);
  let mask2AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

  this.OnFrameGenGhostingFixTransformationMask2(this.m_mask2Path, mask2Margin, mask2Size, 0.0, mask2Shear, mask2AnchorPoint, 0.07, true);

  let mask3Margin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask3Size: Vector2 = new Vector2(2800.0, 1200.0);
  let mask3Shear: Vector2 = new Vector2(0.0, 0.0);
  let mask3AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

  this.OnFrameGenGhostingFixTransformationMask2(this.m_mask3Path, mask3Margin, mask3Size, 0.0, mask3Shear, mask3AnchorPoint, 0.07, true);
  
  let mask4Margin: Vector2 = new Vector2(0.0, 0.0);
  let mask4Size: Vector2 = new Vector2(0.0, 0.0);
  let mask4Shear: Vector2 = new Vector2(0.0, 0.0);
  let mask4AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

  this.OnFrameGenGhostingFixTransformationMask2(this.m_mask4Path, mask4Margin, mask4Size, 0.0, mask4Shear, mask4AnchorPoint, 0.0, false);
}

//FPP Car---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
private cb func OnFrameGenGhostingFixCameraFPPCarEvent(evt: ref<FrameGenGhostingFixCameraFPPCarEvent>) -> Bool {

  let hedMargin: Vector2 = new Vector2(1920.0, 2280.0);
  let hedSize: Vector2 = new Vector2(4240.0, 1440.0);

  this.OnFrameGenGhostingFixTransformationHEDCorners(this.m_hedCornersPath, hedMargin, hedSize, 0.03, true);
  this.OnFrameGenGhostingFixTransformationHEDFill(this.m_hedFillPath, hedMargin, hedSize, 0.0, true);

  let hedTrackerMargin: Vector2 = new Vector2(1920.0, 1920.0);
  let hedTrackerSize: Vector2 = new Vector2(2400.0, 1200.0);

  this.OnFrameGenGhostingFixTransformationHEDTracker(this.m_hedTrackerPath, hedTrackerMargin, hedTrackerSize, 0.0, false);

  let mask1Margin: Vector2 = new Vector2(1920.0, 2000.0);
  let mask1Size: Vector2 = new Vector2(7680.0, 1200.0);
  let mask1Shear: Vector2 = new Vector2(0.0, 0.0);
  let mask1AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

  this.OnFrameGenGhostingFixTransformationMask2(this.m_mask1Path, mask1Margin, mask1Size, 0.0, mask1Shear, mask1AnchorPoint, 0.0, true);
  
  let mask2Margin: Vector2 = new Vector2(1920.0, 1900.0);
  let mask2Size: Vector2 = new Vector2(5120.0, 1200.0);
  let mask2Shear: Vector2 = new Vector2(0.0, 0.0);
  let mask2AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

  this.OnFrameGenGhostingFixTransformationMask2(this.m_mask2Path, mask2Margin, mask2Size, 0.0, mask2Shear, mask2AnchorPoint, 0.0, true);

  let mask3Margin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask3Size: Vector2 = new Vector2(2800.0, 1200.0);
  let mask3Shear: Vector2 = new Vector2(0.0, 0.0);
  let mask3AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

  this.OnFrameGenGhostingFixTransformationMask2(this.m_mask3Path, mask3Margin, mask3Size, 0.0, mask3Shear, mask3AnchorPoint, 0.0, true);
  
  let mask4Margin: Vector2 = new Vector2(0.0, 0.0);
  let mask4Size: Vector2 = new Vector2(0.0, 0.0);
  let mask4Shear: Vector2 = new Vector2(0.0, 0.0);
  let mask4AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

  this.OnFrameGenGhostingFixTransformationMask2(this.m_mask4Path, mask4Margin, mask4Size, 0.0, mask4Shear, mask4AnchorPoint, 0.0, false);
}

//Setting masks when changing cameras on a bike---------------------------------------------------------------------------------------
//TPP Bike---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
private cb func OnFrameGenGhostingFixCameraTPPBikeEvent(evt: ref<FrameGenGhostingFixCameraTPPBikeEvent>) -> Bool {

  let hedMargin: Vector2 = new Vector2(1920.0, 2280.0);
  let hedSize: Vector2 = new Vector2(4240.0, 1440.0);

  this.OnFrameGenGhostingFixTransformationHEDCorners(this.m_hedCornersPath, hedMargin, hedSize, 0.03, true);
  this.OnFrameGenGhostingFixTransformationHEDFill(this.m_hedFillPath, hedMargin, hedSize, 0.03, true);

  let hedTrackerMargin: Vector2 = new Vector2(1920.0, 1920.0);
  let hedTrackerSize: Vector2 = new Vector2(2400.0, 1200.0);

  this.OnFrameGenGhostingFixTransformationHEDTracker(this.m_hedTrackerPath, hedTrackerMargin, hedTrackerSize, 0.0, false);

  let mask1Margin: Vector2 = new Vector2(1920.0, 2000.0);
  let mask1Size: Vector2 = new Vector2(7680.0, 1200.0);
  let mask1Shear: Vector2 = new Vector2(0.0, 0.0);
  let mask1AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

  this.OnFrameGenGhostingFixTransformationMask2(this.m_mask1Path, mask1Margin, mask1Size, 0.0, mask1Shear, mask1AnchorPoint, 0.07, true);
  
  let mask2Margin: Vector2 = new Vector2(1920.0, 1900.0);
  let mask2Size: Vector2 = new Vector2(5120.0, 1200.0);
  let mask2Shear: Vector2 = new Vector2(0.0, 0.0);
  let mask2AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

  this.OnFrameGenGhostingFixTransformationMask2(this.m_mask2Path, mask2Margin, mask2Size, 0.0, mask2Shear, mask2AnchorPoint, 0.07, true);

  let mask3Margin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask3Size: Vector2 = new Vector2(2800.0, 1200.0);
  let mask3Shear: Vector2 = new Vector2(0.0, 0.0);
  let mask3AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

  this.OnFrameGenGhostingFixTransformationMask2(this.m_mask3Path, mask3Margin, mask3Size, 0.0, mask3Shear, mask3AnchorPoint, 0.07, true);
  
  let mask4Margin: Vector2 = new Vector2(0.0, 0.0);
  let mask4Size: Vector2 = new Vector2(0.0, 0.0);
  let mask4Shear: Vector2 = new Vector2(0.0, 0.0);
  let mask4AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

  this.OnFrameGenGhostingFixTransformationMask2(this.m_mask4Path, mask4Margin, mask4Size, 0.0, mask4Shear, mask4AnchorPoint, 0.0, false);
}

//TPP Far Bike---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
private cb func OnFrameGenGhostingFixCameraTPPFarBikeEvent(evt: ref<FrameGenGhostingFixCameraTPPFarBikeEvent>) -> Bool {

  let hedMargin: Vector2 = new Vector2(1920.0, 2280.0);
  let hedSize: Vector2 = new Vector2(4240.0, 1440.0);

  this.OnFrameGenGhostingFixTransformationHEDCorners(this.m_hedCornersPath, hedMargin, hedSize, 0.03, true);
  this.OnFrameGenGhostingFixTransformationHEDFill(this.m_hedFillPath, hedMargin, hedSize, 0.03, true);

  let hedTrackerMargin: Vector2 = new Vector2(1920.0, 1920.0);
  let hedTrackerSize: Vector2 = new Vector2(2400.0, 1200.0);

  this.OnFrameGenGhostingFixTransformationHEDTracker(this.m_hedTrackerPath, hedTrackerMargin, hedTrackerSize, 0.0, false);

  let mask1Margin: Vector2 = new Vector2(1920.0, 2000.0);
  let mask1Size: Vector2 = new Vector2(7680.0, 1200.0);
  let mask1Shear: Vector2 = new Vector2(0.0, 0.0);
  let mask1AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

  this.OnFrameGenGhostingFixTransformationMask2(this.m_mask1Path, mask1Margin, mask1Size, 0.0, mask1Shear, mask1AnchorPoint, 0.07, true);
  
  let mask2Margin: Vector2 = new Vector2(1920.0, 1900.0);
  let mask2Size: Vector2 = new Vector2(5120.0, 1200.0);
  let mask2Shear: Vector2 = new Vector2(0.0, 0.0);
  let mask2AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

  this.OnFrameGenGhostingFixTransformationMask2(this.m_mask2Path, mask2Margin, mask2Size, 0.0, mask2Shear, mask2AnchorPoint, 0.07, true);

  let mask3Margin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask3Size: Vector2 = new Vector2(2800.0, 1200.0);
  let mask3Shear: Vector2 = new Vector2(0.0, 0.0);
  let mask3AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

  this.OnFrameGenGhostingFixTransformationMask2(this.m_mask3Path, mask3Margin, mask3Size, 0.0, mask3Shear, mask3AnchorPoint, 0.07, true);
  
  let mask4Margin: Vector2 = new Vector2(0.0, 0.0);
  let mask4Size: Vector2 = new Vector2(0.0, 0.0);
  let mask4Shear: Vector2 = new Vector2(0.0, 0.0);
  let mask4AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

  this.OnFrameGenGhostingFixTransformationMask2(this.m_mask4Path, mask4Margin, mask4Size, 0.0, mask4Shear, mask4AnchorPoint, 0.0, false);
}

//FPP Bike---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
private cb func OnFrameGenGhostingFixCameraFPPBikeEvent(evt: ref<FrameGenGhostingFixCameraFPPBikeEvent>) -> Bool {

  let hedMargin: Vector2 = new Vector2(1920.0, 2280.0);
  let hedSize: Vector2 = new Vector2(4240.0, 1440.0);

  this.OnFrameGenGhostingFixTransformationHEDCorners(this.m_hedCornersPath, hedMargin, hedSize, 0.03, true);
  this.OnFrameGenGhostingFixTransformationHEDFill(this.m_hedFillPath, hedMargin, hedSize, 0.03, true);

  let hedTrackerMargin: Vector2 = new Vector2(1920.0, 1920.0);
  let hedTrackerSize: Vector2 = new Vector2(2400.0, 1200.0);

  this.OnFrameGenGhostingFixTransformationHEDTracker(this.m_hedTrackerPath, hedTrackerMargin, hedTrackerSize, 0.0, false);

  let mask1Margin: Vector2 = new Vector2(1920.0, 2000.0);
  let mask1Size: Vector2 = new Vector2(7680.0, 1200.0);
  let mask1Shear: Vector2 = new Vector2(0.0, 0.0);
  let mask1AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

  this.OnFrameGenGhostingFixTransformationMask2(this.m_mask1Path, mask1Margin, mask1Size, 0.0, mask1Shear, mask1AnchorPoint, 0.07, true);
  
  let mask2Margin: Vector2 = new Vector2(1920.0, 1900.0);
  let mask2Size: Vector2 = new Vector2(5120.0, 1200.0);
  let mask2Shear: Vector2 = new Vector2(0.0, 0.0);
  let mask2AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

  this.OnFrameGenGhostingFixTransformationMask2(this.m_mask2Path, mask2Margin, mask2Size, 0.0, mask2Shear, mask2AnchorPoint, 0.0, true);

  let mask3Margin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask3Size: Vector2 = new Vector2(2800.0, 1200.0);
  let mask3Shear: Vector2 = new Vector2(0.0, 0.0);
  let mask3AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

  this.OnFrameGenGhostingFixTransformationMask2(this.m_mask3Path, mask3Margin, mask3Size, 0.0, mask3Shear, mask3AnchorPoint, 0.0, true);
  
  let mask4Margin: Vector2 = new Vector2(0.0, 0.0);
  let mask4Size: Vector2 = new Vector2(0.0, 0.0);
  let mask4Shear: Vector2 = new Vector2(0.0, 0.0);
  let mask4AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

  this.OnFrameGenGhostingFixTransformationMask2(this.m_mask4Path, mask4Margin, mask4Size, 0.0, mask4Shear, mask4AnchorPoint, 0.0, false);
}

//Setting masks deactivation for vehicles---------------------------------------------------------------------------------------

@addMethod(gameuiCrosshairContainerController)
protected cb func OnFrameGenGhostingFixDeactivationHEDVehicleEvent(evt: ref<FrameGenGhostingFixDeactivationHEDVehicleEvent>)  -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let hedCorners: ref<inkWidget> = root.GetWidgetByPathName(this.m_hedCornersPath) as inkWidget;
  let hedFill: ref<inkWidget> = root.GetWidgetByPathName(this.m_hedFillPath) as inkWidget;
  let hedTracker: ref<inkWidget> = root.GetWidgetByPathName(this.m_hedTrackerPath) as inkWidget;

  hedCorners.SetOpacity(0.0);
  hedFill.SetOpacity(0.0);
  hedTracker.SetOpacity(0.0);
}

@addMethod(gameuiCrosshairContainerController)
protected cb func OnFrameGenGhostingFixDeactivationMasksVehicleEvent(evt: ref<FrameGenGhostingFixDeactivationMasksVehicleEvent>)  -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let mask1: ref<inkWidget> = root.GetWidgetByPathName(this.m_mask1Path) as inkWidget;
  let mask2: ref<inkWidget> = root.GetWidgetByPathName(this.m_mask2Path) as inkWidget;
  let mask3: ref<inkWidget> = root.GetWidgetByPathName(this.m_mask3Path) as inkWidget;
  let mask4: ref<inkWidget> = root.GetWidgetByPathName(this.m_mask4Path) as inkWidget;

  mask1.SetOpacity(0.0);
  mask2.SetOpacity(0.0);
  mask3.SetOpacity(0.0);
  mask4.SetOpacity(0.0);
}

//Setting masks for windshield editor---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
private cb func OnFrameGenGhostingFixFPPBikeWindshieldEditorEvent(evt: ref<FrameGenGhostingFixFPPBikeWindshieldEditorEvent>) -> Void {

  let mask2Margin: Vector2 = new Vector2(1920.0, 1300.0);
  let mask2Size: Vector2 = new Vector2(2400.0, 1200.0);

  this.FrameGenGhostingFixSetSimpleTransformation(this.m_mask2Path, mask2Margin, mask2Size, 0.7, true);
}

//Setting context for vehicles masks start here---------------------------------------------------------------------------------------
@addMethod(DriveEvents)
protected final func OnFrameGenGhostingFixVehicleSpeedChange(speed: Float) -> Void {
  this.m_vehicleCurrentSpeedFGGF = speed;
}

@addMethod(DriveEvents)
public final func FrameGenGhostingFixDeactivationMasksVehicle(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let vehicleDeactivation: ref<FrameGenGhostingFixDeactivationMasksVehicleEvent>;

  vehicleDeactivation = new FrameGenGhostingFixDeactivationMasksVehicleEvent();

    scriptInterface.executionOwner.QueueEvent(vehicleDeactivation);
}

@addMethod(DriveEvents)
public final func FrameGenGhostingFixBikeStationaryWindshieldEditorContext(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let windshieldEditorContext: ref<FrameGenGhostingFixFPPBikeWindshieldEditorEvent>;

  windshieldEditorContext = new FrameGenGhostingFixFPPBikeWindshieldEditorEvent();

    scriptInterface.executionOwner.QueueEvent(windshieldEditorContext);
}

@addMethod(DriveEvents)
protected final func FrameGenGhostingFixMaskChange(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let vehicleBlackboard: wref<IBlackboard>;

  if !IsDefined(this.m_vehicleCurrentSpeedCallbackFGGF) {
    vehicleBlackboard = (scriptInterface.owner as VehicleObject).GetBlackboard();
    this.m_vehicleCurrentSpeedCallbackFGGF = vehicleBlackboard.RegisterListenerFloat(GetAllBlackboardDefs().Vehicle.SpeedValue, this, n"OnFrameGenGhostingFixVehicleSpeedChange");
  }

  let vehicleType_Record: ref<VehicleType_Record> = TweakDBInterface.GetVehicleRecord((scriptInterface.owner as VehicleObject).GetRecordID()).Type();
  this.m_vehicleCurrentTypeFGGF = vehicleType_Record.Type();
}

@wrapMethod(DriveEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext,scriptInterface);

  this.FrameGenGhostingFixMaskChange(scriptInterface);
}

//Setting context for car masks start here---------------------------------------------------------------------------------------
@addMethod(DriveEvents)
public final func CarCameraChange(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraFPPEvent: ref<FrameGenGhostingFixCameraFPPCarEvent>;
  let cameraTPPEvent: ref<FrameGenGhostingFixCameraTPPCarEvent>;
  let cameraTPPFarEvent: ref<FrameGenGhostingFixCameraTPPFarCarEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPEvent = new FrameGenGhostingFixCameraFPPCarEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPEvent);
      // LogChannel(n"DEBUG", "Car camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.TPPClose:
      cameraTPPEvent = new FrameGenGhostingFixCameraTPPCarEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.TPPMedium:
      cameraTPPEvent = new FrameGenGhostingFixCameraTPPCarEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPMedium mode.");
      break;
    case vehicleCameraPerspective.TPPFar:
      cameraTPPFarEvent = new FrameGenGhostingFixCameraTPPFarCarEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFarEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPFar mode.");
      break;
    default:
      break;
  }
}

//Setting context for bike masks start here---------------------------------------------------------------------------------------
@addMethod(DriveEvents)
public final func BikeCameraChange(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraFPPBikeEvent: ref<FrameGenGhostingFixCameraFPPBikeEvent>;
  let cameraTPPBikeEvent: ref<FrameGenGhostingFixCameraTPPBikeEvent>;
  let cameraTPPFarBikeEvent: ref<FrameGenGhostingFixCameraTPPFarBikeEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPBikeEvent = new FrameGenGhostingFixCameraFPPBikeEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPBikeEvent);
      // LogChannel(n"DEBUG", "Bike camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.TPPClose:
      cameraTPPBikeEvent = new FrameGenGhostingFixCameraTPPBikeEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.TPPMedium:
      cameraTPPBikeEvent = new FrameGenGhostingFixCameraTPPBikeEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPMedium mode.");
      break;
    case vehicleCameraPerspective.TPPFar:
      cameraTPPFarBikeEvent = new FrameGenGhostingFixCameraTPPFarBikeEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFarBikeEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPFar mode.");
      break;
    default:
      break;
  }
}

@wrapMethod(DriveEvents)
public final func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta,stateContext,scriptInterface);

  let vehicleTypeRecord: ref<VehicleType_Record> = TweakDBInterface.GetVehicleRecord((scriptInterface.owner as VehicleObject).GetRecordID()).Type();
  this.m_vehicleCurrentTypeFGGF = vehicleTypeRecord.Type();

  switch(this.m_vehicleCurrentTypeFGGF) {
    case gamedataVehicleType.Bike:
      this.BikeCameraChange(scriptInterface, this.m_bikeCameraContextFGGF);
      break;
    case gamedataVehicleType.Car:
      this.CarCameraChange(scriptInterface, this.m_carCameraContextFGGF);
      break;
    default:
      break;
  }
}

@wrapMethod(DriveEvents)
public final func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext,scriptInterface);

  this.FrameGenGhostingFixDeactivationMasksVehicle(scriptInterface);
  // LogChannel(n"DEBUG", "Deactivating masks...");
}

//Setting context for vehicles masks while in combat starts here---------------------------------------------------------------------------------------
@addMethod(DriverCombatEvents)
protected final func OnFrameGenGhostingFixVehicleSpeedChange(speed: Float) -> Void {
  this.m_vehicleCurrentSpeedFGGF = speed;
}

@addMethod(DriverCombatEvents)
public final func FrameGenGhostingFixDeactivationMasksVehicle(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let vehicleDeactivation: ref<FrameGenGhostingFixDeactivationMasksVehicleEvent>;

  vehicleDeactivation = new FrameGenGhostingFixDeactivationMasksVehicleEvent();

    scriptInterface.executionOwner.QueueEvent(vehicleDeactivation);
}

@addMethod(DriverCombatEvents)
public final func FrameGenGhostingFixBikeStationaryWindshieldEditorContext(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let windshieldEditorContext: ref<FrameGenGhostingFixFPPBikeWindshieldEditorEvent>;

  windshieldEditorContext = new FrameGenGhostingFixFPPBikeWindshieldEditorEvent();

    scriptInterface.executionOwner.QueueEvent(windshieldEditorContext);
}

@addMethod(DriverCombatEvents)
protected final func FrameGenGhostingFixMaskChange(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let vehicleBlackboard: wref<IBlackboard>;

  if !IsDefined(this.m_vehicleCurrentSpeedCallbackFGGF) {
    vehicleBlackboard = (scriptInterface.owner as VehicleObject).GetBlackboard();
    this.m_vehicleCurrentSpeedCallbackFGGF = vehicleBlackboard.RegisterListenerFloat(GetAllBlackboardDefs().Vehicle.SpeedValue, this, n"OnFrameGenGhostingFixVehicleSpeedChange");
  }

  let vehicleType_Record: ref<VehicleType_Record> = TweakDBInterface.GetVehicleRecord((scriptInterface.owner as VehicleObject).GetRecordID()).Type();
  this.m_vehicleCurrentTypeFGGF = vehicleType_Record.Type();
}

@wrapMethod(DriverCombatEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext,scriptInterface);

  this.FrameGenGhostingFixMaskChange(scriptInterface);
}

//Setting context for car masks while in combat starts here---------------------------------------------------------------------------------------
@addMethod(DriverCombatEvents)
public final func CarCameraChange(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraFPPEvent: ref<FrameGenGhostingFixCameraFPPCarEvent>;
  let cameraTPPEvent: ref<FrameGenGhostingFixCameraTPPCarEvent>;
  let cameraTPPFarEvent: ref<FrameGenGhostingFixCameraTPPFarCarEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPEvent = new FrameGenGhostingFixCameraFPPCarEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPEvent);
      // LogChannel(n"DEBUG", "Car camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.DriverCombatClose:
      cameraTPPEvent = new FrameGenGhostingFixCameraTPPCarEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.DriverCombatMedium:
      cameraTPPEvent = new FrameGenGhostingFixCameraTPPCarEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPMedium mode.");
      break;
    case vehicleCameraPerspective.DriverCombatFar:
      cameraTPPFarEvent = new FrameGenGhostingFixCameraTPPFarCarEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFarEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPFar mode.");
      break;
    default:
      break;
  }
}

//Setting context for bike masks while in combat starts here---------------------------------------------------------------------------------------
@addMethod(DriverCombatEvents)
public final func BikeCameraChange(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraFPPBikeEvent: ref<FrameGenGhostingFixCameraFPPBikeEvent>;
  let cameraTPPBikeEvent: ref<FrameGenGhostingFixCameraTPPBikeEvent>;
  let cameraTPPFarBikeEvent: ref<FrameGenGhostingFixCameraTPPFarBikeEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPBikeEvent = new FrameGenGhostingFixCameraFPPBikeEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPBikeEvent);
      // LogChannel(n"DEBUG", "Bike camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.DriverCombatClose:
      cameraTPPBikeEvent = new FrameGenGhostingFixCameraTPPBikeEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.DriverCombatMedium:
      cameraTPPBikeEvent = new FrameGenGhostingFixCameraTPPBikeEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPMedium mode.");
      break;
    case vehicleCameraPerspective.DriverCombatFar:
      cameraTPPFarBikeEvent = new FrameGenGhostingFixCameraTPPFarBikeEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFarBikeEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPFar mode.");
      break;
    default:
      break;
  }
}

@wrapMethod(DriverCombatEvents)
public final func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta,stateContext,scriptInterface);

  let vehicleTypeRecord: ref<VehicleType_Record> = TweakDBInterface.GetVehicleRecord((scriptInterface.owner as VehicleObject).GetRecordID()).Type();
  this.m_vehicleCurrentTypeFGGF = vehicleTypeRecord.Type();

  switch(this.m_vehicleCurrentTypeFGGF) {
    case gamedataVehicleType.Bike:
      this.BikeCameraChange(scriptInterface, this.m_bikeCameraContextFGGF);
      break;
    case gamedataVehicleType.Car:
      this.CarCameraChange(scriptInterface, this.m_carCameraContextFGGF);
      break;
    default:
      break;
  }
}

@wrapMethod(DriverCombatEvents)
public final func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext,scriptInterface);

  this.FrameGenGhostingFixDeactivationMasksVehicle(scriptInterface);
  // LogChannel(n"DEBUG", "Deactivating masks...");
}