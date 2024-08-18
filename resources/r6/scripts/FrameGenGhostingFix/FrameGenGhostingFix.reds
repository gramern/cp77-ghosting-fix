// Thanks to djkovrik and psiberx for help and redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. JackHumbert for the Let There Be Flight mod I took bike parts names from. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

// FrameGen Ghosting 'Fix' 5.1.4, 2024 gramern (scz_g), 2024 danyalzia (omniscient)

// RedScript Modules Presence Check --------------------------------------------------------------------------------
public static func FrameGenGhostingFixIsRedScriptModule() -> Void {}
// Car camera change ---------------------------------------------------------------------------------------
public class FrameGenGhostingFixCameraTPPCarEvent extends Event {}
public class FrameGenGhostingFixCameraTPPFarCarEvent extends Event {}
public class FrameGenGhostingFixCameraFPPCarEvent extends Event {}
// Bike camera change --------------------------------------------------------------------------------------
public class FrameGenGhostingFixCameraTPPBikeEvent extends Event {}
public class FrameGenGhostingFixCameraTPPFarBikeEvent extends Event {}
public class FrameGenGhostingFixCameraFPPBikeEvent extends Event {}
// Vehicles masks deacitvation -----------------------------------------------------------------------------
public class FrameGenGhostingFixDeactivationMasksVehicleEvent extends Event {}
public class FrameGenGhostingFixDeactivationHEDVehicleEvent extends Event {}

// Delay Callback ID ---------------------------------------------------------------------------------------
@addField(gameuiCrosshairContainerController) public let m_delayID: DelayID;

// Player states -------------------------------------------------------------------------------------------
@addField(gameuiCrosshairContainerController) public let m_upperBodyState: gamePSMUpperBodyStates;
@addField(gameuiCrosshairContainerController) public let m_playerStateMachineBB: wref<IBlackboard>;
@addField(gameuiCrosshairContainerController) public let m_playerStateMachineUpperBodyBBID: ref<CallbackHandle>;

// -------------
// The main loop
// -------------
public class FrameGenGhostingFixDelayCallback extends DelayCallback {

  public let controller: wref<gameuiCrosshairContainerController>;

