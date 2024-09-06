import Foundation
import SwiftUI

public class WhatsNewProvider: NSObject, ObservableObject {

    static let shared = WhatsNewProvider()

    @Published var updates: [WhatsNewModel] = []

    @AppStorage("WhatsNewShowedLast") var whatsNewShowedLast: Int?

    let allUpdates: [WhatsNewModel] = [
        WhatsNewModel(
            build: 2,
            title: "WhatsNew.2.title",
            imageName: "Update-2-AddSettingsAppearanceToggle",
            description: "WhatsNew.2.description"),
        WhatsNewModel(
            build: 4,
            title: "WhatsNew.4.title",
            imageName: "Update-4-AddSpeedPaceDisplayToggle",
            description: "WhatsNew.4.description"),
        WhatsNewModel(
            build: 5,
            title: "WhatsNew.5.title",
            imageName: "Update-5-AddOpenStreetMap",
            description: "WhatsNew.5.description"),
        WhatsNewModel(
            build: 10,
            title: "WhatsNew.10.title",
            imageName: "Update-10-GPXExport",
            description: "WhatsNew.10.description")
    ]

    public override init() {
        super.init()

        updates = allUpdates.filter { $0.build > (whatsNewShowedLast ?? 0) }.enumerated().map({ (index, element) in
            var result: WhatsNewModel = element
            result.tag = index
            return result
        })
    }

    public func closeWhatsNew() {
        UserDefaults.standard.set(allUpdates.last!.build, forKey: "WhatsNewShowedLast")
    }

}
