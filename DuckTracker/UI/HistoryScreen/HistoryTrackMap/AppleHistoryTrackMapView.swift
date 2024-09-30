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
        // проверяем надо ли обновлять оверлей маршрута
        if trackCoordinates.count != uiView.overlayTrackPointsDrawed && trackCoordinates.count != 1 {
            // удаляем старый оверлей
            print(Date().description, "AppleHistMap // overlay track del")
            uiView.removeOverlays(uiView.overlays.filter { $0.title == "track" })

            // удаляем старые точки start/finish
            print(Date().description, "AppleHistMap // points track start/finish del")
            uiView.removeAnnotations(uiView.annotations.filter { $0.title == "trackStartPoint" || $0.title == "trackFinishPoint"})

            // добавляем обновленный оверлей
            print(Date().description, "AppleHistMap // overlay track render")
            let overlayTrack = MKPolyline(coordinates: trackCoordinates, count: trackCoordinates.count)
            overlayTrack.title = "track"
            uiView.insertOverlayAboveLast(overlayTrack)

            // добавляем точки start/finish (если есть как минимум 2 точки)
            if trackCoordinates.count >= 2 {
                print(Date().description, "AppleHistMap // points track start/finish render")
                let pointStart = MKPointAnnotation()
                pointStart.coordinate = trackCoordinates.first!
                pointStart.title = "trackStartPoint"
                let pointFinish = MKPointAnnotation()
                pointFinish.coordinate = trackCoordinates.last!
                pointFinish.title = "trackFinishPoint"
                uiView.addAnnotations([pointStart, pointFinish])
            }

            // обновляем информацию о количестве отрисованных точек маршрута
            uiView.overlayTrackPointsDrawed = trackCoordinates.count
        }

        if selectedPoint != uiView.overlaySelectedPointDrawed {
            // удаляем все точки
            print(Date().description, "AppleHistMap // point track selected del")
            uiView.removeAnnotations(uiView.annotations.filter { $0.title == "trackSelectedPoint"})

            // добавляем выбранную точку с графика, если она есть
            if selectedPoint != nil && selectedPoint! < trackCoordinates.count {
                // рисуем выбранную точку
                print(Date().description, "AppleHistMap // point track selected render")
                let selectedAnnotation = MKPointAnnotation()
                selectedAnnotation.coordinate = trackCoordinates[selectedPoint!]
                selectedAnnotation.title = "trackSelectedPoint"
                uiView.addAnnotation(selectedAnnotation)
            }

            // обновляем информацию об отрисованной выбранной точке
            uiView.overlaySelectedPointDrawed = selectedPoint
        }

        mapView.setRegion(region, animated: true)
    }

}
