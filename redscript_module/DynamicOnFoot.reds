// Thanks to djkovrik for redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

//FrameGen Ghosting 'Fix' 3.0.0 for FSR3 FG Mods, 2024 gramern (scz_g) 2024

@addField(IronsightGameController) public let m_masksOnFootEnabled: Bool = false;
@addField(IronsightGameController) public let m_vignetteOnFootEnabled: Bool = false;
@addField(IronsightGameController) public let m_vignetteAimOnFootEnabled: Bool = false;

@addField(IronsightGameController) public let m_isWeaponDrawn: Bool;

@addField(IronsightGameController) public let m_isMaskingOnFootActivated: Bool = false;
@addField(IronsightGameController) public let m_masksOnFootActivated: Bool = false;
@addField(IronsightGameController) public let m_vignetteOnFootActivated: Bool = false;
@addField(IronsightGameController) public let m_vignetteAimOnFootActivated: Bool = false;

@addField(IronsightGameController) public let m_masksOnFootChangeOpacityBy: Float;
@addField(IronsightGameController) public let m_masksOnFootCurrentOpacity: Float;
@addField(IronsightGameController) public let m_masksOnFootFinalOpacity: Float;
@addField(IronsightGameController) public let m_vignetteOnFootChangeOpacityBy: Float;
@addField(IronsightGameController) public let m_vignetteOnFootCurrentOpacity: Float;
@addField(IronsightGameController) public let m_vignetteOnFootFinalOpacity: Float;
@addField(IronsightGameController) public let m_vignetteAimOnFootChangeOpacityBy: Float;
@addField(IronsightGameController) public let m_vignetteAimOnFootCurrentOpacity: Float;
@addField(IronsightGameController) public let m_vignetteAimOnFootFinalOpacity: Float;

@addField(IronsightGameController) public let m_vignetteOnFootMarginLeft: Float;
@addField(IronsightGameController) public let m_vignetteOnFootMarginTop: Float;
@addField(IronsightGameController) public let m_vignetteOnFootSizeX: Float;
@addField(IronsightGameController) public let m_vignetteOnFootSizeY: Float;
@addField(IronsightGameController) public let m_vignetteAimOnFootSizeX: Float;
@addField(IronsightGameController) public let m_vignetteAimOnFootSizeY: Float;
@addField(IronsightGameController) public let m_vignetteAimOnFootDimensionsSet: Bool = false;

@addField(IronsightGameController) public let m_vignetteOnFootEditor: Bool = false;

@addField(IronsightGameController) public let m_onFootLoopID: DelayID;

@addField(IronsightGameController) public let m_isVehicleMounted: Bool = false;

//Standard masks (dumbos) transition functions---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixMasksOnFootSetTransition() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo4OnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4OnFoot") as inkWidget;
  let dumbo5OnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5OnFoot") as inkWidget;

  this.m_masksOnFootCurrentOpacity = this.m_masksOnFootCurrentOpacity + this.m_masksOnFootChangeOpacityBy;
  dumbo4OnFoot.SetOpacity(this.m_masksOnFootCurrentOpacity);
  dumbo5OnFoot.SetOpacity(this.m_masksOnFootCurrentOpacity);

  // LogChannel(n"DEBUG", s"this.m_masksOnFootCurrentOpacity = \(this.m_masksOnFootCurrentOpacity)");
  // LogChannel(n"DEBUG", s"masksOnFoot.GetOpacity() = \(dumbo4OnFoot.GetOpacity())");
  // LogChannel(n"DEBUG", s"masksOnFoot.GetOpacity() = \(dumbo5OnFoot.GetOpacity())");
}

//Vignettes' dimensions transition functions---------------------------------------------------------------------------------------
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

@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixVignetteAimOnFootSetDimensions() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let vignetteAimOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"vignetteAimOnFoot") as inkWidget;

  vignetteAimOnFoot.SetSize(this.m_vignetteAimOnFootSizeX, this.m_vignetteAimOnFootSizeY);
  vignetteAimOnFoot.Reparent(root);

  // LogChannel(n"DEBUG", s"\(this.m_vignetteAimOnFootSizeX) \(this.m_vignetteAimOnFootSizeY)");
  // let vignetteAimOnFootSizeCheck = vignetteAimOnFoot.GetSize();
  // LogChannel(n"DEBUG", s"\(vignetteAimOnFootSizeCheck.X) \(vignetteAimOnFootSizeCheck.Y)");
}

@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixVignetteAimOnFootSetDimensionsToggle(vignetteAimOnFootSizeX: Float, vignetteAimOnFootSizeY: Float) -> Bool {

  this.m_vignetteAimOnFootSizeX = vignetteAimOnFootSizeX;
  this.m_vignetteAimOnFootSizeY = vignetteAimOnFootSizeY;
}

