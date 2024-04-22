// Thanks to djkovrik for redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

//FrameGen Ghosting 'Fix' 4.0.2, 2024 gramern (scz_g) 2024

@addField(IronsightGameController) public let m_isMaskingInVehiclesEnabled: Bool = true;

@addField(DriveEvents) public let m_carCameraContext: vehicleCameraPerspective;
@addField(DriveEvents) public let m_bikeCameraContext: vehicleCameraPerspective;
@addField(DriveEvents) public let m_vehicleCurrentType: gamedataVehicleType;
@addField(DriveEvents) public let m_vehicleCurrentSpeed: Float;
@addField(DriveEvents) public let m_vehicleCurrentSpeedCallback: ref<CallbackHandle>;

@addField(DriverCombatEvents) public let m_carCameraContext: vehicleCameraPerspective;
@addField(DriverCombatEvents) public let m_bikeCameraContext: vehicleCameraPerspective;
@addField(DriverCombatEvents) public let m_vehicleCurrentType: gamedataVehicleType;
@addField(DriverCombatEvents) public let m_vehicleCurrentSpeed: Float;
@addField(DriverCombatEvents) public let m_vehicleCurrentSpeedCallback: ref<CallbackHandle>;


//Global toggle for transtions, called in On Foot loop---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected final func FrameGenFrameGenGhostingFixVehicleToggleEvent() -> Void {
  this.FrameGenGhostingFixVehicleToggle(true);
}

@addMethod(IronsightGameController)
protected final func FrameGenGhostingFixVehicleToggle(maskingInVehicles: Bool) -> Void {
  this.m_isMaskingInVehiclesEnabled = maskingInVehicles;
}

//The main transition function---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin: Vector2, hedSetSize: Vector2, mask2SetMargin: Vector2, mask2SetSize: Vector2, mask1SetMargin: Vector2, mask1SetSize: Vector2, setAnchorPoint: Vector2, hedSetOpacity: Float, mask2SetOpacity: Float, mask1SetOpacity: Float, hedFillVisible: Bool, mask2Visible: Bool, mask1Visible: Bool) -> Bool {

  if NotEquals(this.m_isMaskingInVehiclesEnabled,false) {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let hedCorners: ref<inkWidget> = root.GetWidgetByPathName(n"horizontaledgedowncorners") as inkWidget;
    let hedFill: ref<inkWidget> = root.GetWidgetByPathName(n"horizontaledgedownfill") as inkWidget;
    let mask2: ref<inkWidget> = root.GetWidgetByPathName(n"mask2") as inkWidget;
    let mask1: ref<inkWidget> = root.GetWidgetByPathName(n"mask1") as inkWidget;

    let hedMargin = hedCorners.GetMargin();
    hedCorners.SetMargin(hedSetMargin.X, hedSetMargin.Y, hedMargin.right, hedMargin.bottom);
    hedCorners.SetSize(hedSetSize.X, hedSetSize.Y);
    hedCorners.Reparent(root);
    hedFill.SetMargin(hedSetMargin.X, hedSetMargin.Y, hedMargin.right, hedMargin.bottom);
    hedFill.SetSize(hedSetSize.X, hedSetSize.Y);
    hedFill.Reparent(root);
    // let hedSize = hedCorners.GetSize();
    // LogChannel(n"DEBUG", s"hedSize: \(hedSize.X) \(hedSize.Y)");

    if hedCorners.GetOpacity() != hedSetOpacity {
      hedCorners.SetOpacity(hedSetOpacity);
      hedFill.SetOpacity(hedSetOpacity);       
    }
    if NotEquals(hedFill.IsVisible(),hedFillVisible) {
      hedFill.SetVisible(hedFillVisible);
    }

    let mask2Margin = mask2.GetMargin();
    mask2.SetMargin(mask2SetMargin.X, mask2SetMargin.Y, mask2Margin.right, mask2Margin.bottom);
    mask2.SetSize(mask2SetSize.X, mask2SetSize.Y);
    let mask2Anchor = mask2.GetAnchorPoint();
    if mask2Anchor.Y != setAnchorPoint.Y {
      mask2.SetAnchorPoint(mask2Anchor.X, setAnchorPoint.Y);
    }
    
    if Equals(mask2Visible,true) {
      if mask2.GetOpacity() != mask2SetOpacity {
        mask2.SetOpacity(mask2SetOpacity);
      }
    } else {
      mask2.SetOpacity(0.0);
    }
    mask2.Reparent(root);

    let mask1Margin = mask1.GetMargin();
    mask1.SetMargin(mask1SetMargin.X, mask1SetMargin.Y, mask1Margin.right, mask1Margin.bottom);
    mask1.SetSize(mask1SetSize.X, mask1SetSize.Y);
    let mask1Anchor = mask1.GetAnchorPoint();
    if mask1Anchor.Y != setAnchorPoint.Y {
      mask1.SetAnchorPoint(mask1Anchor.X, setAnchorPoint.Y);
    }

    if Equals(mask1Visible,true) {
      if mask1.GetOpacity() != mask1SetOpacity {
        mask1.SetOpacity(mask1SetOpacity);
      }
    } else {
      mask1.SetOpacity(0.0);
    }
    mask1.Reparent(root);
  }
}

