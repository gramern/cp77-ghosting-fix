// Thanks to djkovrik and psiberx for help and redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. JackHumbert for the Let There Be Flight mod I took bike parts names from. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

// FrameGen Ghosting 'Fix' 4.9.0xl, 2024 gramern (scz_g) 2024

@addField(gameuiCrosshairContainerController) public let m_onFootLoopID: DelayID;

@addField(gameuiCrosshairContainerController) public let m_ADSAnimator: wref<AimDownSightController>;
@addField(gameuiCrosshairContainerController) public let m_playerStateMachineBB: wref<IBlackboard>;
@addField(gameuiCrosshairContainerController) public let m_playerStateMachineUpperBodyBBID: ref<CallbackHandle>;
@addField(gameuiCrosshairContainerController) public let m_upperBodyState: gamePSMUpperBodyStates;

// The main loop ---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
public func FrameGenGhostingFixLoop() {

  let playerPuppet: ref<GameObject> = this.GetPlayerControlledObject();
  let onFootCallback = new FrameGenGhostingFixLoopCallback();
  onFootCallback.masksController = this;
  
  this.m_onFootLoopID = GameInstance.GetDelaySystem(playerPuppet.GetGame()).DelayCallback(onFootCallback, 0.1);
}

public class FrameGenGhostingFixLoopCallback extends DelayCallback {

  public let masksController: wref<gameuiCrosshairContainerController>;

  public func Call() -> Void {

    this.masksController.FrameGenGhostingFixHasWeapon();
    // LogChannel(n"DEBUG", s"\(this.masksController.m_upperBodyState)");

    if Equals(this.masksController.m_isWeaponDrawn, true) {
      if Equals(this.masksController.m_isMaskingOnFootActivated, false) {
        this.masksController.m_isMaskingOnFootActivated = true;
        this.masksController.FrameGenGhostingFixOnFootActivationEvent();
      }
      if Equals(this.masksController.m_masksOnFootActivated, true) && this.masksController.m_masksOnFootCurrentOpacity < this.masksController.m_masksOnFootFinalOpacity {
        this.masksController.FrameGenGhostingFixMasksOnFootSetTransition();
      }
      if Equals(this.masksController.m_vignetteOnFootActivated, true) && this.masksController.m_vignetteOnFootCurrentOpacity < this.masksController.m_vignetteOnFootFinalOpacity {
        this.masksController.FrameGenGhostingFixVignetteOnFootSetTransition();
      }

      this.masksController.FrameGenGhostingFixBlockerAimOnFootToggleEvent();
      this.masksController.FrameGenGhostingFixVignetteAimOnFootToggleEvent();

      if Equals(this.masksController.m_upperBodyState, IntEnum<gamePSMUpperBodyStates>(6)) {
        if Equals(this.masksController.m_blockerAimOnFootEnabled, true) && NotEquals(this.masksController.m_blockerAimOnFootActivated, true) {
          this.masksController.FrameGenGhostingFixBlockerAimOnFootActivationEvent();
        }
        if Equals(this.masksController.m_vignetteAimOnFootEnabled, true) && NotEquals(this.masksController.m_vignetteAimOnFootActivated, true) {
          this.masksController.FrameGenGhostingFixVignetteAimOnFootActivationEvent();
        }
      }
      
      if NotEquals(this.masksController.m_upperBodyState, IntEnum<gamePSMUpperBodyStates>(6)) {
        if Equals(this.masksController.m_blockerAimOnFootEnabled, true) && Equals(this.masksController.m_blockerAimOnFootActivated, true) {
          this.masksController.FrameGenGhostingFixBlockerAimOnFootDeActivationEvent();
        }
        if Equals(this.masksController.m_vignetteAimOnFootEnabled, true) && Equals(this.masksController.m_vignetteAimOnFootActivated, true) {
          this.masksController.FrameGenGhostingFixVignetteAimOnFootDeActivationEvent();
        }
      }

      if Equals(this.masksController.m_blockerAimOnFootActivated, true) && this.masksController.m_blockerAimOnFootCurrentOpacity < this.masksController.m_blockerAimOnFootFinalOpacity {
        this.masksController.FrameGenGhostingFixBlockerAimOnFootSetTransition();
      }
      if Equals(this.masksController.m_blockerAimOnFootActivated, false) && this.masksController.m_blockerAimOnFootCurrentOpacity > this.masksController.m_blockerAimOnFootFinalOpacity {
        this.masksController.FrameGenGhostingFixBlockerAimOnFootSetTransition();
      }

      if Equals(this.masksController.m_vignetteAimOnFootActivated, true) && this.masksController.m_vignetteAimOnFootCurrentOpacity < this.masksController.m_vignetteAimOnFootFinalOpacity {
        this.masksController.FrameGenGhostingFixVignetteAimOnFootSetTransition();
      }
      if Equals(this.masksController.m_vignetteAimOnFootActivated, false) && this.masksController.m_vignetteAimOnFootCurrentOpacity > this.masksController.m_vignetteAimOnFootFinalOpacity {
        this.masksController.FrameGenGhostingFixVignetteAimOnFootSetTransition();
      }

    } else {
      if Equals(this.masksController.m_isMaskingOnFootActivated, true) {
        this.masksController.m_isMaskingOnFootActivated = false;
        this.masksController.FrameGenGhostingFixOnFootDeActivationEvent();
      }
      if Equals(this.masksController.m_masksOnFootActivated, false) && this.masksController.m_masksOnFootCurrentOpacity > this.masksController.m_masksOnFootFinalOpacity {
        this.masksController.FrameGenGhostingFixMasksOnFootSetTransition();
      }
      if Equals(this.masksController.m_vignetteOnFootActivated, false) && this.masksController.m_vignetteOnFootCurrentOpacity > this.masksController.m_vignetteOnFootFinalOpacity {
        this.masksController.FrameGenGhostingFixVignetteOnFootSetTransition();
      }
    }
  
    if NotEquals(this.masksController.m_isVehicleMountedFGGF, true) {
      this.masksController.FrameGenGhostingFixVignetteOnFootEditorToggle();
      if Equals(this.masksController.m_vignetteOnFootEditor, true) {
        this.masksController.FrameGenGhostingFixVignetteOnFootEditor();
      }
    }

    this.masksController.FrameGenGhostingFixLoop();
  }
}