@addMethod(IronsightGameController)
private cb func FrameGenGhostingFixVignetteAimOnFootSetDimensionsToggleEvent() -> Void {

  this.FrameGenGhostingFixVignetteAimOnFootSetDimensionsToggle(3840.0, 2440.0);
}

//Vignettes' opacity transition functions---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixVignetteOnFootSetTransition() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let vignetteOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"vignetteOnFoot") as inkWidget;

  this.m_vignetteOnFootCurrentOpacity = this.m_vignetteOnFootCurrentOpacity + this.m_vignetteOnFootChangeOpacityBy;
  vignetteOnFoot.SetOpacity(this.m_vignetteOnFootCurrentOpacity);

  // LogChannel(n"DEBUG", s"this.m_vignetteOnFootCurrentOpacity = \(this.m_vignetteOnFootCurrentOpacity)");
  // LogChannel(n"DEBUG", s"vignetteOnFoot.GetOpacity() = \(vignetteOnFoot.GetOpacity())");
}

@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixVignetteAimOnFootSetTransition() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let vignetteAimOnFoot: ref<inkWidget> = root.GetWidgetByPathName(n"vignetteAimOnFoot") as inkWidget;

  this.m_vignetteAimOnFootCurrentOpacity = this.m_vignetteAimOnFootCurrentOpacity + this.m_vignetteAimOnFootChangeOpacityBy;
  vignetteAimOnFoot.SetOpacity(this.m_vignetteAimOnFootCurrentOpacity);

  // LogChannel(n"DEBUG", s"this.m_vignetteAimOnFootCurrentOpacity = \(this.m_vignetteAimOnFootCurrentOpacity)");
  // LogChannel(n"DEBUG", s"vignetteAimOnFoot.GetOpacity() = \(vignetteAimOnFoot.GetOpacity())");
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

@addMethod(IronsightGameController)
protected final func FrameGenGhostingFixVignetteOnFootToggleEvent() -> Void {
  this.FrameGenGhostingFixVignetteOnFootToggle(false);
}

@addMethod(IronsightGameController)
protected final func FrameGenGhostingFixVignetteOnFootToggle(vignetteOnFoot: Bool) -> Void {
  this.m_vignetteOnFootEnabled = vignetteOnFoot;
}

@addMethod(IronsightGameController)
protected final func FrameGenGhostingFixVignetteAimOnFootToggleEvent() -> Void {
  this.FrameGenGhostingFixVignetteAimOnFootToggle(false);
}

@addMethod(IronsightGameController)
protected final func FrameGenGhostingFixVignetteAimOnFootToggle(vignetteAimOnFoot: Bool) -> Void {
  this.m_vignetteAimOnFootEnabled = vignetteAimOnFoot;
}

@addMethod(IronsightGameController)
protected final func FrameGenGhostingFixVignetteOnFootDeActivationToggleEvent() -> Void {
  this.FrameGenGhostingFixVignetteOnFootDeActivationToggle(false);
}

@addMethod(IronsightGameController)
protected final func FrameGenGhostingFixVignetteOnFootDeActivationToggle(vignetteOnFootActivation: Bool) -> Void {
  this.m_vignetteOnFootActivated = vignetteOnFootActivation;
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
    this.m_vignetteOnFootCurrentOpacity = 0.025;
    this.m_vignetteOnFootFinalOpacity = 0.0;
    this.m_vignetteOnFootChangeOpacityBy = -0.005;
  }

  this.m_masksOnFootActivated = false;
  this.FrameGenGhostingFixVignetteOnFootDeActivationToggleEvent();
}

@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixAimOnFootActivationEvent() -> Bool {

  if Equals(this.m_vignetteAimOnFootEnabled,true) {
    this.m_vignetteAimOnFootCurrentOpacity = 0.0;
    this.m_vignetteAimOnFootFinalOpacity = 0.018;
    this.m_vignetteAimOnFootChangeOpacityBy = 0.004;
  }

  this.m_vignetteAimOnFootActivated = true;
}