  // This is the callback function that must be implemented
  // https://nativedb.red4ext.com/c/7940738922432226
  public func Call() -> Void {

    this.controller.FrameGenGhostingFixHasWeapon();
    // LogChannel(n"DEBUG", s"\(this.controller.m_upperBodyState)");

    this.controller.FrameGenGhostingFixVignetteOnFootToggle(false);
    this.controller.FrameGenGhostingFixVignetteOnFootPermamentToggle(false);

    if Equals(this.controller.m_vignetteOnFootPermamentEnabled, true) && NotEquals(this.controller.m_isVehicleMountedFGGF, true) {
      if Equals(this.controller.m_vignetteOnFootEnabled, true) && NotEquals(this.controller.m_vignetteOnFootActivated, true) {
        this.controller.FrameGenGhostingFixVignetteOnFootActivationEvent();
      }
      if Equals(this.controller.m_vignetteOnFootActivated, true) && this.controller.m_vignetteOnFootCurrentOpacity < this.controller.m_vignetteOnFootFinalOpacity {
        this.controller.FrameGenGhostingFixVignetteOnFootSetTransition();
        // LogChannel(n"DEBUG", s"Vignette: Activation independent from gun.");
        // LogChannel(n"DEBUG", s"\(this.controller.m_vignetteOnFootCurrentOpacity), \(this.controller.m_vignetteOnFootFinalOpacity), \(this.controller.m_vignetteOnFootChangeOpacityBy)");
      }
    }

    if Equals(this.controller.m_isWeaponDrawn, true) {
      this.controller.FrameGenGhostingFixCornersOnFootToggle(false);
      this.controller.FrameGenGhostingFixBlockerAimOnFootToggle(false);
      this.controller.FrameGenGhostingFixVignetteAimOnFootToggle(false);

      if Equals(this.controller.m_cornersOnFootEnabled, true) && NotEquals(this.controller.m_cornersOnFootActivated, true) {
        this.controller.FrameGenGhostingFixCornersOnFootActivationEvent();
      }
      if Equals(this.controller.m_cornersOnFootActivated, true) && this.controller.m_cornersOnFootCurrentOpacity < this.controller.m_cornersOnFootFinalOpacity {
        this.controller.FrameGenGhostingFixCornersOnFootSetTransition();
      }

      if Equals(this.controller.m_upperBodyState, IntEnum<gamePSMUpperBodyStates>(6)) {
        if Equals(this.controller.m_blockerAimOnFootEnabled, true) && NotEquals(this.controller.m_blockerAimOnFootActivated, true) {
          this.controller.FrameGenGhostingFixBlockerAimOnFootActivationEvent();
        }
        if Equals(this.controller.m_vignetteAimOnFootEnabled, true) && NotEquals(this.controller.m_vignetteAimOnFootActivated, true) {
          this.controller.FrameGenGhostingFixVignetteAimOnFootActivationEvent();
        }
      } else {
        if Equals(this.controller.m_blockerAimOnFootActivated, true) {
          this.controller.FrameGenGhostingFixBlockerAimOnFootDeActivationEvent();
        }
        if Equals(this.controller.m_vignetteAimOnFootActivated, true) {
          this.controller.FrameGenGhostingFixVignetteAimOnFootDeActivationEvent();
        }
      }

      if Equals(this.controller.m_blockerAimOnFootActivated, true) && this.controller.m_blockerAimOnFootCurrentOpacity < this.controller.m_blockerAimOnFootFinalOpacity {
        this.controller.FrameGenGhostingFixBlockerAimOnFootSetTransition();
      }
      if Equals(this.controller.m_blockerAimOnFootActivated, false) && this.controller.m_blockerAimOnFootCurrentOpacity > this.controller.m_blockerAimOnFootFinalOpacity {
        this.controller.FrameGenGhostingFixBlockerAimOnFootSetTransition();
        // LogChannel(n"DEBUG", s"BlockerOnAim: Deactivation");
        // LogChannel(n"DEBUG", s"\(this.controller.m_blockerAimOnFootCurrentOpacity), \(this.controller.m_blockerAimOnFootFinalOpacity), \(this.controller.m_blockerAimOnFootChangeOpacityBy)");
      }

      if Equals(this.controller.m_vignetteAimOnFootActivated, true) && this.controller.m_vignetteAimOnFootCurrentOpacity < this.controller.m_vignetteAimOnFootFinalOpacity {
        this.controller.FrameGenGhostingFixVignetteAimOnFootSetTransition();
      }
      if Equals(this.controller.m_vignetteAimOnFootActivated, false) && this.controller.m_vignetteAimOnFootCurrentOpacity > this.controller.m_vignetteAimOnFootFinalOpacity {
        this.controller.FrameGenGhostingFixVignetteAimOnFootSetTransition();
        // LogChannel(n"DEBUG", s"VignetteOnAim: Deactivation");
        // LogChannel(n"DEBUG", s"\(this.controller.m_vignetteAimOnFootCurrentOpacity), \(this.controller.m_vignetteAimOnFootFinalOpacity), \(this.controller.m_vignetteAimOnFootChangeOpacityBy)");
      }

      if NotEquals(this.controller.m_vignetteOnFootPermamentEnabled, true) && NotEquals(this.controller.m_isVehicleMountedFGGF, true) {
        if Equals(this.controller.m_vignetteOnFootEnabled, true) && NotEquals(this.controller.m_vignetteOnFootActivated, true) {
          this.controller.FrameGenGhostingFixVignetteOnFootActivationEvent();
        }
        if Equals(this.controller.m_vignetteOnFootActivated, true) && this.controller.m_vignetteOnFootCurrentOpacity < this.controller.m_vignetteOnFootFinalOpacity {
          this.controller.FrameGenGhostingFixVignetteOnFootSetTransition();
          // LogChannel(n"DEBUG", s"Vignette: Activation with gun.");
          // LogChannel(n"DEBUG", s"\(this.controller.m_vignetteOnFootCurrentOpacity), \(this.controller.m_vignetteOnFootFinalOpacity), \(this.controller.m_vignetteOnFootChangeOpacityBy)");
        }
      }
    } else {
      if Equals(this.controller.m_cornersOnFootActivated, true) {
        this.controller.FrameGenGhostingFixCornersOnFootDeActivationEvent();
      }
      if Equals(this.controller.m_cornersOnFootActivated, false) && this.controller.m_cornersOnFootCurrentOpacity > this.controller.m_cornersOnFootFinalOpacity {
        this.controller.FrameGenGhostingFixCornersOnFootSetTransition();
        // LogChannel(n"DEBUG", s"Corners: Deactivation");
        // LogChannel(n"DEBUG", s"\(this.controller.m_cornersOnFootCurrentOpacity), \(this.controller.m_cornersOnFootFinalOpacity), \(this.controller.m_cornersOnFootChangeOpacityBy)");
      }

      if NotEquals(this.controller.m_vignetteOnFootPermamentEnabled, true) {
        if Equals(this.controller.m_vignetteOnFootActivated, true) {
          this.controller.FrameGenGhostingFixVignetteOnFootDeActivationEvent();
        }
        if Equals(this.controller.m_vignetteOnFootActivated, false) && this.controller.m_vignetteOnFootCurrentOpacity > this.controller.m_vignetteOnFootFinalOpacity {
          this.controller.FrameGenGhostingFixVignetteOnFootSetTransition();
          // LogChannel(n"DEBUG", s"Vignette: Deactivation without gun.");
          // LogChannel(n"DEBUG", s"\(this.controller.m_vignetteOnFootCurrentOpacity), \(this.controller.m_vignetteOnFootFinalOpacity), \(this.controller.m_vignetteOnFootChangeOpacityBy)");
        }
      }
      if Equals(this.controller.m_isVehicleMountedFGGF, true) && this.controller.m_vignetteOnFootCurrentOpacity > this.controller.m_vignetteOnFootFinalOpacity {
        this.controller.FrameGenGhostingFixVignetteOnFootSetTransition();
        // LogChannel(n"DEBUG", s"Vignette: Deactivation on MountingEvent.");
        // LogChannel(n"DEBUG", s"\(this.controller.m_vignetteOnFootCurrentOpacity), \(this.controller.m_vignetteOnFootFinalOpacity), \(this.controller.m_vignetteOnFootChangeOpacityBy)");
      }
    }
  
    if NotEquals(this.controller.m_isVehicleMountedFGGF, true) {
      this.controller.FrameGenGhostingFixVignetteOnFootEditorContext(false);
      if Equals(this.controller.m_vignetteOnFootEditor, true) {
        this.controller.FrameGenGhostingFixVignetteOnFootEditor();
      }
    }

    // Our main callback function
    this.controller.FrameGenGhostingFixCallback();
  }
}

