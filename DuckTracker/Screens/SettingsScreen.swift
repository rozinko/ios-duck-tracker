import SwiftUI
import MapCache

struct SettingsScreen: View {

    @Binding var selectedTab: Int

    @ObservedObject var deviceIdProvider = DeviceIdProvider.shared

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

    @State var gpxFiles: [URL] = []
    @State var gpxFilesSize: Int = 0
    @State var gpxFilesSizeString: String = "Setting.GPXFiles.empty".localized()
    @State var showGPXFilesClearAlert = false

    func updateGPXFiles() {
        // get files list
        gpxFiles = DuckFileManager.getGPXFiles()
        // get size
        var filesSize: Int = 0
        gpxFiles.forEach { gpxFile in
            filesSize += gpxFile.fileSize ?? 0
        }
        gpxFilesSize = filesSize
        // get size string
        gpxFilesSizeString = gpxFilesSize > 0 ? ByteCountFormatter().string(fromByteCount: Int64(gpxFilesSize)) : "Setting.GPXFiles.empty".localized()
    }

    func deleteGPXFiles() {
        gpxFiles = DuckFileManager.getGPXFiles()
        gpxFiles.forEach { gpxFile in
            do {
                try FileManager.default.removeItem(at: gpxFile)
            } catch {
                print("Error deleting file: \(error)")
            }
        }
        updateGPXFiles()
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

                // Setting GPX files
                Section(header: Text("Setting.GPXFiles.Title".localized())) {
                    if gpxFiles.count > 0 {
                        HStack {
                            Text(
                                "Setting.GPXFiles.SizeOf".localized() + " " +
                                (gpxFiles.count <= 100 ?
                                    gpxFiles.count.toStringWithDeclension(
                                        one: "Setting.GPXFiles.filesOne",
                                        two: "Setting.GPXFiles.filesTwo",
                                        five: "Setting.GPXFiles.filesFive"
                                     ):
                                    "100+ " + "Setting.GPXFiles.filesFive".localized()
                                )
                            )
                            Spacer()
                            Text(gpxFilesSizeString)
                        }

                        Button("Setting.GPXFiles.button".localized()) {
                            showGPXFilesClearAlert = true
                        }
                        .alert(isPresented: $showGPXFilesClearAlert) {
                            Alert(
                                title: Text("Setting.GPXFiles.alert.title".localized()),
                                message: Text("Setting.GPXFiles.alert.message".localized()),
                                primaryButton: .destructive(
                                    Text("Setting.GPXFiles.alert.button".localized()),
                                    action: {
                                        // hide alert
                                        showGPXFilesClearAlert = false
                                        // delete gpx files
                                        deleteGPXFiles()
                                    }
                                ),
                                secondaryButton: .cancel(
                                    Text(".back".localized())
                                )
                            )
                        }
                    } else {
                        HStack {
                            Spacer()
                            Text("Setting.GPXFiles.empty".localized())
                            Spacer()
                        }
                    }
                }
                // End of Setting GPX files

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
                            Text("Device ID: \(deviceIdProvider.deviceId ?? "No id")")
                                .font(.caption2)
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
            updateGPXFiles()
        }

    }

}

#Preview {
    SettingsScreen(selectedTab: .constant(4))
}
