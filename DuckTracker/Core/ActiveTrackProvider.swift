import CoreLocation

public class ActiveTrackProvider: NSObject, ObservableObject {

    static let shared = ActiveTrackProvider()

    @Published var isRecording: Bool = false
    @Published var lastLocation: CLLocation?
    @Published var track: ActiveTrack = ActiveTrack()

    @Published var timeString: String = "00:00:00"

    private let dataProvider = DataProvider.shared
    private let liveActivityService = LiveActivityService.shared

    private var timer: Timer?

    func start() {
        // начинаем запись
        isRecording = true

        // добавляем последнюю точку как начало маршрута
        addPoint(force: true)

        // старт таймера
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                self.updateTimeString()
            }
        }

        // добавляем live activity или продолжаем старый
        if liveActivityService.hasActivity() {
            liveActivityService.updateActivity(isRecording: true)
        } else {
            liveActivityService.startActivity(startDate: Date())
        }
    }

    func pause() {
        // записываем последнюю точку, если есть хотя бы две точки на маршруте
        // если же нет - очищаем трек
        if track.trackPoints.count >= 2 {
            addPoint(force: true)
            liveActivityService.updateActivity(isRecording: false)
        } else {
            clear()
        }

        // прекращаем запись
        isRecording = false

        // останавливаем таймер
        timer?.invalidate()
        timer = nil

        updateTimeString()
    }

    func finish(title: String, type: ActiveTrackType) {
        if track.trackPoints.count >= 2 {
            let addActiveTrackResult = dataProvider.addTrack(activeTrack: track, title: title, type: type)
            if addActiveTrackResult {
                clear()
            }
        }
        clear()
    }

    func clear() {
        track = ActiveTrack()
        updateTimeString()
        liveActivityService.stopActivites()
    }

    func updateTimeString() {
        self.timeString = self.track.getTimeString(isRecording: self.isRecording)
    }

    func addPoint(force: Bool = false) {
        // уходим, если нет локации либо запись маршрута не ведется
        guard let location = lastLocation else { return }
        guard isRecording else { return }

        var add = force
        let point = TrackPoint(location: location, previousTrackPoint: self.track.trackPoints.last)

        // уходим, если это не первая точка (есть параметр дистанции) и дистанция равно нулю
        if point.distance != nil && point.distance! <= 0 { return }

        // минимальное изменение курса для добавления точки
        // работает дополнительно с минимальным расстоянием от прошлой точки (по другому рассчету)
        // TODO: для разных типов маршрутов можно попробовать использовать разный рассчет
        let minCourse: Double = 25
        let minDistanceForCourse: Double = point.location.horizontalAccuracy * 0.5

        // минимальное изменение дистанции для добавлении точки
        // используем для рассчета точность gps сигнала hAcc
        // TODO: для разных типов маршрутов можно попробовать использовать разный рассчет
        let minDistance: Double = point.location.horizontalAccuracy * 5

        // добавляем точку, если это первая точка в маршруте
        if point.distance == nil {
            add = true
        }

        // добавляем точку, если курс движения изменился на minCourse градусов
        // применяем только если прием gps у нас хороший (hAcc <= 10)
        if track.trackPoints.last != nil && point.location.horizontalAccuracy <= 10 && point.distance != nil && point.distance! >= minDistanceForCourse {
            let courseA = track.trackPoints.last!.location.course
            let courseB = point.location.course
            let diffAB = courseA > courseB ? courseA - courseB : courseB - courseA
            let courseDiff = min(diffAB, 360 - diffAB)
            if courseDiff >= minCourse {
                add = true
            }
        }

        // добавляем точку, если прошло minDistance расстояния с прошлой точки
        if point.distance != nil && point.distance! >= minDistance {
            add = true
        }

        // добавляем точку, если это новый максимум скорости
        if point.location.speed > track.maxSpeed {
            add = true
        }

        if add {
            // добавляем точку в маршрут
            self.track.trackPoints.append(point)

            // обновляем live activity
            liveActivityService.updateActivity(
                isRecording: isRecording,
                distance: track.distance,
                lastDate: track.trackPoints.last?.location.timestamp
            )
        }
    }

    func update(location: CLLocation) {
        lastLocation = location
        addPoint()
    }

}
