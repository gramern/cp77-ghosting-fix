// Thanks to djkovrik for redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

//FrameGen Ghosting 'Fix' 2.0 for FSR3 Mods, 2024 gramern (scz_g)

//Global toggle---------------------------------------------------------------------------------------
// public class FrameGenGhostingFixToggleEvent extends Event {}
//CET add-on customization---------------------------------------------------------------------------------------
public class FrameGenGhostingFixFPPCarSideMirrorToggleEvent extends Event {}
public class FrameGenGhostingFixFPPBikeELGSettingsEvent extends Event {}
public class FrameGenGhostingFixFPPBikeELGEEvent extends Event {}
public class FrameGenGhostingFixFPPBikeELGEOFFEvent extends Event {}
//Vehicle activation---------------------------------------------------------------------------------------
// public class FrameGenGhostingFixDumboActivationVehicleEvent extends Event {}
// public class FrameGenGhostingFixDumboActivationCarEvent extends Event {}
// public class FrameGenGhostingFixDumboActivationBikeEvent extends Event {}
//Vehicle mounting---------------------------------------------------------------------------------------
public class FrameGenGhostingFixDumboEnterCarEvent extends Event {}
public class FrameGenGhostingFixDumboEnterBikeEvent extends Event {}
//Car camera change---------------------------------------------------------------------------------------
public class FrameGenGhostingFixDumboCameraTPPCarEvent extends Event {}
public class FrameGenGhostingFixDumboCameraTPPFarCarEvent extends Event {}
public class FrameGenGhostingFixDumboCameraTPPCarSlowEvent extends Event {}
public class FrameGenGhostingFixDumboCameraTPPFarCarSlowEvent extends Event {}
public class FrameGenGhostingFixDumboCameraFPPCarSlowEvent extends Event {}
//Bike camera change---------------------------------------------------------------------------------------
public class FrameGenGhostingFixDumboCameraTPPBikeEvent extends Event {}
public class FrameGenGhostingFixDumboCameraTPPFarBikeEvent extends Event {}
public class FrameGenGhostingFixDumboCameraTPPBikeSlowEvent extends Event {}
public class FrameGenGhostingFixDumboCameraTPPFarBikeSlowEvent extends Event {}
public class FrameGenGhostingFixDumboCameraFPPBikeSlowEvent extends Event {}
//Vehicles masks deacitvation---------------------------------------------------------------------------------------
public class FrameGenGhostingFixDumboDeActivationVehicleEvent extends Event {}

//Setting an input listener for a player's inputs---------------------------------------------------------------------------------------
// public class FrameGenGhostingFixInputListener {

//     private let m_uiSystem: ref<UISystem>;

//     public func SetUISystem(system: ref<UISystem>) -> Void {
//       this.m_uiSystem = system;
//     }

//     protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
//       if ListenerAction.IsAction(action, n"FrameGenGhostingFixToggle") && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED)  {
//         this.m_uiSystem.QueueEvent(new FrameGenGhostingFixToggleEvent());
//       };
//     }
// }

// @addField(PlayerPuppet)
// private let m_frameGenGhostingFixInputListener: ref<FrameGenGhostingFixInputListener>;

// @wrapMethod(PlayerPuppet)
// protected cb func OnGameAttached() -> Bool {
//     wrappedMethod();

//     this.m_frameGenGhostingFixInputListener = new FrameGenGhostingFixInputListener();
//     this.m_frameGenGhostingFixInputListener.SetUISystem(GameInstance.GetUISystem(this.GetGame()));
//     this.RegisterInputListener(this.m_frameGenGhostingFixInputListener);
// }

// @wrapMethod(PlayerPuppet)
// protected cb func OnDetach() -> Bool {
//     wrappedMethod();
	
//     this.UnregisterInputListener(this.m_frameGenGhostingFixInputListener);
//     this.m_frameGenGhostingFixInputListener = null;
// }

// @wrapMethod(EquipmentSystemPlayerData)
// func OnRestored() -> Void {
//     wrappedMethod();
//     LogChannel(n"DEBUG", "FrameGenGhostingFix Redscript Module loaded!");
// }