import SwiftUI
import MapCache

struct SettingsScreen: View {

    @Binding var selectedTab: Int

    @State private var settingAppearance = SettingAppearance(fromInt: UserDefaults.standard.integer(forKey: "SettingAppearance"))
    @State private var settingMapServer = SettingMapServer(fromString: UserDefaults.standard.string(forKey: "SettingMapServer"))
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

    var mapCache: MapCache = MapCache(withConfig: MapCacheConfig(withUrlTemplate: ""))

    @State var mapCacheSize: Int64 = 0
    @State var mapCacheSizeString: String = ".cache.empty".localized()
    @State var showCacheClearAlert = false

    func updateMapCacheSize() {
        mapCacheSize = Int64(mapCache.diskCache.fileSize ?? 0)
        mapCacheSizeString = mapCacheSize > 0 ? ByteCountFormatter().string(fromByteCount: mapCacheSize) : ".cache.empty".localized()
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

                // Setting Map Server
                Section(
                    header: Text("SettingMapServer.title".localized()),
                    footer: Text(settingMapServer.description)
                ) {
                    Picker("SettingMapServer.title".localized(), selection: $settingMapServer) {
                        ForEach(SettingMapServer.allCases, id: \.self) {
                            Text($0.name).tag($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: settingMapServer) { newSettingMapServer in
                        UserDefaults.standard.set(newSettingMapServer.rawValue, forKey: "SettingMapServer")
                    }

                    if mapCacheSize > 0 {

                        HStack {
                            Text("Setting.map.cache.size".localized())
                            Spacer()
                            Text(mapCacheSizeString)
                        }

                        Button("Setting.map.cache.clear".localized()) {
                            showCacheClearAlert = true
                        }
                        .alert(isPresented: $showCacheClearAlert) {
                            Alert(
                                title: Text("Setting.map.cache.clear.title".localized()),
                                message: Text("Setting.map.cache.clear.message".localized()),
                                primaryButton: .destructive(
                                    Text("Setting.map.cache.clear.button".localized()),
                                    action: {
                                        // hide alert
                                        showCacheClearAlert = false
                                        // clear cache!
                                        mapCache.clear(completition: {updateMapCacheSize()})
                                    }
                                ),
                                secondaryButton: .cancel(
                                    Text(".back".localized())
                                )
                            )
                        }
                    } else if settingMapServer != .apple {
                        HStack {
                            Spacer()
                            Text("Setting.map.cache.empty".localized())
                            Spacer()
                        }
                    }
                }
                // End of Setting Map Server

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
        }.onAppear {
            updateMapCacheSize()
        }

    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen(selectedTab: .constant(4))
    }
}
