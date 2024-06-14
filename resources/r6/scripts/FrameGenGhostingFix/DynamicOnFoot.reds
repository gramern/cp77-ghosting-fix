//Thanks to djkovrik and psiberx for help and redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. JackHumbert for the Let There Be Flight mod I took bike parts names from. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

//FrameGen Ghosting 'Fix' 4.8.0, 2024 gramern (scz_g) 2024

@addField(IronsightGameController) public let m_masksOnFootEnabled: Bool = false;
@addField(IronsightGameController) public let m_vignetteOnFootEnabled: Bool = false;
@addField(IronsightGameController) public let m_vignetteAimOnFootEnabled: Bool = false;
@addField(IronsightGameController) public let m_blockerAimOnFootEnabled: Bool = false;

@addField(IronsightGameController) public let m_isWeaponDrawn: Bool;

@addField(IronsightGameController) public let m_isMaskingOnFootActivated: Bool = false;
@addField(IronsightGameController) public let m_masksOnFootActivated: Bool = false;
@addField(IronsightGameController) public let m_vignetteOnFootActivated: Bool = false;
@addField(IronsightGameController) public let m_vignetteAimOnFootActivated: Bool = false;
@addField(IronsightGameController) public let m_blockerAimOnFootActivated: Bool = false;

@addField(IronsightGameController) public let m_masksOnFootChangeOpacityBy: Float;
@addField(IronsightGameController) public let m_masksOnFootCurrentOpacity: Float;
@addField(IronsightGameController) public let m_masksOnFootFinalOpacity: Float;
@addField(IronsightGameController) public let m_vignetteOnFootChangeOpacityBy: Float;
@addField(IronsightGameController) public let m_vignetteOnFootCurrentOpacity: Float;
@addField(IronsightGameController) public let m_vignetteOnFootFinalOpacity: Float;
@addField(IronsightGameController) public let m_vignetteAimOnFootChangeOpacityBy: Float;
@addField(IronsightGameController) public let m_vignetteAimOnFootCurrentOpacity: Float;
@addField(IronsightGameController) public let m_vignetteAimOnFootFinalOpacity: Float;
@addField(IronsightGameController) public let m_blockerAimOnFootChangeOpacityBy: Float;
@addField(IronsightGameController) public let m_blockerAimOnFootCurrentOpacity: Float;
@addField(IronsightGameController) public let m_blockerAimOnFootFinalOpacity: Float;

@addField(IronsightGameController) public let m_vignetteOnFootMarginLeft: Float;
@addField(IronsightGameController) public let m_vignetteOnFootMarginTop: Float;
@addField(IronsightGameController) public let m_vignetteOnFootSizeX: Float;
@addField(IronsightGameController) public let m_vignetteOnFootSizeY: Float;
@addField(IronsightGameController) public let m_aimOnFootSizeX: Float;
@addField(IronsightGameController) public let m_aimOnFootSizeY: Float;
@addField(IronsightGameController) public let m_aimOnFootDimensionsSet: Bool = false;

@addField(IronsightGameController) public let m_vignetteOnFootEditor: Bool = false;

//Corner masks transition functions---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixMasksOnFootSetTransition() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let cornerDownLeftOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"cornerDownLeftOnFoot") as inkWidget;
  let cornerDownRightOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"cornerDownRightOnFoot") as inkWidget;

  this.m_masksOnFootCurrentOpacity = this.m_masksOnFootCurrentOpacity + this.m_masksOnFootChangeOpacityBy;
  cornerDownLeftOnFoot.SetOpacity(this.m_masksOnFootCurrentOpacity);
  cornerDownRightOnFoot.SetOpacity(this.m_masksOnFootCurrentOpacity);

//   LogChannel(n"DEBUG", s"this.m_masksOnFootCurrentOpacity = \(this.m_masksOnFootCurrentOpacity)");
//   LogChannel(n"DEBUG", s"cornerDownLeftOnFoot.GetOpacity() = \(cornerDownLeftOnFoot.GetOpacity())");
//   LogChannel(n"DEBUG", s"cornerDownRightOnFoot.GetOpacity() = \(cornerDownRightOnFoot.GetOpacity())");
}

