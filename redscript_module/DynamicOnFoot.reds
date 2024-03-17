// Thanks to djkovrik for redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

//FrameGen Ghosting 'Fix' 2.12 for FSR3 FG Mods, 2024 gramern (scz_g) 2024

// @addField(IronsightGameController) public let m_debugOnFootPrinted: Bool = false;

@addField(IronsightGameController) public let m_masksOnFootEnabled: Bool;
@addField(IronsightGameController) public let m_vignetteOnFootEnabled: Bool;
@addField(IronsightGameController) public let m_hasWeaponDrawn: Bool;
@addField(IronsightGameController) public let m_isAmplifiedOnFoot: Bool = false;
@addField(IronsightGameController) public let m_isDeactivatingOnFoot: Bool = false;

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

//The main Transition functions---------------------------------------------------------------------------------------
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
protected cb func OnFrameGenGhostingFixActivationFootEvent(evt: ref<FrameGenGhostingFixActivationFootEvent>) -> Bool {

  this.OnFrameGenGhostingFixHasWeapon(true);
  this.OnFrameGenGhostingFixOnFootToggleEvent(true);

  if Equals(this.m_hasWeaponDrawn,true) && Equals(this.m_masksOnFootEnabled,true) {
    if NotEquals(this.m_isAmplifiedOnFoot,true) {
    this.FrameGenGhostingFixFootSetTransition(0.03);
    this.FrameGenGhostingFixOnFootActivationAmplifySetupEvent(0.2);
    } else {
    this.FrameGenGhostingFixOnFootActivationAmplifySetupEvent(0.0);
    }
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
 
  if Equals(this.m_hasWeaponDrawn,true) && Equals(this.m_masksOnFootEnabled,true) {
    this.FrameGenGhostingFixFootSetTransition(0.05);
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

  this.FrameGenGhostingFixFootSetTransition(0.035);

  this.FrameGenGhostingFixOnFootDeActivationPhaseTwoSetupEvent(0.1);
}

//Deactivate masks on foot phase two---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func OnFrameGenGhostingFixDeActivationPhaseTwoFoot(evt: ref<FrameGenGhostingFixDeActivationFootPhaseTwoEvent>) -> Bool {

  this.FrameGenGhostingFixFootSetTransition(0.03);

  this.FrameGenGhostingFixOnFootDeActivationPhaseThreeSetupEvent(0.1);

  this.m_isAmplifiedOnFoot = false;
}

//Deactivate masks on foot phase three---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func OnFrameGenGhostingFixDeActivationPhaseThreeFoot(evt: ref<FrameGenGhostingFixDeActivationFootPhaseThreeEvent>) -> Bool {
  
  if Equals(this.m_isAmplifiedOnFoot,false) {
    this.FrameGenGhostingFixFootSetTransition(0.02);

    this.FrameGenGhostingFixOnFootDeActivationPhaseFourSetupEvent(0.1);
  }
}

//Deactivate masks on foot phase four---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func OnFrameGenGhostingFixDeActivationPhaseFourFoot(evt: ref<FrameGenGhostingFixDeActivationFootPhaseFourEvent>) -> Bool {

  if Equals(this.m_isAmplifiedOnFoot,false) {
    this.FrameGenGhostingFixFootSetTransition(0.015);

    this.FrameGenGhostingFixOnFootDeActivationPhaseFiveSetupEvent(0.1);
  }
}

//Deactivate masks on foot phase four---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func OnFrameGenGhostingFixDeActivationPhaseFiveFoot(evt: ref<FrameGenGhostingFixDeActivationFootPhaseFiveEvent>) -> Bool {

  if Equals(this.m_isAmplifiedOnFoot,false) {
    this.FrameGenGhostingFixFootSetTransition(0.010);

    this.FrameGenGhostingFixOnFootDeActivationSetupEvent(0.1);
  }
}

//Deactivate masks on foot---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func OnFrameGenGhostingFixDeActivationFoot(evt: ref<FrameGenGhostingFixDeActivationFootEvent>) -> Bool {

  this.FrameGenGhostingFixFootSetTransition(0.0);

  this.m_isDeactivatingOnFoot = false;
}