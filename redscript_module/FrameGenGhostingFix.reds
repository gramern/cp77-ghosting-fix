// Thanks to djkovrik for redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

//FrameGen Ghosting 'Fix' 2.11 for FSR3 Mods, 2024 gramern (scz_g)

//Global toggle---------------------------------------------------------------------------------------
public class FrameGenGhostingFixToggleEvent extends Event {}
//CET add-on customization---------------------------------------------------------------------------------------
public class FrameGenGhostingFixFPPCarSideMirrorToggleEvent extends Event {}
public class FrameGenGhostingFixFPPBikeELGEEvent extends Event {}
public class FrameGenGhostingFixFPPBikeELGEOFFEvent extends Event {}
//Car camera change---------------------------------------------------------------------------------------
public class FrameGenGhostingFixDumboCameraTPPCarEvent extends Event {}
public class FrameGenGhostingFixDumboCameraTPPFarCarEvent extends Event {}
public class FrameGenGhostingFixDumboCameraTPPCarFasterEvent extends Event {}
public class FrameGenGhostingFixDumboCameraTPPCarSlowEvent extends Event {}
public class FrameGenGhostingFixDumboCameraTPPFarCarSlowEvent extends Event {}
public class FrameGenGhostingFixDumboCameraTPPCarCrawlEvent extends Event {}
public class FrameGenGhostingFixDumboCameraTPPFarCarCrawlEvent extends Event {}
public class FrameGenGhostingFixDumboCameraFPPCarSlowEvent extends Event {}
//Bike camera change---------------------------------------------------------------------------------------
public class FrameGenGhostingFixDumboCameraTPPBikeEvent extends Event {}
public class FrameGenGhostingFixDumboCameraTPPBikeFasterEvent extends Event {}
public class FrameGenGhostingFixDumboCameraTPPBikeSlowEvent extends Event {}
public class FrameGenGhostingFixDumboCameraTPPBikeCrawlEvent extends Event {}
public class FrameGenGhostingFixDumboCameraTPPFarBikeEvent extends Event {}
public class FrameGenGhostingFixDumboCameraTPPFarBikeSlowEvent extends Event {}
public class FrameGenGhostingFixDumboCameraTPPFarBikeCrawlEvent extends Event {}
public class FrameGenGhostingFixDumboCameraFPPBikeEvent extends Event {}
public class FrameGenGhostingFixDumboCameraFPPBikeFasterEvent extends Event {}
public class FrameGenGhostingFixDumboCameraFPPBikeSlowEvent extends Event {}
public class FrameGenGhostingFixDumboCameraFPPBikeCrawlEvent extends Event {}
//Vehicles with weapon---------------------------------------------------------------------------------------
public class FrameGenGhostingFixWeaponCarEvent extends Event{}
//Vehicles masks deacitvation---------------------------------------------------------------------------------------
public class FrameGenGhostingFixDumboDeActivationVehicleEvent extends Event {}
public class FrameGenGhostingFixDumboDeActivationVehicleToggleEvent extends Event {}
//Dynamic masks on foot---------------------------------------------------------------------------------------
public class FrameGenGhostingFixDumboActivationFootEvent extends Event {}
public class FrameGenGhostingFixDumboDeActivationFootEvent extends Event {}
public class FrameGenGhostingFixActivationFootEvent extends Event {}
public class FrameGenGhostingFixDeActivationFootEvent extends Event {}
public class FrameGenGhostingFixActivationFootAmplifyEvent extends Event {}
public class FrameGenGhostingFixDeActivationFootPhaseOneEvent extends Event {}
public class FrameGenGhostingFixDeActivationFootPhaseTwoEvent extends Event {}
public class FrameGenGhostingFixDeActivationFootPhaseThreeEvent extends Event {}
public class FrameGenGhostingFixDeActivationFootPhaseFourEvent extends Event {}
public class FrameGenGhostingFixDeActivationFootPhaseFiveEvent extends Event {}
//Setting an input listener for a player's inputs---------------------------------------------------------------------------------------
public class FrameGenGhostingFixInputListener {


    private let m_uiSystem: ref<UISystem>;

    public func SetUISystem(system: ref<UISystem>) -> Void {
      this.m_uiSystem = system;
    }

    protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
      if ListenerAction.IsAction(action, n"FrameGenGhostingFixToggle") && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED) {
        this.m_uiSystem.QueueEvent(new FrameGenGhostingFixToggleEvent());
      };
      if ListenerAction.IsAction(action, n"FrameGenGhostingFixOnFootCameraMoveR") && Equals(ListenerAction.GetType(action), gameinputActionType.RELATIVE_CHANGE) {
        this.m_uiSystem.QueueEvent(new FrameGenGhostingFixActivationFootEvent());
        this.m_uiSystem.QueueEvent(new FrameGenGhostingFixWeaponCarEvent());
      };
      if ListenerAction.IsAction(action, n"FrameGenGhostingFixOnFootCameraMoveA") && Equals(ListenerAction.GetType(action), gameinputActionType.AXIS_CHANGE) {
        this.m_uiSystem.QueueEvent(new FrameGenGhostingFixActivationFootEvent());
        this.m_uiSystem.QueueEvent(new FrameGenGhostingFixWeaponCarEvent());
      };
    }
}

@addField(PlayerPuppet)
private let m_frameGenGhostingFixInputListener: ref<FrameGenGhostingFixInputListener>;

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  wrappedMethod();

    this.m_frameGenGhostingFixInputListener = new FrameGenGhostingFixInputListener();
    this.m_frameGenGhostingFixInputListener.SetUISystem(GameInstance.GetUISystem(this.GetGame()));
    this.RegisterInputListener(this.m_frameGenGhostingFixInputListener);
}

@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
  wrappedMethod();
	
    this.UnregisterInputListener(this.m_frameGenGhostingFixInputListener);
    this.m_frameGenGhostingFixInputListener = null;
}

// @wrapMethod(EquipmentSystemPlayerData)
// func OnRestored() -> Void {
//     wrappedMethod();
//     LogChannel(n"DEBUG", "FrameGenGhostingFix Redscript Module loaded!");
// }