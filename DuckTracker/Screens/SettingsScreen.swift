import SwiftUI

struct SettingsScreen: View {

    @Binding var selectedTab: Int

    @State private var appAppearance: AppAppearance = AppAppearance(rawValue: UserDefaults.standard.integer(forKey: "AppAppearance")) ?? .system

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
                            print("new appearance:", newAppAppearance, "/ raw:", newAppAppearance.rawValue)
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
                    }
                    // End of App Appearance

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
