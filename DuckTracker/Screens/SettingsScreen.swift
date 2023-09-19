import SwiftUI

struct SettingsScreen: View {

    @Binding var selectedTab: Int

    @State private var appAppearance: AppAppearance = AppAppearance(rawValue: UserDefaults.standard.integer(forKey: "AppAppearance")) ?? .system

    let appVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "no ver"
    let appBuild: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "no build"
    let isTestFlight: Bool = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"

    var body: some View {

        NavigationView {
            Form {
                Section(header: Text(".tab.settings".localized())) {

                    // App Appearance
                    if #available(iOS 16.0, *) {
                        Picker(
                            selection: $appAppearance,
                            label: Text("AppAppearance.title".localized())
                        ) {
                            ForEach(AppAppearance.allCases, id: \.self) {
                                Text($0.name).tag($0.rawValue)
                            }
                        }
                        .onChange(of: appAppearance) { newAppAppearance in
                            UserDefaults.standard.set(newAppAppearance.rawValue, forKey: "AppAppearance")
                        }
                        .pickerStyle(.navigationLink)
                    } else {
                        Picker(
                            selection: $appAppearance,
                            label: Text("AppAppearance.title".localized())
                        ) {
                            ForEach(AppAppearance.allCases, id: \.self) {
                                Text($0.name).tag($0.rawValue)
                            }
                        }
                        .onChange(of: appAppearance) { newAppAppearance in
                            UserDefaults.standard.set(newAppAppearance.rawValue, forKey: "AppAppearance")
                        }
                    }
                    // End of App Appearance

                }

                Section(footer: HStack {
                    Spacer()
                    if isTestFlight {
                        VStack {
                            Text("Duck Tracker v\(appVersion) (build \(appBuild))")
                            Text("Version from TestFlight")
                        }.foregroundColor(.red)
                    } else {
                        Text("Duck Tracker v\(appVersion) (build \(appBuild))")
                    }
                    Spacer()
                }) {

                }
            }
        }

    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen(selectedTab: .constant(4))
    }
}
