import Foundation
import UIKit

public class AppProvider: NSObject, ObservableObject {

    static let shared = AppProvider()

    // Device ID
    public var deviceId: String?

    // Whats New
    @Published var whatsNewUpdates: [WhatsNewModel] = []
    var whatsNewAllUpdates: [WhatsNewModel] = []
    var whatsNewShowedLast: Int?

    // Main
    public var appVersion: String? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    public var appBuild: String? = Bundle.main.infoDictionary?["CFBundleVersion"] as? String

    func log(_ message: String) {
        #if DEBUG
            print(Date().description, "AppProvider // \(message)")
        #endif
    }

    public func isDebug() -> Bool {
        #if DEBUG
          return true
        #else
          return false
        #endif
    }

    public func isTestFlight() -> Bool {
        return Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    }

    override init() {
        super.init()

        log("Init()")

        initDeviceId()
        initWhatsNew()
    }

}
