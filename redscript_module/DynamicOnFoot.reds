//Thanks to djkovrik and psiberx for help and redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

//FrameGen Ghosting 'Fix' 4.1.4xl, 2024 gramern (scz_g) 2024

@addField(gameuiCrosshairContainerController) public let m_masksOnFootEnabled: Bool = false;
@addField(gameuiCrosshairContainerController) public let m_vignetteOnFootEnabled: Bool = false;
@addField(gameuiCrosshairContainerController) public let m_vignetteAimOnFootEnabled: Bool = false;
@addField(gameuiCrosshairContainerController) public let m_blockerAimOnFootEnabled: Bool = false;

@addField(gameuiCrosshairContainerController) public let m_isWeaponDrawn: Bool;

@addField(gameuiCrosshairContainerController) public let m_isMaskingOnFootActivated: Bool = false;
@addField(gameuiCrosshairContainerController) public let m_masksOnFootActivated: Bool = false;
@addField(gameuiCrosshairContainerController) public let m_vignetteOnFootActivated: Bool = false;
@addField(gameuiCrosshairContainerController) public let m_vignetteAimOnFootActivated: Bool = false;
@addField(gameuiCrosshairContainerController) public let m_blockerAimOnFootActivated: Bool = false;

@addField(gameuiCrosshairContainerController) public let m_masksOnFootChangeOpacityBy: Float;
@addField(gameuiCrosshairContainerController) public let m_masksOnFootCurrentOpacity: Float;
@addField(gameuiCrosshairContainerController) public let m_masksOnFootFinalOpacity: Float;
@addField(gameuiCrosshairContainerController) public let m_vignetteOnFootChangeOpacityBy: Float;
@addField(gameuiCrosshairContainerController) public let m_vignetteOnFootCurrentOpacity: Float;
@addField(gameuiCrosshairContainerController) public let m_vignetteOnFootFinalOpacity: Float;
@addField(gameuiCrosshairContainerController) public let m_vignetteAimOnFootChangeOpacityBy: Float;
@addField(gameuiCrosshairContainerController) public let m_vignetteAimOnFootCurrentOpacity: Float;
@addField(gameuiCrosshairContainerController) public let m_vignetteAimOnFootFinalOpacity: Float;
@addField(gameuiCrosshairContainerController) public let m_blockerAimOnFootChangeOpacityBy: Float;
@addField(gameuiCrosshairContainerController) public let m_blockerAimOnFootCurrentOpacity: Float;
@addField(gameuiCrosshairContainerController) public let m_blockerAimOnFootFinalOpacity: Float;

@addField(gameuiCrosshairContainerController) public let m_vignetteOnFootMarginLeft: Float;
@addField(gameuiCrosshairContainerController) public let m_vignetteOnFootMarginTop: Float;
@addField(gameuiCrosshairContainerController) public let m_vignetteOnFootSizeX: Float;
@addField(gameuiCrosshairContainerController) public let m_vignetteOnFootSizeY: Float;
@addField(gameuiCrosshairContainerController) public let m_aimOnFootSizeX: Float;
@addField(gameuiCrosshairContainerController) public let m_aimOnFootSizeY: Float;
@addField(gameuiCrosshairContainerController) public let m_aimOnFootDimensionsSet: Bool = false;

@addField(gameuiCrosshairContainerController) public let m_vignetteOnFootEditor: Bool = false;

//Corner masks transition functions---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixMasksOnFootSetTransition() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let cornerDownLeftOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"fgfix/cornerDownLeftOnFoot") as inkWidget;
  let cornerDownRightOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"fgfix/cornerDownRightOnFoot") as inkWidget;

  this.m_masksOnFootCurrentOpacity = this.m_masksOnFootCurrentOpacity + this.m_masksOnFootChangeOpacityBy;
  cornerDownLeftOnFoot.SetOpacity(this.m_masksOnFootCurrentOpacity);
  cornerDownRightOnFoot.SetOpacity(this.m_masksOnFootCurrentOpacity);

