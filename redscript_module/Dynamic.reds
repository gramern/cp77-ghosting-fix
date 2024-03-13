// Thanks to djkovrik for redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

//FrameGen Ghosting 'Fix' 2.1 for FSR3 FG Mods, 2024 gramern (scz_g) 2024

@addField(DriveEvents) public let m_carCameraContext: vehicleCameraPerspective;
@addField(DriveEvents) public let m_bikeCameraContext: vehicleCameraPerspective;
@addField(DriveEvents) public let m_vehicleCurrentType: gamedataVehicleType;
@addField(DriveEvents) public let m_vehicleCurrentSpeed: Float;
@addField(DriveEvents) public let m_vehicleCurrentSpeedCallback: ref<CallbackHandle>;


//Setting masks when changing cameras in a car---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPCarEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPCarEvent>) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo1") as inkWidget;
  let dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo2") as inkWidget;
  let dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo3") as inkWidget;
  let dumbo4: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4") as inkWidget;
  let dumbo5: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5") as inkWidget;
  let dynamic_dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo1") as inkWidget;
  let dynamic_dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo2") as inkWidget;
  let dynamic_dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo3") as inkWidget;

  if dumbo1.GetOpacity() != 0.0299999993 {
    dumbo1.SetOpacity(0.0299999993);
  }
  if dumbo2.GetOpacity() != 0.0500000007 {
    dumbo2.SetOpacity(0.0500000007);
  }
  if dumbo3.GetOpacity() != 0.0299999993 {
    dumbo3.SetOpacity(0.0299999993);
  }
  if dumbo4.GetOpacity() != 0.0299999993 {
    dumbo4.SetOpacity(0.0299999993);
  }
  if dumbo5.GetOpacity() != 0.0299999993 {
    dumbo5.SetOpacity(0.0299999993);
  }
  if dynamic_dumbo1.GetOpacity() != 0.0299999993 {
    dynamic_dumbo1.SetOpacity(0.0299999993);
  }
  if dynamic_dumbo2.GetOpacity() != 0.00100000005 {
    dynamic_dumbo2.SetOpacity(0.00100000005);
  }
  if dynamic_dumbo3.GetOpacity() != 0.00100000005 {
    dynamic_dumbo3.SetOpacity(0.00100000005);
  }

  let dumbo1Size = dumbo1.GetSize();
  if dumbo1Size.Y != 950.0 {
    dumbo1.SetSize(dumbo1Size.X, 950.0);
    dumbo1.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.X != 3600.0 {
    dumbo2.SetSize(3600.0, dumbo2Size.Y);
    dumbo2.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.Y != 850.0 {
    dumbo2.SetSize(dumbo2Size.X, 850.0);
    dumbo2.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
  if dumbo3Size.X != 2000.0 {
    dumbo3.SetSize(2000.0, dumbo3Size.Y);
    dumbo3.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
    if dumbo3Size.Y != 900.0 {
    dumbo3.SetSize(dumbo3Size.X, 900.0);
    dumbo3.Reparent(root);
  }
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPCarFasterEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPCarFasterEvent>) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo1") as inkWidget;
  let dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo2") as inkWidget;
  let dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo3") as inkWidget;
  let dumbo4: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4") as inkWidget;
  let dumbo5: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5") as inkWidget;
  let dynamic_dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo1") as inkWidget;
  let dynamic_dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo2") as inkWidget;
  let dynamic_dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo3") as inkWidget;

  if dumbo1.GetOpacity() != 0.0250000004 {
    dumbo1.SetOpacity(0.0250000004);
  }
  if dumbo2.GetOpacity() != 0.0299999993 {
    dumbo2.SetOpacity(0.0299999993);
  }
  if dumbo3.GetOpacity() != 0.0250000004 {
    dumbo3.SetOpacity(0.0250000004);
  }
  if dumbo4.GetOpacity() != 0.0250000004 {
    dumbo4.SetOpacity(0.0250000004);
  }
  if dumbo5.GetOpacity() != 0.0250000004 {
    dumbo5.SetOpacity(0.0250000004);
  }
  if dynamic_dumbo1.GetOpacity() != 0.0199999996 {
    dynamic_dumbo1.SetOpacity(0.0199999996);
  }
  if dynamic_dumbo2.GetOpacity() != 0.00100000005 {
    dynamic_dumbo2.SetOpacity(0.00100000005);
  }
  if dynamic_dumbo3.GetOpacity() != 0.00100000005 {
    dynamic_dumbo3.SetOpacity(0.00100000005);
  }

  let dumbo1Size = dumbo1.GetSize();
  if dumbo1Size.Y != 950.0 {
    dumbo1.SetSize(dumbo1Size.X, 950.0);
    dumbo1.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.X != 3600.0 {
    dumbo2.SetSize(3600.0, dumbo2Size.Y);
    dumbo2.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.Y != 850.0 {
    dumbo2.SetSize(dumbo2Size.X, 850.0);
    dumbo2.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
  if dumbo3Size.X != 2000.0 {
    dumbo3.SetSize(2000.0, dumbo3Size.Y);
    dumbo3.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
    if dumbo3Size.Y != 900.0 {
    dumbo3.SetSize(dumbo3Size.X, 900.0);
    dumbo3.Reparent(root);
  }
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPCarSlowEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPCarSlowEvent>) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo1") as inkWidget;
  let dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo2") as inkWidget;
  let dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo3") as inkWidget;
  let dumbo4: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4") as inkWidget;
  let dumbo5: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5") as inkWidget;
  let dynamic_dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo1") as inkWidget;
  let dynamic_dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo2") as inkWidget;
  let dynamic_dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo3") as inkWidget;

  if dumbo1.GetOpacity() != 0.0199999996 {
    dumbo1.SetOpacity(0.0199999996);
  }
  if dumbo2.GetOpacity() != 0.0199999996 {
    dumbo2.SetOpacity(0.0199999996);
  }
  if dumbo3.GetOpacity() != 0.0199999996{
    dumbo3.SetOpacity(0.0199999996);
  }
  if dumbo4.GetOpacity() != 0.0199999996 {
    dumbo4.SetOpacity(0.0199999996);
  }
  if dumbo5.GetOpacity() != 0.0199999996 {
    dumbo5.SetOpacity(0.0199999996);
  }
  if dynamic_dumbo1.GetOpacity() != 0.00999999978{
    dynamic_dumbo1.SetOpacity(0.00999999978);
  }
  if dynamic_dumbo2.GetOpacity() != 0.00100000005 {
    dynamic_dumbo2.SetOpacity(0.00100000005);
  }
  if dynamic_dumbo3.GetOpacity() != 0.00100000005 {
    dynamic_dumbo3.SetOpacity(0.00100000005);
  }

  let dumbo1Size = dumbo1.GetSize();
  if dumbo1Size.Y != 950.0 {
    dumbo1.SetSize(dumbo1Size.X, 950.0);
    dumbo1.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.X != 3400.0 {
    dumbo2.SetSize(3400.0, dumbo2Size.Y);
    dumbo2.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.Y != 700.0 {
    dumbo2.SetSize(dumbo2Size.X, 700.0);
    dumbo2.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
  if dumbo3Size.X != 1800.0 {
    dumbo3.SetSize(1800.0, dumbo3Size.Y);
    dumbo3.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
    if dumbo3Size.Y != 800.0 {
    dumbo3.SetSize(dumbo3Size.X, 800.0);
    dumbo3.Reparent(root);
  }
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPCarCrawlEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPCarCrawlEvent>) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo1") as inkWidget;
  let dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo2") as inkWidget;
  let dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo3") as inkWidget;
  let dumbo4: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4") as inkWidget;
  let dumbo5: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5") as inkWidget;
  let dynamic_dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo1") as inkWidget;
  let dynamic_dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo2") as inkWidget;
  let dynamic_dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo3") as inkWidget;

  if dumbo1.GetOpacity() != 0.00999999978 {
    dumbo1.SetOpacity(0.00999999978);
  }
  if dumbo2.GetOpacity() != 0.00999999978 {
    dumbo2.SetOpacity(0.00999999978);
  }
  if dumbo3.GetOpacity() != 0.00999999978{
    dumbo3.SetOpacity(0.00999999978);
  }
  if dumbo4.GetOpacity() != 0.00999999978 {
    dumbo4.SetOpacity(0.00999999978);
  }
  if dumbo5.GetOpacity() != 0.00999999978 {
    dumbo5.SetOpacity(0.00999999978);
  }
  if dynamic_dumbo1.GetOpacity() != 0.00999999978 {
    dynamic_dumbo1.SetOpacity(0.00999999978);
  }
  if dynamic_dumbo2.GetOpacity() != 0.00100000005 {
    dynamic_dumbo2.SetOpacity(0.00100000005);
  }
  if dynamic_dumbo3.GetOpacity() != 0.00100000005 {
    dynamic_dumbo3.SetOpacity(0.00100000005);
  }

  let dumbo1Size = dumbo1.GetSize();
  if dumbo1Size.Y != 950.0 {
    dumbo1.SetSize(dumbo1Size.X, 950.0);
    dumbo1.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.X != 3400.0 {
    dumbo2.SetSize(3400.0, dumbo2Size.Y);
    dumbo2.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.Y != 700.0 {
    dumbo2.SetSize(dumbo2Size.X, 700.0);
    dumbo2.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
  if dumbo3Size.X != 1800.0 {
    dumbo3.SetSize(1800.0, dumbo3Size.Y);
    dumbo3.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
    if dumbo3Size.Y != 800.0 {
    dumbo3.SetSize(dumbo3Size.X, 800.0);
    dumbo3.Reparent(root);
  }
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPFarCarEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPFarCarEvent>) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo1") as inkWidget;
  let dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo2") as inkWidget;
  let dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo3") as inkWidget;
  let dumbo4: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4") as inkWidget;
  let dumbo5: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5") as inkWidget;
  let dynamic_dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo1") as inkWidget;
  let dynamic_dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo2") as inkWidget;
  let dynamic_dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo3") as inkWidget;

  if dumbo1.GetOpacity() != 0.00100000005 {
    dumbo1.SetOpacity(0.00100000005);
  }
  if dumbo2.GetOpacity() != 0.0299999993 {
    dumbo2.SetOpacity(0.0299999993);
  }
  if dumbo3.GetOpacity() != 0.0299999993 {
    dumbo3.SetOpacity(0.0299999993);
  }
  if dumbo4.GetOpacity() != 0.0299999993 {
    dumbo4.SetOpacity(0.0299999993);
  }
  if dumbo5.GetOpacity() != 0.0299999993 {
    dumbo5.SetOpacity(0.0299999993);
  }
  if dynamic_dumbo1.GetOpacity() != 0.0299999993 {
    dynamic_dumbo1.SetOpacity(0.0299999993);
  }
  if dynamic_dumbo2.GetOpacity() != 0.00100000005 {
    dynamic_dumbo2.SetOpacity(0.00100000005);
  }
  if dynamic_dumbo3.GetOpacity() != 0.00100000005 {
    dynamic_dumbo3.SetOpacity(0.00100000005);
  }

  let dumbo1Size = dumbo1.GetSize();
  if dumbo1Size.Y != 800.0 {
    dumbo1.SetSize(dumbo1Size.X, 800.0);
    dumbo1.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.X != 2000.0 {
    dumbo2.SetSize(2000.0, dumbo2Size.Y);
    dumbo2.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.Y != 1150.0 {
    dumbo2.SetSize(dumbo2Size.X, 1150.0);
    dumbo2.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
  if dumbo3Size.X != 1800.0 {
    dumbo3.SetSize(1800.0, dumbo3Size.Y);
    dumbo3.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
    if dumbo3Size.Y != 700.0 {
    dumbo3.SetSize(dumbo3Size.X, 700.0);
    dumbo3.Reparent(root);
  }
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPFarCarSlowEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPFarCarSlowEvent>) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo1") as inkWidget;
  let dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo2") as inkWidget;
  let dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo3") as inkWidget;
  let dumbo4: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4") as inkWidget;
  let dumbo5: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5") as inkWidget;
  let dynamic_dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo1") as inkWidget;
  let dynamic_dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo2") as inkWidget;
  let dynamic_dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo3") as inkWidget;

  if dumbo1.GetOpacity() != 0.00100000005 {
   dumbo1.SetOpacity(0.00100000005);
  }
  if dumbo2.GetOpacity() != 0.0199999996 {
  dumbo2.SetOpacity(0.0199999996);
  }
  if dumbo3.GetOpacity() != 0.0199999996 {
  dumbo3.SetOpacity(0.0199999996);
  }
  if dumbo4.GetOpacity() != 0.0299999993 {
  dumbo4.SetOpacity(0.0299999993);
  }
  if dumbo5.GetOpacity() != 0.0299999993 {
  dumbo5.SetOpacity(0.0299999993);
  }
  if dynamic_dumbo1.GetOpacity() != 0.0299999993 {
  dynamic_dumbo1.SetOpacity(0.0299999993);
  }
  if dynamic_dumbo2.GetOpacity() != 0.00100000005 {
  dynamic_dumbo2.SetOpacity(0.00100000005);
  }
  if dynamic_dumbo3.GetOpacity() != 0.00100000005 {
  dynamic_dumbo3.SetOpacity(0.00100000005);
  }

  let dumbo1Size = dumbo1.GetSize();
  if dumbo1Size.Y != 950.0 {
    dumbo1.SetSize(dumbo1Size.X, 950.0);
    dumbo1.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.X != 2600.0 {
    dumbo2.SetSize(2600.0, dumbo2Size.Y);
    dumbo2.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.Y != 800.0 {
    dumbo2.SetSize(dumbo2Size.X, 800.0);
    dumbo2.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
  if dumbo3Size.X != 1800.0 {
    dumbo3.SetSize(1800.0, dumbo3Size.Y);
    dumbo3.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
    if dumbo3Size.Y != 800.0 {
    dumbo3.SetSize(dumbo3Size.X, 800.0);
    dumbo3.Reparent(root);
  }
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPFarCarCrawlEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPFarCarCrawlEvent>) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo1") as inkWidget;
  let dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo2") as inkWidget;
  let dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo3") as inkWidget;
  let dumbo4: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4") as inkWidget;
  let dumbo5: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5") as inkWidget;
  let dynamic_dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo1") as inkWidget;
  let dynamic_dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo2") as inkWidget;
  let dynamic_dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo3") as inkWidget;

  if dumbo1.GetOpacity() != 0.00100000005 {
   dumbo1.SetOpacity(0.00100000005);
  }
  if dumbo2.GetOpacity() != 0.00999999978 {
  dumbo2.SetOpacity(0.00999999978);
  }
  if dumbo3.GetOpacity() != 0.0199999996 {
  dumbo3.SetOpacity(0.0199999996);
  }
  if dumbo4.GetOpacity() != 0.00999999978 {
  dumbo4.SetOpacity(0.00999999978);
  }
  if dumbo5.GetOpacity() != 0.00999999978 {
  dumbo5.SetOpacity(0.00999999978);
  }
  if dynamic_dumbo1.GetOpacity() != 0.00999999978 {
  dynamic_dumbo1.SetOpacity(0.00999999978);
  }
  if dynamic_dumbo2.GetOpacity() != 0.00100000005 {
  dynamic_dumbo2.SetOpacity(0.00100000005);
  }
  if dynamic_dumbo3.GetOpacity() != 0.00100000005 {
  dynamic_dumbo3.SetOpacity(0.00100000005);
  }

  let dumbo1Size = dumbo1.GetSize();
  if dumbo1Size.Y != 950.0 {
    dumbo1.SetSize(dumbo1Size.X, 950.0);
    dumbo1.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.X != 2600.0 {
    dumbo2.SetSize(2600.0, dumbo2Size.Y);
    dumbo2.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.Y != 800.0 {
    dumbo2.SetSize(dumbo2Size.X, 800.0);
    dumbo2.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
  if dumbo3Size.X != 1800.0 {
    dumbo3.SetSize(1800.0, dumbo3Size.Y);
    dumbo3.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
    if dumbo3Size.Y != 800.0 {
    dumbo3.SetSize(dumbo3Size.X, 800.0);
    dumbo3.Reparent(root);
  }
}

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

  if dumbo1.GetOpacity() != 0.00100000005 {
    dumbo1.SetOpacity(0.00100000005);
  }
  if dumbo2.GetOpacity() != 0.00100000005 {
    dumbo2.SetOpacity(0.00100000005);
  }
  if dumbo3.GetOpacity() != 0.00100000005 {
    dumbo3.SetOpacity(0.00100000005);
  }
  if dumbo4.GetOpacity() != 0.0299999993 {
    dumbo4.SetOpacity(0.0299999993);
  }
  if dumbo5.GetOpacity() != 0.0299999993 {
    dumbo5.SetOpacity(0.0299999993);
  }
  if dynamic_dumbo1.GetOpacity() != 0.00100000005 {
    dynamic_dumbo1.SetOpacity(0.00100000005);
  }
  if dynamic_dumbo2.GetOpacity() != fppCarSideMirrorOpacity {
    dynamic_dumbo2.SetOpacity(fppCarSideMirrorOpacity);
  }
  if dynamic_dumbo3.GetOpacity() != 0.00100000005 {
    dynamic_dumbo3.SetOpacity(0.00100000005);
  }

  let dynamic_dumbo2Size = dynamic_dumbo2.GetSize();
  if dynamic_dumbo2Size.X != 2100.0 && dynamic_dumbo2Size.Y != 1800.0 {
    dynamic_dumbo2.SetSize(fppCarSideMirrorSize);
    dynamic_dumbo2.Reparent(root);
  }
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixFPPCarSideMirrorToggleEvent(evt: ref<FrameGenGhostingFixFPPCarSideMirrorToggleEvent>) -> Void {

  this.OnFrameGenGhostingFixDumboCameraFPPCarEvent(0.00100000005, 2100.0, 1800.0);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraFPPCarSlowEvent(evt: ref<FrameGenGhostingFixDumboCameraFPPCarSlowEvent>) -> Bool {

  let fppCarSideMirrorSize: Vector2 = new Vector2(2100.0, 1800.0);

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo1") as inkWidget;
  let dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo2") as inkWidget;
  let dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo3") as inkWidget;
  let dumbo4: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4") as inkWidget;
  let dumbo5: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5") as inkWidget;
  let dynamic_dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo1") as inkWidget;
  let dynamic_dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo2") as inkWidget;
  let dynamic_dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo3") as inkWidget;

  if dumbo1.GetOpacity() != 0.00100000005 {
    dumbo1.SetOpacity(0.00100000005);
  }
  if dumbo2.GetOpacity() != 0.00100000005 {
    dumbo2.SetOpacity(0.00100000005);
  }
  if dumbo3.GetOpacity() != 0.00100000005 {
    dumbo3.SetOpacity(0.00100000005);
  }
  if dumbo4.GetOpacity() != 0.0299999993 {
    dumbo4.SetOpacity(0.0299999993);
  }
  if dumbo5.GetOpacity() != 0.0299999993 {
    dumbo5.SetOpacity(0.0299999993);
  }
  if dynamic_dumbo1.GetOpacity() != 0.00100000005 {
    dynamic_dumbo1.SetOpacity(0.00100000005);
  }
  if dynamic_dumbo2.GetOpacity() != 0.00100000005 {
    dynamic_dumbo2.SetOpacity(0.00100000005);
  }
  if dynamic_dumbo3.GetOpacity() != 0.00100000005 {
    dynamic_dumbo3.SetOpacity(0.00100000005);
  }

  let dynamic_dumbo2Size = dynamic_dumbo2.GetSize();
  if dynamic_dumbo2Size.X != 2100.0 && dynamic_dumbo2Size.Y != 1800.0 {
    dynamic_dumbo2.SetSize(fppCarSideMirrorSize);
    dynamic_dumbo2.Reparent(root);
  }
}

//Setting masks when changing cameras on a bike---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPBikeEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPBikeEvent>) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo1") as inkWidget;
  let dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo2") as inkWidget;
  let dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo3") as inkWidget;
  let dumbo4: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4") as inkWidget;
  let dumbo5: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5") as inkWidget;
  let dynamic_dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo1") as inkWidget;
  let dynamic_dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo2") as inkWidget;
  let dynamic_dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo3") as inkWidget;

  if dumbo1.GetOpacity() != 0.0299999993 {
    dumbo1.SetOpacity(0.0299999993);
  }
  if dumbo2.GetOpacity() != 0.0399999991 {
    dumbo2.SetOpacity(0.0399999991);
  }
  if dumbo3.GetOpacity() != 0.0299999993{
    dumbo3.SetOpacity(0.0299999993);
  }
  if dumbo4.GetOpacity() != 0.0299999993 {
    dumbo4.SetOpacity(0.0299999993);
  }
  if dumbo5.GetOpacity() != 0.0299999993 {
    dumbo5.SetOpacity(0.0299999993);
  }
  if dynamic_dumbo1.GetOpacity() != 0.0299999993 {
    dynamic_dumbo1.SetOpacity(0.0299999993);
  }
  if dynamic_dumbo2.GetOpacity() != 0.00100000005 {
    dynamic_dumbo2.SetOpacity(0.00100000005);
  }
  if dynamic_dumbo3.GetOpacity() != 0.00100000005 {
    dynamic_dumbo3.SetOpacity(0.00100000005);
  }

  let dumbo1Size = dumbo1.GetSize();
  if dumbo1Size.Y != 950.0 {
    dumbo1.SetSize(dumbo1Size.X, 950.0);
    dumbo1.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.X != 3200.0 {
    dumbo2.SetSize(3200.0, dumbo2Size.Y);
    dumbo2.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.Y != 1050.0 {
    dumbo2.SetSize(dumbo2Size.X, 1050.0);
    dumbo2.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
  if dumbo3Size.X != 1400.0 {
    dumbo3.SetSize(1400.0, dumbo3Size.Y);
    dumbo3.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
    if dumbo3Size.Y != 1400.0 {
    dumbo3.SetSize(dumbo3Size.X, 1400.0);
    dumbo3.Reparent(root);
  }
}

//Setting masks when changing cameras on a bike---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPBikeFasterEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPBikeFasterEvent>) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo1") as inkWidget;
  let dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo2") as inkWidget;
  let dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo3") as inkWidget;
  let dumbo4: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4") as inkWidget;
  let dumbo5: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5") as inkWidget;
  let dynamic_dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo1") as inkWidget;
  let dynamic_dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo2") as inkWidget;
  let dynamic_dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo3") as inkWidget;

  if dumbo1.GetOpacity() != 0.0250000004 {
    dumbo1.SetOpacity(0.0250000004);
  }
  if dumbo2.GetOpacity() != 0.0250000004 {
    dumbo2.SetOpacity(0.0250000004);
  }
  if dumbo3.GetOpacity() != 0.0250000004{
    dumbo3.SetOpacity(0.0250000004);
  }
  if dumbo4.GetOpacity() != 0.0250000004 {
    dumbo4.SetOpacity(0.0250000004);
  }
  if dumbo5.GetOpacity() != 0.0250000004 {
    dumbo5.SetOpacity(0.0250000004);
  }
  if dynamic_dumbo1.GetOpacity() != 0.0199999996 {
    dynamic_dumbo1.SetOpacity(0.0199999996);
  }
  if dynamic_dumbo2.GetOpacity() != 0.00100000005 {
    dynamic_dumbo2.SetOpacity(0.00100000005);
  }
  if dynamic_dumbo3.GetOpacity() != 0.00100000005 {
    dynamic_dumbo3.SetOpacity(0.00100000005);
  }

  let dumbo1Size = dumbo1.GetSize();
  if dumbo1Size.Y != 950.0 {
    dumbo1.SetSize(dumbo1Size.X, 950.0);
    dumbo1.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.X != 3200.0 {
    dumbo2.SetSize(3200.0, dumbo2Size.Y);
    dumbo2.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.Y != 1050.0 {
    dumbo2.SetSize(dumbo2Size.X, 1050.0);
    dumbo2.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
  if dumbo3Size.X != 1400.0 {
    dumbo3.SetSize(1400.0, dumbo3Size.Y);
    dumbo3.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
    if dumbo3Size.Y != 1400.0 {
    dumbo3.SetSize(dumbo3Size.X, 1400.0);
    dumbo3.Reparent(root);
  }
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPBikeSlowEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPBikeSlowEvent>) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo1") as inkWidget;
  let dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo2") as inkWidget;
  let dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo3") as inkWidget;
  let dumbo4: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4") as inkWidget;
  let dumbo5: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5") as inkWidget;
  let dynamic_dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo1") as inkWidget;
  let dynamic_dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo2") as inkWidget;
  let dynamic_dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo3") as inkWidget;

  if dumbo1.GetOpacity() != 0.0199999996 {
    dumbo1.SetOpacity(0.0199999996);
  }
  if dumbo2.GetOpacity() != 0.0199999996 {
    dumbo2.SetOpacity(0.0199999996);
  }
  if dumbo3.GetOpacity() != 0.0199999996{
    dumbo3.SetOpacity(0.0199999996);
  }
  if dumbo4.GetOpacity() != 0.0199999996 {
    dumbo4.SetOpacity(0.0199999996);
  }
  if dumbo5.GetOpacity() != 0.0199999996 {
    dumbo5.SetOpacity(0.0199999996);
  }
  if dynamic_dumbo1.GetOpacity() != 0.00999999978 {
    dynamic_dumbo1.SetOpacity(0.00999999978);
  }
  if dynamic_dumbo2.GetOpacity() != 0.00100000005 {
    dynamic_dumbo2.SetOpacity(0.00100000005);
  }
  if dynamic_dumbo3.GetOpacity() != 0.00100000005 {
    dynamic_dumbo3.SetOpacity(0.00100000005);
  }

  let dumbo1Size = dumbo1.GetSize();
  if dumbo1Size.Y != 950.0 {
    dumbo1.SetSize(dumbo1Size.X, 950.0);
    dumbo1.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.X != 2400.0 {
    dumbo2.SetSize(2400.0, dumbo2Size.Y);
    dumbo2.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.Y != 700.0 {
    dumbo2.SetSize(dumbo2Size.X, 700.0);
    dumbo2.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
  if dumbo3Size.X != 1800.0 {
    dumbo3.SetSize(1800.0, dumbo3Size.Y);
    dumbo3.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
    if dumbo3Size.Y != 800.0 {
    dumbo3.SetSize(dumbo3Size.X, 800.0);
    dumbo3.Reparent(root);
  }
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPBikeCrawlEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPBikeCrawlEvent>) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo1") as inkWidget;
  let dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo2") as inkWidget;
  let dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo3") as inkWidget;
  let dumbo4: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4") as inkWidget;
  let dumbo5: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5") as inkWidget;
  let dynamic_dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo1") as inkWidget;
  let dynamic_dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo2") as inkWidget;
  let dynamic_dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo3") as inkWidget;

  if dumbo1.GetOpacity() != 0.00999999978 {
    dumbo1.SetOpacity(0.00999999978);
  }
  if dumbo2.GetOpacity() != 0.00999999978 {
    dumbo2.SetOpacity(0.00999999978);
  }
  if dumbo3.GetOpacity() != 0.00999999978{
    dumbo3.SetOpacity(0.00999999978);
  }
  if dumbo4.GetOpacity() != 0.00999999978 {
    dumbo4.SetOpacity(0.00999999978);
  }
  if dumbo5.GetOpacity() != 0.00999999978 {
    dumbo5.SetOpacity(0.00999999978);
  }
  if dynamic_dumbo1.GetOpacity() != 0.00999999978 {
    dynamic_dumbo1.SetOpacity(0.00999999978);
  }
  if dynamic_dumbo2.GetOpacity() != 0.00100000005 {
    dynamic_dumbo2.SetOpacity(0.00100000005);
  }
  if dynamic_dumbo3.GetOpacity() != 0.00100000005 {
    dynamic_dumbo3.SetOpacity(0.00100000005);
  }

  let dumbo1Size = dumbo1.GetSize();
  if dumbo1Size.Y != 950.0 {
    dumbo1.SetSize(dumbo1Size.X, 950.0);
    dumbo1.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.X != 2400.0 {
    dumbo2.SetSize(2400.0, dumbo2Size.Y);
    dumbo2.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.Y != 700.0 {
    dumbo2.SetSize(dumbo2Size.X, 700.0);
    dumbo2.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
  if dumbo3Size.X != 1800.0 {
    dumbo3.SetSize(1800.0, dumbo3Size.Y);
    dumbo3.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
    if dumbo3Size.Y != 800.0 {
    dumbo3.SetSize(dumbo3Size.X, 800.0);
    dumbo3.Reparent(root);
  }
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPFarBikeEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPFarBikeEvent>) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo1") as inkWidget;
  let dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo2") as inkWidget;
  let dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo3") as inkWidget;
  let dumbo4: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4") as inkWidget;
  let dumbo5: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5") as inkWidget;
  let dynamic_dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo1") as inkWidget;
  let dynamic_dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo2") as inkWidget;
  let dynamic_dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo3") as inkWidget;

  if dumbo1.GetOpacity() != 0.00100000005 {
    dumbo1.SetOpacity(0.00100000005);
  }
  if dumbo2.GetOpacity() != 0.0299999993 {
    dumbo2.SetOpacity(0.0299999993);
  }
  if dumbo3.GetOpacity() != 0.0299999993 {
    dumbo3.SetOpacity(0.0299999993);
  }
  if dumbo4.GetOpacity() != 0.0299999993 {
    dumbo4.SetOpacity(0.0299999993);
  }
  if dumbo5.GetOpacity() != 0.0299999993 {
    dumbo5.SetOpacity(0.0299999993);
  }
  if dynamic_dumbo1.GetOpacity() != 0.0299999993 {
    dynamic_dumbo1.SetOpacity(0.0299999993);
  }
  if dynamic_dumbo2.GetOpacity() != 0.00100000005 {
    dynamic_dumbo2.SetOpacity(0.00100000005);
  }
  if dynamic_dumbo3.GetOpacity() != 0.00100000005 {
    dynamic_dumbo3.SetOpacity(0.00100000005);
  }

  let dumbo1Size = dumbo1.GetSize();
  if dumbo1Size.Y != 800.0 {
    dumbo1.SetSize(dumbo1Size.X, 800.0);
    dumbo1.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.X != 2000.0 {
    dumbo2.SetSize(2000.0, dumbo2Size.Y);
    dumbo2.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.Y != 1050.0 {
    dumbo2.SetSize(dumbo2Size.X, 1050.0);
    dumbo2.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
  if dumbo3Size.X != 1800.0 {
    dumbo3.SetSize(1800.0, dumbo3Size.Y);
    dumbo3.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
    if dumbo3Size.Y != 800.0 {
    dumbo3.SetSize(dumbo3Size.X, 800.0);
    dumbo3.Reparent(root);
  }
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPFarBikeSlowEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPFarBikeSlowEvent>) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo1") as inkWidget;
  let dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo2") as inkWidget;
  let dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo3") as inkWidget;
  let dumbo4: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4") as inkWidget;
  let dumbo5: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5") as inkWidget;
  let dynamic_dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo1") as inkWidget;
  let dynamic_dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo2") as inkWidget;
  let dynamic_dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo3") as inkWidget;

  if dumbo1.GetOpacity() != 0.00100000005 {
    dumbo1.SetOpacity(0.00100000005);
  }
  if dumbo2.GetOpacity() != 0.0199999996 {
    dumbo2.SetOpacity(0.0199999996);
  }
  if dumbo3.GetOpacity() != 0.0199999996 {
    dumbo3.SetOpacity(0.0199999996);
  }
  if dumbo4.GetOpacity() != 0.0199999996 {
    dumbo4.SetOpacity(0.0199999996);
  }
  if dumbo5.GetOpacity() != 0.0199999996 {
    dumbo5.SetOpacity(0.0199999996);
  }
  if dynamic_dumbo1.GetOpacity() != 0.0199999996 {
    dynamic_dumbo1.SetOpacity(0.0199999996);
  }
  if dynamic_dumbo2.GetOpacity() != 0.00100000005 {
    dynamic_dumbo2.SetOpacity(0.00100000005);
  }
  if dynamic_dumbo3.GetOpacity() != 0.00100000005 {
    dynamic_dumbo3.SetOpacity(0.00100000005);
  }

  let dumbo1Size = dumbo1.GetSize();
  if dumbo1Size.Y != 950.0 {
    dumbo1.SetSize(dumbo1Size.X, 950.0);
    dumbo1.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.X != 2000.0 {
    dumbo2.SetSize(2000.0, dumbo2Size.Y);
    dumbo2.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.Y != 700.0 {
    dumbo2.SetSize(dumbo2Size.X, 700.0);
    dumbo2.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
  if dumbo3Size.X != 1800.0 {
    dumbo3.SetSize(1800.0, dumbo3Size.Y);
    dumbo3.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
    if dumbo3Size.Y != 800.0 {
    dumbo3.SetSize(dumbo3Size.X, 800.0);
    dumbo3.Reparent(root);
  }
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraTPPFarBikeCrawlEvent(evt: ref<FrameGenGhostingFixDumboCameraTPPFarBikeCrawlEvent>) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo1") as inkWidget;
  let dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo2") as inkWidget;
  let dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo3") as inkWidget;
  let dumbo4: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4") as inkWidget;
  let dumbo5: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5") as inkWidget;
  let dynamic_dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo1") as inkWidget;
  let dynamic_dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo2") as inkWidget;
  let dynamic_dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo3") as inkWidget;

  if dumbo1.GetOpacity() != 0.00100000005 {
    dumbo1.SetOpacity(0.00100000005);
  }
  if dumbo2.GetOpacity() != 0.00999999978 {
    dumbo2.SetOpacity(0.00999999978);
  }
  if dumbo3.GetOpacity() != 0.00999999978 {
    dumbo3.SetOpacity(0.00999999978);
  }
  if dumbo4.GetOpacity() != 0.00999999978 {
    dumbo4.SetOpacity(0.00999999978);
  }
  if dumbo5.GetOpacity() != 0.00999999978 {
    dumbo5.SetOpacity(0.00999999978);
  }
  if dynamic_dumbo1.GetOpacity() != 0.00999999978 {
    dynamic_dumbo1.SetOpacity(0.00999999978);
  }
  if dynamic_dumbo2.GetOpacity() != 0.00100000005 {
    dynamic_dumbo2.SetOpacity(0.00100000005);
  }
  if dynamic_dumbo3.GetOpacity() != 0.00100000005 {
    dynamic_dumbo3.SetOpacity(0.00100000005);
  }

  let dumbo1Size = dumbo1.GetSize();
  if dumbo1Size.Y != 950.0 {
    dumbo1.SetSize(dumbo1Size.X, 950.0);
    dumbo1.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.X != 2000.0 {
    dumbo2.SetSize(2000.0, dumbo2Size.Y);
    dumbo2.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.Y != 700.0 {
    dumbo2.SetSize(dumbo2Size.X, 700.0);
    dumbo2.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
  if dumbo3Size.X != 1800.0 {
    dumbo3.SetSize(1800.0, dumbo3Size.Y);
    dumbo3.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
    if dumbo3Size.Y != 800.0 {
    dumbo3.SetSize(dumbo3Size.X, 800.0);
    dumbo3.Reparent(root);
  }
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraFPPBikeEvent(fppBikeELGDumbo1SizeY: Float, fppBikeELGDumbo3SizeX: Float, fppBikeELGDumbo3SizeY: Float, fppBikeELGDumbo1Opacity: Float, fppBikeELGDumbo2Opacity: Float, fppBikeELGDumbo3Opacity: Float) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo1") as inkWidget;
  let dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo2") as inkWidget;
  let dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo3") as inkWidget;
  let dumbo4: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4") as inkWidget;
  let dumbo5: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5") as inkWidget;
  let dynamic_dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo1") as inkWidget;
  let dynamic_dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo2") as inkWidget;
  let dynamic_dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo3") as inkWidget;

  if dumbo1.GetOpacity() != fppBikeELGDumbo1Opacity {
    dumbo1.SetOpacity(fppBikeELGDumbo1Opacity);
  }
  if dumbo2.GetOpacity() != fppBikeELGDumbo2Opacity {
    dumbo2.SetOpacity(fppBikeELGDumbo2Opacity);
  }
  if dumbo3.GetOpacity() != fppBikeELGDumbo3Opacity {
    dumbo3.SetOpacity(fppBikeELGDumbo3Opacity);
  }
  if dumbo4.GetOpacity() != 0.0299999993 {
    dumbo4.SetOpacity(0.0299999993);
  }
  if dumbo5.GetOpacity() != 0.0299999993 {
    dumbo5.SetOpacity(0.0299999993);
  }
  if dynamic_dumbo1.GetOpacity() != 0.00100000005 {
    dynamic_dumbo1.SetOpacity(0.00100000005);
  }
  if dynamic_dumbo2.GetOpacity() != 0.00100000005 {
    dynamic_dumbo2.SetOpacity(0.00100000005);
  }
  if dynamic_dumbo3.GetOpacity() != 0.00100000005{
    dynamic_dumbo3.SetOpacity(0.00100000005);
  }

  let dumbo1Size = dumbo1.GetSize();
  if dumbo1Size.Y != fppBikeELGDumbo1SizeY {
    dumbo1.SetSize(dumbo1Size.X, fppBikeELGDumbo1SizeY);
    dumbo1.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.X != 3000.0 {
    dumbo2.SetSize(3000.0, dumbo2Size.Y);
    dumbo2.Reparent(root);
  }
  let dumbo2Size = dumbo2.GetSize();
  if dumbo2Size.Y != 1000.0 {
    dumbo2.SetSize(dumbo2Size.X, 1000.0);
    dumbo2.Reparent(root);
  }
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
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixFPPBikeELGSettingsAmplifyEvent(evt: ref<FrameGenGhostingFixFPPBikeELGSettingsAmplifyEvent>) -> Void {

  this.OnFrameGenGhostingFixDumboCameraFPPBikeEvent(950.0, 1800.0, 800.0, 0.0399999991, 0.0299999993, 0.00100000005);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixFPPBikeELGSettingsEvent(evt: ref<FrameGenGhostingFixFPPBikeELGSettingsEvent>) -> Void {

  this.OnFrameGenGhostingFixDumboCameraFPPBikeEvent(950.0, 1800.0, 800.0, 0.0299999993, 0.0299999993, 0.00100000005);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraFPPBikeSlowEvent(evt: ref<FrameGenGhostingFixDumboCameraFPPBikeSlowEvent>) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo1") as inkWidget;
  let dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo2") as inkWidget;
  let dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo3") as inkWidget;
  let dumbo4: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4") as inkWidget;
  let dumbo5: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5") as inkWidget;
  let dynamic_dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo1") as inkWidget;
  let dynamic_dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo2") as inkWidget;
  let dynamic_dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo3") as inkWidget;

  if dumbo1.GetOpacity() != 0.0199999996 {
    dumbo1.SetOpacity(0.0199999996);
  }
  if dumbo2.GetOpacity() != 0.0199999996 {
    dumbo2.SetOpacity(0.0199999996);
  }
  if dumbo3.GetOpacity() != 0.00100000005 {
    dumbo3.SetOpacity(0.00100000005);
  }
  if dumbo4.GetOpacity() != 0.0199999996 {
    dumbo4.SetOpacity(0.0199999996);
  }
  if dumbo5.GetOpacity() != 0.0199999996 {
    dumbo5.SetOpacity(0.0199999996);
  }
  if dynamic_dumbo1.GetOpacity() != 0.0199999996 {
    dynamic_dumbo1.SetOpacity(0.0199999996);
  }
  if dynamic_dumbo2.GetOpacity() != 0.00100000005 {
    dynamic_dumbo2.SetOpacity(0.00100000005);
  }
  if dynamic_dumbo3.GetOpacity() != 0.00100000005{
    dynamic_dumbo3.SetOpacity(0.00100000005);
  }

  let dumbo1Size = dumbo1.GetSize();
  if dumbo1Size.Y != 950.0 {
    dumbo1.SetSize(dumbo1Size.X, 950.0);
    dumbo1.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
  if dumbo3Size.X != 1800.0 {
    dumbo3.SetSize(1800.0, dumbo3Size.Y);
    dumbo3.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
    if dumbo3Size.Y != 800.0 {
    dumbo3.SetSize(dumbo3Size.X, 800.0);
    dumbo3.Reparent(root);
  }
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboCameraFPPBikeCrawlEvent(evt: ref<FrameGenGhostingFixDumboCameraFPPBikeCrawlEvent>) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo1") as inkWidget;
  let dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo2") as inkWidget;
  let dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo3") as inkWidget;
  let dumbo4: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4") as inkWidget;
  let dumbo5: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5") as inkWidget;
  let dynamic_dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo1") as inkWidget;
  let dynamic_dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo2") as inkWidget;
  let dynamic_dumbo3: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo3") as inkWidget;

  if dumbo1.GetOpacity() != 0.00999999978 {
    dumbo1.SetOpacity(0.00999999978);
  }
  if dumbo2.GetOpacity() != 0.00999999978 {
    dumbo2.SetOpacity(0.00999999978);
  }
  if dumbo3.GetOpacity() != 0.00100000005 {
    dumbo3.SetOpacity(0.00100000005);
  }
  if dumbo4.GetOpacity() != 0.00999999978 {
    dumbo4.SetOpacity(0.00999999978);
  }
  if dumbo5.GetOpacity() != 0.00999999978 {
    dumbo5.SetOpacity(0.00999999978);
  }
  if dynamic_dumbo1.GetOpacity() != 0.00999999978 {
    dynamic_dumbo1.SetOpacity(0.00999999978);
  }
  if dynamic_dumbo2.GetOpacity() != 0.00100000005 {
    dynamic_dumbo2.SetOpacity(0.00100000005);
  }
  if dynamic_dumbo3.GetOpacity() != 0.00100000005{
    dynamic_dumbo3.SetOpacity(0.00100000005);
  }

  let dumbo1Size = dumbo1.GetSize();
  if dumbo1Size.Y != 950.0 {
    dumbo1.SetSize(dumbo1Size.X, 950.0);
    dumbo1.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
  if dumbo3Size.X != 1800.0 {
    dumbo3.SetSize(1800.0, dumbo3Size.Y);
    dumbo3.Reparent(root);
  }
  let dumbo3Size = dumbo3.GetSize();
    if dumbo3Size.Y != 800.0 {
    dumbo3.SetSize(dumbo3Size.X, 800.0);
    dumbo3.Reparent(root);
  }
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

  dumbo1.SetOpacity(0.00100000005);
  dumbo2.SetOpacity(0.00100000005);
  dumbo3.SetOpacity(0.00100000005);
  dumbo4.SetOpacity(0.00100000005);
  dumbo5.SetOpacity(0.00100000005);
  dynamic_dumbo2.SetOpacity(0.00100000005);
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixDumboDeActivationVehicleToggleEvent(evt: ref<FrameGenGhostingFixDumboDeActivationVehicleToggleEvent>)  -> Void {
    this.OnFrameGenGhostingFixDumboDeActivationVehicleSetupEvent(0.5);
}

//Setting masks for vehicles when a weapon is drawn
@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixWeaponCarEvent(evt: ref<FrameGenGhostingFixWeaponCarEvent>) -> Bool {

	let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
	let dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo1") as inkWidget;
  let dumbo2: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo2") as inkWidget;
	let dynamic_dumbo1: ref<inkWidget> = root.GetWidgetByPathName(n"dynamic_dumbo1") as inkWidget;

	if Equals(this.m_hasWeaponDrawn,true) {
		if dumbo1.GetOpacity() != 0.0299999993 {
			dumbo1.SetOpacity(0.0299999993);
		}
		if dumbo2.GetOpacity() != 0.0299999993 {
			dumbo2.SetOpacity(0.0299999993);
		}
		if dynamic_dumbo1.GetOpacity() != 0.0399999991 {
			dynamic_dumbo1.SetOpacity(0.0399999991);
		}
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

  this.OnFrameGenGhostingFixFPPBikeELGEditor(950.0, 1800.0, 800.0, 0.00100000005, 0.00100000005);
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

  let cameraTPPSlowEvent: ref<FrameGenGhostingFixDumboCameraTPPCarCrawlEvent>;
  let cameraTPPFarSlowEvent: ref<FrameGenGhostingFixDumboCameraTPPFarCarCrawlEvent>;
  let cameraFPPSlowEvent: ref<FrameGenGhostingFixDumboCameraFPPCarSlowEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPSlowEvent = new FrameGenGhostingFixDumboCameraFPPCarSlowEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPSlowEvent);
      // LogChannel(n"DEBUG", "Car camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.TPPClose:
      cameraTPPSlowEvent = new FrameGenGhostingFixDumboCameraTPPCarCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPSlowEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.TPPMedium:
      cameraTPPSlowEvent = new FrameGenGhostingFixDumboCameraTPPCarCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPSlowEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPMedium mode.");
    break;
    case vehicleCameraPerspective.TPPFar:
      cameraTPPFarSlowEvent = new FrameGenGhostingFixDumboCameraTPPFarCarCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFarSlowEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPFar mode.");
    break;
    default:
      break;
  }
}

@addMethod(DriveEvents)
public final func CarCameraChangeSlow(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraTPPSlowEvent: ref<FrameGenGhostingFixDumboCameraTPPCarSlowEvent>;
  let cameraTPPFarSlowEvent: ref<FrameGenGhostingFixDumboCameraTPPFarCarSlowEvent>;
  let cameraFPPSlowEvent: ref<FrameGenGhostingFixDumboCameraFPPCarSlowEvent>;

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

  let cameraTPPEvent: ref<FrameGenGhostingFixDumboCameraTPPCarFasterEvent>;
  let cameraTPPFarEvent: ref<FrameGenGhostingFixDumboCameraTPPFarCarEvent>;
  let cameraFPPEvent: ref<FrameGenGhostingFixFPPCarSideMirrorToggleEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPEvent = new FrameGenGhostingFixFPPCarSideMirrorToggleEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPEvent);
      // LogChannel(n"DEBUG", "Car camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.TPPClose:
      cameraTPPEvent = new FrameGenGhostingFixDumboCameraTPPCarFasterEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.TPPMedium:
      cameraTPPEvent = new FrameGenGhostingFixDumboCameraTPPCarFasterEvent();
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

@addMethod(DriveEvents)
public final func CarCameraChange(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraTPPEvent: ref<FrameGenGhostingFixDumboCameraTPPCarEvent>;
  let cameraTPPFarEvent: ref<FrameGenGhostingFixDumboCameraTPPFarCarEvent>;
  let cameraFPPEvent: ref<FrameGenGhostingFixFPPCarSideMirrorToggleEvent>;

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

  let cameraTPPBikeSlowEvent: ref<FrameGenGhostingFixDumboCameraTPPBikeCrawlEvent>;
  let cameraTPPFarBikeSlowEvent: ref<FrameGenGhostingFixDumboCameraTPPFarBikeCrawlEvent>;
  let cameraFPPBikeSlowEvent: ref<FrameGenGhostingFixDumboCameraFPPBikeCrawlEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPBikeSlowEvent = new FrameGenGhostingFixDumboCameraFPPBikeCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPBikeSlowEvent);
      // LogChannel(n"DEBUG", "Bike camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.TPPClose:
      cameraTPPBikeSlowEvent = new FrameGenGhostingFixDumboCameraTPPBikeCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeSlowEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.TPPMedium:
      cameraTPPBikeSlowEvent = new FrameGenGhostingFixDumboCameraTPPBikeCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeSlowEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPMedium mode.");
    break;
    case vehicleCameraPerspective.TPPFar:
      cameraTPPFarBikeSlowEvent = new FrameGenGhostingFixDumboCameraTPPFarBikeCrawlEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPFarBikeSlowEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPFar mode.");
    break;
    default:
      break;
  }
}

@addMethod(DriveEvents)
public final func BikeCameraChangeSlow(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraTPPBikeSlowEvent: ref<FrameGenGhostingFixDumboCameraTPPBikeSlowEvent>;
  let cameraTPPFarBikeSlowEvent: ref<FrameGenGhostingFixDumboCameraTPPFarBikeSlowEvent>;
  let cameraFPPBikeSlowEvent: ref<FrameGenGhostingFixDumboCameraFPPBikeSlowEvent>;

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

  let cameraTPPBikeEvent: ref<FrameGenGhostingFixDumboCameraTPPBikeFasterEvent>;
  let cameraTPPFarBikeEvent: ref<FrameGenGhostingFixDumboCameraTPPFarBikeEvent>;
  let cameraFPPBikeEvent: ref<FrameGenGhostingFixFPPBikeELGSettingsEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPBikeEvent = new FrameGenGhostingFixFPPBikeELGSettingsEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPBikeEvent);
      // LogChannel(n"DEBUG", "Bike camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.TPPClose:
      cameraTPPBikeEvent = new FrameGenGhostingFixDumboCameraTPPBikeFasterEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.TPPMedium:
      cameraTPPBikeEvent = new FrameGenGhostingFixDumboCameraTPPBikeFasterEvent();
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

@addMethod(DriveEvents)
public final func BikeCameraChange(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraTPPBikeEvent: ref<FrameGenGhostingFixDumboCameraTPPBikeEvent>;
  let cameraTPPFarBikeEvent: ref<FrameGenGhostingFixDumboCameraTPPFarBikeEvent>;
  let cameraFPPBikeEvent: ref<FrameGenGhostingFixFPPBikeELGSettingsAmplifyEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPBikeEvent = new FrameGenGhostingFixFPPBikeELGSettingsAmplifyEvent();
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
