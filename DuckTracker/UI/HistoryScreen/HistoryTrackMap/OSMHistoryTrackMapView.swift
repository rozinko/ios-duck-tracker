import SwiftUI
import MapKit
import MapCache

struct OSMHistoryTrackMapView: UIViewRepresentable {

    @Binding var region: MKCoordinateRegion

    let trackCoordinates: [CLLocationCoordinate2D]

    @Binding var selectedPoint: Int?

    private let mapView = OSMHistoryTrackMapViewDelegate()

    func makeUIView(context: UIViewRepresentableContext<OSMHistoryTrackMapView>) -> OSMHistoryTrackMapViewDelegate {
        mapView.delegate = mapView

        mapView.isPitchEnabled = true
        mapView.isZoomEnabled = true
        mapView.isRotateEnabled = true
        mapView.isScrollEnabled = true

        mapView.showsScale = true
        mapView.showsCompass = true

        mapView.showsUserLocation = false
        mapView.userTrackingMode = .none

        mapView.setRegion(region, animated: true)

        let config = MapCacheConfig(withUrlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png")
        let mapCache = MapCache(withConfig: config)
        mapView.useCache(mapCache)

        return mapView
    }

    func updateUIView(_ uiView: OSMHistoryTrackMapViewDelegate, context: UIViewRepresentableContext<OSMHistoryTrackMapView>) {
        // проверяем надо ли обновлять оверлей маршрута
        if trackCoordinates.count != uiView.overlayTrackPointsDrawed && trackCoordinates.count != 1 {
            // удаляем старый оверлей
            print(Date().description, "OSMHistMap // overlay track del")
            uiView.removeOverlays(uiView.overlays.filter { $0.title == "track" })

            // удаляем старые точки start/finish
            print(Date().description, "OSMHistMap // points track start/finish del")
            uiView.removeAnnotations(uiView.annotations.filter { $0.title == "trackStartPoint" || $0.title == "trackFinishPoint"})

            // добавляем обновленный оверлей
            print(Date().description, "OSMHistMap // overlay track render")
            let overlayTrack = MKPolyline(coordinates: trackCoordinates, count: trackCoordinates.count)
            overlayTrack.title = "track"
            uiView.insertOverlayAboveLast(overlayTrack)

            // добавляем точки start/finish (если есть как минимум 2 точки)
            if trackCoordinates.count >= 2 {
                print(Date().description, "OSMHistMap // points track start/finish render")
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
            print(Date().description, "OSMHistMap // point track selected del")
            uiView.removeAnnotations(uiView.annotations.filter { $0.title == "trackSelectedPoint"})

            // добавляем выбранную точку с графика, если она есть
            if selectedPoint != nil && selectedPoint! < trackCoordinates.count {
                // рисуем выбранную точку
                print(Date().description, "OSMHistMap // point track selected render")
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