//Setting masks when changing cameras in a car---------------------------------------------------------------------------------------
//TPP Car---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixCameraTPPCarEvent(evt: ref<FrameGenGhostingFixCameraTPPCarEvent>) -> Bool {
  
  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.03, 0.07, 0.07, true, true, true);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixCameraTPPCarFasterEvent(evt: ref<FrameGenGhostingFixCameraTPPCarFasterEvent>) -> Bool {

  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.02, 0.05, 0.05, true, true, true);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixCameraTPPCarSlowEvent(evt: ref<FrameGenGhostingFixCameraTPPCarSlowEvent>) -> Bool {

  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.01, 0.035, 0.035, true, true, true);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixCameraTPPCarCrawlEvent(evt: ref<FrameGenGhostingFixCameraTPPCarCrawlEvent>) -> Bool {

  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.01, 0.02, 0.02, true, true, true);
}

//TPP Far Car---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixCameraTPPFarCarEvent(evt: ref<FrameGenGhostingFixCameraTPPFarCarEvent>) -> Bool {
  
  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.03, 0.07, 0.07, true, true, true);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixCameraTPPFarCarFasterEvent(evt: ref<FrameGenGhostingFixCameraTPPFarCarFasterEvent>) -> Bool {

  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.02, 0.05, 0.05, true, true, true);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixCameraTPPFarCarSlowEvent(evt: ref<FrameGenGhostingFixCameraTPPFarCarSlowEvent>) -> Bool {

  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.01, 0.035, 0.035, true, true, true);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixCameraTPPFarCarCrawlEvent(evt: ref<FrameGenGhostingFixCameraTPPFarCarCrawlEvent>) -> Bool {

  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.01, 0.02, 0.02, true, true, true);
}

//FPP Car---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixCameraFPPCarEvent(evt: ref<FrameGenGhostingFixCameraFPPCarEvent>) -> Bool {

  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.0, 0.0, 0.0, true, true, true);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixCameraFPPCarFasterEvent(evt: ref<FrameGenGhostingFixCameraFPPCarFasterEvent>) -> Bool {

  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.0, 0.0, 0.0, true, true, true);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixCameraFPPCarSlowEvent(evt: ref<FrameGenGhostingFixCameraFPPCarSlowEvent>) -> Bool {

  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.0, 0.0, 0.0, true, true, true);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixCameraFPPCarCrawlEvent(evt: ref<FrameGenGhostingFixCameraFPPCarCrawlEvent>) -> Bool {

  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.0, 0.0, 0.0, true, true, true);
}

//Setting masks when changing cameras on a bike---------------------------------------------------------------------------------------
//TPP Bike---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixCameraTPPBikeEvent(evt: ref<FrameGenGhostingFixCameraTPPBikeEvent>) -> Bool {

  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.03, 0.07, 0.07, true, true, true);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixCameraTPPBikeFasterEvent(evt: ref<FrameGenGhostingFixCameraTPPBikeFasterEvent>) -> Bool {

  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.02, 0.05, 0.05, true, true, true);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixCameraTPPBikeSlowEvent(evt: ref<FrameGenGhostingFixCameraTPPBikeSlowEvent>) -> Bool {

  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.01, 0.035, 0.035, true, true, true);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixCameraTPPBikeCrawlEvent(evt: ref<FrameGenGhostingFixCameraTPPBikeCrawlEvent>) -> Bool {

  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.01, 0.02, 0.02, true, true, true);
}

