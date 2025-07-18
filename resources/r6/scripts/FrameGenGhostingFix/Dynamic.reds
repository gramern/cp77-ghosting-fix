// Thanks to djkovrik and psiberx for help and redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. JackHumbert for the Let There Be Flight mod I took bike parts names from. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

// FrameGen Ghosting 'Fix' 5.2.5, 2024 gramern (scz_g), 2024 danyalzia (omniscient)

@if(ModuleExists("Codeware"))
import Codeware.UI.*

// -----------------
// Get widgets scale
// -----------------
@if(ModuleExists("Codeware"))
@addMethod(inkGameController)
protected cb func FrameGenFrameGenGhostingFixGetWidgetsScale() -> Vector2 {

  let scale: Vector2;

  let playerPuppet: ref<GameObject> = this.GetPlayerControlledObject();
  let screenResolution = ScreenHelper.GetScreenSize(playerPuppet.GetGame());
  let screenAspectRatio = screenResolution.X / screenResolution.Y;

  if screenAspectRatio < 2.2 {
    scale = new Vector2(screenResolution.X / 3840.0, screenResolution.X / 3840.0);
  } else {
    scale = new Vector2(screenResolution.Y / 2160.0, screenResolution.Y / 2160.0);
  }

  // LogChannel(n"DEBUG", s"Screen Resolution: \(screenResolution.X), \(screenResolution.Y)");
  // LogChannel(n"DEBUG", s"Masks scaling: \(scale.X), \(scale.Y)");

  return scale;
}

@if(!ModuleExists("Codeware"))
@addMethod(inkGameController)
protected cb func FrameGenFrameGenGhostingFixGetWidgetsScale() -> Vector2 {

  let scale: Vector2;

  let playerPuppet: ref<GameObject> = this.GetPlayerControlledObject();
  let settings = GameInstance.GetSettingsSystem(playerPuppet.GetGame());
  let screenResolutionConfigVar = settings.GetVar(n"/video/display", n"Resolution") as ConfigVarListString;
  let screenDimensions = StrSplit(screenResolutionConfigVar.GetValue(), "x");
  let screenResolution = new Vector2(StringToFloat(screenDimensions[0]), StringToFloat(screenDimensions[1]));
  let screenAspectRatio = screenResolution.X / screenResolution.Y;

  if screenAspectRatio < 2.2 {
    scale = new Vector2(screenResolution.X / 3840.0, screenResolution.X / 3840.0);
  } else {
    scale = new Vector2(screenResolution.Y / 2160.0, screenResolution.Y / 2160.0);
  }

  // LogChannel(n"DEBUG", s"Screen Resolution: \(screenResolution.X), \(screenResolution.Y)");
  // LogChannel(n"DEBUG", s"Masks scaling: \(scale.X), \(scale.Y)");

  return scale;
}

// -------------
// Scale widgets
// -------------
@if(ModuleExists("Codeware"))
@addMethod(inkGameController)
protected cb func OnFrameGenGhostingFixScaleWidgetsEvent(evt: ref<FrameGenGhostingFixScaleWidgetsEvent>) -> Void {
  
  if this.IsA(n"gameuiRootHudGameController") {
    let inkSystem = GameInstance.GetInkSystem();
    let hudRoot = inkSystem.GetLayer(n"inkHUDLayer").GetVirtualWindow();
    let fgfix: ref<inkWidget> = hudRoot.GetWidget(n"FrameGenGhostingFixMasks") as inkWidget;

    if IsDefined(fgfix) {
      let scale = this.FrameGenFrameGenGhostingFixGetWidgetsScale();
      fgfix.SetScale(scale);

      // LogChannel(n"DEBUG", s"Masks are scaled for the screen.");
    }
  }
}

@if(!ModuleExists("Codeware"))
@addMethod(inkGameController)
protected cb func OnFrameGenGhostingFixScaleWidgetsEvent(evt: ref<FrameGenGhostingFixScaleWidgetsEvent>) -> Void {
  
  if this.IsA(n"gameuiRootHudGameController") {
    
    let hudRoot: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let fgfix: ref<inkWidget> = hudRoot.GetWidget(n"FrameGenGhostingFixMasks") as inkWidget;

    if IsDefined(fgfix) {
      let scale = this.FrameGenFrameGenGhostingFixGetWidgetsScale();
      fgfix.SetScale(scale);

      // LogChannel(n"DEBUG", s"Masks are scaled for the screen.");
    }
  }
}

