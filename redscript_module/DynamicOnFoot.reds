// Thanks to djkovrik for redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

//FrameGen Ghosting 'Fix' 2.1 for FSR3 FG Mods, 2024 gramern (scz_g) 2024

@addField(IronsightGameController) public let m_masksOnFootEnabled: Bool;
@addField(IronsightGameController) public let m_hasWeaponDrawn: Bool;
@addField(IronsightGameController) public let m_isDeactivatingPlusOnFoot: Bool = false;

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
private final func FrameGenGhostingFixOnFootActivationPlusPhaseTwoSetupEvent(delay: Float) -> Void {
  let player: ref<GameObject> = this.GetPlayerControlledObject();
  let turnOnMasksPhaseTwo: ref<FrameGenGhostingFixActivationFootPhaseTwoEvent> = new FrameGenGhostingFixActivationFootPhaseTwoEvent();
  GameInstance.GetDelaySystem(player.GetGame()).DelayEvent(player, turnOnMasksPhaseTwo, delay, false);
}

@addMethod(IronsightGameController)
protected cb func OnFrameGenGhostingFixActivationFootEvent(evt: ref<FrameGenGhostingFixActivationFootEvent>) -> Bool {

  this.OnFrameGenGhostingFixOnFootToggleEvent(true);
  this.OnFrameGenGhostingFixHasWeapon(true);

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo4foot: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4foot") as inkWidget;
  let dumbo5foot: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5foot") as inkWidget;

  if Equals(this.m_hasWeaponDrawn,true) && Equals(this.m_masksOnFootEnabled,true) {
    if dumbo4foot.GetOpacity() != 0.0500000007 {
      dumbo4foot.SetOpacity(0.0299999993);
    }
    if dumbo5foot.GetOpacity() != 0.0500000007 {
      dumbo5foot.SetOpacity(0.0299999993);
    }
    this.FrameGenGhostingFixOnFootActivationPlusPhaseTwoSetupEvent(0.2);
  }
}

//Activate masks plus on foot---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func OnFrameGenGhostingFixActivationFootPhaseTwoEvent(evt: ref<FrameGenGhostingFixActivationFootPhaseTwoEvent>) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo4foot: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4foot") as inkWidget;
  let dumbo5foot: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5foot") as inkWidget;

  if dumbo4foot.GetOpacity() != 0.0500000007 {
    dumbo4foot.SetOpacity(0.0500000007);
  }
  if dumbo5foot.GetOpacity() != 0.0500000007 {
    dumbo5foot.SetOpacity(0.0500000007);
  }
  if Equals(this.m_isDeactivatingPlusOnFoot,false) {
    this.m_isDeactivatingPlusOnFoot = true;
    this.FrameGenGhostingFixOnFootDeActivationPlusPhaseOneSetupEvent(3.0);
  }
}

//Setting deactivation for masks on foot---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
private final func FrameGenGhostingFixOnFootDeActivationPlusPhaseOneSetupEvent(delay: Float) -> Void {
  let player: ref<GameObject> = this.GetPlayerControlledObject();
  let turnOffMasksPhaseOne: ref<FrameGenGhostingFixDeActivationFootPlusPhaseOneEvent> = new FrameGenGhostingFixDeActivationFootPlusPhaseOneEvent();
  GameInstance.GetDelaySystem(player.GetGame()).DelayEvent(player, turnOffMasksPhaseOne, delay, false);
}

@addMethod(IronsightGameController)
private final func FrameGenGhostingFixOnFootDeActivationPlusPhaseTwoSetupEvent(delay: Float) -> Void {
  let player: ref<GameObject> = this.GetPlayerControlledObject();
  let turnOffMasksPhaseTwo: ref<FrameGenGhostingFixDeActivationFootPlusPhaseTwoEvent> = new FrameGenGhostingFixDeActivationFootPlusPhaseTwoEvent();
  GameInstance.GetDelaySystem(player.GetGame()).DelayEvent(player, turnOffMasksPhaseTwo, delay, false);
}

@addMethod(IronsightGameController)
private final func FrameGenGhostingFixOnFootDeActivationPlusPhaseThreeSetupEvent(delay: Float) -> Void {
  let player: ref<GameObject> = this.GetPlayerControlledObject();
  let turnOffMasksPhaseThree: ref<FrameGenGhostingFixDeActivationFootPlusPhaseThreeEvent> = new FrameGenGhostingFixDeActivationFootPlusPhaseThreeEvent();
  GameInstance.GetDelaySystem(player.GetGame()).DelayEvent(player, turnOffMasksPhaseThree, delay, false);
}

@addMethod(IronsightGameController)
private final func FrameGenGhostingFixOnFootDeActivationPlusPhaseFourSetupEvent(delay: Float) -> Void {
  let player: ref<GameObject> = this.GetPlayerControlledObject();
  let turnOffMasksPhaseFour: ref<FrameGenGhostingFixDeActivationFootPlusPhaseFourEvent> = new FrameGenGhostingFixDeActivationFootPlusPhaseFourEvent();
  GameInstance.GetDelaySystem(player.GetGame()).DelayEvent(player, turnOffMasksPhaseFour, delay, false);
}