//TPP Far Bike---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixCameraTPPFarBikeEvent(evt: ref<FrameGenGhostingFixCameraTPPFarBikeEvent>) -> Bool {

  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.03, 0.07, 0.07, true, true, true);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixCameraTPPFarBikeFasterEvent(evt: ref<FrameGenGhostingFixCameraTPPFarBikeFasterEvent>) -> Bool {

  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.02, 0.05, 0.05, true, true, true);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixCameraTPPFarBikeSlowEvent(evt: ref<FrameGenGhostingFixCameraTPPFarBikeSlowEvent>) -> Bool {

  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.01, 0.035, 0.035, true, true, true);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixCameraTPPFarBikeCrawlEvent(evt: ref<FrameGenGhostingFixCameraTPPFarBikeCrawlEvent>) -> Bool {

  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.01, 0.02, 0.02, true, true, true);
}

//FPP Bike---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixCameraFPPBikeEvent(evt: ref<FrameGenGhostingFixCameraFPPBikeEvent>) -> Bool {

  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.0, 0.0, 0.0, true, true, true);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixCameraFPPBikeFasterEvent(evt: ref<FrameGenGhostingFixCameraFPPBikeFasterEvent>) -> Bool {

  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.0, 0.0, 0.0, true, true, true);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixCameraFPPBikeSlowEvent(evt: ref<FrameGenGhostingFixCameraFPPBikeSlowEvent>) -> Bool {

  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.0, 0.0, 0.0, true, true, true);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixCameraFPPBikeCrawlEvent(evt: ref<FrameGenGhostingFixCameraFPPBikeCrawlEvent>) -> Bool {

  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.0, 0.0, 0.0, true, true, true);
}

//Setting masks deactivation for vehicles---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func OnFrameGenGhostingFixDeActivationVehicleEvent(evt: ref<FrameGenGhostingFixDeActivationVehicleEvent>)  -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let hedCorners: ref<inkWidget> = root.GetWidgetByPathName(n"horizontaledgedowncorners") as inkWidget;
  let hedFill: ref<inkWidget> = root.GetWidgetByPathName(n"horizontaledgedownfill") as inkWidget;
  let mask2: ref<inkWidget> = root.GetWidgetByPathName(n"mask2") as inkWidget;
  let mask1: ref<inkWidget> = root.GetWidgetByPathName(n"mask1") as inkWidget;

  hedCorners.SetOpacity(0.0);
  hedFill.SetOpacity(0.0);
  mask2.SetOpacity(0.0);
  mask1.SetOpacity(0.0);
}

//Setting masks for windshield editor---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixFPPBikeWindshieldEditorEvent(evt: ref<FrameGenGhostingFixFPPBikeWindshieldEditorEvent>) -> Void {

  let hedSetMargin: Vector2 = new Vector2(1920.0, 2320.0);
  let hedSetSize: Vector2 = new Vector2(4320.0, 1440.0);
  let mask2SetMargin: Vector2 = new Vector2(1920.0, 1700.0);
  let mask2SetSize: Vector2 = new Vector2(3000.0, 900.0);
  let mask1Margin: Vector2 = new Vector2(1920, 1550.0);
  let mask1SetSize: Vector2 = new Vector2(1800.0, 900.0);
  let setAnchorPoint: Vector2 = new Vector2(0.5, 0.25);

  this.OnFrameGenGhostingFixVehicleSetTransition(hedSetMargin, hedSetSize, mask2SetMargin, mask2SetSize, mask1Margin, mask1SetSize, setAnchorPoint, 0.0, 0.0, 0.03, false, false, true);
}

//Setting context for vehicles masks start here---------------------------------------------------------------------------------------
@addMethod(DriveEvents)
protected final func OnVehicleSpeedChange(speed: Float) -> Void {
  this.m_vehicleCurrentSpeed = speed;
}

@addMethod(DriveEvents)
public final func VehicleStationaryDeactivation(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let vehicleDeactivation: ref<FrameGenGhostingFixDeActivationVehicleEvent>;

  vehicleDeactivation = new FrameGenGhostingFixDeActivationVehicleEvent();

    scriptInterface.executionOwner.QueueEvent(vehicleDeactivation);
}

@addMethod(DriveEvents)
public final func BikeStationaryWindshieldEditorContext(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let windshieldEditorContext: ref<FrameGenGhostingFixFPPBikeWindshieldEditorEvent>;

  windshieldEditorContext = new FrameGenGhostingFixFPPBikeWindshieldEditorEvent();

    scriptInterface.executionOwner.QueueEvent(windshieldEditorContext);
}