@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixAimOnFootDeActivationEvent() -> Bool {
  
  if Equals(this.m_vignetteAimOnFootEnabled,true) {
    this.m_vignetteAimOnFootCurrentOpacity = 0.02;
    this.m_vignetteAimOnFootFinalOpacity = 0.0;
    this.m_vignetteAimOnFootChangeOpacityBy = -0.004;
  }

  this.m_vignetteAimOnFootActivated = false;
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

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixMountingEvent(evt: ref<MountingEvent>) -> Bool {
  this.m_isVehicleMounted = true;
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixUnmountingEvent(evt: ref<UnmountingEvent>) -> Bool {
  this.m_isVehicleMounted = false;
}

//On foot loop - callback---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
public func FrameGenGhostingFixOnFootLoop() {
  let playerPuppet: ref<GameObject> = this.GetPlayerControlledObject();
  let onFootCallback = new FrameGenGhostingFixOnFootCallback();
  onFootCallback.ironsightController = this;
  this.m_onFootLoopID = GameInstance.GetDelaySystem(playerPuppet.GetGame()).DelayCallback(onFootCallback, 0.1);
}

public class FrameGenGhostingFixOnFootCallback extends DelayCallback {

  public let ironsightController: wref<IronsightGameController>;

  public func Call() -> Void {

    this.ironsightController.FrameGenGhostingFixHasWeapon();

    if Equals(this.ironsightController.m_isWeaponDrawn,true) {
      if Equals(this.ironsightController.m_isMaskingOnFootActivated,false) {
        this.ironsightController.m_isMaskingOnFootActivated = true;
        this.ironsightController.FrameGenGhostingFixOnFootActivationEvent();
      }
      if Equals(this.ironsightController.m_masksOnFootActivated,true) && this.ironsightController.m_masksOnFootCurrentOpacity < this.ironsightController.m_masksOnFootFinalOpacity {
        this.ironsightController.FrameGenGhostingFixMasksOnFootSetTransition();
      }
      if Equals(this.ironsightController.m_vignetteOnFootActivated,true) && this.ironsightController.m_vignetteOnFootCurrentOpacity < this.ironsightController.m_vignetteOnFootFinalOpacity {
        this.ironsightController.FrameGenGhostingFixVignetteOnFootSetTransition();
      }

      this.ironsightController.FrameGenGhostingFixVignetteAimOnFootToggleEvent();
      if Equals(this.ironsightController.m_upperBodyState,IntEnum<gamePSMUpperBodyStates>(6)) && Equals(this.ironsightController.m_vignetteAimOnFootEnabled,true) && NotEquals(this.ironsightController.m_vignetteAimOnFootActivated,true) {
        this.ironsightController.FrameGenGhostingFixAimOnFootActivationEvent();
      }
      if NotEquals(this.ironsightController.m_upperBodyState,IntEnum<gamePSMUpperBodyStates>(6)) && Equals(this.ironsightController.m_vignetteAimOnFootEnabled,true) && Equals(this.ironsightController.m_vignetteAimOnFootActivated,true) {
        this.ironsightController.FrameGenGhostingFixAimOnFootDeActivationEvent();
      }
      if Equals(this.ironsightController.m_vignetteAimOnFootActivated,true) && this.ironsightController.m_vignetteAimOnFootCurrentOpacity < this.ironsightController.m_vignetteAimOnFootFinalOpacity {
        this.ironsightController.FrameGenGhostingFixVignetteAimOnFootSetTransition();
      }
      if Equals(this.ironsightController.m_vignetteAimOnFootActivated,false) && this.ironsightController.m_vignetteAimOnFootCurrentOpacity > this.ironsightController.m_vignetteAimOnFootFinalOpacity {
        this.ironsightController.FrameGenGhostingFixVignetteAimOnFootSetTransition();
      }

      if Equals(this.ironsightController.m_isVehicleMounted,true) {
        this.ironsightController.FrameGenGhostingFixVehicleWeaponEvent();
      }
    } else {
      if Equals(this.ironsightController.m_isMaskingOnFootActivated,true) {
        this.ironsightController.m_isMaskingOnFootActivated = false;
        this.ironsightController.FrameGenGhostingFixOnFootDeActivationEvent();
      }
      if Equals(this.ironsightController.m_masksOnFootActivated,false) && this.ironsightController.m_masksOnFootCurrentOpacity > this.ironsightController.m_masksOnFootFinalOpacity {
        this.ironsightController.FrameGenGhostingFixMasksOnFootSetTransition();
      }
      if Equals(this.ironsightController.m_vignetteOnFootActivated,false) && this.ironsightController.m_vignetteOnFootCurrentOpacity > this.ironsightController.m_vignetteOnFootFinalOpacity {
        this.ironsightController.FrameGenGhostingFixVignetteOnFootSetTransition();
      }
    }
  
    this.ironsightController.FrameGenGhostingFixVignetteOnFootEditorToggle();
    if Equals(this.ironsightController.m_vignetteOnFootEditor,true) {
      this.ironsightController.FrameGenGhostingFixVignetteOnFootEditor();
    }

    this.ironsightController.FrameGenGhostingFixOnFootLoop();
  }
}

@wrapMethod(IronsightGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);

  this.FrameGenGhostingFixOnFootLoop();
  this.FrameGenGhostingFixVignetteOnFootSetDimensions();
  this.FrameGenGhostingFixVignetteAimOnFootToggleEvent();
  this.FrameGenGhostingFixVignetteAimOnFootSetDimensionsToggleEvent();
  this.FrameGenGhostingFixVignetteAimOnFootSetDimensions();
}
