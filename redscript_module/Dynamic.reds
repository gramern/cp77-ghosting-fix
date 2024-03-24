// Thanks to djkovrik for redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

//FrameGen Ghosting 'Fix' 2.13.0-alpha for FSR3 FG Mods, 2024 gramern (scz_g) 2024

// @addField(IronsightGameController) public let m_debugPrinted: Bool = false;

@addField(DriveEvents) public let m_carCameraContext: vehicleCameraPerspective;
@addField(DriveEvents) public let m_bikeCameraContext: vehicleCameraPerspective;
@addField(DriveEvents) public let m_vehicleCurrentType: gamedataVehicleType;
@addField(DriveEvents) public let m_vehicleCurrentSpeed: Float;
@addField(DriveEvents) public let m_vehicleCurrentSpeedCallback: ref<CallbackHandle>;

//The main Transition function---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixVehicleSetTransition(dumbo1setSize: Vector2, dumbo2setSize: Vector2, dumbo3setSize: Vector2, dumbo1setOpacity: Float, dumbo2setOpacity: Float, dumbo3setOpacity: Float, dumbo45setOpacity: Float, dynamic_dumbo1setOpacity: Float, dynamic_dumbo2setOpacity: Float, dynamic_dumbo3setOpacity: Float) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo1") as inkWidget;
  let dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo2") as inkWidget;
  let dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo3") as inkWidget;
  let dumbo4: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4") as inkWidget;
  let dumbo5: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5") as inkWidget;
  let dynamic_dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo1") as inkWidget;
  let dynamic_dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo2") as inkWidget;
  let dynamic_dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo3") as inkWidget;

  let dumbo1size = dumbo1.GetSize();
  if dumbo1size.Y != dumbo1setSize.Y {
    dumbo1.SetSize(dumbo1size.X, dumbo1setSize.Y);
    dumbo1.Reparent(root);
  }
  let dumbo2size = dumbo2.GetSize();
  if dumbo2size.X != dumbo2setSize.X {
    dumbo2.SetSize(dumbo2setSize.X, dumbo2size.Y);
    dumbo2.Reparent(root);
  }
  let dumbo2size = dumbo2.GetSize();
  if dumbo2size.Y != dumbo2setSize.Y {
    dumbo2.SetSize(dumbo2size.X, dumbo2setSize.Y);
    dumbo2.Reparent(root);
  }
  let dumbo3size = dumbo3.GetSize();
  if dumbo3size.X != dumbo3setSize.X {
    dumbo3.SetSize(dumbo3setSize.X, dumbo3size.Y);
    dumbo3.Reparent(root);
  }
  let dumbo3size = dumbo3.GetSize();
    if dumbo3size.Y != dumbo3setSize.Y {
    dumbo3.SetSize(dumbo3size.X, dumbo3setSize.Y);
    dumbo3.Reparent(root);
  }

  if dumbo1.GetOpacity() != dumbo1setOpacity {
    dumbo1.SetOpacity(dumbo1setOpacity);
  }
  if dumbo2.GetOpacity() != dumbo2setOpacity {
    dumbo2.SetOpacity(dumbo2setOpacity);
  }
  if dumbo3.GetOpacity() != dumbo3setOpacity {
    dumbo3.SetOpacity(dumbo3setOpacity);
  }
  if dumbo4.GetOpacity() != dumbo45setOpacity {
    dumbo4.SetOpacity(dumbo45setOpacity);
  }
  if dumbo5.GetOpacity() != dumbo45setOpacity {
    dumbo5.SetOpacity(dumbo45setOpacity);
  }
  if dynamic_dumbo1.GetOpacity() != dynamic_dumbo1setOpacity {
    dynamic_dumbo1.SetOpacity(dynamic_dumbo1setOpacity);
  }
  if dynamic_dumbo2.GetOpacity() != dynamic_dumbo2setOpacity {
    dynamic_dumbo2.SetOpacity(dynamic_dumbo2setOpacity);
  }
  if dynamic_dumbo3.GetOpacity() != dynamic_dumbo3setOpacity {
    dynamic_dumbo3.SetOpacity(dynamic_dumbo3setOpacity);
  }
}

