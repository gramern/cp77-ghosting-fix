//Thanks to djkovrik and psiberx for help and redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

//FrameGen Ghosting 'Fix' 4.8.0xl-alpha2, 2024 gramern (scz_g)

//CET add-on customization---------------------------------------------------------------------------------------
public class FrameGenGhostingFixFPPBikeWindshieldEditorEvent extends Event {}
public class FrameGenGhostingFixVignetteOnFootEditorEvent extends Event {}
//Car camera change---------------------------------------------------------------------------------------
public class FrameGenGhostingFixCameraTPPCarEvent extends Event {}
public class FrameGenGhostingFixCameraTPPFarCarEvent extends Event {}
public class FrameGenGhostingFixCameraFPPCarEvent extends Event {}
//Bike camera change---------------------------------------------------------------------------------------
public class FrameGenGhostingFixCameraTPPBikeEvent extends Event {}
public class FrameGenGhostingFixCameraTPPFarBikeEvent extends Event {}
public class FrameGenGhostingFixCameraFPPBikeEvent extends Event {}
//Vehicles masks deacitvation---------------------------------------------------------------------------------------
public class FrameGenGhostingFixDeActivationVehicleEvent extends Event {}

//Masks set transformation methods-------------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
private cb func FrameGenGhostingFixSetTransformation(setMaskPath: CName, setMaskMargin: Vector2, setMaskSize: Vector2, setMaskRotation: Float, setMaskShear: Vector2, setMaskAnchorPoint: Vector2, setMaskOpacity: Float, setMaskVisible: Bool) -> Bool {

  if NotEquals(this.m_isMaskingInVehiclesEnabledFGGF,false) {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let mask: ref<inkWidget> = root.GetWidgetByPathName(setMaskPath) as inkWidget;

    if NotEquals(setMaskVisible,mask.IsVisible()) {
      mask.SetVisible(setMaskVisible);
    }

    if Equals(setMaskVisible,true) {
      let maskMargin = mask.GetMargin();
      mask.SetMargin(setMaskMargin.X, setMaskMargin.Y, maskMargin.right, maskMargin.bottom);
      mask.SetSize(setMaskSize);
      mask.SetRotation(setMaskRotation);
      mask.SetShear(setMaskShear);
      mask.SetAnchorPoint(setMaskAnchorPoint);

      if setMaskOpacity != mask.GetOpacity() {
        mask.SetOpacity(setMaskOpacity);
      }
    }
  }
}

@addMethod(gameuiCrosshairContainerController)
private cb func FrameGenGhostingFixSetSimpleTransformation(setMaskPath: CName, setMaskMargin: Vector2, setMaskSize: Vector2, setMaskOpacity: Float, setMaskVisible: Bool) -> Bool {

  if NotEquals(this.m_isMaskingInVehiclesEnabledFGGF,false) {
    let root: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let mask: ref<inkWidget> = root.GetWidgetByPathName(setMaskPath) as inkWidget;

    if NotEquals(setMaskVisible,mask.IsVisible()) {
       mask.SetVisible(setMaskVisible);
    }

    if Equals(setMaskVisible,true) {
      let maskMargin = mask.GetMargin();
      mask.SetMargin(setMaskMargin.X, setMaskMargin.Y, maskMargin.right, maskMargin.bottom);
      mask.SetSize(setMaskSize);

      if setMaskOpacity != mask.GetOpacity() {
        mask.SetOpacity(setMaskOpacity);
      }
    }
  }
}