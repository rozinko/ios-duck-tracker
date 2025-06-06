import SwiftUI
import MapKit
import MapCache

struct OSMActiveTrackMapView: UIViewRepresentable {

    @Binding var mapRegion: MKCoordinateRegion

    let isRecordingMode: Bool
    let showUserLocation: Bool
    let showUserTrackingButton: Bool

    let trackCoordinates: [CLLocationCoordinate2D]

    private let mapView = OSMActiveTrackMapViewDelegate()

    func makeUIView(context: UIViewRepresentableContext<OSMActiveTrackMapView>) -> OSMActiveTrackMapViewDelegate {
        mapView.delegate = mapView

        mapView.isPitchEnabled = true
        mapView.isZoomEnabled = true
        mapView.isRotateEnabled = true
        mapView.isScrollEnabled = true

        mapView.showsScale = true
        mapView.showsCompass = true

        if showUserLocation {
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .followWithHeading
        } else {
            mapView.showsUserLocation = false
            mapView.userTrackingMode = .none
        }

        if showUserTrackingButton {
            let userTrackingButton = MKUserTrackingButton(mapView: mapView)

            userTrackingButton.layer.backgroundColor = UIColor.white.cgColor
            userTrackingButton.layer.cornerRadius = 5
            userTrackingButton.tintColor = UIColor.orange

            userTrackingButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
            userTrackingButton.widthAnchor.constraint(equalToConstant: 32).isActive = true

            mapView.addSubview(userTrackingButton)

            userTrackingButton.translatesAutoresizingMaskIntoConstraints = false

            userTrackingButton.trailingAnchor.constraint(equalTo: mapView.layoutMarginsGuide.trailingAnchor, constant: -16).isActive = true
            userTrackingButton.bottomAnchor.constraint(equalTo: mapView.layoutMarginsGuide.bottomAnchor, constant: -32).isActive = true
        }

        mapView.setRegion(mapRegion, animated: true)

        let config = MapCacheConfig(withUrlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png")
        let mapCache = MapCache(withConfig: config)
        mapView.useCache(mapCache)

        return mapView
    }

    func updateUIView(_ uiView: OSMActiveTrackMapViewDelegate, context: UIViewRepresentableContext<OSMActiveTrackMapView>) {
        // обновляем оверлей основного маршрута:
        // - если есть 2 и более точек маршрута и в прошлый раз было отрисовано другое количество точек
        // - если новое значение 0 а было более одной (когда маршрут сбрасывается)
        if (trackCoordinates.count >= 2 && trackCoordinates.count != uiView.overlayTrackPointsDrawed) ||
            (trackCoordinates.count == 0 && uiView.overlayTrackPointsDrawed >= 2) {
            // удаляем старый
            uiView.removeOverlays(uiView.overlays.filter { $0.title == "track" })
            // добавляем обновленный
            let overlayTrack = MKPolyline(coordinates: trackCoordinates, count: trackCoordinates.count)
            overlayTrack.title = "track"
            uiView.insertOverlayAboveLast(overlayTrack)
            // обновляем информацию о количестве отрисованных точек маршрута
            uiView.overlayTrackPointsDrawed = trackCoordinates.count
        }

        // убираем оверлей отростка до текущей позиции,
        // если запись маршрута уже не ведется, а на карте отросток нарисован
        if !isRecordingMode && uiView.overlayTrackToUserLocationDrawed {
            // удаляем оверлей
            uiView.removeOverlays(uiView.overlays.filter { $0.title == "trackToUserLocation" })
            // ставим метку что отростка нет
            uiView.overlayTrackToUserLocationDrawed = false
        }

        // обновляем оверлей отростка,
        // если ведется запись маршрута и есть хотя бы одна точка маршрута и текущая позиция присвоена
        if isRecordingMode && trackCoordinates.count >= 1 && uiView.userLocation.location != nil {
            // удаляем старый оверлей
            uiView.removeOverlays(uiView.overlays.filter { $0.title == "trackToUserLocation" })
            // добавляем новый оверлей
            let overlayTrackLast = MKPolyline(coordinates: [trackCoordinates.last!, uiView.userLocation.location!.coordinate], count: 2)
            overlayTrackLast.title = "trackToUserLocation"
            uiView.insertOverlayAboveLast(overlayTrackLast)
            // обновляем метку что отросток отрисован
            uiView.overlayTrackToUserLocationDrawed = true
        }

    }

}
