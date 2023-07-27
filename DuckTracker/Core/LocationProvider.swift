/**

 This component based on video from: https://www.youtube.com/watch?v=poSmKJ_spts

 */

import CoreLocation

public class LocationProvider: NSObject, ObservableObject {

    static let shared = LocationProvider()

    @Published var userLocation: CLLocation?
    @Published var locationStatus: Int8 = 0

    private let lm = CLLocationManager()
    private let activeTrackProvider = ActiveTrackProvider.shared
    private var isUpdating: Bool = false

    override init() {
        super.init()

        lm.delegate = self

        lm.desiredAccuracy = kCLLocationAccuracyBest
        lm.activityType = .fitness
        lm.distanceFilter = 0
        lm.allowsBackgroundLocationUpdates = true
        lm.pausesLocationUpdatesAutomatically = false
        lm.showsBackgroundLocationIndicator = true

        self.start()
    }

    func requestAuthorization() {
        lm.requestWhenInUseAuthorization()
    }

    func start() {
        if !self.isUpdating {
            lm.startUpdatingLocation()
            lm.startUpdatingHeading()

            self.isUpdating = true
        }
    }

    func stop() {
        if self.isUpdating && !activeTrackProvider.isRecording {
            lm.stopUpdatingLocation()
            lm.stopUpdatingHeading()

            self.isUpdating = false
        }
    }

}

extension LocationProvider: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            self.locationStatus = 0
        case .restricted:
            self.locationStatus = 1
        case .denied:
            self.locationStatus = 2
        case .authorizedWhenInUse:
            self.locationStatus = 3
        case .authorizedAlways:
            self.locationStatus = 4
        case .authorized:
            self.locationStatus = 3
        default:
            break
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        self.userLocation = location

        activeTrackProvider.update(location: location)
    }

}
