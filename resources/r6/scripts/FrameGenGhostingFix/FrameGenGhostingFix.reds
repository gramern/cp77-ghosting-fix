// Thanks to djkovrik and psiberx for help and redscript snippets, Snaxgamer for his AutoVehicleCamera Switch mod from which a method of wrapping certain events has been inspired. JackHumbert for the Let There Be Flight mod I took bike parts names from. The code is also inspired by danyalzia's contribution to the Ghosting Fix mod (the first functioning script, thank you!)

// FrameGen Ghosting 'Fix' 4.9.0xl, 2024 gramern (scz_g)

// CET add-on customization --------------------------------------------------------------------------------
public class FrameGenGhostingFixMaskEditor1Event extends Event {}
public class FrameGenGhostingFixMaskEditor2Event extends Event {}
public class FrameGenGhostingFixVignetteOnFootEditorEvent extends Event {}
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

// Masks set transformation methods ------------------------------------------------------------------------
@addMethod(gameuiCrosshairContainerController)
private cb func FrameGenGhostingFixSetTransformation(path: CName, margin: Vector2, size: Vector2, rotation: Float, shear: Vector2, anchorPoint: Vector2, opacity: Float, visible: Bool) -> Bool {

  if NotEquals(this.m_isMaskingInVehiclesEnabledFGGF, false) {
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

@addMethod(gameuiCrosshairContainerController)
private cb func FrameGenGhostingFixSetSimpleTransformation(path: CName, margin: Vector2, size: Vector2, opacity: Float, visible: Bool) -> Bool {

  if NotEquals(this.m_isMaskingInVehiclesEnabledFGGF, false) {
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