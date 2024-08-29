// Thanks to djkovrik and psiberx for help and redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. JackHumbert for the Let There Be Flight mod I took bike parts names from. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

// FrameGen Ghosting 'Fix' 5.1.10, 2024 gramern (scz_g), 2024 danyalzia (omniscient)

@addField(gameuiCrosshairContainerController) public let m_cornersOnFootEnabled: Bool = false;
@addField(gameuiCrosshairContainerController) public let m_blockerAimOnFootEnabled: Bool = false;
@addField(gameuiCrosshairContainerController) public let m_vignetteAimOnFootEnabled: Bool = false;
@addField(gameuiCrosshairContainerController) public let m_vignetteOnFootEnabled: Bool = false;
@addField(gameuiCrosshairContainerController) public let m_vignetteOnFootPermamentEnabled: Bool = false;

@addField(gameuiCrosshairContainerController) public let m_isWeaponDrawn: Bool;

// @addField(gameuiCrosshairContainerController) public let m_isMaskingOnFootActivated: Bool = false;
@addField(gameuiCrosshairContainerController) public let m_cornersOnFootActivated: Bool = false;
@addField(gameuiCrosshairContainerController) public let m_blockerAimOnFootActivated: Bool = false;
@addField(gameuiCrosshairContainerController) public let m_vignetteAimOnFootActivated: Bool = false;
@addField(gameuiCrosshairContainerController) public let m_vignetteOnFootActivated: Bool = false;

@addField(gameuiCrosshairContainerController) public let m_onFootMaxOpacity: Float = 0.02;
@addField(gameuiCrosshairContainerController) public let m_onFootChangeOpacityBy: Float = 0.005;
@addField(gameuiCrosshairContainerController) public let m_cornersOnFootChangeOpacityBy: Float;
@addField(gameuiCrosshairContainerController) public let m_cornersOnFootCurrentOpacity: Float;
@addField(gameuiCrosshairContainerController) public let m_cornersOnFootFinalOpacity: Float;
@addField(gameuiCrosshairContainerController) public let m_blockerAimOnFootChangeOpacityBy: Float;
@addField(gameuiCrosshairContainerController) public let m_blockerAimOnFootCurrentOpacity: Float;
@addField(gameuiCrosshairContainerController) public let m_blockerAimOnFootFinalOpacity: Float;
@addField(gameuiCrosshairContainerController) public let m_vignetteAimOnFootChangeOpacityBy: Float;
@addField(gameuiCrosshairContainerController) public let m_vignetteAimOnFootCurrentOpacity: Float;
@addField(gameuiCrosshairContainerController) public let m_vignetteAimOnFootFinalOpacity: Float;
@addField(gameuiCrosshairContainerController) public let m_vignetteOnFootChangeOpacityBy: Float;
@addField(gameuiCrosshairContainerController) public let m_vignetteOnFootCurrentOpacity: Float;
@addField(gameuiCrosshairContainerController) public let m_vignetteOnFootFinalOpacity: Float;

@addField(gameuiCrosshairContainerController) public let m_cornerDownLeftMargin: Float;
@addField(gameuiCrosshairContainerController) public let m_cornerDownRightMargin: Float;
@addField(gameuiCrosshairContainerController) public let m_cornerDownMarginTop: Float;
@addField(gameuiCrosshairContainerController) public let m_aimOnFootSizeX: Float;
@addField(gameuiCrosshairContainerController) public let m_aimOnFootSizeY: Float;
@addField(gameuiCrosshairContainerController) public let m_vignetteOnFootMarginLeft: Float;
@addField(gameuiCrosshairContainerController) public let m_vignetteOnFootMarginTop: Float;
@addField(gameuiCrosshairContainerController) public let m_vignetteOnFootSizeX: Float;
@addField(gameuiCrosshairContainerController) public let m_vignetteOnFootSizeY: Float;

@addField(gameuiCrosshairContainerController) public let m_vignetteOnFootEditor: Bool = false;

// Corner masks transition functions ---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixCornersOnFootSetTransition() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let cornerDownLeftOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"fgfix/cornerDownLeftOnFoot") as inkWidget;
  let cornerDownRightOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"fgfix/cornerDownRightOnFoot") as inkWidget;

  this.m_cornersOnFootCurrentOpacity = this.m_cornersOnFootCurrentOpacity + this.m_cornersOnFootChangeOpacityBy;
  cornerDownLeftOnFoot.SetOpacity(this.m_cornersOnFootCurrentOpacity);
  cornerDownRightOnFoot.SetOpacity(this.m_cornersOnFootCurrentOpacity);

  // LogChannel(n"DEBUG", s"this.m_cornersOnFootCurrentOpacity = \(this.m_cornersOnFootCurrentOpacity)");
  // LogChannel(n"DEBUG", s"cornerDownLeftOnFoot.GetOpacity() = \(cornerDownLeftOnFoot.GetOpacity())");
  // LogChannel(n"DEBUG", s"cornerDownRightOnFoot.GetOpacity() = \(cornerDownRightOnFoot.GetOpacity())");
}

