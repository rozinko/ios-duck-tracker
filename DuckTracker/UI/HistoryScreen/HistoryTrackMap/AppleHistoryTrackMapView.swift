import SwiftUI
import MapKit

struct AppleHistoryTrackMapView: UIViewRepresentable {

    @Binding var region: MKCoordinateRegion

    let trackCoordinates: [CLLocationCoordinate2D]

    @Binding var selectedPoint: Int?

    private let mapView = AppleHistoryTrackMapViewDelegate()

    func makeUIView(context: UIViewRepresentableContext<AppleHistoryTrackMapView>) -> AppleHistoryTrackMapViewDelegate {
        mapView.delegate = mapView

        mapView.isPitchEnabled = true
        mapView.isZoomEnabled = true
        mapView.isRotateEnabled = true
        mapView.isScrollEnabled = true

        mapView.showsScale = true
        mapView.showsCompass = true

        mapView.showsUserLocation = false
        mapView.userTrackingMode = .none

//        let region = mapView.regionThatFits(region)

        mapView.setRegion(region, animated: true)

        return mapView
    }

    func updateUIView(_ uiView: AppleHistoryTrackMapViewDelegate, context: UIViewRepresentableContext<AppleHistoryTrackMapView>) {
        // удаляем старый оверлей
        uiView.removeOverlays(uiView.overlays.filter { $0.title == "track" })
        // добавляем обновленный оверлей
        let overlayTrack = MKPolyline(coordinates: trackCoordinates, count: trackCoordinates.count)
        overlayTrack.title = "track"
        uiView.insertOverlayAboveLast(overlayTrack)

        // удаляем все точки
        uiView.removeAnnotations(uiView.annotations)
        // добавляем выбранную точку с графика, если она есть
        if selectedPoint != nil && selectedPoint! < trackCoordinates.count {
            let selectedAnnotation = MKPointAnnotation()
            selectedAnnotation.coordinate = trackCoordinates[selectedPoint!]
            selectedAnnotation.title = "SelectedPoint"
            uiView.addAnnotation(selectedAnnotation)
        }

        /*
        // обновляем оверлей основного маршрута:
        // - если есть 2 и более точек маршрута и в прошлый раз было отрисовано другое количество точек
        // - если новое значение 0 а было более одной (когда маршрут сбрасывается)
        if trackCoordinates.count != uiView.overlayTrackPointsDrawed && trackCoordinates.count != 1 {
            // удаляем старый
            uiView.removeOverlays(uiView.overlays.filter { $0.title == "track" })
            // добавляем обновленный
            let overlayTrack = MKPolyline(coordinates: trackCoordinates, count: trackCoordinates.count)
            overlayTrack.title = "track"
            uiView.addOverlay(overlayTrack, level: .aboveRoads)
            // обновляем информацию о количестве отрисованных точек маршрута
            uiView.overlayTrackPointsDrawed = trackCoordinates.count
        }
        */

        mapView.setRegion(region, animated: true)

    }

}