//Setting masks when changing cameras in a car---------------------------------------------------------------------------------------
//TPP Car---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPCarEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPCarEvent>) -> Bool {
  
  // this.m_debugPrinted = false;

  let dumbo1setSize: Vector2 = new Vector2(7680.0, 950.0);
  let dumbo2setSize: Vector2 = new Vector2(3600.0, 850.0);
  let dumbo3setSize: Vector2 = new Vector2(2000.0, 900.0);

  this.OnFrameGenGhostingFixVehicleSetTransition(dumbo1setSize, dumbo2setSize, dumbo3setSize, 0.03, 0.05, 0.03, 0.03, 0.03, 0.0, 0.0);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPCarFasterEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPCarFasterEvent>) -> Bool {

  // this.m_debugPrinted = false;

  let dumbo1setSize: Vector2 = new Vector2(7680.0, 950.0);
  let dumbo2setSize: Vector2 = new Vector2(3600.0, 850.0);
  let dumbo3setSize: Vector2 = new Vector2(2000.0, 900.0);

  this.OnFrameGenGhostingFixVehicleSetTransition(dumbo1setSize, dumbo2setSize, dumbo3setSize, 0.025, 0.03, 0.025, 0.025, 0.02, 0.0, 0.0);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPCarSlowEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPCarSlowEvent>) -> Bool {

  // this.m_debugPrinted = false;

  let dumbo1setSize: Vector2 = new Vector2(7680.0, 950.0);
  let dumbo2setSize: Vector2 = new Vector2(3400.0, 700.0);
  let dumbo3setSize: Vector2 = new Vector2(1800.0, 800.0);

  this.OnFrameGenGhostingFixVehicleSetTransition(dumbo1setSize, dumbo2setSize, dumbo3setSize, 0.02, 0.02, 0.02, 0.02, 0.01, 0.0, 0.0);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPCarCrawlEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPCarCrawlEvent>) -> Bool {

  // this.m_debugPrinted = false;

  let dumbo1setSize: Vector2 = new Vector2(7680.0, 950.0);
  let dumbo2setSize: Vector2 = new Vector2(3400.0, 700.0);
  let dumbo3setSize: Vector2 = new Vector2(1800.0, 800.0);

  this.OnFrameGenGhostingFixVehicleSetTransition(dumbo1setSize, dumbo2setSize, dumbo3setSize, 0.01, 0.01, 0.01, 0.01, 0.01, 0.0, 0.0);
}

//TPP Far Car---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPFarCarEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPFarCarEvent>) -> Bool {

  let dumbo1setSize: Vector2 = new Vector2(7680.0, 800.0);
  let dumbo2setSize: Vector2 = new Vector2(2000.0, 1150.0);
  let dumbo3setSize: Vector2 = new Vector2(1800.0, 700.0);

  this.OnFrameGenGhostingFixVehicleSetTransition(dumbo1setSize, dumbo2setSize, dumbo3setSize, 0.0, 0.03, 0.03, 0.03, 0.03, 0.0, 0.0);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPFarCarSlowEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPFarCarSlowEvent>) -> Bool {

  let dumbo1setSize: Vector2 = new Vector2(7680.0, 950.0);
  let dumbo2setSize: Vector2 = new Vector2(2600.0, 800.0);
  let dumbo3setSize: Vector2 = new Vector2(1800.0, 800.0);

  this.OnFrameGenGhostingFixVehicleSetTransition(dumbo1setSize, dumbo2setSize, dumbo3setSize, 0.0, 0.02, 0.02, 0.03, 0.03, 0.0, 0.0);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPFarCarCrawlEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPFarCarCrawlEvent>) -> Bool {

  let dumbo1setSize: Vector2 = new Vector2(7680.0, 950.0);
  let dumbo2setSize: Vector2 = new Vector2(2600.0, 800.0);
  let dumbo3setSize: Vector2 = new Vector2(1800.0, 800.0);

  this.OnFrameGenGhostingFixVehicleSetTransition(dumbo1setSize, dumbo2setSize, dumbo3setSize, 0.0, 0.01, 0.02, 0.01, 0.01, 0.0, 0.0);
}

