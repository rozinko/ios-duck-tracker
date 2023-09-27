import SwiftUI

public enum SettingMapServer: String, CaseIterable {
    case apple, osm

    var name: String {
        switch self {
        case .apple: return "SettingMapServer.apple".localized()
        case .osm: return "SettingMapServer.osm".localized()
        }
    }

    var description: String {
        switch self {
        case .apple: return "SettingMapServer.apple.description".localized()
        case .osm: return "SettingMapServer.osm.description".localized()
        }
    }

    init(fromString rawValue: String?) {
        self = Self.init(rawValue: rawValue ?? "osm") ?? .osm
    }

}