@addMethod(DriveEvents)
protected final func MaskChange(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let vehicleBlackboard: wref<IBlackboard>;

  if !IsDefined(this.m_vehicleCurrentSpeedCallback) {
    vehicleBlackboard = (scriptInterface.owner as VehicleObject).GetBlackboard();
    this.m_vehicleCurrentSpeedCallback = vehicleBlackboard.RegisterListenerFloat(GetAllBlackboardDefs().Vehicle.SpeedValue, this, n"OnVehicleSpeedChange");
  }

  let vehicleType_Record: ref<VehicleType_Record> = TweakDBInterface.GetVehicleRecord((scriptInterface.owner as VehicleObject).GetRecordID()).Type();
  this.m_vehicleCurrentType = vehicleType_Record.Type();
}

@wrapMethod(DriveEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.MaskChange(scriptInterface);
  wrappedMethod(stateContext,scriptInterface);
}

//Setting context for car masks start here---------------------------------------------------------------------------------------
@addMethod(DriveEvents)
public final func CarCameraChangeCrawl(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraFPPCrawlEvent: ref<FrameGenGhostingFixCameraFPPCarCrawlEvent>;
  let cameraTPPCrawlEvent: ref<FrameGenGhostingFixCameraTPPCarCrawlEvent>;
  let cameraTPPFarCrawlEvent: ref<FrameGenGhostingFixCameraTPPFarCarCrawlEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPCrawlEvent = new FrameGenGhostingFixCameraFPPCarCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPCrawlEvent);
      // LogChannel(n"DEBUG", "Car camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.TPPClose:
      cameraTPPCrawlEvent = new FrameGenGhostingFixCameraTPPCarCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPCrawlEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.TPPMedium:
      cameraTPPCrawlEvent = new FrameGenGhostingFixCameraTPPCarCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPCrawlEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPMedium mode.");
      break;
    case vehicleCameraPerspective.TPPFar:
      cameraTPPFarCrawlEvent = new FrameGenGhostingFixCameraTPPFarCarCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFarCrawlEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPFar mode.");
      break;
    default:
      break;
  }
}

@addMethod(DriveEvents)
public final func CarCameraChangeSlow(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraFPPSlowEvent: ref<FrameGenGhostingFixCameraFPPCarSlowEvent>;
  let cameraTPPSlowEvent: ref<FrameGenGhostingFixCameraTPPCarSlowEvent>;
  let cameraTPPFarSlowEvent: ref<FrameGenGhostingFixCameraTPPFarCarSlowEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPSlowEvent = new FrameGenGhostingFixCameraFPPCarSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPSlowEvent);
      // LogChannel(n"DEBUG", "Car camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.TPPClose:
      cameraTPPSlowEvent = new FrameGenGhostingFixCameraTPPCarSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPSlowEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.TPPMedium:
      cameraTPPSlowEvent = new FrameGenGhostingFixCameraTPPCarSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPSlowEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPMedium mode.");
      break;
    case vehicleCameraPerspective.TPPFar:
      cameraTPPFarSlowEvent = new FrameGenGhostingFixCameraTPPFarCarSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFarSlowEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPFar mode.");
      break;
    default:
      break;
  }
}

@addMethod(DriveEvents)
public final func CarCameraChangeFaster(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {
 
  let cameraFPPFasterEvent: ref<FrameGenGhostingFixCameraFPPCarFasterEvent>;
  let cameraTPPFasterEvent: ref<FrameGenGhostingFixCameraTPPCarFasterEvent>;
  let cameraTPPFarFasterEvent: ref<FrameGenGhostingFixCameraTPPFarCarFasterEvent>;


  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPFasterEvent = new FrameGenGhostingFixCameraFPPCarFasterEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPFasterEvent);
      // LogChannel(n"DEBUG", "Car camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.TPPClose:
      cameraTPPFasterEvent = new FrameGenGhostingFixCameraTPPCarFasterEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFasterEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.TPPMedium:
      cameraTPPFasterEvent = new FrameGenGhostingFixCameraTPPCarFasterEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFasterEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPMedium mode.");
     break;
    case vehicleCameraPerspective.TPPFar:
      cameraTPPFarFasterEvent = new FrameGenGhostingFixCameraTPPFarCarFasterEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFarFasterEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPFar mode.");
      break;
    default:
      break;
  }
}

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
public final func BikeCameraChangeCrawl(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraFPPBikeCrawlEvent: ref<FrameGenGhostingFixCameraFPPBikeCrawlEvent>;
  let cameraTPPBikeCrawlEvent: ref<FrameGenGhostingFixCameraTPPBikeCrawlEvent>;
  let cameraTPPFarBikeCrawlEvent: ref<FrameGenGhostingFixCameraTPPFarBikeCrawlEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPBikeCrawlEvent = new FrameGenGhostingFixCameraFPPBikeCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPBikeCrawlEvent);
      // LogChannel(n"DEBUG", "Bike camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.TPPClose:
      cameraTPPBikeCrawlEvent = new FrameGenGhostingFixCameraTPPBikeCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeCrawlEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.TPPMedium:
      cameraTPPBikeCrawlEvent = new FrameGenGhostingFixCameraTPPBikeCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeCrawlEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPMedium mode.");
      break;
    case vehicleCameraPerspective.TPPFar:
      cameraTPPFarBikeCrawlEvent = new FrameGenGhostingFixCameraTPPFarBikeCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFarBikeCrawlEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPFar mode.");
      break;
    default:
      break;
  }
}