//FPP Car---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraFPPCarEvent(fppCarSideMirrorOpacity: Float, fppCarSideMirrorSizeX: Float, fppCarSideMirrorSizeY: Float) -> Bool {

  let fppCarSideMirrorSize: Vector2 = new Vector2(fppCarSideMirrorSizeX, fppCarSideMirrorSizeY);

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo1") as inkWidget;
  let dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo2") as inkWidget;
  let dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo3") as inkWidget;
  let dumbo4: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4") as inkWidget;
  let dumbo5: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5") as inkWidget;
  let dynamic_dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo1") as inkWidget;
  let dynamic_dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo2") as inkWidget;
  let dynamic_dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo3") as inkWidget;

  let dynamic_dumbo2Size = dynamic_dumbo2.GetSize();
  if dynamic_dumbo2Size.X != 2100.0 && dynamic_dumbo2Size.Y != 1800.0 {
    dynamic_dumbo2.SetSize(fppCarSideMirrorSize);
    dynamic_dumbo2.Reparent(root);
  }

  if dumbo1.GetOpacity() != 0.0 {
    dumbo1.SetOpacity(0.0);
  }
  if dumbo2.GetOpacity() != 0.0 {
    dumbo2.SetOpacity(0.0);
  }
  if dumbo3.GetOpacity() != 0.0 {
    dumbo3.SetOpacity(0.0);
  }
  if dumbo4.GetOpacity() != 0.03 {
    dumbo4.SetOpacity(0.03);
  }
  if dumbo5.GetOpacity() != 0.03 {
    dumbo5.SetOpacity(0.03);
  }
  if dynamic_dumbo1.GetOpacity() != 0.0 {
    dynamic_dumbo1.SetOpacity(0.0);
  }
  if dynamic_dumbo2.GetOpacity() != fppCarSideMirrorOpacity {
    dynamic_dumbo2.SetOpacity(fppCarSideMirrorOpacity);
  }
  if dynamic_dumbo3.GetOpacity() != 0.0 {
    dynamic_dumbo3.SetOpacity(0.0);
  }
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixFPPCarSideMirrorToggleEvent(evt: ref<FrameGenGhostingFixFPPCarSideMirrorToggleEvent>) -> Void {

  this.OnFrameGenGhostingFixDumboCameraFPPCarEvent(0.0, 2100.0, 1800.0);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraFPPCarSlowEvent(evt: ref<FrameGenGhostingFixDumboCameraFPPCarSlowEvent>) -> Bool {

  let dumbo1setSize: Vector2 = new Vector2(7680.0, 950.0);
  let dumbo2setSize: Vector2 = new Vector2(2600.0, 800.0);
  let dumbo3setSize: Vector2 = new Vector2(1800.0, 800.0);

  this.OnFrameGenGhostingFixVehicleSetTransition(dumbo1setSize, dumbo2setSize, dumbo3setSize, 0.0, 0.0, 0.0, 0.03, 0.0, 0.0, 0.0);
}

//Setting masks when changing cameras on a bike---------------------------------------------------------------------------------------
//TPP Bike---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPBikeEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPBikeEvent>) -> Bool {

  let dumbo1setSize: Vector2 = new Vector2(7680.0, 950.0);
  let dumbo2setSize: Vector2 = new Vector2(3200.0, 1050.0);
  let dumbo3setSize: Vector2 = new Vector2(1400.0, 1400.0);

  this.OnFrameGenGhostingFixVehicleSetTransition(dumbo1setSize, dumbo2setSize, dumbo3setSize, 0.03, 0.04, 0.03, 0.03, 0.03, 0.0, 0.0);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPBikeFasterEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPBikeFasterEvent>) -> Bool {

  let dumbo1setSize: Vector2 = new Vector2(7680.0, 950.0);
  let dumbo2setSize: Vector2 = new Vector2(3200.0, 1050.0);
  let dumbo3setSize: Vector2 = new Vector2(1400.0, 1400.0);

  this.OnFrameGenGhostingFixVehicleSetTransition(dumbo1setSize, dumbo2setSize, dumbo3setSize, 0.025, 0.025, 0.025, 0.025, 0.02, 0.0, 0.0);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPBikeSlowEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPBikeSlowEvent>) -> Bool {

  let dumbo1setSize: Vector2 = new Vector2(7680.0, 950.0);
  let dumbo2setSize: Vector2 = new Vector2(2400.0, 700.0);
  let dumbo3setSize: Vector2 = new Vector2(1800.0, 800.0);

  this.OnFrameGenGhostingFixVehicleSetTransition(dumbo1setSize, dumbo2setSize, dumbo3setSize, 0.02, 0.02, 0.02, 0.02, 0.01, 0.0, 0.0);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPBikeCrawlEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPBikeCrawlEvent>) -> Bool {

  let dumbo1setSize: Vector2 = new Vector2(7680.0, 950.0);
  let dumbo2setSize: Vector2 = new Vector2(2400.0, 700.0);
  let dumbo3setSize: Vector2 = new Vector2(1800.0, 800.0);

  this.OnFrameGenGhostingFixVehicleSetTransition(dumbo1setSize, dumbo2setSize, dumbo3setSize, 0.01, 0.01, 0.01, 0.01, 0.01, 0.0, 0.0);
}

