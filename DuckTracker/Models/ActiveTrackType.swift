import Foundation
import SwiftUI

public enum ActiveTrackType: String, CaseIterable, Codable {
    case run, walk, scooter, bike, electroscooter, electrobike, hike, car, bus, train, boat, airplane, skateboard, snowboard, motorcycle, other
}

enum ActiveTrackTypePrefix: String {
    case short = "ActiveTrackInfoTypeView.type.short."
    case full = "ActiveTrackInfoTypeView.type."
}

extension ActiveTrackType {

    var isPaceType: Bool { self == .run || self == .walk || self == .hike }

    // swiftlint:disable:next cyclomatic_complexity
    func getSystemImageName() -> String {
        switch self {
        case .run:
            if #available(iOS 16.0, *) { return "figure.run" }
            return "figure.walk"
        case .walk:
            return "figure.walk"
        case .scooter, .electroscooter:
            if #available(iOS 15.0, *) { return "scooter" }
            return "location.north.fill"
        case .bike, .electrobike:
            if #available(iOS 16.0, *) { return "figure.outdoor.cycle" }
            return "bicycle"
        case .hike:
            if #available(iOS 16.0, *) { return "figure.hiking" }
            return "figure.walk"
        case .car:
            if #available(iOS 16.1, *) { return "car.side" }
            return "car"
        case .bus:
            return "bus.fill"
        case .train:
            return "tram.fill"
        case .boat:
            if #available(iOS 16.0, *) { return "sailboat" }
            if #available(iOS 15.0, *) { return "ferry" }
            return "location.north.fill"
        case .airplane:
            return "airplane"
        case .skateboard:
            if #available(iOS 18.0, *) { return "figure.skateboarding" }
            if #available(iOS 17.0, *) { return "skateboard" }
            return "location.north.fill"
        case .snowboard:
            if #available(iOS 16.0, *) { return "figure.snowboarding" }
            return "location.north.fill"
        case .motorcycle:
            if #available(iOS 18.0, *) { return "motorcycle" }
            return "location.north.fill"
        case .other:
            return "location.north.fill"
        }
    }

    func getIcon() -> some View {
        Image(systemName: self.getSystemImageName())
    }

    func getLocalized(prefix: ActiveTrackTypePrefix = .full) -> String {
        return self.rawValue.localized(withPrefix: prefix.rawValue)
    }

    func getLabel(prefix: ActiveTrackTypePrefix = .full) -> some View {
        HStack(spacing: 5) {
            self.getIcon()
            Text(self.getLocalized(prefix: prefix))
        }
    }

    func getDefaultTitle(firstTimestamp time: Date?) -> String {
        var result: String = ""

        result += "ActiveTrackInfoTypeView.getDefaultTitle.preType".localized()
        result += self.rawValue.localized(withPrefix: "ActiveTrackInfoTypeView.getDefaultTitle.type.")
        result += "ActiveTrackInfoTypeView.getDefaultTitle.afterType".localized()

        result = result.capitalizedSentence

        if time != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            result += dateFormatter.string(from: time!).capitalized
        }

        return result
    }

}
