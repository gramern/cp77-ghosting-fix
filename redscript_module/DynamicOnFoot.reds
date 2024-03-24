// Thanks to djkovrik for redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

//FrameGen Ghosting 'Fix' 2.13.0-alpha for FSR3 FG Mods, 2024 gramern (scz_g) 2024

// @addField(IronsightGameController) public let m_debugOnFootPrinted: Bool = false;

@addField(IronsightGameController) public let m_masksOnFootEnabled: Bool;
@addField(IronsightGameController) public let m_vignetteOnFootEnabled: Bool;
@addField(IronsightGameController) public let m_hasWeaponDrawn: Bool;
@addField(IronsightGameController) public let m_isAmplifiedOnFoot: Bool = false;
@addField(IronsightGameController) public let m_isDeactivatingOnFoot: Bool = false;

@addField(IronsightGameController) public let m_vignettefootMarginLeft: Float;
@addField(IronsightGameController) public let m_vignettefootMarginTop: Float;
@addField(IronsightGameController) public let m_vignettefootSizeX: Float;
@addField(IronsightGameController) public let m_vignettefootSizeY: Float;

@addField(IronsightGameController) public let m_vignettefootEditor: Bool = false;
@addField(IronsightGameController) public let m_vignettefootEditorID: DelayID;

@addMethod(IronsightGameController)
protected final func OnFrameGenGhostingFixHasWeapon(hasWeapon: Bool) -> Void {
  let player: ref<GameObject> = this.GetPlayerControlledObject();
  let hasWeaponCheck = ScriptedPuppet.GetWeaponRight(player);
  if hasWeaponCheck != null {
    this.m_hasWeaponDrawn = true;      
    // LogChannel(n"DEBUG", "V has a weapon in their right hand!");
  } else {
    this.m_hasWeaponDrawn = false;
  }
}

//The main transition functions---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixFootSetTransition(dumbo45footSetOpacity: Float) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo4foot: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4foot") as inkWidget;
  let dumbo5foot: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5foot") as inkWidget;

  if dumbo4foot.GetOpacity() != dumbo45footSetOpacity {
    dumbo4foot.SetOpacity(dumbo45footSetOpacity);
  }
  if dumbo5foot.GetOpacity() != dumbo45footSetOpacity {
    dumbo5foot.SetOpacity(dumbo45footSetOpacity);
  }
}

@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixVignetteFootSetTransition(vignettefootSetOpacity: Float) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let vignettefoot: ref<inkWidget> = root.GetWidgetByPathName(n"vignettefoot") as inkWidget;

  let vignettefootMargin = vignettefoot.GetMargin();
  if vignettefootMargin.left != this.m_vignettefootMarginLeft {
    vignettefoot.SetMargin(this.m_vignettefootMarginLeft, vignettefootMargin.top, vignettefootMargin.right, vignettefootMargin.bottom);
  }
  if vignettefootMargin.top != this.m_vignettefootMarginTop {
    vignettefoot.SetMargin(vignettefootMargin.left, this.m_vignettefootMarginTop, vignettefootMargin.right, vignettefootMargin.bottom);
  }

  let vignettefootSize = vignettefoot.GetSize();
  if vignettefootSize.X != this.m_vignettefootSizeX {
    vignettefoot.SetSize(this.m_vignettefootSizeX, vignettefootSize.Y);
    vignettefoot.Reparent(root);
  }
  if vignettefootSize.Y != this.m_vignettefootSizeY {
    vignettefoot.SetSize(vignettefootSize.X, this.m_vignettefootSizeY);
    vignettefoot.Reparent(root);
  }

  if vignettefoot.GetOpacity() != vignettefootSetOpacity {
    vignettefoot.SetOpacity(vignettefootSetOpacity);
  }
  
  this.FrameGenGhostingFixVignetteFootEditorTurnOff();
}

@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixVignetteFootSetDimensions(vignettefootMarginLeft: Float, vignettefootMarginTop: Float, vignettefootSizeX: Float, vignettefootSizeY: Float) -> Bool {

  this.m_vignettefootMarginLeft = vignettefootMarginLeft;
  this.m_vignettefootMarginTop = vignettefootMarginTop;
  this.m_vignettefootSizeX = vignettefootSizeX;
  this.m_vignettefootSizeY = vignettefootSizeY;
}

@addMethod(IronsightGameController)
private cb func OnFrameGenGhostingFixVignetteFootSetDimensionsEvent(replacer: Bool) -> Void {

  this.FrameGenGhostingFixVignetteFootSetDimensions(1920.0, 1080.0, 4840.0, 2560.0);
}