//TPP Far Bike---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPFarBikeEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPFarBikeEvent>) -> Bool {

  let dumbo1setSize: Vector2 = new Vector2(7680.0, 800.0);
  let dumbo2setSize: Vector2 = new Vector2(2000.0, 1050.0);
  let dumbo3setSize: Vector2 = new Vector2(1800.0, 800.0);

  this.OnFrameGenGhostingFixVehicleSetTransition(dumbo1setSize, dumbo2setSize, dumbo3setSize, 0.0, 0.03, 0.03, 0.03, 0.03, 0.0, 0.0);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPFarBikeSlowEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPFarBikeSlowEvent>) -> Bool {

  let dumbo1setSize: Vector2 = new Vector2(7680.0, 800.0);
  let dumbo2setSize: Vector2 = new Vector2(2000.0, 900.0);
  let dumbo3setSize: Vector2 = new Vector2(1800.0, 800.0);

  this.OnFrameGenGhostingFixVehicleSetTransition(dumbo1setSize, dumbo2setSize, dumbo3setSize, 0.0, 0.02, 0.02, 0.02, 0.02, 0.0, 0.0);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPFarBikeCrawlEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPFarBikeCrawlEvent>) -> Bool {

  let dumbo1setSize: Vector2 = new Vector2(7680.0, 800.0);
  let dumbo2setSize: Vector2 = new Vector2(2000.0, 700.0);
  let dumbo3setSize: Vector2 = new Vector2(1800.0, 800.0);

  this.OnFrameGenGhostingFixVehicleSetTransition(dumbo1setSize, dumbo2setSize, dumbo3setSize, 0.0, 0.01, 0.01, 0.01, 0.01, 0.0, 0.0);
}