@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixMasksOnFootSetMargins(cornerDownLeftMargin: Float, cornerDownRightMargin: Float, cornerDownMarginTop: Float) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let cornerDownLeftOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"cornerDownLeftOnFoot") as inkWidget;
  let cornerDownRightOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"cornerDownRightOnFoot") as inkWidget;

  let cornerDownLeftOnFootMargin = cornerDownLeftOnFoot.GetMargin();
  cornerDownLeftOnFoot.SetMargin(cornerDownLeftMargin, cornerDownMarginTop, cornerDownLeftOnFootMargin.right, cornerDownLeftOnFootMargin.bottom);

  let cornerDownRightOnFootMargin = cornerDownRightOnFoot.GetMargin();
  cornerDownRightOnFoot.SetMargin(cornerDownRightMargin, cornerDownMarginTop, cornerDownRightOnFootMargin.right, cornerDownRightOnFootMargin.bottom);

  // LogChannel(n"DEBUG", s"Margins for corner masks set: \(cornerDownLeftMargin), \(cornerDownRightMargin), \(cornerDownMarginTop)");
}

@addMethod(IronsightGameController)
private cb func FrameGenGhostingFixMasksOnFootSetMarginsToggleEvent() -> Void {

  this.FrameGenGhostingFixMasksOnFootSetMargins(0.0, 3840.0, 2160.0);
}

//Vignette dimensions transition functions---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixVignetteOnFootSetDimensions() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let vignetteOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"vignetteOnFoot") as inkWidget;

  let vignetteOnFootMargin = vignetteOnFoot.GetMargin();
  vignetteOnFoot.SetMargin(this.m_vignetteOnFootMarginLeft, this.m_vignetteOnFootMarginTop, vignetteOnFootMargin.right, vignetteOnFootMargin.bottom);

  vignetteOnFoot.SetSize(this.m_vignetteOnFootSizeX, this.m_vignetteOnFootSizeY);
  vignetteOnFoot.Reparent(root);
}

@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixVignetteOnFootSetDimensionsToggle(vignetteOnFootMarginLeft: Float, vignetteOnFootMarginTop: Float, vignetteOnFootSizeX: Float, vignetteOnFootSizeY: Float) -> Bool {

  this.m_vignetteOnFootMarginLeft = vignetteOnFootMarginLeft;
  this.m_vignetteOnFootMarginTop = vignetteOnFootMarginTop;
  this.m_vignetteOnFootSizeX = vignetteOnFootSizeX;
  this.m_vignetteOnFootSizeY = vignetteOnFootSizeY;
}

@addMethod(IronsightGameController)
private cb func FrameGenGhostingFixVignetteOnFootSetDimensionsToggleEvent() -> Void {

  this.FrameGenGhostingFixVignetteOnFootSetDimensionsToggle(1920.0, 1080.0, 4840.0, 2560.0);
}

//Vignette opacity transition functions---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixVignetteOnFootSetTransition() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let vignetteOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"vignetteOnFoot") as inkWidget;

  this.m_vignetteOnFootCurrentOpacity = this.m_vignetteOnFootCurrentOpacity + this.m_vignetteOnFootChangeOpacityBy;
  vignetteOnFoot.SetOpacity(this.m_vignetteOnFootCurrentOpacity);

//   LogChannel(n"DEBUG", s"this.m_vignetteOnFootCurrentOpacity = \(this.m_vignetteOnFootCurrentOpacity)");
//   LogChannel(n"DEBUG", s"vignetteOnFoot.GetOpacity() = \(vignetteOnFoot.GetOpacity())");
}

//Aiming on foot dimension transition functions---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixAimOnFootSetDimensions() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let blockerAimOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"blockerAimOnFoot") as inkWidget;
  let vignetteAimOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"vignetteAimOnFoot") as inkWidget;

  blockerAimOnFoot.SetSize(this.m_aimOnFootSizeX, this.m_aimOnFootSizeY);
  blockerAimOnFoot.Reparent(root);
  vignetteAimOnFoot.SetSize(this.m_aimOnFootSizeX, this.m_aimOnFootSizeY);
  vignetteAimOnFoot.Reparent(root);

