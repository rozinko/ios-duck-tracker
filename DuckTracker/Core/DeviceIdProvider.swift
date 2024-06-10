import Foundation
import SwiftUI
import UIKit

public class DeviceIdProvider: NSObject, ObservableObject {

    static let shared = DeviceIdProvider()

    @Published var deviceId: String?

    @State private var deviceIdUserDefaults: String? = UserDefaults.standard.string(forKey: "DeviceId")

    override init() {
        super.init()

        if deviceIdUserDefaults != nil {
            deviceId = deviceIdUserDefaults
            #if DEBUG
            print("DeviceIdProvider // init // DeviceId restored!")
            #endif
        } else {
            deviceId = generateNewDeviceId()
            UserDefaults.standard.set(deviceId, forKey: "DeviceId")
            #if DEBUG
            print("DeviceIdProvider // init // DeviceId generated!")
            #endif
        }
        #if DEBUG
        print("DeviceIdProvider // init // DeviceId = \(deviceId ?? "no device id")")
        #endif
    }

    private func crypt(_ number: Int) -> String {
        let base36array = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ").map { String($0) } // 0..35
        return (number > 35 ? crypt((number - (number % 36))/36) : "") + base36array[number % 36]
    }

    private func uncrypt(_ cryptedString: String) -> Int {
        if cryptedString == "" {
            return 0
        }

        let base36characters: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ") // 0..35

        let lastCharacter: Character = cryptedString[cryptedString.index(before: cryptedString.endIndex)]
        let uncryptedNumber: Int = base36characters.firstIndex(of: lastCharacter) ?? 0

        return uncrypt(String(cryptedString[..<cryptedString.index(before: cryptedString.endIndex)])) * 36 + uncryptedNumber
    }

///    Версия OS внутри Device ID
///    Число вида NNNN кодируется в base36(), где:
///    - Первое число 1 (неизвестная ОС), 3 (iPhone) или 5 (iPad)
///    - Второе число номер ОС (версия минус 14), ver. 14 - 0, ver. 15 - 1, ...
///    - Третье и четвертое число - minor и patch соответственно
    private func cryptOsVerPart() -> String {
        let osVersion = ProcessInfo.processInfo.operatingSystemVersion

        var osVersionNumber: Int = 1000

        if UIDevice.current.userInterfaceIdiom == .phone {
            osVersionNumber += 2000
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            osVersionNumber += 4000
        }

        osVersionNumber += (osVersion.majorVersion - 14) * 100 + osVersion.minorVersion * 10 + osVersion.patchVersion

        return crypt(osVersionNumber)
    }

    private func cryptTimestampPart() -> String {
        return crypt(Int(Date().timeIntervalSince1970))
    }

    private func randomString(length: Int) -> String {
        let characters: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ") // 0..35
        return String((0..<length).map { _ in characters.randomElement()! })
    }

    private func generateNewDeviceId() -> String {
        return cryptOsVerPart() + "-" + cryptTimestampPart() + "-" + randomString(length: 5) + "-" + randomString(length: 10)
    }

}