@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixMasksOnFootSetMargins() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let cornerDownLeftOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"fgfix/cornerDownLeftOnFoot") as inkWidget;
  let cornerDownRightOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"fgfix/cornerDownRightOnFoot") as inkWidget;

  let cornerDownLeftOnFootMargin = cornerDownLeftOnFoot.GetMargin();
  cornerDownLeftOnFoot.SetMargin(this.m_cornerDownLeftMargin, this.m_cornerDownMarginTop, cornerDownLeftOnFootMargin.right, cornerDownLeftOnFootMargin.bottom);

  let cornerDownRightOnFootMargin = cornerDownRightOnFoot.GetMargin();
  cornerDownRightOnFoot.SetMargin(this.m_cornerDownRightMargin, this.m_cornerDownMarginTop, cornerDownRightOnFootMargin.right, cornerDownRightOnFootMargin.bottom);
}

@addMethod(gameuiCrosshairContainerController)
private cb func FrameGenGhostingFixMasksOnFootSetMarginsToggle(cornerDownLeftMargin: Float, cornerDownRightMargin: Float, cornerDownMarginTop: Float) -> Void {
  
  this.m_cornerDownLeftMargin = cornerDownLeftMargin;
  this.m_cornerDownRightMargin = cornerDownRightMargin;
  this.m_cornerDownMarginTop = cornerDownMarginTop;
  this.FrameGenGhostingFixMasksOnFootSetMargins();
}

// Aiming on foot dimension transition functions ---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixAimOnFootSetDimensions() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let blockerAimOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"fgfix/blockerAimOnFoot") as inkWidget;
  let vignetteAimOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"fgfix/vignetteAimOnFoot") as inkWidget;

  blockerAimOnFoot.SetSize(this.m_aimOnFootSizeX, this.m_aimOnFootSizeY);
  blockerAimOnFoot.Reparent(root);
  vignetteAimOnFoot.SetSize(this.m_aimOnFootSizeX, this.m_aimOnFootSizeY);
  vignetteAimOnFoot.Reparent(root);

  // LogChannel(n"DEBUG", s"vignetteOnFoot.GetOpacity() = \(vignetteAimOnFoot.GetSize())");
}

@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixAimOnFootSetDimensionsToggle(aimOnFootSizeX: Float, aimOnFootSizeY: Float) -> Bool {

  this.m_aimOnFootSizeX = aimOnFootSizeX;
  this.m_aimOnFootSizeY = aimOnFootSizeY;
  this.FrameGenGhostingFixAimOnFootSetDimensions();
}

// Aiming on foot transitions functions ---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixVignetteAimOnFootSetTransition() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let vignetteAimOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"fgfix/vignetteAimOnFoot") as inkWidget;

  this.m_vignetteAimOnFootCurrentOpacity = this.m_vignetteAimOnFootCurrentOpacity + this.m_vignetteAimOnFootChangeOpacityBy;
  vignetteAimOnFoot.SetOpacity(this.m_vignetteAimOnFootCurrentOpacity);

  // LogChannel(n"DEBUG", s"this.m_vignetteAimOnFootCurrentOpacity = \(this.m_vignetteAimOnFootCurrentOpacity)");
  // LogChannel(n"DEBUG", s"vignetteAimOnFoot.GetOpacity() = \(vignetteAimOnFoot.GetOpacity())");
}

@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixBlockerAimOnFootSetTransition() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let blockerAimOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"fgfix/blockerAimOnFoot") as inkWidget;

  this.m_blockerAimOnFootCurrentOpacity = this.m_blockerAimOnFootCurrentOpacity + this.m_blockerAimOnFootChangeOpacityBy;
  blockerAimOnFoot.SetOpacity(this.m_blockerAimOnFootCurrentOpacity);

//   LogChannel(n"DEBUG", s"this.m_blockerAimOnFootCurrentOpacity = \(this.m_blockerAimOnFootCurrentOpacity)");
//   LogChannel(n"DEBUG", s"blockerAimOnFoot.GetOpacity() = \(blockerAimOnFoot.GetOpacity())");
}

