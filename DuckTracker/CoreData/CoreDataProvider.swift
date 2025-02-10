import CoreData
import SwiftUI

struct CoreDataProvider {

    static let shared = CoreDataProvider()

    let persistentContainer: NSPersistentContainer

    init() {
        if #available(iOS 15, *) { print(Date.now, "CoreDataProvider // init(): start") }

        persistentContainer = NSPersistentContainer(name: "Main")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("CoreDataProvider / Init failed. Store failed. Error: \(error.localizedDescription). Description: \(description)")
            }
        }

        if #available(iOS 15, *) { print(Date.now, "CoreDataProvider // init(): end") }
    }

    func save() -> Bool {
        if #available(iOS 15, *) { print(Date.now, "CoreDataProvider // save(): start") }

        if !persistentContainer.viewContext.hasChanges {
            if #available(iOS 15, *) { print(Date.now, "CoreDataProvider // save(): end without changes") }
            return true
        }

        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print("CoreDataProvider / persistentContainer.viewContext.save() / Error. Rollback.")
            return false
        }

        if #available(iOS 15, *) { print(Date.now, "CoreDataProvider // save(): end WITH changes") }

        return true
    }

    func addTrack(activeTrack: ActiveTrack, title: String, type: ActiveTrackType) -> Bool {
        let cdTrack = CoreDataTrack(context: persistentContainer.viewContext)

        cdTrack.id = UUID()
        cdTrack.title = title

        cdTrack.timestampStart = activeTrack.trackPoints.first!.location.timestamp
        cdTrack.timestampFinish = activeTrack.trackPoints.last!.location.timestamp
        cdTrack.timestampUpdate = Date()

        _ = cdTrack.generateUniqueHash()
        _ = cdTrack.generateTrackId(firstPoint: activeTrack.trackPoints.first!)

        cdTrack.avgSpeed = activeTrack.avgSpeed
        cdTrack.maxSpeed = activeTrack.maxSpeed
        cdTrack.distance = activeTrack.distance

        cdTrack.type = type.rawValue

        _ = cdTrack.encodeJSONAttributes()
        _ = cdTrack.encodeJSONRoute(activeTrack: activeTrack)

        return save()
    }

    func updateTrack(cdTrack: CoreDataTrack, title: String, type: ActiveTrackType) -> Bool {
        cdTrack.title = title
        cdTrack.type = type.rawValue

        return save()
    }

    func deleteTrack(cdTrack: CoreDataTrack) -> Bool {
        persistentContainer.viewContext.delete(cdTrack)

        return save()
    }

    func selectTracks(_ closure: @escaping (_ cdTracks: [CoreDataTrack]) -> Void) {
//        if #available(iOS 15, *) { print(Date.now, "CoreDataProvider // selectTracks(): start") }

        let fetchRequest = CoreDataTrack.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "timestampStart", ascending: false)
        ]

//        if #available(iOS 15, *) { print(Date.now, "CoreDataProvider // selectTracks(): before async") }

        DispatchQueue.global(qos: .userInitiated).async {
            do {
//                if #available(iOS 15, *) { print(Date.now, "CoreDataProvider // selectTracks(): start async fetch") }
                let result = try persistentContainer.viewContext.fetch(fetchRequest)
                DispatchQueue.main.async {
                    closure(result)
                }
//                if #available(iOS 15, *) { print(Date.now, "CoreDataProvider // selectTracks(): end async fetch") }
            } catch {}
        }
    }

}