// Add upper body state func ---------------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
protected cb func OnUpperBodyChanged(state: Int32) -> Bool {
  let isAiming: Bool = state == 6;
  this.m_upperBodyState = IntEnum<gamePSMUpperBodyStates>(state);
  if IsDefined(this.m_ADSAnimator) {
    this.m_ADSAnimator.OnAim(isAiming);
  };
}

// Spawn widgets ---------------------------------------------------------------------------------------
@wrapMethod(gameuiCrosshairContainerController)
protected cb func OnInitialize() -> Bool {
  wrappedMethod();
  
  // In case the widgets have been spawned already, then do nothing
  if IsDefined(this.GetChildWidgetByPath(this.m_hedCornersPath)) {
    return false;
  }
  if IsDefined(this.GetChildWidgetByPath(this.m_hedFillPath)) {
    return false;
  }
  if IsDefined(this.GetChildWidgetByPath(this.m_hedTrackerPath)) {
    return false;
  }
  if IsDefined(this.GetChildWidgetByPath(this.m_mask1Path)) {
    return false;
  }
  if IsDefined(this.GetChildWidgetByPath(this.m_mask2Path)) {
    return false;
  }
  if IsDefined(this.GetChildWidgetByPath(this.m_mask3Path)) {
    return false;
  }
  if IsDefined(this.GetChildWidgetByPath(this.m_mask4Path)) {
    return false;
  }
  if IsDefined(this.GetChildWidgetByPath(this.m_maskEditor1Path)) {
    return false;
  }
  if IsDefined(this.GetChildWidgetByPath(this.m_maskEditor2Path)) {
    return false;
  }
  if IsDefined(this.GetChildWidgetByPath(n"fgfix/cornerDownLeftOnFoot")) {
    return false;
  }
  if IsDefined(this.GetChildWidgetByPath(n"fgfix/cornerDownRightOnFoot")) {
    return false;
  }
  if IsDefined(this.GetChildWidgetByPath(n"fgfix/vignetteOnFoot")) {
    return false;
  }
  if IsDefined(this.GetChildWidgetByPath(n"fgfix/blockerAimOnFoot")) {
    return false;
  }
  if IsDefined(this.GetChildWidgetByPath(n"fgfix/vignetteAimOnFoot")) {
    return false;
  }
  if IsDefined(this.GetChildWidgetByPath(n"fgfix/vignetteOnFoot_editor")) {
    return false;
  }

  let root = this.GetRootCompoundWidget();
  let fgfixcars = this.SpawnFromExternal(root, r"base\\gameplay\\gui\\widgets\\fgfixcars\\fgfixcars.inkwidget", n"Root") as inkCompoundWidget;
  fgfixcars.SetName(n"fgfixcars");

  let fgfix = this.SpawnFromExternal(root, r"base\\gameplay\\gui\\widgets\\fgfix\\fgfix.inkwidget", n"Root") as inkCompoundWidget;
  fgfix.SetName(n"fgfix");

  let hedDeactivationEvent: ref<FrameGenGhostingFixDeactivationHEDVehicleEvent>;
  this.OnFrameGenGhostingFixDeactivationHEDVehicleEvent(hedDeactivationEvent);

  let masksDeactivationEvent: ref<FrameGenGhostingFixDeactivationMasksVehicleEvent>;
  this.OnFrameGenGhostingFixDeactivationMasksVehicleEvent(masksDeactivationEvent);
}