@addMethod(IronsightGameController)
private final func FrameGenGhostingFixOnFootDeActivationPlusPhaseFiveSetupEvent(delay: Float) -> Void {
  let player: ref<GameObject> = this.GetPlayerControlledObject();
  let turnOffMasksPhaseFive: ref<FrameGenGhostingFixDeActivationFootPlusPhaseFiveEvent> = new FrameGenGhostingFixDeActivationFootPlusPhaseFiveEvent();
  GameInstance.GetDelaySystem(player.GetGame()).DelayEvent(player, turnOffMasksPhaseFive, delay, false);
}

@addMethod(IronsightGameController)
private final func FrameGenGhostingFixOnFootDeActivationSetupEvent(delay: Float) -> Void {
  let player: ref<GameObject> = this.GetPlayerControlledObject();
  let turnOffMasks: ref<FrameGenGhostingFixDeActivationFootEvent> = new FrameGenGhostingFixDeActivationFootEvent();
  GameInstance.GetDelaySystem(player.GetGame()).DelayEvent(player, turnOffMasks, delay, false);
}

//Deactivate masks plus on foot phase one---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func OnFrameGenGhostingFixDeActivationPlusPhaseOneFoot(evt: ref<FrameGenGhostingFixDeActivationFootPlusPhaseOneEvent>) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo4foot: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4foot") as inkWidget;
  let dumbo5foot: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5foot") as inkWidget;

  if dumbo4foot.GetOpacity() != 0.0350000001 {
    dumbo4foot.SetOpacity(0.0350000001);
  }
  if dumbo5foot.GetOpacity() != 0.0350000001 {
    dumbo5foot.SetOpacity(0.0350000001);
  }
  this.FrameGenGhostingFixOnFootDeActivationPlusPhaseTwoSetupEvent(0.5);
}

//Deactivate masks plus on foot phase two---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func OnFrameGenGhostingFixDeActivationPlusPhaseTwoFoot(evt: ref<FrameGenGhostingFixDeActivationFootPlusPhaseTwoEvent>) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo4foot: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4foot") as inkWidget;
  let dumbo5foot: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5foot") as inkWidget;

  if dumbo4foot.GetOpacity() != 0.0299999993 {
    dumbo4foot.SetOpacity(0.0299999993);
  }
  if dumbo5foot.GetOpacity() != 0.0299999993 {
    dumbo5foot.SetOpacity(0.0299999993);
  }
   this.FrameGenGhostingFixOnFootDeActivationPlusPhaseThreeSetupEvent(0.5);
}

//Deactivate masks plus on foot phase three---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func OnFrameGenGhostingFixDeActivationPlusPhaseThreeFoot(evt: ref<FrameGenGhostingFixDeActivationFootPlusPhaseThreeEvent>) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo4foot: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4foot") as inkWidget;
  let dumbo5foot: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5foot") as inkWidget;

  if dumbo4foot.GetOpacity() != 0.0199999996 {
    dumbo4foot.SetOpacity(0.0199999996);
  }
  if dumbo5foot.GetOpacity() != 0.0199999996 {
    dumbo5foot.SetOpacity(0.0199999996);
  }
   this.FrameGenGhostingFixOnFootDeActivationPlusPhaseFourSetupEvent(0.5);
}

//Deactivate masks plus on foot phase four---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func OnFrameGenGhostingFixDeActivationPlusPhaseFourFoot(evt: ref<FrameGenGhostingFixDeActivationFootPlusPhaseFourEvent>) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo4foot: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4foot") as inkWidget;
  let dumbo5foot: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5foot") as inkWidget;

  if dumbo4foot.GetOpacity() != 0.0149999997 {
    dumbo4foot.SetOpacity(0.0149999997);
  }
  if dumbo5foot.GetOpacity() != 0.0149999997 {
    dumbo5foot.SetOpacity(0.0149999997);
  }
  this.FrameGenGhostingFixOnFootDeActivationPlusPhaseFiveSetupEvent(0.5);
}

//Deactivate masks plus on foot phase four---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func OnFrameGenGhostingFixDeActivationPlusPhaseFiveFoot(evt: ref<FrameGenGhostingFixDeActivationFootPlusPhaseFiveEvent>) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo4foot: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4foot") as inkWidget;
  let dumbo5foot: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5foot") as inkWidget;

  if dumbo4foot.GetOpacity() != 0.00999999978 {
    dumbo4foot.SetOpacity(0.00999999978);
  }
  if dumbo5foot.GetOpacity() != 0.00999999978 {
    dumbo5foot.SetOpacity(0.00999999978);
  }
  this.FrameGenGhostingFixOnFootDeActivationSetupEvent(0.5);
}

//Deactivate masks on foot---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
protected cb func OnFrameGenGhostingFixDeActivationFoot(evt: ref<FrameGenGhostingFixDeActivationFootEvent>) -> Bool {

  let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
  let dumbo4foot: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo4foot") as inkWidget;
  let dumbo5foot: ref<inkWidget> = root.GetWidgetByPathName(n"dumbo5foot") as inkWidget;

  if dumbo4foot.GetOpacity() != 0.0 {
    dumbo4foot.SetOpacity(0.0);
  }
  if dumbo5foot.GetOpacity() != 0.0 {
    dumbo5foot.SetOpacity(0.0);
  }
  this.m_isDeactivatingPlusOnFoot = false;
}