//Vignette editor context---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixVignetteFootEditor() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let vignettefoot_editor: ref<inkWidget> = root.GetWidgetByPathName(n"vignettefoot_editor") as inkWidget;

  vignettefoot_editor.SetOpacity(0.5);

  let vignettefoot_editorMargin = vignettefoot_editor.GetMargin();
  if vignettefoot_editorMargin.left != this.m_vignettefootMarginLeft {
    vignettefoot_editor.SetMargin(this.m_vignettefootMarginLeft, vignettefoot_editorMargin.top, vignettefoot_editorMargin.right, vignettefoot_editorMargin.bottom);
  }
  if vignettefoot_editorMargin.top != this.m_vignettefootMarginTop {
    vignettefoot_editor.SetMargin(vignettefoot_editorMargin.left, this.m_vignettefootMarginTop, vignettefoot_editorMargin.right, vignettefoot_editorMargin.bottom);
  }
  let vignettefootSize = vignettefoot_editor.GetSize();
  if vignettefootSize.X != this.m_vignettefootSizeX {
  vignettefoot_editor.SetSize(this.m_vignettefootSizeX, vignettefootSize.Y);
  vignettefoot_editor.Reparent(root);
  }
  if vignettefootSize.Y != this.m_vignettefootSizeY {
  vignettefoot_editor.SetSize(vignettefootSize.X, this.m_vignettefootSizeY);
  vignettefoot_editor.Reparent(root);
  }
}

@addMethod(IronsightGameController)
protected cb func FrameGenGhostingFixVignetteFootEditorTurnOff() -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let vignettefoot_editor: ref<inkWidget> = root.GetWidgetByPathName(n"vignettefoot_editor") as inkWidget;
  
  if vignettefoot_editor.GetOpacity() != 0.0 {
    vignettefoot_editor.SetOpacity(0.0);
  }
}

@addMethod(IronsightGameController)
private cb func FrameGenGhostingFixVignetteOnFootEditorContext(vignettefootEditor: Bool) -> Void {
  this.m_vignettefootEditor = vignettefootEditor;
}

@addMethod(IronsightGameController)
private cb func FrameGenGhostingFixVignetteOnFootEditorToggle() -> Void {
  this.FrameGenGhostingFixVignetteOnFootEditorContext(false);
}

@addMethod(IronsightGameController)
public func FrameGenGhostingFixVignetteOnFootEditorContextLoop() {
  let playerPuppet: ref<GameObject> = this.GetPlayerControlledObject();
  let vignetteEditorCallback = new FrameGenGhostingFixVignetteOnFootEditorCallback();
  vignetteEditorCallback.ironsightController = this;
  this.m_vignettefootEditorID = GameInstance.GetDelaySystem(playerPuppet.GetGame()).DelayCallback(vignetteEditorCallback, 0.1);
}

public class FrameGenGhostingFixVignetteOnFootEditorCallback extends DelayCallback {
  public let ironsightController: wref<IronsightGameController>;
  public func Call() -> Void {
    this.ironsightController.FrameGenGhostingFixVignetteOnFootEditorContextLoop();
    this.ironsightController.FrameGenGhostingFixVignetteOnFootEditorToggle();
    if Equals(this.ironsightController.m_vignettefootEditor,true) {
      this.ironsightController.FrameGenGhostingFixVignetteFootEditor();
    }
  }
}

@wrapMethod(IronsightGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);

  this.FrameGenGhostingFixVignetteOnFootEditorContextLoop();
}

//Activate masks on foot---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected final func OnFrameGenGhostingFixOnFootToggleEvent(replacer: Bool) -> Void {
  this.OnFrameGenGhostingFixOnFootToggle(false);
}

@addMethod(IronsightGameController)
protected final func OnFrameGenGhostingFixOnFootToggle(masksOnFoot: Bool) -> Void {
  this.m_masksOnFootEnabled = masksOnFoot;
}

@addMethod(IronsightGameController)
protected final func OnFrameGenGhostingFixVignetteOnFootToggleEvent(replacer: Bool) -> Void {
  this.OnFrameGenGhostingFixVignetteOnFootToggle(false);
}

@addMethod(IronsightGameController)
protected final func OnFrameGenGhostingFixVignetteOnFootToggle(vignetteOnFoot: Bool) -> Void {
  this.m_vignetteOnFootEnabled = vignetteOnFoot;
}