//   LogChannel(n"DEBUG", s"this.m_masksOnFootCurrentOpacity = \(this.m_masksOnFootCurrentOpacity)");
//   LogChannel(n"DEBUG", s"cornerDownLeftOnFoot.GetOpacity() = \(cornerDownLeftOnFoot.GetOpacity())");
//   LogChannel(n"DEBUG", s"cornerDownRightOnFoot.GetOpacity() = \(cornerDownRightOnFoot.GetOpacity())");
}

@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixMasksOnFootSetMargins(cornerDownLeftMargin: Float, cornerDownRightMargin: Float, cornerDownMarginTop: Float) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let cornerDownLeftOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"fgfix/cornerDownLeftOnFoot") as inkWidget;
  let cornerDownRightOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"fgfix/cornerDownRightOnFoot") as inkWidget;

  let cornerDownLeftOnFootMargin = cornerDownLeftOnFoot.GetMargin();
  cornerDownLeftOnFoot.SetMargin(cornerDownLeftMargin, cornerDownMarginTop, cornerDownLeftOnFootMargin.right, cornerDownLeftOnFootMargin.bottom);

  let cornerDownRightOnFootMargin = cornerDownRightOnFoot.GetMargin();
  cornerDownRightOnFoot.SetMargin(cornerDownRightMargin, cornerDownMarginTop, cornerDownRightOnFootMargin.right, cornerDownRightOnFootMargin.bottom);

  // LogChannel(n"DEBUG", s"Margins for corner masks set: \(cornerDownLeftMargin), \(cornerDownRightMargin), \(cornerDownMarginTop)");
}

@addMethod(gameuiCrosshairContainerController)
private cb func FrameGenGhostingFixMasksOnFootSetMarginsToggleEvent() -> Void {

  this.FrameGenGhostingFixMasksOnFootSetMargins(0.0, 3840.0, 2160.0);
}

//Vignette dimensions transition functions---------------------------------------------------------------------------------------
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
}

@addMethod(gameuiCrosshairContainerController)
private cb func FrameGenGhostingFixVignetteOnFootSetDimensionsToggleEvent() -> Void {

  this.FrameGenGhostingFixVignetteOnFootSetDimensionsToggle(1920.0, 1080.0, 4840.0, 2560.0);
}

//Vignette opacity transition functions---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixVignetteOnFootSetTransition() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let vignetteOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"fgfix/vignetteOnFoot") as inkWidget;

  this.m_vignetteOnFootCurrentOpacity = this.m_vignetteOnFootCurrentOpacity + this.m_vignetteOnFootChangeOpacityBy;
  vignetteOnFoot.SetOpacity(this.m_vignetteOnFootCurrentOpacity);

//   LogChannel(n"DEBUG", s"this.m_vignetteOnFootCurrentOpacity = \(this.m_vignetteOnFootCurrentOpacity)");
//   LogChannel(n"DEBUG", s"vignetteOnFoot.GetOpacity() = \(vignetteOnFoot.GetOpacity())");
}

//Aiming on foot dimension transition functions---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixAimOnFootSetDimensions() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let blockerAimOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"fgfix/blockerAimOnFoot") as inkWidget;
  let vignetteAimOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"fgfix/vignetteAimOnFoot") as inkWidget;

  blockerAimOnFoot.SetSize(this.m_aimOnFootSizeX, this.m_aimOnFootSizeY);
  blockerAimOnFoot.Reparent(root);
  vignetteAimOnFoot.SetSize(this.m_aimOnFootSizeX, this.m_aimOnFootSizeY);
  vignetteAimOnFoot.Reparent(root);

//   LogChannel(n"DEBUG", s"this.m_aimOnFootSizeX, this.m_aimOnFootSizeY = \(this.m_aimOnFootSizeX) \(this.m_aimOnFootSizeY)");
//   LogChannel(n"DEBUG", s"vignetteOnFoot.GetOpacity() = \(vignetteAimOnFoot.GetSize())");
}

@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixAimOnFootSetDimensionsToggle(aimOnFootSizeX: Float, aimOnFootSizeY: Float) -> Bool {

  this.m_aimOnFootSizeX = aimOnFootSizeX;
  this.m_aimOnFootSizeY = aimOnFootSizeY;
}

