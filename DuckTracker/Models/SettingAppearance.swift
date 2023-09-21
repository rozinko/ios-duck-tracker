import Foundation
import SwiftUI

public enum SettingAppearance: Int, CaseIterable {
    case system, light, dark

    var name: String {
        switch self {
        case .system: return "SettingAppearance.system".localized()
        case .light: return "SettingAppearance.light".localized()
        case .dark: return "SettingAppearance.dark".localized()
        }
    }

    var getColorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }

    init(fromInt rawValue: Int?) {
        self = Self.init(rawValue: rawValue ?? 0) ?? .system
    }

}
