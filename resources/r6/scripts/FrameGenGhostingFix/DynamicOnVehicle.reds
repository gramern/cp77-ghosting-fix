// Thanks to djkovrik and psiberx for help and redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. JackHumbert for the Let There Be Flight mod I took bike parts names from. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

// FrameGen Ghosting 'Fix' 5.2.5, 2024 gramern (scz_g), 2024 danyalzia (omniscient)

@addField(DriveEvents) public let m_carCameraContextFGGF: vehicleCameraPerspective;
@addField(DriveEvents) public let m_bikeCameraContextFGGF: vehicleCameraPerspective;
@addField(DriveEvents) public let m_vehicleCurrentTypeFGGF: gamedataVehicleType;
@addField(DriveEvents) public let m_vehicleCurrentSpeedFGGF: Float;
@addField(DriveEvents) public let m_vehicleCurrentSpeedCallbackFGGF: ref<CallbackHandle>;

@addField(DriverCombatEvents) public let m_carCameraContextFGGF: vehicleCameraPerspective;
@addField(DriverCombatEvents) public let m_bikeCameraContextFGGF: vehicleCameraPerspective;
@addField(DriverCombatEvents) public let m_vehicleCurrentTypeFGGF: gamedataVehicleType;
@addField(DriverCombatEvents) public let m_vehicleCurrentSpeedFGGF: Float;
@addField(DriverCombatEvents) public let m_vehicleCurrentSpeedCallbackFGGF: ref<CallbackHandle>;

// Setting context for vehicles masks start here ---------------------------------------------------------------------------------------
@addMethod(DriveEvents)
protected final func OnFrameGenGhostingFixVehicleSpeedChange(speed: Float) -> Void {
  this.m_vehicleCurrentSpeedFGGF = speed;
}

@addMethod(DriveEvents)
public final func FrameGenGhostingFixDeactivationHedVehicle(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let vehicleDeactivation: ref<FrameGenGhostingFixDeactivationHEDVehicleEvent>;

  vehicleDeactivation = new FrameGenGhostingFixDeactivationHEDVehicleEvent();

  scriptInterface.executionOwner.QueueEvent(vehicleDeactivation);
}

@addMethod(DriveEvents)
public final func FrameGenGhostingFixDeactivationMasksVehicle(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let vehicleDeactivation: ref<FrameGenGhostingFixDeactivationMasksVehicleEvent>;

  vehicleDeactivation = new FrameGenGhostingFixDeactivationMasksVehicleEvent();

  scriptInterface.executionOwner.QueueEvent(vehicleDeactivation);
}

@addMethod(DriveEvents)
public final func FrameGenGhostingFixOnVehicleMounted(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let vehicleMounting: ref<FrameGenGhostingFixOnVehicleMountedEvent>;

  vehicleMounting = new FrameGenGhostingFixOnVehicleMountedEvent();

  scriptInterface.executionOwner.QueueEvent(vehicleMounting);
}

@addMethod(DriveEvents)
public final func FrameGenGhostingFixOnVehicleUnmounted(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let vehicleMounting: ref<FrameGenGhostingFixOnVehicleUnmountedEvent>;

  vehicleMounting = new FrameGenGhostingFixOnVehicleUnmountedEvent();

  scriptInterface.executionOwner.QueueEvent(vehicleMounting);
}

@addMethod(DriveEvents)
protected final func FrameGenGhostingFixMaskChange(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let vehicleBlackboard: wref<IBlackboard>;

  if !IsDefined(this.m_vehicleCurrentSpeedCallbackFGGF) {
    vehicleBlackboard = (scriptInterface.owner as VehicleObject).GetBlackboard();
    this.m_vehicleCurrentSpeedCallbackFGGF = vehicleBlackboard.RegisterListenerFloat(GetAllBlackboardDefs().Vehicle.SpeedValue, this, n"OnFrameGenGhostingFixVehicleSpeedChange");
  }

  let vehicleType_Record: ref<VehicleType_Record> = TweakDBInterface.GetVehicleRecord((scriptInterface.owner as VehicleObject).GetRecordID()).Type();
  this.m_vehicleCurrentTypeFGGF = vehicleType_Record.Type();
}

@wrapMethod(DriveEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  this.FrameGenGhostingFixMaskChange(scriptInterface);
}

// Setting context for car masks start here ---------------------------------------------------------------------------------------
@addMethod(DriveEvents)
public final func FrameGenGhostingFixCarCameraChange(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraFPPEvent: ref<FrameGenGhostingFixCameraFPPCarEvent>;
  let cameraTPPEvent: ref<FrameGenGhostingFixCameraTPPCarEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPEvent = new FrameGenGhostingFixCameraFPPCarEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPEvent);
      // LogChannel(n"DEBUG", "Car camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.TPPClose:
      cameraTPPEvent = new FrameGenGhostingFixCameraTPPCarEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.TPPMedium:
      cameraTPPEvent = new FrameGenGhostingFixCameraTPPCarEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPMedium mode.");
      break;
    case vehicleCameraPerspective.TPPFar:
      cameraTPPEvent = new FrameGenGhostingFixCameraTPPCarEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPFar mode.");
      break;
    default:
      break;
  }
}

