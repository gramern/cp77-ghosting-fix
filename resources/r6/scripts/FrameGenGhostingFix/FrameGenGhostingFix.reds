// Thanks to djkovrik and psiberx for help and redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. JackHumbert for the Let There Be Flight mod I took bike parts names from. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

// FrameGen Ghosting 'Fix' 5.1.12, 2024 gramern (scz_g), 2024 danyalzia (omniscient)

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
// Vehicles mounting events -----------------------------------------------------------------------------
public class FrameGenGhostingFixOnVehicleMountedEvent extends Event {}
public class FrameGenGhostingFixOnVehicleUnmountedEvent extends Event {}

// Custom masks controller wref -------------------------------------------------------------------------------------------
@addField(NewHudPhoneGameController) public let m_masksController: wref<frameGenGhostingFixMasksController>;

//------------------------
// Custom masks controller
//------------------------
public class frameGenGhostingFixMasksController extends inkGameController {

  // Main loop's delayID -------------------------------------------------------------------------------------------
  private let m_delayID: DelayID;

  // // Player states -------------------------------------------------------------------------------------------
  private let m_upperBodyState: gamePSMUpperBodyStates;
  private let m_playerStateMachineBB: wref<IBlackboard>;
  private let m_playerStateMachineUpperBodyBBID: ref<CallbackHandle>;

  // On-foot -------------------------------------------------------------------------------------------
  private let m_cornerDownLeftPath: CName = n"cornerDownLeftOnFoot";
  private let m_cornerDownRightPath: CName = n"cornerDownRightOnFoot";
  private let m_blockerAimPath: CName = n"blockerAimOnFoot";
  private let m_vignetteAimPath: CName = n"vignetteAimOnFoot";
  private let m_vignettePath: CName = n"vignetteOnFoot";
  private let m_vignetteEditorPath: CName = n"vignetteOnFoot_editor";

  private let m_cornersOnFootEnabled: Bool = false;
  private let m_blockerAimOnFootEnabled: Bool = false;
  private let m_vignetteAimOnFootEnabled: Bool = false;
  private let m_vignetteOnFootEnabled: Bool = false;
  private let m_vignetteOnFootPermamentEnabled: Bool = false;

  private let m_isWeaponDrawn: Bool;

  // private let m_isMaskingOnFootActivated: Bool = false;
  private let m_cornersOnFootActivated: Bool = false;
  private let m_blockerAimOnFootActivated: Bool = false;
  private let m_vignetteAimOnFootActivated: Bool = false;
  private let m_vignetteOnFootActivated: Bool = false;

  private let m_onFootMaxOpacity: Float = 0.02;
  private let m_onFootChangeOpacityBy: Float = 0.005;
  private let m_cornersOnFootChangeOpacityBy: Float;
  private let m_cornersOnFootCurrentOpacity: Float;
  private let m_cornersOnFootFinalOpacity: Float;
  private let m_blockerAimOnFootChangeOpacityBy: Float;
  private let m_blockerAimOnFootCurrentOpacity: Float;
  private let m_blockerAimOnFootFinalOpacity: Float;
  private let m_vignetteAimOnFootChangeOpacityBy: Float;
  private let m_vignetteAimOnFootCurrentOpacity: Float;
  private let m_vignetteAimOnFootFinalOpacity: Float;
  private let m_vignetteOnFootChangeOpacityBy: Float;
  private let m_vignetteOnFootCurrentOpacity: Float;
  private let m_vignetteOnFootFinalOpacity: Float;

  private let m_cornerDownLeftMargin: Float;
  private let m_cornerDownRightMargin: Float;
  private let m_cornerDownMarginTop: Float;
  private let m_aimOnFootSizeX: Float;
  private let m_aimOnFootSizeY: Float;
  private let m_vignetteOnFootMarginLeft: Float;
  private let m_vignetteOnFootMarginTop: Float;
  private let m_vignetteOnFootSizeX: Float;
  private let m_vignetteOnFootSizeY: Float;

  private let m_vignetteOnFootEditor: Bool = false;

  // Vehicles -------------------------------------------------------------------------------------------
  private let m_isMaskingInVehiclesEnabled: Bool = true;
  private let m_isVehicleMounted: Bool = false;
  private let m_hedCornersPath: CName = n"horizontaledgedowncorners";
  private let m_hedFillPath: CName = n"horizontaledgedownfill";
  private let m_hedTrackerPath: CName = n"horizontaledgedowntracker";
  private let m_mask1Path: CName = n"mask1";
  private let m_mask2Path: CName = n"mask2";
  private let m_mask3Path: CName = n"mask3";
  private let m_mask4Path: CName = n"mask4";

  // Methods -------------------------------------------------------------------------------------------
  protected cb func OnCreate() {}

  protected cb func OnInitialize() {}

  protected cb func OnUninitialize() {}

  protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {

    this.m_playerStateMachineBB = this.GetBlackboardSystem().GetLocalInstanced(playerPuppet.GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    if IsDefined(this.m_playerStateMachineBB) {
      this.m_playerStateMachineUpperBodyBBID = this.m_playerStateMachineBB.RegisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.UpperBody, this, n"OnUpperBodyChanged");
    };

    let hedDeactivationEvent: ref<FrameGenGhostingFixDeactivationHEDVehicleEvent>;
    this.OnFrameGenGhostingFixDeactivationHEDVehicleEvent(hedDeactivationEvent);

    let masksDeactivationEvent: ref<FrameGenGhostingFixDeactivationMasksVehicleEvent>;
    this.OnFrameGenGhostingFixDeactivationMasksVehicleEvent(masksDeactivationEvent);

    this.FrameGenGhostingFixCallback();
    this.FrameGenGhostingFixOpacityOnFootToggle(0.02, 0.005);
    this.FrameGenGhostingFixMasksOnFootSetMarginsToggle(0.0, 3840.0, 2160.0);
    this.FrameGenGhostingFixAimOnFootSetDimensionsToggle(3840.0, 2440.0);
    this.FrameGenGhostingFixVignetteOnFootSetDimensionsToggle(1920.0, 1080.0, 4840.0, 2560.0);

    // ------------
    // OnPlayerAttach debug check
    // ------------
    LogChannel(n"DEBUG", s"Opacity for on foot masks set: \(this.m_onFootMaxOpacity), \(this.m_onFootChangeOpacityBy)");
    LogChannel(n"DEBUG", s"Margins for on foot corner masks set: \(this.m_cornerDownLeftMargin), \(this.m_cornerDownRightMargin), \(this.m_cornerDownMarginTop)");
    LogChannel(n"DEBUG", s"Dimensions for on aim masks set: \(this.m_aimOnFootSizeX), \(this.m_aimOnFootSizeY)");
    LogChannel(n"DEBUG", s"Margins for on foot vignette set: \(this.m_vignetteOnFootMarginLeft), \(this.m_vignetteOnFootMarginTop)");
    LogChannel(n"DEBUG", s"Dimensions for on foot vignette set: \(this.m_vignetteOnFootSizeX), \(this.m_vignetteOnFootSizeY)");

    this.FrameGenGhostingFixCornersOnFootToggle(false);
    this.FrameGenGhostingFixBlockerAimOnFootToggle(false);
    this.FrameGenGhostingFixVignetteAimOnFootToggle(false);
    this.FrameGenGhostingFixVignetteOnFootToggle(false);
    this.FrameGenGhostingFixVignetteOnFootPermamentToggle(false);
    LogChannel(n"DEBUG", s"Corner masks enabled: \(this.m_cornersOnFootEnabled)");
    LogChannel(n"DEBUG", s"Blocker on aim enabled: \(this.m_blockerAimOnFootEnabled)");
    LogChannel(n"DEBUG", s"Vignette on aim enabled: \(this.m_vignetteAimOnFootEnabled)");
    LogChannel(n"DEBUG", s"Vignette on weapon enabled: \(this.m_vignetteOnFootEnabled)");
    LogChannel(n"DEBUG", s"Vignette permament enabled: \(this.m_vignetteOnFootPermamentEnabled)");
    LogChannel(n"DEBUG", s"Main Loop initialized...");
  }

  protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {

    if IsDefined(this.m_playerStateMachineBB) {
      this.m_playerStateMachineBB.UnregisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.UpperBody, this.m_playerStateMachineUpperBodyBBID);
    };