//FPP Bike---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixFPPBikeSetTransition(fppBikeELGDumbo1SizeY: Float, fppBikeELGDumbo3SizeX: Float, fppBikeELGDumbo3SizeY: Float, fppBikeELGDumbo1Opacity: Float, fppBikeELGDumbo2Opacity: Float, fppBikeELGDumbo3Opacity: Float, fppBikeELGDumbo45Opacity: Float) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo1") as inkWidget;
  let dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo2") as inkWidget;
  let dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo3") as inkWidget;
  let dumbo4: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4") as inkWidget;
  let dumbo5: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5") as inkWidget;
  let dynamic_dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo1") as inkWidget;
  let dynamic_dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo2") as inkWidget;
  let dynamic_dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo3") as inkWidget;

  let dumbo1Size = dumbo1.GetSize();
  if dumbo1Size.Y != fppBikeELGDumbo1SizeY {
    dumbo1.SetSize(dumbo1Size.X, fppBikeELGDumbo1SizeY);
    dumbo1.Reparent(root);
  }
  // let dumbo2Size = dumbo2.GetSize();
  // if dumbo2Size.X != 3000.0 {
  //   dumbo2.SetSize(3000.0, dumbo2Size.Y);
  //   dumbo2.Reparent(root);
  // }
  // let dumbo2Size = dumbo2.GetSize();
  // if dumbo2Size.Y != 1000.0 {
  //   dumbo2.SetSize(dumbo2Size.X, 1000.0);
  //   dumbo2.Reparent(root);
  // }
  let dumbo3Size = dumbo3.GetSize();
  if dumbo3Size.X != fppBikeELGDumbo3SizeX {
    dumbo3.SetSize(fppBikeELGDumbo3SizeX, fppBikeELGDumbo3SizeY);
    dumbo3.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
  if dumbo3Size.Y != fppBikeELGDumbo3SizeY {
    dumbo3.SetSize(fppBikeELGDumbo3SizeX, fppBikeELGDumbo3SizeY);
    dumbo3.Reparent(root);
  }

  if dumbo1.GetOpacity() != fppBikeELGDumbo1Opacity {
    dumbo1.SetOpacity(fppBikeELGDumbo1Opacity);
  }
  if dumbo2.GetOpacity() != fppBikeELGDumbo2Opacity {
    dumbo2.SetOpacity(fppBikeELGDumbo2Opacity);
  }
  if dumbo3.GetOpacity() != fppBikeELGDumbo3Opacity {
    dumbo3.SetOpacity(fppBikeELGDumbo3Opacity);
  }
  if dumbo4.GetOpacity() != fppBikeELGDumbo45Opacity {
    dumbo4.SetOpacity(fppBikeELGDumbo45Opacity);
  }
  if dumbo5.GetOpacity() != fppBikeELGDumbo45Opacity{
    dumbo5.SetOpacity(fppBikeELGDumbo45Opacity);
  }
  if dynamic_dumbo1.GetOpacity() != 0.0 {
    dynamic_dumbo1.SetOpacity(0.0);
  }
  if dynamic_dumbo2.GetOpacity() != 0.0 {
    dynamic_dumbo2.SetOpacity(0.0);
  }
  if dynamic_dumbo3.GetOpacity() != 0.0 {
    dynamic_dumbo3.SetOpacity(0.0);
  }
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraFPPBikeEvent(evt: ref<FrameGenGhostingFixDumboCameraFPPBikeEvent>) -> Void {

  this.OnFrameGenGhostingFixFPPBikeSetTransition(1100.0, 1800.0, 800.0, 0.04, 0.0, 0.0, 0.03);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraFPPBikeFasterEvent(evt: ref<FrameGenGhostingFixDumboCameraFPPBikeFasterEvent>) -> Void {

  this.OnFrameGenGhostingFixFPPBikeSetTransition(1050.0, 1800.0, 800.0, 0.03, 0.0, 0.0, 0.03);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraFPPBikeSlowEvent(evt: ref<FrameGenGhostingFixDumboCameraFPPBikeSlowEvent>) -> Bool {

  this.OnFrameGenGhostingFixFPPBikeSetTransition(1000.0, 1800.0, 800.0, 0.02, 0.0, 0.0, 0.02);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraFPPBikeCrawlEvent(evt: ref<FrameGenGhostingFixDumboCameraFPPBikeCrawlEvent>) -> Bool {

  this.OnFrameGenGhostingFixFPPBikeSetTransition(950.0, 1800.0, 800.0, 0.01, 0.0, 0.0, 0.01);
}

//Setting masks deactivation for vehicles---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
private final func OnFrameGenGhostingFixDumboDeActivationVehicleSetupEvent(delay: Float) -> Void {
  let player: ref<GameObject> = this.GetPlayerControlledObject();
  let turnOffMasksPhaseOne: ref<FrameGenGhostingFixDumboDeActivationVehicleEvent> = new FrameGenGhostingFixDumboDeActivationVehicleEvent();
  GameInstance.GetDelaySystem(player.GetGame()).DelayEvent(player, turnOffMasksPhaseOne, delay, false);
}

@addMethod(IronsightGameController)
protected cb func OnFrameGenGhostingFixDumboDeActivationVehicleEvent(evt: ref<FrameGenGhostingFixDumboDeActivationVehicleEvent>)  -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo1") as inkWidget;
  let dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo2") as inkWidget;
  let dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo3") as inkWidget;
  let dumbo4: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4") as inkWidget;
  let dumbo5: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5") as inkWidget;
  let dynamic_dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo2") as inkWidget;

  dumbo1.SetOpacity(0.0);
  dumbo2.SetOpacity(0.0);
  dumbo3.SetOpacity(0.0);
  dumbo4.SetOpacity(0.0);
  dumbo5.SetOpacity(0.0);
  dynamic_dumbo2.SetOpacity(0.0);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboDeActivationVehicleToggleEvent(evt: ref<FrameGenGhostingFixDumboDeActivationVehicleToggleEvent>)  -> Void {
    this.OnFrameGenGhostingFixDumboDeActivationVehicleSetupEvent(0.5);
}

//Setting masks for vehicles when a weapon is drawn
@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixWeaponCarEvent(evt: ref<FrameGenGhostingFixWeaponCarEvent>) -> Bool {
	
  if Equals(this.m_hasWeaponDrawn,true) {
    let dumbo1setSize: Vector2 = new Vector2(7680.0, 900.0);
    let dumbo2setSize: Vector2 = new Vector2(3000.0, 700.0);
    let dumbo3setSize: Vector2 = new Vector2(1800.0, 900.0);

    this.OnFrameGenGhostingFixVehicleSetTransition(dumbo1setSize, dumbo2setSize, dumbo3setSize, 0.03, 0.03, 0.0, 0.01, 0.04, 0.0, 0.0);
	}
}

//Setting masks for ELG Editor---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixFPPBikeELGEditor(fppBikeELGEDumbo1SizeY: Float, fppBikeELGEDumbo3SizeX: Float, fppBikeELGEDumbo3SizeY: Float, fppBikeELGEDumbo1Opacity: Float, fppBikeELGEDumbo3Opacity: Float) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo1_elgeditor: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo1_elgeditor") as inkWidget;
  let dumbo3_elgeditor: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo3_elgeditor") as inkWidget;

  if dumbo1_elgeditor.GetOpacity() != fppBikeELGEDumbo1Opacity {
    dumbo1_elgeditor.SetOpacity(fppBikeELGEDumbo1Opacity);
  }
  if dumbo3_elgeditor.GetOpacity() != fppBikeELGEDumbo3Opacity {
    dumbo3_elgeditor.SetOpacity(fppBikeELGEDumbo3Opacity);
  }
  let dumbo1_elgeditorSize = dumbo1_elgeditor.GetSize();
  if dumbo1_elgeditorSize.Y != fppBikeELGEDumbo1SizeY {
    dumbo1_elgeditor.SetSize(dumbo1_elgeditorSize.X, fppBikeELGEDumbo1SizeY);
    dumbo1_elgeditor.Reparent(root);
  }
  let dumbo3_elgeditorSize = dumbo3_elgeditor.GetSize();
  if dumbo3_elgeditorSize.X != fppBikeELGEDumbo3SizeX {
    dumbo3_elgeditor.SetSize(fppBikeELGEDumbo3SizeX, fppBikeELGEDumbo3SizeY);
    dumbo3_elgeditor.Reparent(root);
  }
  let dumbo3_elgeditorSize = dumbo3_elgeditor.GetSize();
    if dumbo3_elgeditorSize.Y != fppBikeELGEDumbo3SizeY {
    dumbo3_elgeditor.SetSize(fppBikeELGEDumbo3SizeX, fppBikeELGEDumbo3SizeY);
    dumbo3_elgeditor.Reparent(root);
  }
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixFPPBikeELGEEvent(evt: ref<FrameGenGhostingFixFPPBikeELGEEvent>) -> Void {

  this.OnFrameGenGhostingFixFPPBikeELGEditor(950.0, 1800.0, 800.0, 0.0, 0.0);
}

//Setting context for vehicles masks start here---------------------------------------------------------------------------------------
@addMethod(DriveEvents)
protected final func OnVehicleSpeedChange(speed: Float) -> Void {
  this.m_vehicleCurrentSpeed = speed;
}

@addMethod(DriveEvents)
public final func VehicleStationaryDumboDeactivation(scriptInterface: ref<StateGameScriptInterface>, done: Bool) -> Void {
  let vehicleDumboDeactivation: ref<FrameGenGhostingFixDumboDeActivationVehicleToggleEvent>;

  vehicleDumboDeactivation = new FrameGenGhostingFixDumboDeActivationVehicleToggleEvent();

    scriptInterface.executionOwner.QueueEvent(vehicleDumboDeactivation);
}

@addMethod(DriveEvents)
public final func BikeStationaryELGEditorContext(scriptInterface: ref<StateGameScriptInterface>, done: Bool) -> Void {
  let elgEditorContext: ref<FrameGenGhostingFixFPPBikeELGEEvent>;

  elgEditorContext = new FrameGenGhostingFixFPPBikeELGEEvent();

    scriptInterface.executionOwner.QueueEvent(elgEditorContext);
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

  let cameraFPPCrawlEvent: ref<FrameGenGhostingFixDumboCameraFPPCarSlowEvent>;
  let cameraTPPCrawlEvent: ref<FrameGenGhostingFixDumboCameraTPPCarCrawlEvent>;
  let cameraTPPFarCrawlEvent: ref<FrameGenGhostingFixDumboCameraTPPFarCarCrawlEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPCrawlEvent = new FrameGenGhostingFixDumboCameraFPPCarSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPCrawlEvent);
      // LogChannel(n"DEBUG", "Car camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.TPPClose:
      cameraTPPCrawlEvent = new FrameGenGhostingFixDumboCameraTPPCarCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPCrawlEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.TPPMedium:
      cameraTPPCrawlEvent = new FrameGenGhostingFixDumboCameraTPPCarCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPCrawlEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPMedium mode.");
    break;
    case vehicleCameraPerspective.TPPFar:
      cameraTPPFarCrawlEvent = new FrameGenGhostingFixDumboCameraTPPFarCarCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFarCrawlEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPFar mode.");
    break;
    default:
      break;
  }
}

@addMethod(DriveEvents)
public final func CarCameraChangeSlow(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraFPPSlowEvent: ref<FrameGenGhostingFixDumboCameraFPPCarSlowEvent>;
  let cameraTPPSlowEvent: ref<FrameGenGhostingFixDumboCameraTPPCarSlowEvent>;
  let cameraTPPFarSlowEvent: ref<FrameGenGhostingFixDumboCameraTPPFarCarSlowEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPSlowEvent = new FrameGenGhostingFixDumboCameraFPPCarSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPSlowEvent);
      // LogChannel(n"DEBUG", "Car camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.TPPClose:
      cameraTPPSlowEvent = new FrameGenGhostingFixDumboCameraTPPCarSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPSlowEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.TPPMedium:
      cameraTPPSlowEvent = new FrameGenGhostingFixDumboCameraTPPCarSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPSlowEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPMedium mode.");
    break;
    case vehicleCameraPerspective.TPPFar:
      cameraTPPFarSlowEvent = new FrameGenGhostingFixDumboCameraTPPFarCarSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFarSlowEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPFar mode.");
    break;
    default:
      break;
  }
}

