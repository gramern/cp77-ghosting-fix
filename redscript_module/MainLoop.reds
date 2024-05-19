//Thanks to djkovrik and psiberx for help and redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

//FrameGen Ghosting 'Fix' 4.1.0, 2024 gramern (scz_g) 2024

//The main loop---------------------------------------------------------------------------------------
@addMethod(IronsightGameController)
public func FrameGenGhostingFixLoop() {
  let playerPuppet: ref<GameObject> = this.GetPlayerControlledObject();
  let onFootCallback = new FrameGenGhostingFixLoopCallback();
  onFootCallback.ironsightController = this;
  this.m_onFootLoopID = GameInstance.GetDelaySystem(playerPuppet.GetGame()).DelayCallback(onFootCallback, 0.1);
}

public class FrameGenGhostingFixLoopCallback extends DelayCallback {

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

      this.ironsightController.FrameGenGhostingFixBlockerAimOnFootToggleEvent();
      this.ironsightController.FrameGenGhostingFixVignetteAimOnFootToggleEvent();

      if Equals(this.ironsightController.m_upperBodyState,IntEnum<gamePSMUpperBodyStates>(6)) {
        if Equals(this.ironsightController.m_blockerAimOnFootEnabled,true) && NotEquals(this.ironsightController.m_blockerAimOnFootActivated,true) {
          this.ironsightController.FrameGenGhostingFixBlockerAimOnFootActivationEvent();
        }
        if Equals(this.ironsightController.m_vignetteAimOnFootEnabled,true) && NotEquals(this.ironsightController.m_vignetteAimOnFootActivated,true) {
          this.ironsightController.FrameGenGhostingFixVignetteAimOnFootActivationEvent();
        }
      }
      
      if NotEquals(this.ironsightController.m_upperBodyState,IntEnum<gamePSMUpperBodyStates>(6)) {
        if Equals(this.ironsightController.m_blockerAimOnFootEnabled,true) && Equals(this.ironsightController.m_blockerAimOnFootActivated,true) {
          this.ironsightController.FrameGenGhostingFixBlockerAimOnFootDeActivationEvent();
        }
        if Equals(this.ironsightController.m_vignetteAimOnFootEnabled,true) && Equals(this.ironsightController.m_vignetteAimOnFootActivated,true) {
          this.ironsightController.FrameGenGhostingFixVignetteAimOnFootDeActivationEvent();
        }
      }

      if Equals(this.ironsightController.m_blockerAimOnFootActivated,true) && this.ironsightController.m_blockerAimOnFootCurrentOpacity < this.ironsightController.m_blockerAimOnFootFinalOpacity {
        this.ironsightController.FrameGenGhostingFixBlockerAimOnFootSetTransition();
      }
      if Equals(this.ironsightController.m_blockerAimOnFootActivated,false) && this.ironsightController.m_blockerAimOnFootCurrentOpacity > this.ironsightController.m_blockerAimOnFootFinalOpacity {
        this.ironsightController.FrameGenGhostingFixBlockerAimOnFootSetTransition();
      }

      if Equals(this.ironsightController.m_vignetteAimOnFootActivated,true) && this.ironsightController.m_vignetteAimOnFootCurrentOpacity < this.ironsightController.m_vignetteAimOnFootFinalOpacity {
        this.ironsightController.FrameGenGhostingFixVignetteAimOnFootSetTransition();
      }
      if Equals(this.ironsightController.m_vignetteAimOnFootActivated,false) && this.ironsightController.m_vignetteAimOnFootCurrentOpacity > this.ironsightController.m_vignetteAimOnFootFinalOpacity {
        this.ironsightController.FrameGenGhostingFixVignetteAimOnFootSetTransition();
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
  
    if NotEquals(this.ironsightController.m_isVehicleMountedFGGF,true) {
      this.ironsightController.FrameGenGhostingFixVignetteOnFootEditorToggle();
      if Equals(this.ironsightController.m_vignetteOnFootEditor,true) {
        this.ironsightController.FrameGenGhostingFixVignetteOnFootEditor();
      }
    }  

    this.ironsightController.FrameGenGhostingFixLoop();
  }
}

//The kick off---------------------------------------------------------------------------------------
@wrapMethod(IronsightGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);

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