    let playerPuppet: ref<GameObject> = this.GetPlayerControlledObject();
    GameInstance.GetDelaySystem(playerPuppet.GetGame()).CancelCallback(this.m_delayID);
  }

  // // ----------------------
  // // Track upper body state
  // // ----------------------
  // // Parts of it are taken from IronsighGameController's OnUpperBodyChanged
  // // https://nativedb.red4ext.com/c/1313336034427012
  protected cb func OnUpperBodyChanged(state: Int32) -> Bool {

    this.m_upperBodyState = IntEnum<gamePSMUpperBodyStates>(state);

    // LogChannel(n"DEBUG", s"\(this.m_upperBodyState)");
  }

  public func FrameGenGhostingFixCallback() {
    // LogChannel(n"DEBUG", s"DelayCallback function fired...");

    let playerPuppet: ref<GameObject> = this.GetPlayerControlledObject();
    let delayCallback = new FrameGenGhostingFixDelayCallback();
    delayCallback.controller = this;
    
    // Call it every 0.1 seconds
    this.m_delayID = GameInstance.GetDelaySystem(playerPuppet.GetGame()).DelayCallback(delayCallback, 0.1);
  }

  // Masks set transformation methods ------------------------------------------------------------------------
  private cb func FrameGenGhostingFixSetTransformation(path: CName, margin: Vector2, size: Vector2, rotation: Float, shear: Vector2, anchorPoint: Vector2, opacity: Float, visible: Bool) -> Bool {

    if NotEquals(this.m_isMaskingInVehiclesEnabled, false) {
      let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
      let mask: ref<inkWidget> = root.GetWidgetByPathName(path) as inkWidget;

      if NotEquals(visible, mask.IsVisible()) {
        mask.SetVisible(visible);
      }

      if Equals(visible, true) {
        let currentMargin = mask.GetMargin();
        mask.SetMargin(margin.X, margin.Y, currentMargin.right, currentMargin.bottom);
        mask.SetSize(size);
        mask.SetRotation(rotation);
        mask.SetShear(shear);
        mask.SetAnchorPoint(anchorPoint);

        if opacity != mask.GetOpacity() {
          mask.SetOpacity(opacity);
        }
      }
    }
  }

  private cb func FrameGenGhostingFixSetSimpleTransformation(path: CName, margin: Vector2, size: Vector2, opacity: Float, visible: Bool) -> Bool {

    if NotEquals(this.m_isMaskingInVehiclesEnabled, false) {
      let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
      let mask: ref<inkWidget> = root.GetWidgetByPathName(path) as inkWidget;

      if NotEquals(visible, mask.IsVisible()) {
        mask.SetVisible(visible);
      }

      if Equals(visible, true) {
        let currentMargin = mask.GetMargin();
        mask.SetMargin(margin.X, margin.Y, currentMargin.right, currentMargin.bottom);
        mask.SetSize(size);

        if opacity != mask.GetOpacity() {
          mask.SetOpacity(opacity);
        }
      }
    }
  }

  //--------
  // On-foot
  //--------
  protected cb func FrameGenGhostingFixCornersOnFootSetTransition() -> Bool {

    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let cornerDownLeftOnFoot: ref<inkWidget> = root.GetWidgetByPathName(this.m_cornerDownLeftPath) as inkWidget;
    let cornerDownRightOnFoot: ref<inkWidget> = root.GetWidgetByPathName(this.m_cornerDownRightPath) as inkWidget;

    this.m_cornersOnFootCurrentOpacity = this.m_cornersOnFootCurrentOpacity + this.m_cornersOnFootChangeOpacityBy;
    cornerDownLeftOnFoot.SetOpacity(this.m_cornersOnFootCurrentOpacity);
    cornerDownRightOnFoot.SetOpacity(this.m_cornersOnFootCurrentOpacity);

    // LogChannel(n"DEBUG", s"this.m_cornersOnFootCurrentOpacity = \(this.m_cornersOnFootCurrentOpacity)");
    // LogChannel(n"DEBUG", s"cornerDownLeftOnFoot.GetOpacity() = \(cornerDownLeftOnFoot.GetOpacity())");
    // LogChannel(n"DEBUG", s"cornerDownRightOnFoot.GetOpacity() = \(cornerDownRightOnFoot.GetOpacity())");
  }

  protected cb func FrameGenGhostingFixMasksOnFootSetMargins() -> Bool {

    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let cornerDownLeftOnFoot: ref<inkWidget> = root.GetWidgetByPathName(this.m_cornerDownLeftPath) as inkWidget;
    let cornerDownRightOnFoot: ref<inkWidget> = root.GetWidgetByPathName(this.m_cornerDownRightPath) as inkWidget;

    let cornerDownLeftOnFootMargin = cornerDownLeftOnFoot.GetMargin();
    cornerDownLeftOnFoot.SetMargin(this.m_cornerDownLeftMargin, this.m_cornerDownMarginTop, cornerDownLeftOnFootMargin.right, cornerDownLeftOnFootMargin.bottom);

    let cornerDownRightOnFootMargin = cornerDownRightOnFoot.GetMargin();
    cornerDownRightOnFoot.SetMargin(this.m_cornerDownRightMargin, this.m_cornerDownMarginTop, cornerDownRightOnFootMargin.right, cornerDownRightOnFootMargin.bottom);
  }

  private cb func FrameGenGhostingFixMasksOnFootSetMarginsToggle(cornerDownLeftMargin: Float, cornerDownRightMargin: Float, cornerDownMarginTop: Float) -> Void {
    
    this.m_cornerDownLeftMargin = cornerDownLeftMargin;
    this.m_cornerDownRightMargin = cornerDownRightMargin;
    this.m_cornerDownMarginTop = cornerDownMarginTop;
    this.FrameGenGhostingFixMasksOnFootSetMargins();
  }

  // Aiming on foot dimension transition functions ---------------------------------------------------------------------------------------
  protected cb func FrameGenGhostingFixAimOnFootSetDimensions() -> Bool {

    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let blockerAimOnFoot: ref<inkWidget> = root.GetWidgetByPathName(this.m_blockerAimPath) as inkWidget;
    let vignetteAimOnFoot: ref<inkWidget> = root.GetWidgetByPathName(this.m_vignetteAimPath) as inkWidget;

    blockerAimOnFoot.SetSize(this.m_aimOnFootSizeX, this.m_aimOnFootSizeY);
    blockerAimOnFoot.Reparent(root);
    vignetteAimOnFoot.SetSize(this.m_aimOnFootSizeX, this.m_aimOnFootSizeY);
    vignetteAimOnFoot.Reparent(root);

    // LogChannel(n"DEBUG", s"vignetteOnFoot.GetOpacity() = \(vignetteAimOnFoot.GetSize())");
  }

  protected cb func FrameGenGhostingFixAimOnFootSetDimensionsToggle(aimOnFootSizeX: Float, aimOnFootSizeY: Float) -> Bool {

    this.m_aimOnFootSizeX = aimOnFootSizeX;
    this.m_aimOnFootSizeY = aimOnFootSizeY;
    this.FrameGenGhostingFixAimOnFootSetDimensions();
  }

  // Aiming on foot transitions functions ---------------------------------------------------------------------------------------
  protected cb func FrameGenGhostingFixVignetteAimOnFootSetTransition() -> Bool {

    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let vignetteAimOnFoot: ref<inkWidget> = root.GetWidgetByPathName(this.m_vignetteAimPath) as inkWidget;

    this.m_vignetteAimOnFootCurrentOpacity = this.m_vignetteAimOnFootCurrentOpacity + this.m_vignetteAimOnFootChangeOpacityBy;
    vignetteAimOnFoot.SetOpacity(this.m_vignetteAimOnFootCurrentOpacity);

    // LogChannel(n"DEBUG", s"this.m_vignetteAimOnFootCurrentOpacity = \(this.m_vignetteAimOnFootCurrentOpacity)");
    // LogChannel(n"DEBUG", s"vignetteAimOnFoot.GetOpacity() = \(vignetteAimOnFoot.GetOpacity())");
  }

  protected cb func FrameGenGhostingFixBlockerAimOnFootSetTransition() -> Bool {

    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let blockerAimOnFoot: ref<inkWidget> = root.GetWidgetByPathName(this.m_blockerAimPath) as inkWidget;

    this.m_blockerAimOnFootCurrentOpacity = this.m_blockerAimOnFootCurrentOpacity + this.m_blockerAimOnFootChangeOpacityBy;
    blockerAimOnFoot.SetOpacity(this.m_blockerAimOnFootCurrentOpacity);

  //   LogChannel(n"DEBUG", s"this.m_blockerAimOnFootCurrentOpacity = \(this.m_blockerAimOnFootCurrentOpacity)");
  //   LogChannel(n"DEBUG", s"blockerAimOnFoot.GetOpacity() = \(blockerAimOnFoot.GetOpacity())");
  }

  // Vignette dimensions transition functions ---------------------------------------------------------------------------------------
  protected cb func FrameGenGhostingFixVignetteOnFootSetDimensions() -> Bool {

    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let vignetteOnFoot: ref<inkWidget> = root.GetWidgetByPathName(this.m_vignettePath) as inkWidget;

    let vignetteOnFootMargin = vignetteOnFoot.GetMargin();
    vignetteOnFoot.SetMargin(this.m_vignetteOnFootMarginLeft, this.m_vignetteOnFootMarginTop, vignetteOnFootMargin.right, vignetteOnFootMargin.bottom);

    vignetteOnFoot.SetSize(this.m_vignetteOnFootSizeX, this.m_vignetteOnFootSizeY);
    vignetteOnFoot.Reparent(root);
  }

  protected cb func FrameGenGhostingFixVignetteOnFootSetDimensionsToggle(vignetteOnFootMarginLeft: Float, vignetteOnFootMarginTop: Float, vignetteOnFootSizeX: Float, vignetteOnFootSizeY: Float) -> Bool {

    this.m_vignetteOnFootMarginLeft = vignetteOnFootMarginLeft;
    this.m_vignetteOnFootMarginTop = vignetteOnFootMarginTop;
    this.m_vignetteOnFootSizeX = vignetteOnFootSizeX;
    this.m_vignetteOnFootSizeY = vignetteOnFootSizeY;
    this.FrameGenGhostingFixVignetteOnFootSetDimensions();
  }

  // Vignette opacity transition functions ---------------------------------------------------------------------------------------
  protected cb func FrameGenGhostingFixVignetteOnFootSetTransition() -> Bool {

    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let vignetteOnFoot: ref<inkWidget> = root.GetWidgetByPathName(this.m_vignettePath) as inkWidget;

    this.m_vignetteOnFootCurrentOpacity = this.m_vignetteOnFootCurrentOpacity + this.m_vignetteOnFootChangeOpacityBy;
    vignetteOnFoot.SetOpacity(this.m_vignetteOnFootCurrentOpacity);

    // LogChannel(n"DEBUG", s"this.m_vignetteOnFootCurrentOpacity = \(this.m_vignetteOnFootCurrentOpacity)");
    // LogChannel(n"DEBUG", s"vignetteOnFoot.GetOpacity() = \(vignetteOnFoot.GetOpacity())");
  }

  // Vignette editor context ---------------------------------------------------------------------------------------
  protected cb func FrameGenGhostingFixVignetteOnFootEditor() -> Bool {

    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let vignetteOnFoot_editor: ref<inkWidget> = root.GetWidgetByPathName(this.m_vignetteEditorPath) as inkWidget;

    let opacity = this.m_onFootMaxOpacity * 20.0;
    vignetteOnFoot_editor.SetOpacity(opacity);

    let vignetteOnFoot_editorMargin = vignetteOnFoot_editor.GetMargin();
    vignetteOnFoot_editor.SetMargin(this.m_vignetteOnFootMarginLeft, this.m_vignetteOnFootMarginTop, vignetteOnFoot_editorMargin.right, vignetteOnFoot_editorMargin.bottom);

    vignetteOnFoot_editor.SetSize(this.m_vignetteOnFootSizeX, this.m_vignetteOnFootSizeY);
    vignetteOnFoot_editor.Reparent(root);
  }

  protected cb func FrameGenGhostingFixVignetteOnFootEditorTurnOff() -> Bool {

    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let vignetteOnFoot_editor: ref<inkWidget> = root.GetWidgetByPathName(this.m_vignetteEditorPath) as inkWidget;

    vignetteOnFoot_editor.SetOpacity(0.0);
  }

  private cb func FrameGenGhostingFixVignetteOnFootEditorContext(vignetteOnFootEditor: Bool) -> Void {
    this.m_vignetteOnFootEditor = vignetteOnFootEditor;
  }

  // Toggle masks on foot opacity ---------------------------------------------------------------------------------------
  protected final func FrameGenGhostingFixOpacityOnFootToggle(maxOpacity: Float, changeStep: Float) -> Void {
    this.m_onFootMaxOpacity = maxOpacity;
    this.m_onFootChangeOpacityBy = changeStep;
  }

  // Activate corner masks on foot ---------------------------------------------------------------------------------------
  protected final func FrameGenGhostingFixCornersOnFootToggle(cornersOnFoot: Bool) -> Void {
    this.m_cornersOnFootEnabled = cornersOnFoot;
  }

  // Activate vignette for aiming ---------------------------------------------------------------------------------------
  protected final func FrameGenGhostingFixVignetteAimOnFootToggle(vignetteAimOnFoot: Bool) -> Void {
    this.m_vignetteAimOnFootEnabled = vignetteAimOnFoot;
  }

  // Activate blocker for aiming ---------------------------------------------------------------------------------------
  protected final func FrameGenGhostingFixBlockerAimOnFootToggle(blockerAimOnFoot: Bool) -> Void {
    this.m_blockerAimOnFootEnabled = blockerAimOnFoot;
  }

  // Activate main vignette ---------------------------------------------------------------------------------------
  protected final func FrameGenGhostingFixVignetteOnFootToggle(vignetteOnFoot: Bool) -> Void {
    this.m_vignetteOnFootEnabled = vignetteOnFoot;
  }

  // Turn off deactivation of main vignette without weapon---------------------------------------------------------------------------------------
  protected final func FrameGenGhostingFixVignetteOnFootPermamentToggle(vignetteOnFootPermament: Bool) -> Void {
    this.m_vignetteOnFootPermamentEnabled = vignetteOnFootPermament;
  }

  protected cb func FrameGenGhostingFixCornersOnFootActivationEvent() -> Bool {

    if Equals(this.m_cornersOnFootEnabled, true) {
      this.m_cornersOnFootActivated = true;
      this.m_cornersOnFootCurrentOpacity = 0.0;
      this.m_cornersOnFootFinalOpacity = this.m_onFootMaxOpacity * 2.2;
      this.m_cornersOnFootChangeOpacityBy = this.m_onFootChangeOpacityBy * 2.0;
    }
  }

  protected cb func FrameGenGhostingFixCornersOnFootDeActivationEvent() -> Bool {

    this.m_cornersOnFootCurrentOpacity = this.m_onFootMaxOpacity * 2.2;
    this.m_cornersOnFootFinalOpacity = 0.0;
    this.m_cornersOnFootChangeOpacityBy = this.m_onFootChangeOpacityBy * -2.0;
    this.m_cornersOnFootActivated = false;
  }

  // Blocker onAim
  protected cb func FrameGenGhostingFixBlockerAimOnFootActivationEvent() -> Bool {

    if Equals(this.m_blockerAimOnFootEnabled, true) {
      this.m_blockerAimOnFootActivated = true;
      this.m_blockerAimOnFootCurrentOpacity = 0.0;
      this.m_blockerAimOnFootFinalOpacity = this.m_onFootMaxOpacity;
      this.m_blockerAimOnFootChangeOpacityBy = this.m_onFootChangeOpacityBy;
    }
  }

  protected cb func FrameGenGhostingFixBlockerAimOnFootDeActivationEvent() -> Bool {
    
    this.m_blockerAimOnFootCurrentOpacity = this.m_onFootMaxOpacity;
    this.m_blockerAimOnFootFinalOpacity = 0.0;
    this.m_blockerAimOnFootChangeOpacityBy = -this.m_onFootChangeOpacityBy;
    this.m_blockerAimOnFootActivated = false;
  }

  // Vignette onAim
  protected cb func FrameGenGhostingFixVignetteAimOnFootActivationEvent() -> Bool {

    if Equals(this.m_vignetteAimOnFootEnabled, true) {
      this.m_vignetteAimOnFootActivated = true;
      this.m_vignetteAimOnFootCurrentOpacity = 0.0;
      this.m_vignetteAimOnFootFinalOpacity = this.m_onFootMaxOpacity;
      this.m_vignetteAimOnFootChangeOpacityBy = this.m_onFootChangeOpacityBy;
    }
  }

  protected cb func FrameGenGhostingFixVignetteAimOnFootDeActivationEvent() -> Bool {

    this.m_vignetteAimOnFootCurrentOpacity = this.m_onFootMaxOpacity;
    this.m_vignetteAimOnFootFinalOpacity = 0.0;
    this.m_vignetteAimOnFootChangeOpacityBy = -this.m_onFootChangeOpacityBy;
    this.m_vignetteAimOnFootActivated = false;
  }

  // Vignette onWeapon/permament
  protected cb func FrameGenGhostingFixVignetteOnFootActivationEvent() -> Bool {

    if Equals(this.m_vignetteOnFootEnabled, true) {
      this.m_vignetteOnFootActivated = true;
      this.m_vignetteOnFootCurrentOpacity = 0.0;
      this.m_vignetteOnFootFinalOpacity = this.m_onFootMaxOpacity;
      this.m_vignetteOnFootChangeOpacityBy = this.m_onFootChangeOpacityBy;
    }
  }

  protected cb func FrameGenGhostingFixVignetteOnFootDeActivationEvent() -> Bool {

    this.m_vignetteOnFootCurrentOpacity = this.m_onFootMaxOpacity;
    this.m_vignetteOnFootFinalOpacity = 0.0;
    this.m_vignetteOnFootChangeOpacityBy = -this.m_onFootChangeOpacityBy;
    this.m_vignetteOnFootActivated = false;
  }

  // Weapon drawn checks ---------------------------------------------------------------------------------------
  protected final func FrameGenGhostingFixHasWeapon() -> Void {

    let playerPuppet: ref<GameObject> = this.GetPlayerControlledObject();
    let hasWeaponCheck = ScriptedPuppet.GetWeaponRight(playerPuppet);
    if hasWeaponCheck != null {
      this.m_isWeaponDrawn = true;
      // LogChannel(n"DEBUG", "V has a weapon in their right hand!");
    } else {
      this.m_isWeaponDrawn = false;
    }
  }

  //---------
  // Vehicles
  //---------
  // Mounting/unmounting events ---------------------------------------------------------------------------------------
  private cb func OnFrameGenGhostingFixMountingEvent(evt: ref<MountingEvent>) -> Bool {

    this.m_isVehicleMounted = true;
    
    if Equals(this.m_vignetteOnFootActivated, true) {
      this.FrameGenGhostingFixVignetteOnFootDeActivationEvent();
      // LogChannel(n"DEBUG", s"Vignette: Deactivation on MountingEvent.");
    }
  }

  private cb func OnFrameGenGhostingFixUnmountingEvent(evt: ref<UnmountingEvent>) -> Bool {
    
    this.m_isVehicleMounted = false;

    let hedDeactivationEvent: ref<FrameGenGhostingFixDeactivationHEDVehicleEvent>;
    this.OnFrameGenGhostingFixDeactivationHEDVehicleEvent(hedDeactivationEvent);
    
    let masksDeactivationEvent: ref<FrameGenGhostingFixDeactivationMasksVehicleEvent>;
    this.OnFrameGenGhostingFixDeactivationMasksVehicleEvent(masksDeactivationEvent);

  }

  // Additional mounting/unmounting events for earlier on-foot vignette triggering and on game state change updates ---------------------------------------------------------------------------------------
  protected cb func OnFrameGenGhostingFixOnVehicleMountedEvent(evt: ref<FrameGenGhostingFixOnVehicleMountedEvent>) -> Bool {
    
    if NotEquals(this.m_isVehicleMounted, true) {
      this.m_isVehicleMounted = true;

      if Equals(this.m_vignetteOnFootActivated, true) {
        this.FrameGenGhostingFixVignetteOnFootDeActivationEvent();
        // LogChannel(n"DEBUG", s"Vignette: Additional Deactivation on mounting event.");
      }
    }
  }

  protected cb func OnFrameGenGhostingFixOnVehicleUnmountedEvent(evt: ref<FrameGenGhostingFixOnVehicleUnmountedEvent>) -> Bool {
    
    this.m_isVehicleMounted = false;
  }

  // Global toggle for transtions, called in the main loop---------------------------------------------------------------------------------------
  protected final func FrameGenFrameGenGhostingFixVehicleToggleEvent() -> Void {
    this.FrameGenGhostingFixVehicleToggle(true);
  }

  protected final func FrameGenGhostingFixVehicleToggle(maskingInVehicles: Bool) -> Void {
    this.m_isMaskingInVehiclesEnabled = maskingInVehicles;
  }

  // Setting transformation for specific masks ---------------------------------------------------------------------------------------
  // Setting masks when changing cameras in a car ---------------------------------------------------------------------------------------
  // TPP Car ---------------------------------------------------------------------------------------
  private cb func OnFrameGenGhostingFixCameraTPPCarEvent(evt: ref<FrameGenGhostingFixCameraTPPCarEvent>) -> Bool {

    let hedMargin: Vector2 = new Vector2(1920.0, 2280.0);
    let hedSize: Vector2 = new Vector2(4240.0, 1440.0);

    this.FrameGenGhostingFixSetSimpleTransformation(this.m_hedCornersPath, hedMargin, hedSize, 0.03, true);
    this.FrameGenGhostingFixSetSimpleTransformation(this.m_hedFillPath, hedMargin, hedSize, 0.03, true);

    let hedTrackerMargin: Vector2 = new Vector2(1920.0, 1920.0);
    let hedTrackerSize: Vector2 = new Vector2(2400.0, 1200.0);
    let hedTrackerShear: Vector2 = new Vector2(0.0, 0.0);
    let hedTrackerAnchorPoint: Vector2 = new Vector2(0.5, 0.5);

    this.FrameGenGhostingFixSetTransformation(this.m_hedTrackerPath, hedTrackerMargin, hedTrackerSize, 0.0, hedTrackerShear, hedTrackerAnchorPoint, 0.0, false);

    let mask1Margin: Vector2 = new Vector2(1920.0, 2000.0);
    let mask1Size: Vector2 = new Vector2(7680.0, 1200.0);
    let mask1Shear: Vector2 = new Vector2(0.0, 0.0);
    let mask1AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

    this.FrameGenGhostingFixSetTransformation(this.m_mask1Path, mask1Margin, mask1Size, 0.0, mask1Shear, mask1AnchorPoint, 0.07, true);
    
    let mask2Margin: Vector2 = new Vector2(1920.0, 1900.0);
    let mask2Size: Vector2 = new Vector2(5120.0, 1200.0);
    let mask2Shear: Vector2 = new Vector2(0.0, 0.0);
    let mask2AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

    this.FrameGenGhostingFixSetTransformation(this.m_mask2Path, mask2Margin, mask2Size, 0.0, mask2Shear, mask2AnchorPoint, 0.07, true);

    let mask3Margin: Vector2 = new Vector2(1920.0, 1700.0);
    let mask3Size: Vector2 = new Vector2(2800.0, 1200.0);
    let mask3Shear: Vector2 = new Vector2(0.0, 0.0);
    let mask3AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

    this.FrameGenGhostingFixSetTransformation(this.m_mask3Path, mask3Margin, mask3Size, 0.0, mask3Shear, mask3AnchorPoint, 0.07, true);

    let mask4Margin: Vector2 = new Vector2(0.0, 0.0);
    let mask4Size: Vector2 = new Vector2(0.0, 0.0);
    let mask4Shear: Vector2 = new Vector2(0.0, 0.0);
    let mask4AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

    this.FrameGenGhostingFixSetTransformation(this.m_mask4Path, mask4Margin, mask4Size, 0.0, mask4Shear, mask4AnchorPoint, 0.0, false);
  }

  // FPP Car ---------------------------------------------------------------------------------------
  private cb func OnFrameGenGhostingFixCameraFPPCarEvent(evt: ref<FrameGenGhostingFixCameraFPPCarEvent>) -> Bool {

    let hedMargin: Vector2 = new Vector2(1920.0, 2280.0);
    let hedSize: Vector2 = new Vector2(4240.0, 1440.0);

    this.FrameGenGhostingFixSetSimpleTransformation(this.m_hedCornersPath, hedMargin, hedSize, 0.03, true);
    this.FrameGenGhostingFixSetSimpleTransformation(this.m_hedFillPath, hedMargin, hedSize, 0.0, true);

    let hedTrackerMargin: Vector2 = new Vector2(1920.0, 1920.0);
    let hedTrackerSize: Vector2 = new Vector2(2400.0, 1200.0);
    let hedTrackerShear: Vector2 = new Vector2(0.0, 0.0);
    let hedTrackerAnchorPoint: Vector2 = new Vector2(0.5, 0.5);

    this.FrameGenGhostingFixSetTransformation(this.m_hedTrackerPath, hedTrackerMargin, hedTrackerSize, 0.0, hedTrackerShear, hedTrackerAnchorPoint, 0.0, false);

    let mask1Margin: Vector2 = new Vector2(1920.0, 2000.0);
    let mask1Size: Vector2 = new Vector2(7680.0, 1200.0);
    let mask1Shear: Vector2 = new Vector2(0.0, 0.0);
    let mask1AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

    this.FrameGenGhostingFixSetTransformation(this.m_mask1Path, mask1Margin, mask1Size, 0.0, mask1Shear, mask1AnchorPoint, 0.0, true);
    
    let mask2Margin: Vector2 = new Vector2(1920.0, 1900.0);
    let mask2Size: Vector2 = new Vector2(5120.0, 1200.0);
    let mask2Shear: Vector2 = new Vector2(0.0, 0.0);
    let mask2AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

    this.FrameGenGhostingFixSetTransformation(this.m_mask2Path, mask2Margin, mask2Size, 0.0, mask2Shear, mask2AnchorPoint, 0.0, true);

    let mask3Margin: Vector2 = new Vector2(1920.0, 1700.0);
    let mask3Size: Vector2 = new Vector2(2800.0, 1200.0);
    let mask3Shear: Vector2 = new Vector2(0.0, 0.0);
    let mask3AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

    this.FrameGenGhostingFixSetTransformation(this.m_mask3Path, mask3Margin, mask3Size, 0.0, mask3Shear, mask3AnchorPoint, 0.0, true);
    
    let mask4Margin: Vector2 = new Vector2(0.0, 0.0);
    let mask4Size: Vector2 = new Vector2(0.0, 0.0);
    let mask4Shear: Vector2 = new Vector2(0.0, 0.0);
    let mask4AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

    this.FrameGenGhostingFixSetTransformation(this.m_mask4Path, mask4Margin, mask4Size, 0.0, mask4Shear, mask4AnchorPoint, 0.0, false);
  }

  // Setting masks when changing cameras on a bike ---------------------------------------------------------------------------------------
  // TPP Bike ---------------------------------------------------------------------------------------
  private cb func OnFrameGenGhostingFixCameraTPPBikeEvent(evt: ref<FrameGenGhostingFixCameraTPPBikeEvent>) -> Bool {

    let hedMargin: Vector2 = new Vector2(1920.0, 2280.0);
    let hedSize: Vector2 = new Vector2(4240.0, 1440.0);

    this.FrameGenGhostingFixSetSimpleTransformation(this.m_hedCornersPath, hedMargin, hedSize, 0.03, true);
    this.FrameGenGhostingFixSetSimpleTransformation(this.m_hedFillPath, hedMargin, hedSize, 0.03, true);

    let hedTrackerMargin: Vector2 = new Vector2(1920.0, 1920.0);
    let hedTrackerSize: Vector2 = new Vector2(2400.0, 1200.0);
    let hedTrackerShear: Vector2 = new Vector2(0.0, 0.0);
    let hedTrackerAnchorPoint: Vector2 = new Vector2(0.5, 0.5);

    this.FrameGenGhostingFixSetTransformation(this.m_hedTrackerPath, hedTrackerMargin, hedTrackerSize, 0.0, hedTrackerShear, hedTrackerAnchorPoint, 0.0, false);

    let mask1Margin: Vector2 = new Vector2(1920.0, 2000.0);
    let mask1Size: Vector2 = new Vector2(7680.0, 1200.0);
    let mask1Shear: Vector2 = new Vector2(0.0, 0.0);
    let mask1AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

    this.FrameGenGhostingFixSetTransformation(this.m_mask1Path, mask1Margin, mask1Size, 0.0, mask1Shear, mask1AnchorPoint, 0.07, true);
    
    let mask2Margin: Vector2 = new Vector2(1920.0, 1900.0);
    let mask2Size: Vector2 = new Vector2(5120.0, 1200.0);
    let mask2Shear: Vector2 = new Vector2(0.0, 0.0);
    let mask2AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

    this.FrameGenGhostingFixSetTransformation(this.m_mask2Path, mask2Margin, mask2Size, 0.0, mask2Shear, mask2AnchorPoint, 0.07, true);

    let mask3Margin: Vector2 = new Vector2(1920.0, 1700.0);
    let mask3Size: Vector2 = new Vector2(2800.0, 1200.0);
    let mask3Shear: Vector2 = new Vector2(0.0, 0.0);
    let mask3AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

    this.FrameGenGhostingFixSetTransformation(this.m_mask3Path, mask3Margin, mask3Size, 0.0, mask3Shear, mask3AnchorPoint, 0.07, true);
    
    let mask4Margin: Vector2 = new Vector2(0.0, 0.0);
    let mask4Size: Vector2 = new Vector2(0.0, 0.0);
    let mask4Shear: Vector2 = new Vector2(0.0, 0.0);
    let mask4AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

    this.FrameGenGhostingFixSetTransformation(this.m_mask4Path, mask4Margin, mask4Size, 0.0, mask4Shear, mask4AnchorPoint, 0.0, false);
  }

  // FPP Bike ---------------------------------------------------------------------------------------
  private cb func OnFrameGenGhostingFixCameraFPPBikeEvent(evt: ref<FrameGenGhostingFixCameraFPPBikeEvent>) -> Bool {

    let hedMargin: Vector2 = new Vector2(1920.0, 2280.0);
    let hedSize: Vector2 = new Vector2(4240.0, 1440.0);

    this.FrameGenGhostingFixSetSimpleTransformation(this.m_hedCornersPath, hedMargin, hedSize, 0.03, true);
    this.FrameGenGhostingFixSetSimpleTransformation(this.m_hedFillPath, hedMargin, hedSize, 0.03, true);

    let hedTrackerMargin: Vector2 = new Vector2(1920.0, 1920.0);
    let hedTrackerSize: Vector2 = new Vector2(2400.0, 1200.0);
    let hedTrackerShear: Vector2 = new Vector2(0.0, 0.0);
    let hedTrackerAnchorPoint: Vector2 = new Vector2(0.5, 0.5);

    this.FrameGenGhostingFixSetTransformation(this.m_hedTrackerPath, hedTrackerMargin, hedTrackerSize, 0.0, hedTrackerShear, hedTrackerAnchorPoint, 0.0, false);

    let mask1Margin: Vector2 = new Vector2(1920.0, 2000.0);
    let mask1Size: Vector2 = new Vector2(7680.0, 1200.0);
    let mask1Shear: Vector2 = new Vector2(0.0, 0.0);
    let mask1AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

    this.FrameGenGhostingFixSetTransformation(this.m_mask1Path, mask1Margin, mask1Size, 0.0, mask1Shear, mask1AnchorPoint, 0.07, true);
    
    let mask2Margin: Vector2 = new Vector2(1920.0, 1900.0);
    let mask2Size: Vector2 = new Vector2(5120.0, 1200.0);
    let mask2Shear: Vector2 = new Vector2(0.0, 0.0);
    let mask2AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

    this.FrameGenGhostingFixSetTransformation(this.m_mask2Path, mask2Margin, mask2Size, 0.0, mask2Shear, mask2AnchorPoint, 0.0, true);

    let mask3Margin: Vector2 = new Vector2(1920.0, 1700.0);
    let mask3Size: Vector2 = new Vector2(2800.0, 1200.0);
    let mask3Shear: Vector2 = new Vector2(0.0, 0.0);
    let mask3AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

    this.FrameGenGhostingFixSetTransformation(this.m_mask3Path, mask3Margin, mask3Size, 0.0, mask3Shear, mask3AnchorPoint, 0.0, true);
    
    let mask4Margin: Vector2 = new Vector2(0.0, 0.0);
    let mask4Size: Vector2 = new Vector2(0.0, 0.0);
    let mask4Shear: Vector2 = new Vector2(0.0, 0.0);
    let mask4AnchorPoint: Vector2 = new Vector2(0.5, 0.5);

    this.FrameGenGhostingFixSetTransformation(this.m_mask4Path, mask4Margin, mask4Size, 0.0, mask4Shear, mask4AnchorPoint, 0.0, false);
  }

  // Setting masks deactivation for vehicles ---------------------------------------------------------------------------------------
  protected cb func OnFrameGenGhostingFixDeactivationHEDVehicleEvent(evt: ref<FrameGenGhostingFixDeactivationHEDVehicleEvent>) -> Bool {

    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let hedCorners: ref<inkWidget> = root.GetWidgetByPathName(this.m_hedCornersPath) as inkWidget;
    let hedFill: ref<inkWidget> = root.GetWidgetByPathName(this.m_hedFillPath) as inkWidget;
    let hedTracker: ref<inkWidget> = root.GetWidgetByPathName(this.m_hedTrackerPath) as inkWidget;

    hedCorners.SetOpacity(0.0);
    hedFill.SetOpacity(0.0);
    hedTracker.SetOpacity(0.0);
  }

  protected cb func OnFrameGenGhostingFixDeactivationMasksVehicleEvent(evt: ref<FrameGenGhostingFixDeactivationMasksVehicleEvent>) -> Bool {

    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let mask1: ref<inkWidget> = root.GetWidgetByPathName(this.m_mask1Path) as inkWidget;
    let mask2: ref<inkWidget> = root.GetWidgetByPathName(this.m_mask2Path) as inkWidget;
    let mask3: ref<inkWidget> = root.GetWidgetByPathName(this.m_mask3Path) as inkWidget;
    let mask4: ref<inkWidget> = root.GetWidgetByPathName(this.m_mask4Path) as inkWidget;

    mask1.SetOpacity(0.0);
    mask2.SetOpacity(0.0);
    mask3.SetOpacity(0.0);
    mask4.SetOpacity(0.0);
  }
}