@addMethod(gameuiCrosshairContainerController)
private cb func FrameGenGhostingFixAimOnFootSetDimensionsToggleEvent() -> Void {

  this.FrameGenGhostingFixAimOnFootSetDimensionsToggle(3840.0, 2440.0);
}

//Aiming on foot transitions functions---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixVignetteAimOnFootSetTransition() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let vignetteAimOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"fgfix/vignetteAimOnFoot") as inkWidget;

  this.m_vignetteAimOnFootCurrentOpacity = this.m_vignetteAimOnFootCurrentOpacity + this.m_vignetteAimOnFootChangeOpacityBy;
  vignetteAimOnFoot.SetOpacity(this.m_vignetteAimOnFootCurrentOpacity);

//   LogChannel(n"DEBUG", s"this.m_vignetteAimOnFootCurrentOpacity = \(this.m_vignetteAimOnFootCurrentOpacity)");
//   LogChannel(n"DEBUG", s"vignetteAimOnFoot.GetOpacity() = \(vignetteAimOnFoot.GetOpacity())");
}

@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixBlockerAimOnFootSetTransition() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let blockerAimOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"fgfix/blockerAimOnFoot") as inkWidget;

  this.m_blockerAimOnFootCurrentOpacity = this.m_blockerAimOnFootCurrentOpacity + this.m_blockerAimOnFootChangeOpacityBy;
  blockerAimOnFoot.SetOpacity(this.m_blockerAimOnFootCurrentOpacity);

  // LogChannel(n"DEBUG", s"this.m_blockerAimOnFootCurrentOpacity = \(this.m_blockerAimOnFootCurrentOpacity)");
  // LogChannel(n"DEBUG", s"blockerAimOnFoot.GetOpacity() = \(blockerAimOnFoot.GetOpacity())");
}


//Vignette editor context---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixVignetteOnFootEditor() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let vignetteOnFoot_editor: ref<inkWidget> = root.GetWidgetByPathName(n"fgfix/vignetteOnFoot_editor") as inkWidget;

  vignetteOnFoot_editor.SetOpacity(0.5);

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

@addMethod(gameuiCrosshairContainerController)
private cb func FrameGenGhostingFixVignetteOnFootEditorToggle() -> Void {
  this.FrameGenGhostingFixVignetteOnFootEditorContext(false);
}

//Activate masks on foot---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected final func FrameGenGhostingFixOnFootToggleEvent() -> Void {
  this.FrameGenGhostingFixOnFootToggle(false);
}

@addMethod(gameuiCrosshairContainerController)
protected final func FrameGenGhostingFixOnFootToggle(masksOnFoot: Bool) -> Void {
  this.m_masksOnFootEnabled = masksOnFoot;
}

//Activate main vignette---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected final func FrameGenGhostingFixVignetteOnFootToggleEvent() -> Void {
  this.FrameGenGhostingFixVignetteOnFootToggle(false);
}

@addMethod(gameuiCrosshairContainerController)
protected final func FrameGenGhostingFixVignetteOnFootToggle(vignetteOnFoot: Bool) -> Void {
  this.m_vignetteOnFootEnabled = vignetteOnFoot;
}

//Turn off deactivation of main vignette---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected final func FrameGenGhostingFixVignetteOnFootDeActivationToggleEvent() -> Void {
  this.FrameGenGhostingFixVignetteOnFootDeActivationToggle(false);
}

@addMethod(gameuiCrosshairContainerController)
protected final func FrameGenGhostingFixVignetteOnFootDeActivationToggle(vignetteOnFootActivation: Bool) -> Void {
  this.m_vignetteOnFootActivated = vignetteOnFootActivation;
}

//Activate vignette for aiming---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected final func FrameGenGhostingFixVignetteAimOnFootToggleEvent() -> Void {
  this.FrameGenGhostingFixVignetteAimOnFootToggle(false);
}

@addMethod(gameuiCrosshairContainerController)
protected final func FrameGenGhostingFixVignetteAimOnFootToggle(vignetteAimOnFoot: Bool) -> Void {
  this.m_vignetteAimOnFootEnabled = vignetteAimOnFoot;
}