@wrapMethod(gameuiCrosshairContainerController)
protected cb func OnUninitialize() -> Bool {
  wrappedMethod();

  let playerPuppet: ref<GameObject> = this.GetPlayerControlledObject();
  GameInstance.GetDelaySystem(playerPuppet.GetGame()).CancelCallback(this.m_onFootLoopID);
}

// The kick off ---------------------------------------------------------------------------------------
@wrapMethod(gameuiCrosshairContainerController)
protected cb func OnPlayerAttach(playerGameObject: ref<GameObject>) -> Bool {
  wrappedMethod(playerGameObject);

  this.m_playerStateMachineBB = this.GetBlackboardSystem().GetLocalInstanced(playerGameObject.GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
  if IsDefined(this.m_playerStateMachineBB) {
    this.m_playerStateMachineUpperBodyBBID = this.m_playerStateMachineBB.RegisterDelayedListenerInt(GetAllBlackboardDefs().PlayerStateMachine.UpperBody, this, n"OnUpperBodyChanged");
  };

  this.FrameGenGhostingFixLoop();
  this.FrameGenGhostingFixMasksOnFootSetMarginsToggleEvent();
  this.FrameGenGhostingFixVignetteOnFootSetDimensions();
  this.FrameGenGhostingFixVignetteAimOnFootToggleEvent();
  this.FrameGenGhostingFixAimOnFootSetDimensionsToggleEvent();
  this.FrameGenGhostingFixAimOnFootSetDimensions();

  // LogChannel(n"DEBUG", s"On Foot Loop initialized...");
}

@wrapMethod(gameuiCrosshairContainerController)
protected cb func OnPlayerDetach(playerGameObject: ref<GameObject>) -> Bool {
  wrappedMethod(playerGameObject);

  if IsDefined(this.m_playerStateMachineBB) {
    this.m_playerStateMachineBB.UnregisterDelayedListener(GetAllBlackboardDefs().PlayerStateMachine.UpperBody, this.m_playerStateMachineUpperBodyBBID);
  };
}