//   LogChannel(n"DEBUG", s"this.m_aimOnFootSizeX, this.m_aimOnFootSizeY = \(this.m_aimOnFootSizeX) \(this.m_aimOnFootSizeY)");
//   LogChannel(n"DEBUG", s"vignetteOnFoot.GetOpacity() = \(vignetteAimOnFoot.GetSize())");
}

@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixAimOnFootSetDimensionsToggle(aimOnFootSizeX: Float, aimOnFootSizeY: Float) -> Bool {

  this.m_aimOnFootSizeX = aimOnFootSizeX;
  this.m_aimOnFootSizeY = aimOnFootSizeY;
}

@addMethod(IronsightGameController)
private cb func FrameGenGhostingFixAimOnFootSetDimensionsToggleEvent() -> Void {

  this.FrameGenGhostingFixAimOnFootSetDimensionsToggle(3840.0, 2440.0);
}

//Aiming on foot transitions functions---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixVignetteAimOnFootSetTransition() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let vignetteAimOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"vignetteAimOnFoot") as inkWidget;

  this.m_vignetteAimOnFootCurrentOpacity = this.m_vignetteAimOnFootCurrentOpacity + this.m_vignetteAimOnFootChangeOpacityBy;
  vignetteAimOnFoot.SetOpacity(this.m_vignetteAimOnFootCurrentOpacity);

//   LogChannel(n"DEBUG", s"this.m_vignetteAimOnFootCurrentOpacity = \(this.m_vignetteAimOnFootCurrentOpacity)");
//   LogChannel(n"DEBUG", s"vignetteAimOnFoot.GetOpacity() = \(vignetteAimOnFoot.GetOpacity())");
}

@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixBlockerAimOnFootSetTransition() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let blockerAimOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"blockerAimOnFoot") as inkWidget;

  this.m_blockerAimOnFootCurrentOpacity = this.m_blockerAimOnFootCurrentOpacity + this.m_blockerAimOnFootChangeOpacityBy;
  blockerAimOnFoot.SetOpacity(this.m_blockerAimOnFootCurrentOpacity);

  // LogChannel(n"DEBUG", s"this.m_blockerAimOnFootCurrentOpacity = \(this.m_blockerAimOnFootCurrentOpacity)");
  // LogChannel(n"DEBUG", s"blockerAimOnFoot.GetOpacity() = \(blockerAimOnFoot.GetOpacity())");
}


//Vignette editor context---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixVignetteOnFootEditor() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let vignetteOnFoot_editor: ref<inkWidget> = root.GetWidgetByPathName(n"vignetteOnFoot_editor") as inkWidget;

  vignetteOnFoot_editor.SetOpacity(0.5);

  let vignetteOnFoot_editorMargin = vignetteOnFoot_editor.GetMargin();
  vignetteOnFoot_editor.SetMargin(this.m_vignetteOnFootMarginLeft, this.m_vignetteOnFootMarginTop, vignetteOnFoot_editorMargin.right, vignetteOnFoot_editorMargin.bottom);

  vignetteOnFoot_editor.SetSize(this.m_vignetteOnFootSizeX, this.m_vignetteOnFootSizeY);
  vignetteOnFoot_editor.Reparent(root);
}

@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixVignetteOnFootEditorTurnOff() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let vignetteOnFoot_editor: ref<inkWidget> = root.GetWidgetByPathName(n"vignetteOnFoot_editor") as inkWidget;

  vignetteOnFoot_editor.SetOpacity(0.0);
}

@addMethod(IronsightGameController)
private cb func FrameGenGhostingFixVignetteOnFootEditorContext(vignetteOnFootEditor: Bool) -> Void {
  this.m_vignetteOnFootEditor = vignetteOnFootEditor;
}

@addMethod(IronsightGameController)
private cb func FrameGenGhostingFixVignetteOnFootEditorToggle() -> Void {
  this.FrameGenGhostingFixVignetteOnFootEditorContext(false);
}