//Activate blocker for aiming---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected final func FrameGenGhostingFixBlockerAimOnFootToggleEvent() -> Void {
  this.FrameGenGhostingFixBlockerAimOnFootToggle(false);
}

@addMethod(gameuiCrosshairContainerController)
protected final func FrameGenGhostingFixBlockerAimOnFootToggle(blockerAimOnFoot: Bool) -> Void {
  this.m_blockerAimOnFootEnabled = blockerAimOnFoot;
}


@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixOnFootActivationEvent() -> Bool {
  
  this.FrameGenGhostingFixOnFootToggleEvent();
  this.FrameGenGhostingFixVignetteOnFootToggleEvent();

  if Equals(this.m_masksOnFootEnabled,true) {
    this.m_masksOnFootActivated = true;
    this.m_masksOnFootCurrentOpacity = 0.0;
    this.m_masksOnFootFinalOpacity = 0.044;
    this.m_masksOnFootChangeOpacityBy = 0.009;
  }

  if Equals(this.m_vignetteOnFootEnabled,true) {
    this.FrameGenGhostingFixVignetteOnFootSetDimensionsToggleEvent();
    this.m_vignetteOnFootActivated = true;
    this.m_vignetteOnFootCurrentOpacity = 0.0;
    this.m_vignetteOnFootFinalOpacity = 0.018;
    this.m_vignetteOnFootChangeOpacityBy = 0.005;
  }
}

@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixOnFootDeActivationEvent() -> Bool {

  if Equals(this.m_masksOnFootActivated,true) {
    this.m_masksOnFootCurrentOpacity = 0.045;
    this.m_masksOnFootFinalOpacity = 0.0;
    this.m_masksOnFootChangeOpacityBy = -0.009;
  }

  if Equals(this.m_vignetteOnFootEnabled,true) {
    this.m_vignetteOnFootCurrentOpacity = 0.02;
    this.m_vignetteOnFootFinalOpacity = 0.0;
    this.m_vignetteOnFootChangeOpacityBy = -0.005;
  }

  this.m_masksOnFootActivated = false;
  this.FrameGenGhostingFixVignetteOnFootDeActivationToggleEvent();
}

//Vignette aiming
@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixVignetteAimOnFootActivationEvent() -> Bool {

  if Equals(this.m_vignetteAimOnFootEnabled,true) {
    this.m_vignetteAimOnFootActivated = true;
    this.m_vignetteAimOnFootCurrentOpacity = 0.0;
    this.m_vignetteAimOnFootFinalOpacity = 0.018;
    this.m_vignetteAimOnFootChangeOpacityBy = 0.004;
  }
}

@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixVignetteAimOnFootDeActivationEvent() -> Bool {

  if Equals(this.m_vignetteAimOnFootEnabled,true) {
    this.m_vignetteAimOnFootCurrentOpacity = 0.02;
    this.m_vignetteAimOnFootFinalOpacity = 0.001;
    this.m_vignetteAimOnFootChangeOpacityBy = -0.004;
  }

  this.m_vignetteAimOnFootActivated = false;
}

//Blocker aiming
@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixBlockerAimOnFootActivationEvent() -> Bool {

  if Equals(this.m_blockerAimOnFootEnabled,true) {
    this.m_blockerAimOnFootActivated = true;
    this.m_blockerAimOnFootCurrentOpacity = 0.0;
    this.m_blockerAimOnFootFinalOpacity = 0.014;
    this.m_blockerAimOnFootChangeOpacityBy = 0.004;
  }
}

@addMethod(gameuiCrosshairContainerController)
protected cb func FrameGenGhostingFixBlockerAimOnFootDeActivationEvent() -> Bool {
  
  if Equals(this.m_blockerAimOnFootEnabled,true) {
    this.m_blockerAimOnFootCurrentOpacity = 0.016;
    this.m_blockerAimOnFootFinalOpacity = 0.001;
    this.m_blockerAimOnFootChangeOpacityBy = -0.004;
  }

  this.m_blockerAimOnFootActivated = false;
}

//Weapon checks---------------------------------------------------------------------------------------
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