@addMethod(gameuiCrosshairContainerController)
public func FrameGenGhostingFixCallback() {
  // LogChannel(n"DEBUG", s"DelayCallback function fired...");

  let playerPuppet: ref<GameObject> = this.GetPlayerControlledObject();
  let delayCallback = new FrameGenGhostingFixDelayCallback();
  delayCallback.controller = this;
  
  // Call it every 0.1 seconds
  this.m_delayID = GameInstance.GetDelaySystem(playerPuppet.GetGame()).DelayCallback(delayCallback, 0.1);
}

// ----------------------
// Track upper body state
// ----------------------
// Parts of it are taken from IronsighGameController's OnUpperBodyChanged
// https://nativedb.red4ext.com/c/1313336034427012
@addMethod(gameuiCrosshairContainerController)
protected cb func OnUpperBodyChanged(state: Int32) -> Bool {
  this.m_upperBodyState = IntEnum<gamePSMUpperBodyStates>(state);
}

// -------------
// Spawn widgets
// -------------
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
  GameInstance.GetDelaySystem(playerPuppet.GetGame()).CancelCallback(this.m_delayID);
}

// ------------
// The kick off
// ------------
@wrapMethod(gameuiCrosshairContainerController)
protected cb func OnPlayerAttach(playerGameObject: ref<GameObject>) -> Bool {
  wrappedMethod(playerGameObject);

  this.m_playerStateMachineBB = this.GetBlackboardSystem().GetLocalInstanced(playerGameObject.GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
  if IsDefined(this.m_playerStateMachineBB) {
    this.m_playerStateMachineUpperBodyBBID = this.m_playerStateMachineBB.RegisterDelayedListenerInt(GetAllBlackboardDefs().PlayerStateMachine.UpperBody, this, n"OnUpperBodyChanged");
  };

  this.FrameGenGhostingFixCallback();
  this.FrameGenGhostingFixMasksOnFootSetMarginsToggle(0.0, 3840.0, 2160.0);
  this.FrameGenGhostingFixAimOnFootSetDimensionsToggle(3840.0, 2440.0);
  this.FrameGenGhostingFixVignetteOnFootSetDimensionsToggle(1920.0, 1080.0, 4840.0, 2560.0);

  // LogChannel(n"DEBUG", s"Main Loop initialized...");
}

@wrapMethod(gameuiCrosshairContainerController)
protected cb func OnPlayerDetach(playerGameObject: ref<GameObject>) -> Bool {
  wrappedMethod(playerGameObject);

  if IsDefined(this.m_playerStateMachineBB) {
    this.m_playerStateMachineBB.UnregisterDelayedListener(GetAllBlackboardDefs().PlayerStateMachine.UpperBody, this.m_playerStateMachineUpperBodyBBID);
  };
}