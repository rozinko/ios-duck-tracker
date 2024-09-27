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
        if trackCoordinates.count != uiView.overlayTrackPointsDrawed && trackCoordinates.count != 1 {
            // удаляем старый оверлей
            print(Date().description, "AppleHistMap // overlays del")
            uiView.removeOverlays(uiView.overlays.filter { $0.title == "track" })
            // добавляем обновленный оверлей
            print(Date().description, "AppleHistMap // overlay rerender")
            let overlayTrack = MKPolyline(coordinates: trackCoordinates, count: trackCoordinates.count)
            overlayTrack.title = "track"
            uiView.insertOverlayAboveLast(overlayTrack)
            // обновляем информацию о количестве отрисованных точек маршрута
            uiView.overlayTrackPointsDrawed = trackCoordinates.count
        }

        if selectedPoint != uiView.overlaySelectedPointDrawed {
            // удаляем все точки
            print(Date().description, "AppleHistMap // points del")
            uiView.removeAnnotations(uiView.annotations)
            // добавляем выбранную точку с графика, если она есть
            if selectedPoint != nil && selectedPoint! < trackCoordinates.count {
                // рисуем выбранную точку
                print(Date().description, "AppleHistMap // selected point rerender")
                let selectedAnnotation = MKPointAnnotation()
                selectedAnnotation.coordinate = trackCoordinates[selectedPoint!]
                selectedAnnotation.title = "SelectedPoint"
                uiView.addAnnotation(selectedAnnotation)
            }
            // обновляем информацию об отрисованной выбранной точке
            uiView.overlaySelectedPointDrawed = selectedPoint
        }

        mapView.setRegion(region, animated: true)
    }

}