@addMethod(DriveEvents)
public final func BikeCameraChangeSlow(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraFPPBikeSlowEvent: ref<FrameGenGhostingFixCameraFPPBikeSlowEvent>;
  let cameraTPPBikeSlowEvent: ref<FrameGenGhostingFixCameraTPPBikeSlowEvent>;
  let cameraTPPFarBikeSlowEvent: ref<FrameGenGhostingFixCameraTPPFarBikeSlowEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPBikeSlowEvent = new FrameGenGhostingFixCameraFPPBikeSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPBikeSlowEvent);
      // LogChannel(n"DEBUG", "Bike camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.TPPClose:
      cameraTPPBikeSlowEvent = new FrameGenGhostingFixCameraTPPBikeSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeSlowEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.TPPMedium:
      cameraTPPBikeSlowEvent = new FrameGenGhostingFixCameraTPPBikeSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeSlowEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPMedium mode.");
      break;
    case vehicleCameraPerspective.TPPFar:
      cameraTPPFarBikeSlowEvent = new FrameGenGhostingFixCameraTPPFarBikeSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFarBikeSlowEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPFar mode.");
      break;
    default:
      break;
  }
}

@addMethod(DriveEvents)
public final func BikeCameraChangeFaster(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraFPPBikeFasterEvent: ref<FrameGenGhostingFixCameraFPPBikeFasterEvent>;
  let cameraTPPBikeFasterEvent: ref<FrameGenGhostingFixCameraTPPBikeFasterEvent>;
  let cameraTPPFarBikeFasterEvent: ref<FrameGenGhostingFixCameraTPPFarBikeFasterEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPBikeFasterEvent = new FrameGenGhostingFixCameraFPPBikeFasterEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPBikeFasterEvent);
      // LogChannel(n"DEBUG", "Bike camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.TPPClose:
      cameraTPPBikeFasterEvent = new FrameGenGhostingFixCameraTPPBikeFasterEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeFasterEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.TPPMedium:
      cameraTPPBikeFasterEvent = new FrameGenGhostingFixCameraTPPBikeFasterEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeFasterEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPMedium mode.");
      break;
    case vehicleCameraPerspective.TPPFar:
      cameraTPPFarBikeFasterEvent = new FrameGenGhostingFixCameraTPPFarBikeFasterEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFarBikeFasterEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPFar mode.");
      break;
    default:
      break;
  }
}

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
  this.m_vehicleCurrentType = vehicleTypeRecord.Type();

  switch(this.m_vehicleCurrentType) {
    case gamedataVehicleType.Bike:
      if NotEquals(RoundTo(this.m_vehicleCurrentSpeed,1),0.0) {
        if RoundTo(this.m_vehicleCurrentSpeed,1)<2.0 {
          this.BikeCameraChangeCrawl(scriptInterface, this.m_bikeCameraContext);
        } else {
          this.BikeCameraChangeSlow(scriptInterface, this.m_bikeCameraContext);
          if RoundTo(this.m_vehicleCurrentSpeed,1)>4.0 {
            this.BikeCameraChangeFaster(scriptInterface, this.m_carCameraContext);
            if RoundTo(this.m_vehicleCurrentSpeed,1)>7.0 {
              this.BikeCameraChange(scriptInterface, this.m_carCameraContext);
            }
          }
        }
      } else {
        this.VehicleStationaryDeactivation(scriptInterface);
        this.BikeStationaryWindshieldEditorContext(scriptInterface);
      }
      break;
    case gamedataVehicleType.Car:
      if NotEquals(RoundTo(this.m_vehicleCurrentSpeed,1),0.0) {
        if RoundTo(this.m_vehicleCurrentSpeed,1)<-2.0 {
          this.CarCameraChangeSlow(scriptInterface, this.m_carCameraContext);
          if RoundTo(this.m_vehicleCurrentSpeed,1)<-4.0 {
            this.CarCameraChangeFaster(scriptInterface, this.m_carCameraContext);
            if RoundTo(this.m_vehicleCurrentSpeed,1)<-7.0 {
              this.CarCameraChange(scriptInterface, this.m_carCameraContext);
            }
          }
        } else {
          if RoundTo(this.m_vehicleCurrentSpeed,1)<2.0 {
            this.CarCameraChangeCrawl(scriptInterface, this.m_carCameraContext);
          } else {
            this.CarCameraChangeSlow(scriptInterface, this.m_carCameraContext);
            if RoundTo(this.m_vehicleCurrentSpeed,1)>4.0 {
              this.CarCameraChangeFaster(scriptInterface, this.m_carCameraContext);
              if RoundTo(this.m_vehicleCurrentSpeed,1)>7.0 {
                this.CarCameraChange(scriptInterface, this.m_carCameraContext);
              }
            }
          }
        }
      } else {
        this.VehicleStationaryDeactivation(scriptInterface);
      }
      break;
    default:
      break;
  }
}

