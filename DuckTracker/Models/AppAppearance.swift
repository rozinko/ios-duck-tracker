import Foundation
import SwiftUI

public enum AppAppearance: Int, CaseIterable {
    case system, light, dark

    var name: String {
        switch self {
        case .system: return "AppAppearance.system".localized()
        case .light: return "AppAppearance.light".localized()
        case .dark: return "AppAppearance.dark".localized()
        }
    }

    var getColorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
