// Thanks to djkovrik for redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

//FrameGen Ghosting 'Fix' 2.18.0-alpha for FSR3 FG Mods, 2024 gramern (scz_g)

//CET add-on customization---------------------------------------------------------------------------------------
public class FrameGenGhostingFixFPPCarSideMirrorToggleEvent extends Event {}
public class FrameGenGhostingFixFPPBikeELGEEvent extends Event {}
public class FrameGenGhostingFixVignetteOnFootEditorEvent extends Event {}
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