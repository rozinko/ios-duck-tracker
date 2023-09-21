import Foundation
import SwiftUI

public enum SettingSpeedDisplay: Int, CaseIterable {
    case auto, speed, pace

    var name: String {
        switch self {
        case .auto: return "SettingSpeedDisplay.auto".localized()
        case .speed: return "SettingSpeedDisplay.speed".localized()
        case .pace: return "SettingSpeedDisplay.pace".localized()
        }
    }

    var description: String {
        switch self {
        case .auto: return "SettingSpeedDisplay.auto.description".localized()
        case .speed: return "SettingSpeedDisplay.speed.description".localized()
        case .pace: return "SettingSpeedDisplay.pace.description".localized()
        }
    }
    
    init(fromInt rawValue: Int?) {
        self = Self.init(rawValue: rawValue ?? 0) ?? .auto
    }
    
}
