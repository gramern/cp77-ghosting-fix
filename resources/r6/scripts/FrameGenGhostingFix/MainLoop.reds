//Thanks to djkovrik and psiberx for help and redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. JackHumbert for the Let There Be Flight mod I took bike parts names from. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

//FrameGen Ghosting 'Fix' 4.8.0, 2024 gramern (scz_g) 2024

@addField(IronsightGameController) public let m_onFootLoopID: DelayID;

//The main loop---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
public func FrameGenGhostingFixLoop() {

  let playerPuppet: ref<GameObject> = this.GetPlayerControlledObject();
  let onFootCallback = new FrameGenGhostingFixLoopCallback();
  onFootCallback.masksController = this;
  
  this.m_onFootLoopID = GameInstance.GetDelaySystem(playerPuppet.GetGame()).DelayCallback(onFootCallback, 0.1);
}

public class FrameGenGhostingFixLoopCallback extends DelayCallback {

  public let masksController: wref<IronsightGameController>;

  public func Call() -> Void {

    this.masksController.FrameGenGhostingFixHasWeapon();
    // LogChannel(n"DEBUG", s"\(this.masksController.m_upperBodyState)");

    if Equals(this.masksController.m_isWeaponDrawn,true) {
      if Equals(this.masksController.m_isMaskingOnFootActivated,false) {
        this.masksController.m_isMaskingOnFootActivated = true;
        this.masksController.FrameGenGhostingFixOnFootActivationEvent();
      }
      if Equals(this.masksController.m_masksOnFootActivated,true) && this.masksController.m_masksOnFootCurrentOpacity < this.masksController.m_masksOnFootFinalOpacity {
        this.masksController.FrameGenGhostingFixMasksOnFootSetTransition();
      }
      if Equals(this.masksController.m_vignetteOnFootActivated,true) && this.masksController.m_vignetteOnFootCurrentOpacity < this.masksController.m_vignetteOnFootFinalOpacity {
        this.masksController.FrameGenGhostingFixVignetteOnFootSetTransition();
      }

      this.masksController.FrameGenGhostingFixBlockerAimOnFootToggleEvent();
      this.masksController.FrameGenGhostingFixVignetteAimOnFootToggleEvent();

      if Equals(this.masksController.m_upperBodyState,IntEnum<gamePSMUpperBodyStates>(6)) {
        if Equals(this.masksController.m_blockerAimOnFootEnabled,true) && NotEquals(this.masksController.m_blockerAimOnFootActivated,true) {
          this.masksController.FrameGenGhostingFixBlockerAimOnFootActivationEvent();
        }
        if Equals(this.masksController.m_vignetteAimOnFootEnabled,true) && NotEquals(this.masksController.m_vignetteAimOnFootActivated,true) {
          this.masksController.FrameGenGhostingFixVignetteAimOnFootActivationEvent();
        }
      }
      
      if NotEquals(this.masksController.m_upperBodyState,IntEnum<gamePSMUpperBodyStates>(6)) {
        if Equals(this.masksController.m_blockerAimOnFootEnabled,true) && Equals(this.masksController.m_blockerAimOnFootActivated,true) {
          this.masksController.FrameGenGhostingFixBlockerAimOnFootDeActivationEvent();
        }
        if Equals(this.masksController.m_vignetteAimOnFootEnabled,true) && Equals(this.masksController.m_vignetteAimOnFootActivated,true) {
          this.masksController.FrameGenGhostingFixVignetteAimOnFootDeActivationEvent();
        }
      }

      if Equals(this.masksController.m_blockerAimOnFootActivated,true) && this.masksController.m_blockerAimOnFootCurrentOpacity < this.masksController.m_blockerAimOnFootFinalOpacity {
        this.masksController.FrameGenGhostingFixBlockerAimOnFootSetTransition();
      }
      if Equals(this.masksController.m_blockerAimOnFootActivated,false) && this.masksController.m_blockerAimOnFootCurrentOpacity > this.masksController.m_blockerAimOnFootFinalOpacity {
        this.masksController.FrameGenGhostingFixBlockerAimOnFootSetTransition();
      }

      if Equals(this.masksController.m_vignetteAimOnFootActivated,true) && this.masksController.m_vignetteAimOnFootCurrentOpacity < this.masksController.m_vignetteAimOnFootFinalOpacity {
        this.masksController.FrameGenGhostingFixVignetteAimOnFootSetTransition();
      }
      if Equals(this.masksController.m_vignetteAimOnFootActivated,false) && this.masksController.m_vignetteAimOnFootCurrentOpacity > this.masksController.m_vignetteAimOnFootFinalOpacity {
        this.masksController.FrameGenGhostingFixVignetteAimOnFootSetTransition();
      }

    } else {
      if Equals(this.masksController.m_isMaskingOnFootActivated,true) {
        this.masksController.m_isMaskingOnFootActivated = false;
        this.masksController.FrameGenGhostingFixOnFootDeActivationEvent();
      }
      if Equals(this.masksController.m_masksOnFootActivated,false) && this.masksController.m_masksOnFootCurrentOpacity > this.masksController.m_masksOnFootFinalOpacity {
        this.masksController.FrameGenGhostingFixMasksOnFootSetTransition();
      }
      if Equals(this.masksController.m_vignetteOnFootActivated,false) && this.masksController.m_vignetteOnFootCurrentOpacity > this.masksController.m_vignetteOnFootFinalOpacity {
        this.masksController.FrameGenGhostingFixVignetteOnFootSetTransition();
      }
    }
  
    if NotEquals(this.masksController.m_isVehicleMountedFGGF,true) {
      this.masksController.FrameGenGhostingFixVignetteOnFootEditorToggle();
      if Equals(this.masksController.m_vignetteOnFootEditor,true) {
        this.masksController.FrameGenGhostingFixVignetteOnFootEditor();
      }
    }  

    this.masksController.FrameGenGhostingFixLoop();
  }
}

@wrapMethod(IronsightGameController)
protected cb func OnUninitialize() -> Bool {
  wrappedMethod();

  let playerPuppet: ref<GameObject> = this.GetPlayerControlledObject();
  GameInstance.GetDelaySystem(playerPuppet.GetGame()).CancelCallback(this.m_onFootLoopID);
}

//The kick off---------------------------------------------------------------------------------------
@wrapMethod(IronsightGameController)
protected cb func OnPlayerAttach(playerGameObject: ref<GameObject>) -> Bool {
  wrappedMethod(playerGameObject);

  this.FrameGenGhostingFixLoop();
  this.FrameGenGhostingFixMasksOnFootSetMarginsToggleEvent();
  this.FrameGenGhostingFixVignetteOnFootSetDimensions();
  this.FrameGenGhostingFixVignetteAimOnFootToggleEvent();
  this.FrameGenGhostingFixAimOnFootSetDimensionsToggleEvent();
  this.FrameGenGhostingFixAimOnFootSetDimensions();

  // LogChannel(n"DEBUG", s"On Foot Loop initialized...");
}

@wrapMethod(IronsightGameController)
protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);

  GameInstance.GetDelaySystem(playerPuppet.GetGame()).CancelCallback(this.m_onFootLoopID);
}