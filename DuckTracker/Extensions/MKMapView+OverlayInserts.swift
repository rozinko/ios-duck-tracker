import MapKit

extension MKMapView {

    func insertOverlayBelowFirst(_ overlay: MKOverlay) {
        if let firstOverlay = self.overlays.first {
            self.insertOverlay(overlay, below: firstOverlay)
        } else {
            self.addOverlay(overlay)
        }
    }

    func insertOverlayAboveLast(_ overlay: MKOverlay) {
        if let lastOverlay = self.overlays.last {
            self.insertOverlay(overlay, above: lastOverlay)
        } else {
            self.addOverlay(overlay)
        }
    }

}