// ------------
// The kick off
// ------------
@wrapMethod(NewHudPhoneGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);

  // In case the widgets have been spawned already, then do nothing
  if IsDefined(this.m_masksController.GetChildWidgetByPath(this.m_masksController.m_hedCornersPath)) {
    return false;
  }
  if IsDefined(this.m_masksController.GetChildWidgetByPath(this.m_masksController.m_hedFillPath)) {
    return false;
  }
  if IsDefined(this.m_masksController.GetChildWidgetByPath(this.m_masksController.m_hedTrackerPath)) {
    return false;
  }
  if IsDefined(this.m_masksController.GetChildWidgetByPath(this.m_masksController.m_mask1Path)) {
    return false;
  }
  if IsDefined(this.m_masksController.GetChildWidgetByPath(this.m_masksController.m_mask2Path)) {
    return false;
  }
  if IsDefined(this.m_masksController.GetChildWidgetByPath(this.m_masksController.m_mask3Path)) {
    return false;
  }
  if IsDefined(this.m_masksController.GetChildWidgetByPath(this.m_masksController.m_mask4Path)) {
    return false;
  }
  if IsDefined(this.m_masksController.GetChildWidgetByPath(this.m_masksController.m_cornerDownLeftPath)) {
    return false;
  }
  if IsDefined(this.m_masksController.GetChildWidgetByPath(this.m_masksController.m_cornerDownRightPath)) {
    return false;
  }
  if IsDefined(this.m_masksController.GetChildWidgetByPath(this.m_masksController.m_blockerAimPath)) {
    return false;
  }
  if IsDefined(this.m_masksController.GetChildWidgetByPath(this.m_masksController.m_vignetteAimPath)) {
    return false;
  }
  if IsDefined(this.m_masksController.GetChildWidgetByPath(this.m_masksController.m_vignettePath)) {
    return false;
  }
  if IsDefined(this.m_masksController.GetChildWidgetByPath(this.m_masksController.m_vignetteEditorPath)) {
    return false;
  }

  // Spawn widgets
  let root = this.GetRootCompoundWidget();
  this.SpawnFromExternal(root, r"base\\gameplay\\gui\\widgets\\fgfix\\fgfix.inkwidget", n"Root:frameGenGhostingFixMasksController");

  this.m_masksController.OnPlayerAttach(playerPuppet);
}

@wrapMethod(NewHudPhoneGameController)
protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);

  this.m_masksController.OnPlayerDetach(playerPuppet);
}
