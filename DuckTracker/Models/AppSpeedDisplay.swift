import Foundation
import SwiftUI

public enum AppSpeedDisplay: Int, CaseIterable {
    case auto, speed, pace

    var name: String {
        switch self {
        case .auto: return "AppSpeedDisplay.auto".localized()
        case .speed: return "AppSpeedDisplay.speed".localized()
        case .pace: return "AppSpeedDisplay.pace".localized()
        }
    }
}