// -------------
// Spawn widgets
// -------------
@if(ModuleExists("Codeware"))
@addMethod(inkGameController)
protected cb func OnFrameGenGhostingFixSpawnWidgets(evt: ref<FrameGenGhostingFixSpawnWidgetsEvent>) -> Bool {

  if this.IsA(n"gameuiRootHudGameController") {

    let inkSystem = GameInstance.GetInkSystem();
    let hudRoot = inkSystem.GetLayer(n"inkHUDLayer").GetVirtualWindow();

    if !IsDefined(hudRoot.GetWidget(n"FrameGenGhostingFixMasks")) {

      // LogChannel(n"DEBUG", s"Codeware is installed. Alternative methods for widgets spawning and scaling have been added.");

      let fgfix = this.SpawnFromExternal(hudRoot, r"base\\gameplay\\gui\\widgets\\fgfix\\fgfix.inkwidget", n"Root:frameGenGhostingFixMasksController") as inkCompoundWidget;
      fgfix.SetName(n"FrameGenGhostingFixMasks");
      fgfix.SetAnchor(inkEAnchor.Centered);
      fgfix.SetAnchorPoint(0.5, 0.5);
      let scale = this.FrameGenFrameGenGhostingFixGetWidgetsScale();
      fgfix.SetScale(scale);

      // LogChannel(n"DEBUG", s"Spawning masks...");
  
      // if IsDefined(hudRoot.GetWidget(n"FrameGenGhostingFixMasks")) {
      //   LogChannel(n"DEBUG", s"Masks spawned.");
      // }
    }
  }
}

@if(!ModuleExists("Codeware"))
@addMethod(inkGameController)
protected cb func OnFrameGenGhostingFixSpawnWidgets(evt: ref<FrameGenGhostingFixSpawnWidgetsEvent>) -> Bool {

  if this.IsA(n"gameuiRootHudGameController") {

    let hudRoot: ref<inkCompoundWidget> = this.GetRootCompoundWidget();

    if !IsDefined(hudRoot.GetWidget(n"FrameGenGhostingFixMasks")) {

      // LogChannel(n"DEBUG", s"Codeware isn't installed. Standard methods for widgets spawning and scaling have been added.");

      let fgfix = this.SpawnFromExternal(hudRoot, r"base\\gameplay\\gui\\widgets\\fgfix\\fgfix.inkwidget", n"Root:frameGenGhostingFixMasksController") as inkCompoundWidget;
      fgfix.SetName(n"FrameGenGhostingFixMasks");
      fgfix.SetAnchor(inkEAnchor.Centered);
      fgfix.SetAnchorPoint(0.5, 0.5);
      let scale = this.FrameGenFrameGenGhostingFixGetWidgetsScale();
      fgfix.SetScale(scale);

      // LogChannel(n"DEBUG", s"Spawning masks...");
  
      // if IsDefined(hudRoot.GetWidget(n"FrameGenGhostingFixMasks")) {
      //   LogChannel(n"DEBUG", s"Masks spawned.");
      // }
    }
  }
}

// ------------
// The kick off
// ------------
@wrapMethod(gameuiCrosshairContainerController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);

  let spawnWidgets: ref<FrameGenGhostingFixSpawnWidgetsEvent>;
  spawnWidgets = new FrameGenGhostingFixSpawnWidgetsEvent();
  GameInstance.GetUISystem(playerPuppet.GetGame()).QueueEvent(spawnWidgets);
  // LogChannel(n"DEBUG", s"Masks spawning initialized...");

  let masksController: wref<frameGenGhostingFixMasksController>;

  masksController.OnPlayerAttach(playerPuppet);
}

@wrapMethod(gameuiCrosshairContainerController)
protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
  wrappedMethod(playerPuppet);

  let masksController: wref<frameGenGhostingFixMasksController>;

  masksController.OnPlayerDetach(playerPuppet);
}