//Setting context for vehicles masks while in combat starts here---------------------------------------------------------------------------------------
@addMethod(DriverCombatEvents)
protected final func OnVehicleSpeedChange(speed: Float) -> Void {
  this.m_vehicleCurrentSpeed = speed;
}

@addMethod(DriverCombatEvents)
public final func VehicleStationaryDeactivation(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let vehicleDeactivation: ref<FrameGenGhostingFixDeActivationVehicleEvent>;

  vehicleDeactivation = new FrameGenGhostingFixDeActivationVehicleEvent();

    scriptInterface.executionOwner.QueueEvent(vehicleDeactivation);
}

@addMethod(DriverCombatEvents)
public final func BikeStationaryWindshieldEditorContext(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let windshieldEditorContext: ref<FrameGenGhostingFixFPPBikeWindshieldEditorEvent>;

  windshieldEditorContext = new FrameGenGhostingFixFPPBikeWindshieldEditorEvent();

    scriptInterface.executionOwner.QueueEvent(windshieldEditorContext);
}

@addMethod(DriverCombatEvents)
protected final func MaskChange(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let vehicleBlackboard: wref<IBlackboard>;

  if !IsDefined(this.m_vehicleCurrentSpeedCallback) {
    vehicleBlackboard = (scriptInterface.owner as VehicleObject).GetBlackboard();
    this.m_vehicleCurrentSpeedCallback = vehicleBlackboard.RegisterListenerFloat(GetAllBlackboardDefs().Vehicle.SpeedValue, this, n"OnVehicleSpeedChange");
  }

  let vehicleType_Record: ref<VehicleType_Record> = TweakDBInterface.GetVehicleRecord((scriptInterface.owner as VehicleObject).GetRecordID()).Type();
  this.m_vehicleCurrentType = vehicleType_Record.Type();
}

@wrapMethod(DriverCombatEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.MaskChange(scriptInterface);
  wrappedMethod(stateContext,scriptInterface);
}

//Setting context for car masks while in combat starts here---------------------------------------------------------------------------------------
@addMethod(DriverCombatEvents)
public final func CarCameraChangeCrawl(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraFPPCrawlEvent: ref<FrameGenGhostingFixCameraFPPCarCrawlEvent>;
  let cameraTPPCrawlEvent: ref<FrameGenGhostingFixCameraTPPCarCrawlEvent>;
  let cameraTPPFarCrawlEvent: ref<FrameGenGhostingFixCameraTPPFarCarCrawlEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPCrawlEvent = new FrameGenGhostingFixCameraFPPCarCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPCrawlEvent);
      // LogChannel(n"DEBUG", "Car camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.DriverCombatClose:
      cameraTPPCrawlEvent = new FrameGenGhostingFixCameraTPPCarCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPCrawlEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.DriverCombatMedium:
      cameraTPPCrawlEvent = new FrameGenGhostingFixCameraTPPCarCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPCrawlEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPMedium mode.");
      break;
    case vehicleCameraPerspective.DriverCombatFar:
      cameraTPPFarCrawlEvent = new FrameGenGhostingFixCameraTPPFarCarCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFarCrawlEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPFar mode.");
      break;
    default:
      break;
  }
}