@addMethod(DriveEvents)
public final func CarCameraChangeFaster(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {
 
  let cameraFPPFasterEvent: ref<FrameGenGhostingFixFPPCarSideMirrorToggleEvent>;
  let cameraTPPFasterEvent: ref<FrameGenGhostingFixDumboCameraTPPCarFasterEvent>;
  let cameraTPPFarFasterEvent: ref<FrameGenGhostingFixDumboCameraTPPFarCarEvent>;


  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPFasterEvent = new FrameGenGhostingFixFPPCarSideMirrorToggleEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPFasterEvent);
      // LogChannel(n"DEBUG", "Car camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.TPPClose:
      cameraTPPFasterEvent = new FrameGenGhostingFixDumboCameraTPPCarFasterEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFasterEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.TPPMedium:
      cameraTPPFasterEvent = new FrameGenGhostingFixDumboCameraTPPCarFasterEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFasterEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPMedium mode.");
    break;
    case vehicleCameraPerspective.TPPFar:
      cameraTPPFarFasterEvent = new FrameGenGhostingFixDumboCameraTPPFarCarEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFarFasterEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPFar mode.");
    break;
    default:
      break;
  }
}

@addMethod(DriveEvents)
public final func CarCameraChange(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraFPPEvent: ref<FrameGenGhostingFixFPPCarSideMirrorToggleEvent>;
  let cameraTPPEvent: ref<FrameGenGhostingFixDumboCameraTPPCarEvent>;
  let cameraTPPFarEvent: ref<FrameGenGhostingFixDumboCameraTPPFarCarEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPEvent = new FrameGenGhostingFixFPPCarSideMirrorToggleEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPEvent);
      // LogChannel(n"DEBUG", "Car camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.TPPClose:
      cameraTPPEvent = new FrameGenGhostingFixDumboCameraTPPCarEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.TPPMedium:
      cameraTPPEvent = new FrameGenGhostingFixDumboCameraTPPCarEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPMedium mode.");
    break;
    case vehicleCameraPerspective.TPPFar:
      cameraTPPFarEvent = new FrameGenGhostingFixDumboCameraTPPFarCarEvent();
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

  let cameraFPPBikeCrawlEvent: ref<FrameGenGhostingFixDumboCameraFPPBikeCrawlEvent>;
  let cameraTPPBikeCrawlEvent: ref<FrameGenGhostingFixDumboCameraTPPBikeCrawlEvent>;
  let cameraTPPFarBikeCrawlEvent: ref<FrameGenGhostingFixDumboCameraTPPFarBikeCrawlEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPBikeCrawlEvent = new FrameGenGhostingFixDumboCameraFPPBikeCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPBikeCrawlEvent);
      // LogChannel(n"DEBUG", "Bike camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.TPPClose:
      cameraTPPBikeCrawlEvent = new FrameGenGhostingFixDumboCameraTPPBikeCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeCrawlEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.TPPMedium:
      cameraTPPBikeCrawlEvent = new FrameGenGhostingFixDumboCameraTPPBikeCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeCrawlEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPMedium mode.");
    break;
    case vehicleCameraPerspective.TPPFar:
      cameraTPPFarBikeCrawlEvent = new FrameGenGhostingFixDumboCameraTPPFarBikeCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFarBikeCrawlEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPFar mode.");
    break;
    default:
      break;
  }
}