// Setting context for bike masks start here ---------------------------------------------------------------------------------------
@addMethod(DriveEvents)
public final func FrameGenGhostingFixBikeCameraChange(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraFPPBikeEvent: ref<FrameGenGhostingFixCameraFPPBikeEvent>;
  let cameraTPPBikeEvent: ref<FrameGenGhostingFixCameraTPPBikeEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPBikeEvent = new FrameGenGhostingFixCameraFPPBikeEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPBikeEvent);
      // LogChannel(n"DEBUG", "Bike camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.TPPClose:
      cameraTPPBikeEvent = new FrameGenGhostingFixCameraTPPBikeEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.TPPMedium:
      cameraTPPBikeEvent = new FrameGenGhostingFixCameraTPPBikeEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPMedium mode.");
      break;
    case vehicleCameraPerspective.TPPFar:
      cameraTPPBikeEvent = new FrameGenGhostingFixCameraTPPBikeEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPFar mode.");
      break;
    default:
      break;
  }
}

@wrapMethod(DriveEvents)
public final func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);

  let vehicleTypeRecord: ref<VehicleType_Record> = TweakDBInterface.GetVehicleRecord((scriptInterface.owner as VehicleObject).GetRecordID()).Type();
  this.m_vehicleCurrentTypeFGGF = vehicleTypeRecord.Type();

  switch(this.m_vehicleCurrentTypeFGGF) {
    case gamedataVehicleType.Bike:
      this.FrameGenGhostingFixBikeCameraChange(scriptInterface, this.m_bikeCameraContextFGGF);
      break;
    case gamedataVehicleType.Car:
      this.FrameGenGhostingFixCarCameraChange(scriptInterface, this.m_carCameraContextFGGF);
      break;
    default:
      break;
  }

  this.FrameGenGhostingFixOnVehicleMounted(scriptInterface);
}

@wrapMethod(DriveEvents)
public final func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  this.FrameGenGhostingFixOnVehicleUnmounted(scriptInterface);
  this.FrameGenGhostingFixDeactivationMasksVehicle(scriptInterface);
  // LogChannel(n"DEBUG", "Deactivating masks...");
}

@wrapMethod(DriveEvents)
public final func OnForcedExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  this.FrameGenGhostingFixOnVehicleUnmounted(scriptInterface);
  this.FrameGenGhostingFixDeactivationHedVehicle(scriptInterface);
  this.FrameGenGhostingFixDeactivationMasksVehicle(scriptInterface);
  // LogChannel(n"DEBUG", "Deactivating masks...");
}

// Setting context for vehicles masks while in combat starts here ---------------------------------------------------------------------------------------
@addMethod(DriverCombatEvents)
protected final func OnFrameGenGhostingFixVehicleSpeedChange(speed: Float) -> Void {
  this.m_vehicleCurrentSpeedFGGF = speed;
}

@addMethod(DriverCombatEvents)
public final func FrameGenGhostingFixDeactivationHedVehicle(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let vehicleDeactivation: ref<FrameGenGhostingFixDeactivationHEDVehicleEvent>;

  vehicleDeactivation = new FrameGenGhostingFixDeactivationHEDVehicleEvent();

  scriptInterface.executionOwner.QueueEvent(vehicleDeactivation);
}

@addMethod(DriverCombatEvents)
public final func FrameGenGhostingFixDeactivationMasksVehicle(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let vehicleDeactivation: ref<FrameGenGhostingFixDeactivationMasksVehicleEvent>;

  vehicleDeactivation = new FrameGenGhostingFixDeactivationMasksVehicleEvent();

  scriptInterface.executionOwner.QueueEvent(vehicleDeactivation);
}

@addMethod(DriverCombatEvents)
public final func FrameGenGhostingFixOnVehicleMounted(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let vehicleMounting: ref<FrameGenGhostingFixOnVehicleMountedEvent>;

  vehicleMounting = new FrameGenGhostingFixOnVehicleMountedEvent();

  scriptInterface.executionOwner.QueueEvent(vehicleMounting);
}

@addMethod(DriverCombatEvents)
public final func FrameGenGhostingFixOnVehicleUnmounted(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let vehicleMounting: ref<FrameGenGhostingFixOnVehicleUnmountedEvent>;

  vehicleMounting = new FrameGenGhostingFixOnVehicleUnmountedEvent();

  scriptInterface.executionOwner.QueueEvent(vehicleMounting);
}