//Activate masks on foot---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected final func FrameGenGhostingFixOnFootToggleEvent() -> Void {
  this.FrameGenGhostingFixOnFootToggle(false);
}

@addMethod(IronsightGameController)
protected final func FrameGenGhostingFixOnFootToggle(masksOnFoot: Bool) -> Void {
  this.m_masksOnFootEnabled = masksOnFoot;
}

//Activate main vignette---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected final func FrameGenGhostingFixVignetteOnFootToggleEvent() -> Void {
  this.FrameGenGhostingFixVignetteOnFootToggle(false);
}

@addMethod(IronsightGameController)
protected final func FrameGenGhostingFixVignetteOnFootToggle(vignetteOnFoot: Bool) -> Void {
  this.m_vignetteOnFootEnabled = vignetteOnFoot;
}

//Turn off deactivation of main vignette---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected final func FrameGenGhostingFixVignetteOnFootDeActivationToggleEvent() -> Void {
  this.FrameGenGhostingFixVignetteOnFootDeActivationToggle(false);
}

@addMethod(IronsightGameController)
protected final func FrameGenGhostingFixVignetteOnFootDeActivationToggle(vignetteOnFootActivation: Bool) -> Void {
  this.m_vignetteOnFootActivated = vignetteOnFootActivation;
}

//Activate vignette for aiming---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected final func FrameGenGhostingFixVignetteAimOnFootToggleEvent() -> Void {
  this.FrameGenGhostingFixVignetteAimOnFootToggle(false);
}

@addMethod(IronsightGameController)
protected final func FrameGenGhostingFixVignetteAimOnFootToggle(vignetteAimOnFoot: Bool) -> Void {
  this.m_vignetteAimOnFootEnabled = vignetteAimOnFoot;
}

//Activate blocker for aiming---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected final func FrameGenGhostingFixBlockerAimOnFootToggleEvent() -> Void {
  this.FrameGenGhostingFixBlockerAimOnFootToggle(false);
}

@addMethod(IronsightGameController)
protected final func FrameGenGhostingFixBlockerAimOnFootToggle(blockerAimOnFoot: Bool) -> Void {
  this.m_blockerAimOnFootEnabled = blockerAimOnFoot;
}


@addMethod(IronsightGameController)
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

@addMethod(IronsightGameController)
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
@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixVignetteAimOnFootActivationEvent() -> Bool {

  if Equals(this.m_vignetteAimOnFootEnabled,true) {
    this.m_vignetteAimOnFootActivated = true;
    this.m_vignetteAimOnFootCurrentOpacity = 0.0;
    this.m_vignetteAimOnFootFinalOpacity = 0.018;
    this.m_vignetteAimOnFootChangeOpacityBy = 0.004;
  }
}

@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixVignetteAimOnFootDeActivationEvent() -> Bool {

  if Equals(this.m_vignetteAimOnFootEnabled,true) {
    this.m_vignetteAimOnFootCurrentOpacity = 0.02;
    this.m_vignetteAimOnFootFinalOpacity = 0.001;
    this.m_vignetteAimOnFootChangeOpacityBy = -0.004;
  }

  this.m_vignetteAimOnFootActivated = false;
}

//Blocker aiming
@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixBlockerAimOnFootActivationEvent() -> Bool {

  if Equals(this.m_blockerAimOnFootEnabled,true) {
    this.m_blockerAimOnFootActivated = true;
    this.m_blockerAimOnFootCurrentOpacity = 0.0;
    this.m_blockerAimOnFootFinalOpacity = 0.014;
    this.m_blockerAimOnFootChangeOpacityBy = 0.004;
  }
}

@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixBlockerAimOnFootDeActivationEvent() -> Bool {
  
  if Equals(this.m_blockerAimOnFootEnabled,true) {
    this.m_blockerAimOnFootCurrentOpacity = 0.016;
    this.m_blockerAimOnFootFinalOpacity = 0.001;
    this.m_blockerAimOnFootChangeOpacityBy = -0.004;
  }

  this.m_blockerAimOnFootActivated = false;
}

//Weapon checks---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
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