@addMethod(DriveEvents)
public final func BikeCameraChangeSlow(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraFPPBikeSlowEvent: ref<FrameGenGhostingFixDumboCameraFPPBikeSlowEvent>;
  let cameraTPPBikeSlowEvent: ref<FrameGenGhostingFixDumboCameraTPPBikeSlowEvent>;
  let cameraTPPFarBikeSlowEvent: ref<FrameGenGhostingFixDumboCameraTPPFarBikeSlowEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPBikeSlowEvent = new FrameGenGhostingFixDumboCameraFPPBikeSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPBikeSlowEvent);
      // LogChannel(n"DEBUG", "Bike camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.TPPClose:
      cameraTPPBikeSlowEvent = new FrameGenGhostingFixDumboCameraTPPBikeSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeSlowEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.TPPMedium:
      cameraTPPBikeSlowEvent = new FrameGenGhostingFixDumboCameraTPPBikeSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeSlowEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPMedium mode.");
    break;
    case vehicleCameraPerspective.TPPFar:
      cameraTPPFarBikeSlowEvent = new FrameGenGhostingFixDumboCameraTPPFarBikeSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFarBikeSlowEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPFar mode.");
    break;
    default:
      break;
  }
}

@addMethod(DriveEvents)
public final func BikeCameraChangeFaster(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraFPPBikeFasterEvent: ref<FrameGenGhostingFixDumboCameraFPPBikeFasterEvent>;
  let cameraTPPBikeFasterEvent: ref<FrameGenGhostingFixDumboCameraTPPBikeFasterEvent>;
  let cameraTPPFarBikeFasterEvent: ref<FrameGenGhostingFixDumboCameraTPPFarBikeEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPBikeFasterEvent = new FrameGenGhostingFixDumboCameraFPPBikeFasterEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPBikeFasterEvent);
      // LogChannel(n"DEBUG", "Bike camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.TPPClose:
      cameraTPPBikeFasterEvent = new FrameGenGhostingFixDumboCameraTPPBikeFasterEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeFasterEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.TPPMedium:
      cameraTPPBikeFasterEvent = new FrameGenGhostingFixDumboCameraTPPBikeFasterEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeFasterEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPMedium mode.");
    break;
    case vehicleCameraPerspective.TPPFar:
      cameraTPPFarBikeFasterEvent = new FrameGenGhostingFixDumboCameraTPPFarBikeEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFarBikeFasterEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPFar mode.");
    break;
    default:
      break;
  }
}

