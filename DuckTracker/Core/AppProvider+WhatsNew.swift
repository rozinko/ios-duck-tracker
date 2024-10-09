import Foundation

extension AppProvider {

    public func initWhatsNew() {
        log("InitWhatsNew()")
        whatsNewShowedLast = Int(UserDefaults.standard.string(forKey: "WhatsNewShowedLast") ?? "0")
        log("whatsNewShowedLast: \(whatsNewShowedLast ?? -1)")

        whatsNewAllUpdates = [
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
                description: "WhatsNew.10.description"),
            WhatsNewModel(
                build: 13,
                title: "WhatsNew.13.title",
                imageName: "Update-13-Charts",
                description: "WhatsNew.13.description")
        ]

        whatsNewUpdates = whatsNewAllUpdates.filter { $0.build > (whatsNewShowedLast ?? 0) }.enumerated().map({ (index, element) in
            var result: WhatsNewModel = element
            result.tag = index
            return result
        })
        log("whatsNewUpdates count: \(whatsNewUpdates.count)")
    }

    public func closeWhatsNew() {
        UserDefaults.standard.set(whatsNewAllUpdates.last!.build, forKey: "WhatsNewShowedLast")
        whatsNewShowedLast = whatsNewAllUpdates.last!.build
        log("closeWhatsNew() with whatsNewShowedLast = \(whatsNewAllUpdates.last!.build)")
    }

}