@addMethod(IronsightGameController)
protected cb func OnFrameGenGhostingFixActivationFootEvent(evt: ref<FrameGenGhostingFixActivationFootEvent>) -> Bool {

  this.OnFrameGenGhostingFixHasWeapon(true);
  this.OnFrameGenGhostingFixOnFootToggleEvent(true);
  this.OnFrameGenGhostingFixVignetteOnFootToggleEvent(true);
  this.OnFrameGenGhostingFixVignetteFootSetDimensionsEvent(true);

  if Equals(this.m_hasWeaponDrawn,true) {
    if NotEquals(this.m_isAmplifiedOnFoot,true) {
      this.FrameGenGhostingFixOnFootActivationAmplifySetupEvent(0.2);
      if Equals(this.m_masksOnFootEnabled,true) {
        this.FrameGenGhostingFixFootSetTransition(0.02);
      }
      if Equals(this.m_vignetteOnFootEnabled,true) {
      this.FrameGenGhostingFixVignetteFootSetTransition(0.015);
      }
    } else {
      this.FrameGenGhostingFixOnFootActivationAmplifySetupEvent(0.0);
    }
  } else {
    this.FrameGenGhostingFixVignetteFootEditorTurnOff();
  }
}

//Amplify masks on foot---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
private final func FrameGenGhostingFixOnFootActivationAmplifySetupEvent(delay: Float) -> Void {
  let player: ref<GameObject> = this.GetPlayerControlledObject();
  let turnOnMasksPhaseTwo: ref<FrameGenGhostingFixActivationFootAmplifyEvent> = new FrameGenGhostingFixActivationFootAmplifyEvent();
  GameInstance.GetDelaySystem(player.GetGame()).DelayEvent(player, turnOnMasksPhaseTwo, delay, false);
}

@addMethod(IronsightGameController)
protected cb func OnFrameGenGhostingFixActivationFootAmplifyEvent(evt: ref<FrameGenGhostingFixActivationFootAmplifyEvent>) -> Bool {
 
  if Equals(this.m_hasWeaponDrawn,true) {
    if Equals(this.m_masksOnFootEnabled,true) {
      this.FrameGenGhostingFixFootSetTransition(0.045);
    }
    if Equals(this.m_vignetteOnFootEnabled,true) {
      this.FrameGenGhostingFixVignetteFootSetTransition(0.025);
    }
    this.m_isAmplifiedOnFoot = true;
  }
  if Equals(this.m_isDeactivatingOnFoot,false) {
    this.FrameGenGhostingFixOnFootDeActivationPhaseOneSetupEvent(3.0);
    this.m_isDeactivatingOnFoot = true;
  }
}

//Setting deactivation for masks on foot---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
private final func FrameGenGhostingFixOnFootDeActivationPhaseOneSetupEvent(delay: Float) -> Void {
  let player: ref<GameObject> = this.GetPlayerControlledObject();
  let nextEvent: ref<FrameGenGhostingFixDeActivationFootPhaseOneEvent> = new FrameGenGhostingFixDeActivationFootPhaseOneEvent();
  GameInstance.GetDelaySystem(player.GetGame()).DelayEvent(player, nextEvent, delay, false);
}

@addMethod(IronsightGameController)
private final func FrameGenGhostingFixOnFootDeActivationPhaseTwoSetupEvent(delay: Float) -> Void {
  let player: ref<GameObject> = this.GetPlayerControlledObject();
  let turnOffMasksPhaseTwo: ref<FrameGenGhostingFixDeActivationFootPhaseTwoEvent> = new FrameGenGhostingFixDeActivationFootPhaseTwoEvent();
  GameInstance.GetDelaySystem(player.GetGame()).DelayEvent(player, turnOffMasksPhaseTwo, delay, false);
}

@addMethod(IronsightGameController)
private final func FrameGenGhostingFixOnFootDeActivationPhaseThreeSetupEvent(delay: Float) -> Void {
  let player: ref<GameObject> = this.GetPlayerControlledObject();
  let turnOffMasksPhaseThree: ref<FrameGenGhostingFixDeActivationFootPhaseThreeEvent> = new FrameGenGhostingFixDeActivationFootPhaseThreeEvent();
  GameInstance.GetDelaySystem(player.GetGame()).DelayEvent(player, turnOffMasksPhaseThree, delay, false);
}

@addMethod(IronsightGameController)
private final func FrameGenGhostingFixOnFootDeActivationPhaseFourSetupEvent(delay: Float) -> Void {
  let player: ref<GameObject> = this.GetPlayerControlledObject();
  let turnOffMasksPhaseFour: ref<FrameGenGhostingFixDeActivationFootPhaseFourEvent> = new FrameGenGhostingFixDeActivationFootPhaseFourEvent();
  GameInstance.GetDelaySystem(player.GetGame()).DelayEvent(player, turnOffMasksPhaseFour, delay, false);
}