@addMethod(DriveEvents)
public final func BikeCameraChange(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraFPPBikeEvent: ref<FrameGenGhostingFixDumboCameraFPPBikeEvent>;
  let cameraTPPBikeEvent: ref<FrameGenGhostingFixDumboCameraTPPBikeEvent>;
  let cameraTPPFarBikeEvent: ref<FrameGenGhostingFixDumboCameraTPPFarBikeEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPBikeEvent = new FrameGenGhostingFixDumboCameraFPPBikeEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPBikeEvent);
      // LogChannel(n"DEBUG", "Bike camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.TPPClose:
      cameraTPPBikeEvent = new FrameGenGhostingFixDumboCameraTPPBikeEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.TPPMedium:
      cameraTPPBikeEvent = new FrameGenGhostingFixDumboCameraTPPBikeEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPMedium mode.");
    break;
    case vehicleCameraPerspective.TPPFar:
      cameraTPPFarBikeEvent = new FrameGenGhostingFixDumboCameraTPPFarBikeEvent();
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
        this.VehicleStationaryDumboDeactivation(scriptInterface, true);
        this.BikeStationaryELGEditorContext(scriptInterface,true);
      }
      break;
    case gamedataVehicleType.Car:
      if NotEquals(RoundTo(this.m_vehicleCurrentSpeed,1),0.0) {
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
      } else {
        this.VehicleStationaryDumboDeactivation(scriptInterface, true);
      }
      break;
    default:
      break;
  }
}