// Vignette dimensions transition functions ---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixVignetteOnFootSetDimensions() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let vignetteOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"fgfix/vignetteOnFoot") as inkWidget;

  let vignetteOnFootMargin = vignetteOnFoot.GetMargin();
  vignetteOnFoot.SetMargin(this.m_vignetteOnFootMarginLeft, this.m_vignetteOnFootMarginTop, vignetteOnFootMargin.right, vignetteOnFootMargin.bottom);

  vignetteOnFoot.SetSize(this.m_vignetteOnFootSizeX, this.m_vignetteOnFootSizeY);
  vignetteOnFoot.Reparent(root);
}

@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixVignetteOnFootSetDimensionsToggle(vignetteOnFootMarginLeft: Float, vignetteOnFootMarginTop: Float, vignetteOnFootSizeX: Float, vignetteOnFootSizeY: Float) -> Bool {

  this.m_vignetteOnFootMarginLeft = vignetteOnFootMarginLeft;
  this.m_vignetteOnFootMarginTop = vignetteOnFootMarginTop;
  this.m_vignetteOnFootSizeX = vignetteOnFootSizeX;
  this.m_vignetteOnFootSizeY = vignetteOnFootSizeY;
  this.FrameGenGhostingFixVignetteOnFootSetDimensions();
}

// Vignette opacity transition functions ---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixVignetteOnFootSetTransition() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let vignetteOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"fgfix/vignetteOnFoot") as inkWidget;

  this.m_vignetteOnFootCurrentOpacity = this.m_vignetteOnFootCurrentOpacity + this.m_vignetteOnFootChangeOpacityBy;
  vignetteOnFoot.SetOpacity(this.m_vignetteOnFootCurrentOpacity);

  // LogChannel(n"DEBUG", s"this.m_vignetteOnFootCurrentOpacity = \(this.m_vignetteOnFootCurrentOpacity)");
  // LogChannel(n"DEBUG", s"vignetteOnFoot.GetOpacity() = \(vignetteOnFoot.GetOpacity())");
}

// Vignette editor context ---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixVignetteOnFootEditor() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let vignetteOnFoot_editor: ref<inkWidget> = root.GetWidgetByPathName(n"fgfix/vignetteOnFoot_editor") as inkWidget;

  let opacity = this.m_onFootMaxOpacity * 20.0;
  vignetteOnFoot_editor.SetOpacity(opacity);

  let vignetteOnFoot_editorMargin = vignetteOnFoot_editor.GetMargin();
  vignetteOnFoot_editor.SetMargin(this.m_vignetteOnFootMarginLeft, this.m_vignetteOnFootMarginTop, vignetteOnFoot_editorMargin.right, vignetteOnFoot_editorMargin.bottom);

  vignetteOnFoot_editor.SetSize(this.m_vignetteOnFootSizeX, this.m_vignetteOnFootSizeY);
  vignetteOnFoot_editor.Reparent(root);
}

@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixVignetteOnFootEditorTurnOff() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let vignetteOnFoot_editor: ref<inkWidget> = root.GetWidgetByPathName(n"fgfix/vignetteOnFoot_editor") as inkWidget;

  vignetteOnFoot_editor.SetOpacity(0.0);
}

@addMethod(gameuiCrosshairContainerController)
private cb func FrameGenGhostingFixVignetteOnFootEditorContext(vignetteOnFootEditor: Bool) -> Void {
  this.m_vignetteOnFootEditor = vignetteOnFootEditor;
}

// Toggle masks on foot opacity ---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected final func FrameGenGhostingFixOpacityOnFootToggle(maxOpacity: Float, changeStep: Float) -> Void {
  this.m_onFootMaxOpacity = maxOpacity;
  this.m_onFootChangeOpacityBy = changeStep;
}

// Activate corner masks on foot ---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected final func FrameGenGhostingFixCornersOnFootToggle(cornersOnFoot: Bool) -> Void {
  this.m_cornersOnFootEnabled = cornersOnFoot;
}

// Activate vignette for aiming ---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected final func FrameGenGhostingFixVignetteAimOnFootToggle(vignetteAimOnFoot: Bool) -> Void {
  this.m_vignetteAimOnFootEnabled = vignetteAimOnFoot;
}

// Activate blocker for aiming ---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected final func FrameGenGhostingFixBlockerAimOnFootToggle(blockerAimOnFoot: Bool) -> Void {
  this.m_blockerAimOnFootEnabled = blockerAimOnFoot;
}

