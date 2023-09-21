import SwiftUI

struct SettingsScreen: View {

    @Binding var selectedTab: Int

    @State private var appAppearance: AppAppearance = AppAppearance(rawValue: UserDefaults.standard.integer(forKey: "AppAppearance")) ?? .system
    @State private var appSpeedDisplay: AppSpeedDisplay = AppSpeedDisplay(rawValue: UserDefaults.standard.integer(forKey: "AppSpeedDisplay")) ?? .auto

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

                // App Appearance
                Section(header: Text("AppAppearance.title".localized())) {
                    Picker("AppAppearance.title".localized(), selection: $appAppearance) {
                        ForEach(AppAppearance.allCases, id: \.self) {
                            Text($0.name).tag($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: appAppearance) { newAppAppearance in
                        UserDefaults.standard.set(newAppAppearance.rawValue, forKey: "AppAppearance")
                    }
                }
                // End of App Appearance

                // App Speed Display
                Section(
                    header: Text("AppSpeedDisplay.title".localized()),
                    footer: Text(appSpeedDisplay.description)
                ) {
                    Picker("AppSpeedDisplay.title".localized(), selection: $appSpeedDisplay) {
                        ForEach(AppSpeedDisplay.allCases, id: \.self) {
                            Text($0.name).tag($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: appSpeedDisplay) { newAppSpeedDisplay in
                        UserDefaults.standard.set(newAppSpeedDisplay.rawValue, forKey: "AppSpeedDisplay")
                    }
                }
                // End of App Speed Display

                // Info in footer
                Section(footer: HStack {
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
                }) {

                }
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