@addMethod(IronsightGameController)
private final func FrameGenGhostingFixOnFootDeActivationPhaseFiveSetupEvent(delay: Float) -> Void {
  let player: ref<GameObject> = this.GetPlayerControlledObject();
  let turnOffMasksPhaseFive: ref<FrameGenGhostingFixDeActivationFootPhaseFiveEvent> = new FrameGenGhostingFixDeActivationFootPhaseFiveEvent();
  GameInstance.GetDelaySystem(player.GetGame()).DelayEvent(player, turnOffMasksPhaseFive, delay, false);
}

@addMethod(IronsightGameController)
private final func FrameGenGhostingFixOnFootDeActivationSetupEvent(delay: Float) -> Void {
  let player: ref<GameObject> = this.GetPlayerControlledObject();
  let turnOffMasks: ref<FrameGenGhostingFixDeActivationFootEvent> = new FrameGenGhostingFixDeActivationFootEvent();
  GameInstance.GetDelaySystem(player.GetGame()).DelayEvent(player, turnOffMasks, delay, false);
}

//Deactivate masks on foot phase one---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func OnFrameGenGhostingFixDeActivationPhaseOneFoot(evt: ref<FrameGenGhostingFixDeActivationFootPhaseOneEvent>) -> Bool {

  if Equals(this.m_masksOnFootEnabled,true) {
    this.FrameGenGhostingFixFootSetTransition(0.035);
  }
  if Equals(this.m_vignetteOnFootEnabled,true) {
    this.FrameGenGhostingFixVignetteFootSetTransition(0.02);
  }

  this.FrameGenGhostingFixOnFootDeActivationPhaseTwoSetupEvent(0.1);
}

//Deactivate masks on foot phase two---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func OnFrameGenGhostingFixDeActivationPhaseTwoFoot(evt: ref<FrameGenGhostingFixDeActivationFootPhaseTwoEvent>) -> Bool {

  if Equals(this.m_masksOnFootEnabled,true) {
    this.FrameGenGhostingFixFootSetTransition(0.03);
  }
  if Equals(this.m_vignetteOnFootEnabled,true) {
    this.FrameGenGhostingFixVignetteFootSetTransition(0.016);
  }

  this.FrameGenGhostingFixOnFootDeActivationPhaseThreeSetupEvent(0.1);

  this.m_isAmplifiedOnFoot = false;
}

//Deactivate masks on foot phase three---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func OnFrameGenGhostingFixDeActivationPhaseThreeFoot(evt: ref<FrameGenGhostingFixDeActivationFootPhaseThreeEvent>) -> Bool {

  if Equals(this.m_masksOnFootEnabled,true) {
    this.FrameGenGhostingFixFootSetTransition(0.02);
  }
  if Equals(this.m_vignetteOnFootEnabled,true) {
    this.FrameGenGhostingFixVignetteFootSetTransition(0.012);
  }

  this.FrameGenGhostingFixOnFootDeActivationPhaseFourSetupEvent(0.1);
}

//Deactivate masks on foot phase four---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func OnFrameGenGhostingFixDeActivationPhaseFourFoot(evt: ref<FrameGenGhostingFixDeActivationFootPhaseFourEvent>) -> Bool {
  
  if Equals(this.m_masksOnFootEnabled,true) {
    this.FrameGenGhostingFixFootSetTransition(0.015);
  }
  if Equals(this.m_vignetteOnFootEnabled,true) {
    this.FrameGenGhostingFixVignetteFootSetTransition(0.008);
  }

  this.FrameGenGhostingFixOnFootDeActivationPhaseFiveSetupEvent(0.1);
}

//Deactivate masks on foot phase four---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func OnFrameGenGhostingFixDeActivationPhaseFiveFoot(evt: ref<FrameGenGhostingFixDeActivationFootPhaseFiveEvent>) -> Bool {

  if Equals(this.m_masksOnFootEnabled,true) {
    this.FrameGenGhostingFixFootSetTransition(0.010);
  }
  if Equals(this.m_vignetteOnFootEnabled,true) {
    this.FrameGenGhostingFixVignetteFootSetTransition(0.004);
  }

  this.FrameGenGhostingFixOnFootDeActivationSetupEvent(0.1);
}

//Deactivate masks on foot---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func OnFrameGenGhostingFixDeActivationFoot(evt: ref<FrameGenGhostingFixDeActivationFootEvent>) -> Bool {

  if Equals(this.m_masksOnFootEnabled,true) {
   this.FrameGenGhostingFixFootSetTransition(0.0);
  }
  if Equals(this.m_vignetteOnFootEnabled,true) {
    this.FrameGenGhostingFixVignetteFootSetTransition(0.0);
  }

  this.m_isDeactivatingOnFoot = false;
}