@addMethod(DriverCombatEvents)
public final func CarCameraChangeSlow(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraFPPSlowEvent: ref<FrameGenGhostingFixCameraFPPCarSlowEvent>;
  let cameraTPPSlowEvent: ref<FrameGenGhostingFixCameraTPPCarSlowEvent>;
  let cameraTPPFarSlowEvent: ref<FrameGenGhostingFixCameraTPPFarCarSlowEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPSlowEvent = new FrameGenGhostingFixCameraFPPCarSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPSlowEvent);
      // LogChannel(n"DEBUG", "Car camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.DriverCombatClose:
      cameraTPPSlowEvent = new FrameGenGhostingFixCameraTPPCarSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPSlowEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.DriverCombatMedium:
      cameraTPPSlowEvent = new FrameGenGhostingFixCameraTPPCarSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPSlowEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPMedium mode.");
      break;
    case vehicleCameraPerspective.DriverCombatFar:
      cameraTPPFarSlowEvent = new FrameGenGhostingFixCameraTPPFarCarSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFarSlowEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPFar mode.");
      break;
    default:
      break;
  }
}

@addMethod(DriverCombatEvents)
public final func CarCameraChangeFaster(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {
 
  let cameraFPPFasterEvent: ref<FrameGenGhostingFixCameraFPPCarFasterEvent>;
  let cameraTPPFasterEvent: ref<FrameGenGhostingFixCameraTPPCarFasterEvent>;
  let cameraTPPFarFasterEvent: ref<FrameGenGhostingFixCameraTPPFarCarFasterEvent>;


  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPFasterEvent = new FrameGenGhostingFixCameraFPPCarFasterEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPFasterEvent);
      // LogChannel(n"DEBUG", "Car camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.DriverCombatClose:
      cameraTPPFasterEvent = new FrameGenGhostingFixCameraTPPCarFasterEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFasterEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.DriverCombatMedium:
      cameraTPPFasterEvent = new FrameGenGhostingFixCameraTPPCarFasterEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFasterEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPMedium mode.");
     break;
    case vehicleCameraPerspective.DriverCombatFar:
      cameraTPPFarFasterEvent = new FrameGenGhostingFixCameraTPPFarCarFasterEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFarFasterEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPFar mode.");
      break;
    default:
      break;
  }
}

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
public final func BikeCameraChangeCrawl(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraFPPBikeCrawlEvent: ref<FrameGenGhostingFixCameraFPPBikeCrawlEvent>;
  let cameraTPPBikeCrawlEvent: ref<FrameGenGhostingFixCameraTPPBikeCrawlEvent>;
  let cameraTPPFarBikeCrawlEvent: ref<FrameGenGhostingFixCameraTPPFarBikeCrawlEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPBikeCrawlEvent = new FrameGenGhostingFixCameraFPPBikeCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPBikeCrawlEvent);
      // LogChannel(n"DEBUG", "Bike camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.DriverCombatClose:
      cameraTPPBikeCrawlEvent = new FrameGenGhostingFixCameraTPPBikeCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeCrawlEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.DriverCombatMedium:
      cameraTPPBikeCrawlEvent = new FrameGenGhostingFixCameraTPPBikeCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeCrawlEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPMedium mode.");
      break;
    case vehicleCameraPerspective.DriverCombatFar:
      cameraTPPFarBikeCrawlEvent = new FrameGenGhostingFixCameraTPPFarBikeCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFarBikeCrawlEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPFar mode.");
      break;
    default:
      break;
  }
}

