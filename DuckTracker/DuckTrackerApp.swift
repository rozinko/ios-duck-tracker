/**

 Part of `scenePhase` from: https://www.hackingwithswift.com/books/ios-swiftui/how-to-be-notified-when-your-swiftui-app-moves-to-the-background

 */

import SwiftUI

@main
struct DuckTrackerApp: App, Scene {

    @Environment(\.scenePhase) private var scenePhase

    private let coreDataProvider = CoreDataProvider.shared
    private let locationProvider = LocationProvider.shared

    var body: some Scene {
        WindowGroup {
            WrapperView()
                .environment(\.managedObjectContext, coreDataProvider.persistentContainer.viewContext)
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                locationProvider.start()
            case .background:
                locationProvider.stop()
            default:
                break
            }

            if !coreDataProvider.save() {
                print("SwiftTrackingApp // Scene.onChange() / coreDataProvider.save() returned false.")
            }
        }
    }
}