// Activate main vignette ---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected final func FrameGenGhostingFixVignetteOnFootToggle(vignetteOnFoot: Bool) -> Void {
  this.m_vignetteOnFootEnabled = vignetteOnFoot;
}

// Turn off deactivation of main vignette without weapon---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected final func FrameGenGhostingFixVignetteOnFootPermamentToggle(vignetteOnFootPermament: Bool) -> Void {
  this.m_vignetteOnFootPermamentEnabled = vignetteOnFootPermament;
}

@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixCornersOnFootActivationEvent() -> Bool {

  if Equals(this.m_cornersOnFootEnabled, true) {
    this.m_cornersOnFootActivated = true;
    this.m_cornersOnFootCurrentOpacity = 0.0;
    this.m_cornersOnFootFinalOpacity = this.m_onFootMaxOpacity * 2.2;
    this.m_cornersOnFootChangeOpacityBy = this.m_onFootChangeOpacityBy * 2.0;
  }
}

@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixCornersOnFootDeActivationEvent() -> Bool {

  this.m_cornersOnFootCurrentOpacity = this.m_onFootMaxOpacity * 2.2;
  this.m_cornersOnFootFinalOpacity = 0.0;
  this.m_cornersOnFootChangeOpacityBy = this.m_onFootChangeOpacityBy * -2.0;
  this.m_cornersOnFootActivated = false;
}

// Blocker onAim
@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixBlockerAimOnFootActivationEvent() -> Bool {

  if Equals(this.m_blockerAimOnFootEnabled, true) {
    this.m_blockerAimOnFootActivated = true;
    this.m_blockerAimOnFootCurrentOpacity = 0.0;
    this.m_blockerAimOnFootFinalOpacity = this.m_onFootMaxOpacity;
    this.m_blockerAimOnFootChangeOpacityBy = this.m_onFootChangeOpacityBy;
  }
}

@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixBlockerAimOnFootDeActivationEvent() -> Bool {
  
  this.m_blockerAimOnFootCurrentOpacity = this.m_onFootMaxOpacity;
  this.m_blockerAimOnFootFinalOpacity = 0.0;
  this.m_blockerAimOnFootChangeOpacityBy = -this.m_onFootChangeOpacityBy;
  this.m_blockerAimOnFootActivated = false;
}

// Vignette onAim
@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixVignetteAimOnFootActivationEvent() -> Bool {

  if Equals(this.m_vignetteAimOnFootEnabled, true) {
    this.m_vignetteAimOnFootActivated = true;
    this.m_vignetteAimOnFootCurrentOpacity = 0.0;
    this.m_vignetteAimOnFootFinalOpacity = this.m_onFootMaxOpacity;
    this.m_vignetteAimOnFootChangeOpacityBy = this.m_onFootChangeOpacityBy;
  }
}

@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixVignetteAimOnFootDeActivationEvent() -> Bool {

  this.m_vignetteAimOnFootCurrentOpacity = this.m_onFootMaxOpacity;
  this.m_vignetteAimOnFootFinalOpacity = 0.0;
  this.m_vignetteAimOnFootChangeOpacityBy = -this.m_onFootChangeOpacityBy;
  this.m_vignetteAimOnFootActivated = false;
}

// Vignette onWeapon/permament
@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixVignetteOnFootActivationEvent() -> Bool {

  if Equals(this.m_vignetteOnFootEnabled, true) {
    this.m_vignetteOnFootActivated = true;
    this.m_vignetteOnFootCurrentOpacity = 0.0;
    this.m_vignetteOnFootFinalOpacity = this.m_onFootMaxOpacity;
    this.m_vignetteOnFootChangeOpacityBy = this.m_onFootChangeOpacityBy;
  }
}

@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixVignetteOnFootDeActivationEvent() -> Bool {

  this.m_vignetteOnFootCurrentOpacity = this.m_onFootMaxOpacity;
  this.m_vignetteOnFootFinalOpacity = 0.0;
  this.m_vignetteOnFootChangeOpacityBy = -this.m_onFootChangeOpacityBy;
  this.m_vignetteOnFootActivated = false;
}

// Weapon checks ---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected final func FrameGenGhostingFixHasWeapon() -> Void {
  let player: ref<GameObject> = this.GetPlayerControlledObject();
  let hasWeaponCheck = ScriptedPuppet.GetWeaponRight(player);
  if hasWeaponCheck != null {
    this.m_isWeaponDrawn = true;
    // LogChannel(n"DEBUG", "V has a weapon in their right hand!");
  } else {
    this.m_isWeaponDrawn = false;
  }
}