@addMethod(DriverCombatEvents)
public final func BikeCameraChangeSlow(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraFPPBikeSlowEvent: ref<FrameGenGhostingFixCameraFPPBikeSlowEvent>;
  let cameraTPPBikeSlowEvent: ref<FrameGenGhostingFixCameraTPPBikeSlowEvent>;
  let cameraTPPFarBikeSlowEvent: ref<FrameGenGhostingFixCameraTPPFarBikeSlowEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPBikeSlowEvent = new FrameGenGhostingFixCameraFPPBikeSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPBikeSlowEvent);
      // LogChannel(n"DEBUG", "Bike camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.DriverCombatClose:
      cameraTPPBikeSlowEvent = new FrameGenGhostingFixCameraTPPBikeSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeSlowEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.DriverCombatMedium:
      cameraTPPBikeSlowEvent = new FrameGenGhostingFixCameraTPPBikeSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeSlowEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPMedium mode.");
      break;
    case vehicleCameraPerspective.DriverCombatFar:
      cameraTPPFarBikeSlowEvent = new FrameGenGhostingFixCameraTPPFarBikeSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFarBikeSlowEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPFar mode.");
      break;
    default:
      break;
  }
}

@addMethod(DriverCombatEvents)
public final func BikeCameraChangeFaster(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraFPPBikeFasterEvent: ref<FrameGenGhostingFixCameraFPPBikeFasterEvent>;
  let cameraTPPBikeFasterEvent: ref<FrameGenGhostingFixCameraTPPBikeFasterEvent>;
  let cameraTPPFarBikeFasterEvent: ref<FrameGenGhostingFixCameraTPPFarBikeFasterEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPBikeFasterEvent = new FrameGenGhostingFixCameraFPPBikeFasterEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPBikeFasterEvent);
      // LogChannel(n"DEBUG", "Bike camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.DriverCombatClose:
      cameraTPPBikeFasterEvent = new FrameGenGhostingFixCameraTPPBikeFasterEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeFasterEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.DriverCombatMedium:
      cameraTPPBikeFasterEvent = new FrameGenGhostingFixCameraTPPBikeFasterEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeFasterEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPMedium mode.");
      break;
    case vehicleCameraPerspective.DriverCombatFar:
      cameraTPPFarBikeFasterEvent = new FrameGenGhostingFixCameraTPPFarBikeFasterEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFarBikeFasterEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPFar mode.");
      break;
    default:
      break;
  }
}

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
  this.m_vehicleCurrentType = vehicleTypeRecord.Type();

  switch(this.m_vehicleCurrentType) {
    case gamedataVehicleType.Bike:
      if NotEquals(RoundTo(this.m_vehicleCurrentSpeed,1),0.0) {
        if RoundTo(this.m_vehicleCurrentSpeed,1)<2.0 {
          this.BikeCameraChangeCrawl(scriptInterface, this.m_bikeCameraContext);
        } else {
          this.BikeCameraChangeSlow(scriptInterface, this.m_bikeCameraContext);
          if RoundTo(this.m_vehicleCurrentSpeed,1)>4.0 {
            this.BikeCameraChangeFaster(scriptInterface, this.m_carCameraContext);
            if RoundTo(this.m_vehicleCurrentSpeed,1)>7.0 {
              this.BikeCameraChange(scriptInterface, this.m_carCameraContext);
            }
          }
        }
      } else {
        this.VehicleStationaryDeactivation(scriptInterface);
        this.BikeStationaryWindshieldEditorContext(scriptInterface);
      }
      break;
    case gamedataVehicleType.Car:
      if NotEquals(RoundTo(this.m_vehicleCurrentSpeed,1),0.0) {
        if RoundTo(this.m_vehicleCurrentSpeed,1)<-2.0 {
          this.CarCameraChangeSlow(scriptInterface, this.m_carCameraContext);
          if RoundTo(this.m_vehicleCurrentSpeed,1)<-4.0 {
            this.CarCameraChangeFaster(scriptInterface, this.m_carCameraContext);
            if RoundTo(this.m_vehicleCurrentSpeed,1)<-7.0 {
              this.CarCameraChange(scriptInterface, this.m_carCameraContext);
            }
          }
        } else {
          if RoundTo(this.m_vehicleCurrentSpeed,1)<2.0 {
            this.CarCameraChangeCrawl(scriptInterface, this.m_carCameraContext);
          } else {
            this.CarCameraChangeSlow(scriptInterface, this.m_carCameraContext);
            if RoundTo(this.m_vehicleCurrentSpeed,1)>4.0 {
              this.CarCameraChangeFaster(scriptInterface, this.m_carCameraContext);
              if RoundTo(this.m_vehicleCurrentSpeed,1)>7.0 {
                this.CarCameraChange(scriptInterface, this.m_carCameraContext);
              }
            }
          }
        }
      } else {
        this.VehicleStationaryDeactivation(scriptInterface);
      }
      break;
    default:
      break;
  }
}
