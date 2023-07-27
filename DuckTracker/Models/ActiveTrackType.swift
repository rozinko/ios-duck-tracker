import Foundation
import SwiftUI

public enum ActiveTrackType: String, CaseIterable {
    case run, walk, scooter, bike, electroscooter, electrobike, hike, car, bus, train, boat, airplane, other
}

enum ActiveTrackTypePrefix: String {
    case short = "ActiveTrackInfoTypeView.type.short."
    case full = "ActiveTrackInfoTypeView.type."
}

extension ActiveTrackType {

    var isPaceType: Bool { self == .run || self == .walk || self == .hike }

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
        case .other:
            return "location.north.fill"
        }
    }

    func getIcon() -> some View {
        Image(systemName: self.getSystemImageName())
    }

    func getLabel(prefix: ActiveTrackTypePrefix = .full) -> some View {
        HStack(spacing: 5) {
            self.getIcon()
            Text(self.rawValue.localized(withPrefix: prefix.rawValue))
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
