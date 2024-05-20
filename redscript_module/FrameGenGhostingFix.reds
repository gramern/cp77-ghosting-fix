//Thanks to djkovrik and psiberx for help and redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

//FrameGen Ghosting 'Fix' 4.1.2, 2024 gramern (scz_g)

//CET add-on customization---------------------------------------------------------------------------------------
public class FrameGenGhostingFixFPPBikeWindshieldEditorEvent extends Event {}
public class FrameGenGhostingFixVignetteOnFootEditorEvent extends Event {}
//Car camera change---------------------------------------------------------------------------------------
public class FrameGenGhostingFixCameraTPPCarEvent extends Event {}
public class FrameGenGhostingFixCameraTPPFarCarEvent extends Event {}
public class FrameGenGhostingFixCameraTPPCarFasterEvent extends Event {}
public class FrameGenGhostingFixCameraTPPFarCarFasterEvent extends Event {}
public class FrameGenGhostingFixCameraTPPCarSlowEvent extends Event {}
public class FrameGenGhostingFixCameraTPPFarCarSlowEvent extends Event {}
public class FrameGenGhostingFixCameraTPPCarCrawlEvent extends Event {}
public class FrameGenGhostingFixCameraTPPFarCarCrawlEvent extends Event {}
public class FrameGenGhostingFixCameraFPPCarEvent extends Event {}
public class FrameGenGhostingFixCameraFPPCarFasterEvent extends Event {}
public class FrameGenGhostingFixCameraFPPCarSlowEvent extends Event {}
public class FrameGenGhostingFixCameraFPPCarCrawlEvent extends Event {}
//Bike camera change---------------------------------------------------------------------------------------
public class FrameGenGhostingFixCameraTPPBikeEvent extends Event {}
public class FrameGenGhostingFixCameraTPPBikeFasterEvent extends Event {}
public class FrameGenGhostingFixCameraTPPBikeSlowEvent extends Event {}
public class FrameGenGhostingFixCameraTPPFarBikeFasterEvent extends Event {}
public class FrameGenGhostingFixCameraTPPBikeCrawlEvent extends Event {}
public class FrameGenGhostingFixCameraTPPFarBikeEvent extends Event {}
public class FrameGenGhostingFixCameraTPPFarBikeSlowEvent extends Event {}
public class FrameGenGhostingFixCameraTPPFarBikeCrawlEvent extends Event {}
public class FrameGenGhostingFixCameraFPPBikeEvent extends Event {}
public class FrameGenGhostingFixCameraFPPBikeFasterEvent extends Event {}
public class FrameGenGhostingFixCameraFPPBikeSlowEvent extends Event {}
public class FrameGenGhostingFixCameraFPPBikeCrawlEvent extends Event {}
//Vehicles masks deacitvation---------------------------------------------------------------------------------------
public class FrameGenGhostingFixDeActivationVehicleEvent extends Event {}