import CoreData
import SwiftUI

struct CoreDataProvider {

    static let shared = CoreDataProvider()

    let persistentContainer: NSPersistentContainer

    init() {
        persistentContainer = NSPersistentContainer(name: "Main")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("CoreDataProvider / Init failed. Store failed. Error: \(error.localizedDescription). Description: \(description)")
            }
        }
    }

    func save() -> Bool {
        if !persistentContainer.viewContext.hasChanges {
            return true
        }

        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            return false
        }

        return true
    }

    func selectAll(_ closure: @escaping (_ cdTracks: [CoreDataTrack]) -> Void) {
        let fetchRequest = CoreDataTrack.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "timestampStart", ascending: false)
        ]

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                sleep(2)
                let result = try persistentContainer.viewContext.fetch(fetchRequest)
                DispatchQueue.main.async {
                    closure(result)
                }
            } catch {}
        }
    }

    func selectById(trackId id: UUID, _ closure: @escaping (_ cdTrack: [CoreDataTrack]) -> Void) {
        let fetchRequest = CoreDataTrack.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id ==  %@", id as CVarArg)

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                sleep(25)
                let result = try persistentContainer.viewContext.fetch(fetchRequest)
                DispatchQueue.main.async {
                    closure(result)
                }
            } catch {}
        }
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

}