@addMethod(DriverCombatEvents)
protected final func FrameGenGhostingFixMaskChange(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let vehicleBlackboard: wref<IBlackboard>;

  if !IsDefined(this.m_vehicleCurrentSpeedCallbackFGGF) {
    vehicleBlackboard = (scriptInterface.owner as VehicleObject).GetBlackboard();
    this.m_vehicleCurrentSpeedCallbackFGGF = vehicleBlackboard.RegisterListenerFloat(GetAllBlackboardDefs().Vehicle.SpeedValue, this, n"OnFrameGenGhostingFixVehicleSpeedChange");
  }

  let vehicleType_Record: ref<VehicleType_Record> = TweakDBInterface.GetVehicleRecord((scriptInterface.owner as VehicleObject).GetRecordID()).Type();
  this.m_vehicleCurrentTypeFGGF = vehicleType_Record.Type();
}

@wrapMethod(DriverCombatEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  this.FrameGenGhostingFixMaskChange(scriptInterface);
}

// Setting context for car masks while in combat starts here ---------------------------------------------------------------------------------------
@addMethod(DriverCombatEvents)
public final func FrameGenGhostingFixCarCameraChange(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraFPPEvent: ref<FrameGenGhostingFixCameraFPPCarEvent>;
  let cameraTPPEvent: ref<FrameGenGhostingFixCameraTPPCarEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPEvent = new FrameGenGhostingFixCameraFPPCarEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPEvent);
      // LogChannel(n"DEBUG", "Car camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.DriverCombatClose:
      cameraTPPEvent = new FrameGenGhostingFixCameraTPPCarEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.DriverCombatMedium:
      cameraTPPEvent = new FrameGenGhostingFixCameraTPPCarEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPMedium mode.");
      break;
    case vehicleCameraPerspective.DriverCombatFar:
      cameraTPPEvent = new FrameGenGhostingFixCameraTPPCarEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPEvent);
      // LogChannel(n"DEBUG", "Car camera is in TPPFar mode.");
      break;
    default:
      break;
  }
}

// Setting context for bike masks while in combat starts here ---------------------------------------------------------------------------------------
@addMethod(DriverCombatEvents)
public final func FrameGenGhostingFixBikeCameraChange(scriptInterface: ref<StateGameScriptInterface>, perspective: vehicleCameraPerspective) -> Void {

  let cameraFPPBikeEvent: ref<FrameGenGhostingFixCameraFPPBikeEvent>;
  let cameraTPPBikeEvent: ref<FrameGenGhostingFixCameraTPPBikeEvent>;

  switch((scriptInterface.owner as VehicleObject).GetCameraManager().GetActivePerspective()) {
    case vehicleCameraPerspective.FPP:
      cameraFPPBikeEvent = new FrameGenGhostingFixCameraFPPBikeEvent();
      scriptInterface.executionOwner.QueueEvent(cameraFPPBikeEvent);
      // LogChannel(n"DEBUG", "Bike camera is in FPP mode.");
      break;
    case vehicleCameraPerspective.DriverCombatClose:
      cameraTPPBikeEvent = new FrameGenGhostingFixCameraTPPBikeEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPClose mode.");
      break;
    case vehicleCameraPerspective.DriverCombatMedium:
      cameraTPPBikeEvent = new FrameGenGhostingFixCameraTPPBikeEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPMedium mode.");
      break;
    case vehicleCameraPerspective.DriverCombatFar:
      cameraTPPBikeEvent = new FrameGenGhostingFixCameraTPPBikeEvent();
      scriptInterface.executionOwner.QueueEvent(cameraTPPBikeEvent);
      // LogChannel(n"DEBUG", "Bike camera is in TPPFar mode.");
      break;
    default:
      break;
  }
}

@wrapMethod(DriverCombatEvents)
public final func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(timeDelta, stateContext, scriptInterface);

  let vehicleTypeRecord: ref<VehicleType_Record> = TweakDBInterface.GetVehicleRecord((scriptInterface.owner as VehicleObject).GetRecordID()).Type();
  this.m_vehicleCurrentTypeFGGF = vehicleTypeRecord.Type();

  switch(this.m_vehicleCurrentTypeFGGF) {
    case gamedataVehicleType.Bike:
      this.FrameGenGhostingFixBikeCameraChange(scriptInterface, this.m_bikeCameraContextFGGF);
      break;
    case gamedataVehicleType.Car:
      this.FrameGenGhostingFixCarCameraChange(scriptInterface, this.m_carCameraContextFGGF);
      break;
    default:
      break;
  }

  this.FrameGenGhostingFixOnVehicleMounted(scriptInterface);
}

@wrapMethod(DriverCombatEvents)
public final func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  this.FrameGenGhostingFixOnVehicleUnmounted(scriptInterface);
  this.FrameGenGhostingFixDeactivationMasksVehicle(scriptInterface);
  // LogChannel(n"DEBUG", "Deactivating masks...");
}

@wrapMethod(DriverCombatEvents)
public final func OnForcedExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);

  this.FrameGenGhostingFixOnVehicleUnmounted(scriptInterface);
  this.FrameGenGhostingFixDeactivationHedVehicle(scriptInterface);
  this.FrameGenGhostingFixDeactivationMasksVehicle(scriptInterface);
  // LogChannel(n"DEBUG", "Deactivating masks...");
}