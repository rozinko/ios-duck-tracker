import Foundation

extension CoreDataTrack {

    public func generateUniqueHash() -> String {
        if self.uniqueHash == nil || self.uniqueHash == "" {
            self.uniqueHash = String().random(length: 10)
        }
        return self.uniqueHash!
    }

    public func generateTrackId(firstPoint: TrackPoint) -> String {
        // timeIntervalSince1970 - uniqueHash - md5OfStartCoordinations
        let part1 = String(Int(firstPoint.location.timestamp.timeIntervalSince1970))
        let part2 = self.uniqueHash ?? ""
        let startCoord = String(firstPoint.latitude) + "-" + String(firstPoint.longitude) + "-" + String(firstPoint.location.altitude)
        let part3 = startCoord.md5

        self.trackId = part1 + "-" + part2 + "-" + part3

        return self.trackId!
    }

    func encodeJSONAttributes() -> Bool {
        let cdTrackAttributes = CoreDataTrackAttributes()

        let encoder = JSONEncoder()

        do {
            let json = try encoder.encode(cdTrackAttributes)
            self.jsonAttributes = String(data: json, encoding: .utf8)!
            return true
        } catch {
            return false
        }
    }

    func encodeJSONRoute(activeTrack: ActiveTrack) -> Bool {
        let points: [CoreDataTrackPoint] = activeTrack.trackPoints.map {
            CoreDataTrackPoint(fromLocation: $0.location)
        }

        let cdTrackPoints = CoreDataTrackRoute(points: points)

        let encoder = JSONEncoder()

        do {
            let json = try encoder.encode(cdTrackPoints)
            self.jsonRoute = String(data: json, encoding: .utf8)!
            return true
        } catch {
            return false
        }
    }

    func decodeJSONAttributes() -> CoreDataTrackAttributes? {
        if self.jsonAttributes == nil {
            return nil
        }

        let decoder = JSONDecoder()

        do {
            let attributes: CoreDataTrackAttributes = try decoder.decode(CoreDataTrackAttributes.self, from: self.jsonAttributes!.data(using: .utf8)!)
            return attributes
        } catch {
            return nil
        }
    }

    func decodeJSONRoute() -> CoreDataTrackRoute? {
        if self.jsonRoute == nil {
            return nil
        }

        let decoder = JSONDecoder()

        do {
            let route: CoreDataTrackRoute = try decoder.decode(CoreDataTrackRoute.self, from: self.jsonRoute!.data(using: .utf8)!)
            return route
        } catch {
            return nil
        }
    }

}
