import SwiftUI

struct SettingsScreen: View {

    @Binding var selectedTab: Int

    @State private var settingAppearance = SettingAppearance(fromInt: UserDefaults.standard.integer(forKey: "SettingAppearance"))
    @State private var settingSpeedDisplay = SettingSpeedDisplay(fromInt: UserDefaults.standard.integer(forKey: "SettingSpeedDisplay"))

    let appVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "no ver"
    let appBuild: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "no build"
    let isTestFlight: Bool = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    var isDebug: Bool {
        #if DEBUG
          return true
        #else
          return false
        #endif
    }

    var body: some View {

        NavigationView {
            Form {

                // Setting Appearance
                Section(header: Text("SettingAppearance.title".localized())) {
                    Picker("SettingAppearance.title".localized(), selection: $settingAppearance) {
                        ForEach(SettingAppearance.allCases, id: \.self) {
                            Text($0.name).tag($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: settingAppearance) { newSettingAppearance in
                        UserDefaults.standard.set(newSettingAppearance.rawValue, forKey: "SettingAppearance")
                    }
                }
                // End of Setting Appearance

                // Setting Speed Display
                Section(
                    header: Text("SettingSpeedDisplay.title".localized()),
                    footer: Text(settingSpeedDisplay.description)
                ) {
                    Picker("SettingSpeedDisplay.title".localized(), selection: $settingSpeedDisplay) {
                        ForEach(SettingSpeedDisplay.allCases, id: \.self) {
                            Text($0.name).tag($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: settingSpeedDisplay) { newSettingSpeedDisplay in
                        UserDefaults.standard.set(newSettingSpeedDisplay.rawValue, forKey: "SettingSpeedDisplay")
                    }
                }
                // End of Setting Speed Display

                // Info in footer
                Section(
                    footer: HStack {
                        Spacer()
                        VStack {
                            Text("Duck Tracker v\(appVersion) (build \(appBuild))")
                            if isDebug {
                                Text("DEBUG MODE").foregroundColor(.red)
                            }
                            if isTestFlight {
                                Text("Version from TestFlight").foregroundColor(.blue)
                            }
                        }
                        Spacer()
                    }
                ) { }
                // End of Info in footer
            }
        }

    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen(selectedTab: .constant(4))
    }
}
