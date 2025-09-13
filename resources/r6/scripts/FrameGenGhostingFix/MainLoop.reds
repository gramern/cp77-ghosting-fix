// Thanks to djkovrik and psiberx for help and redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. JackHumbert for the Let There Be Flight mod I took bike parts names from. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

// FrameGen Ghosting 'Fix' 5.2.7, 2025 gramern (scz_g), 2025 danyalzia (omniscient)

// -------------
// The main loop
// -------------
public class FrameGenGhostingFixDelayCallback extends DelayCallback {

  public let controller: wref<frameGenGhostingFixMasksController>;

  // This is the callback function that must be implemented
  // https://nativedb.red4ext.com/c/7940738922432226
  public func Call() -> Void {

    this.controller.FrameGenGhostingFixHasWeapon();
    // LogChannel(n"DEBUG", s"\(this.controller.m_upperBodyState)");

    this.controller.FrameGenGhostingFixVignetteOnFootToggle(false);
    this.controller.FrameGenGhostingFixVignetteOnFootPermamentToggle(false);

    if Equals(this.controller.m_vignetteOnFootPermamentEnabled, true) && NotEquals(this.controller.m_isVehicleMounted, true) {
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
          // LogChannel(n"DEBUG", s"BlockerOnAim: Activation");
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

      if NotEquals(this.controller.m_vignetteOnFootPermamentEnabled, true) && NotEquals(this.controller.m_isVehicleMounted, true) {
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
      if Equals(this.controller.m_isVehicleMounted, true) && this.controller.m_vignetteOnFootCurrentOpacity > this.controller.m_vignetteOnFootFinalOpacity {
        this.controller.FrameGenGhostingFixVignetteOnFootSetTransition();
        // LogChannel(n"DEBUG", s"Vignette: Deactivation on MountingEvent.");
        // LogChannel(n"DEBUG", s"\(this.controller.m_vignetteOnFootCurrentOpacity), \(this.controller.m_vignetteOnFootFinalOpacity), \(this.controller.m_vignetteOnFootChangeOpacityBy)");
      }
    }
  
    if NotEquals(this.controller.m_isVehicleMounted, true) {
      this.controller.FrameGenGhostingFixVignetteOnFootEditorContext(false);
      if Equals(this.controller.m_vignetteOnFootEditor, true) {
        this.controller.FrameGenGhostingFixVignetteOnFootEditor();
      }
    }

    // Our main callback function
    this.controller.FrameGenGhostingFixCallback();
  }
}