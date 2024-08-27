import Foundation
import CoreGPX

class DuckFileManager: NSObject {

    class var filesFolderURL: URL { FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] }

    class var gpxFolderURL: URL {
        // TODO: fix this URL to URL?
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("GPXFiles", isDirectory: true)

        // check gpx folder exists
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url.absoluteURL, withIntermediateDirectories: false)
            } catch let error as NSError {
                print("GPX folder create error: \(error)")
//                return nil
            }
        }

        return url
    }

    class var gpxFiles: [DuckFileInfo] {
        return []
    }

    class func isFileExists(url: URL) -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }

    class func isFileExists(infoTrack: InfoTrack) -> Bool {
        return isFileExists(url: infoTrack.gpxFileURL)
    }

    class func generateGPXContent(infoTrack: InfoTrack) -> String {
        let root = GPXRoot(creator: "Duck Tracker")

        let track = GPXTrack()
        let tracksegment = GPXTrackSegment()
        var trackpoints = [GPXTrackPoint]()

        infoTrack.route.points.forEach { point in
            let trackpoint = GPXTrackPoint(latitude: point.latitude, longitude: point.longitude)
            trackpoint.elevation = point.altitude
            trackpoint.time = point.timestamp
            trackpoints.append(trackpoint)
        }

        tracksegment.add(trackpoints: trackpoints)
        track.add(trackSegment: tracksegment)
        root.add(track: track)

        return root.gpx()
    }

    class func getGPXFileURL(infoTrack: InfoTrack) -> URL? {
        if !isFileExists(url: infoTrack.gpxFileURL) {
            // generate new gpx file
            let gpxContent = generateGPXContent(infoTrack: infoTrack)

            do {
                try gpxContent.write(toFile: infoTrack.gpxFileURL.path, atomically: true, encoding: String.Encoding.utf8)
            } catch let error as NSError {
                print("GPX file save error: \(error)")
                return nil
            }
        }

        return infoTrack.gpxFileURL
    }

    class func getGPXFiles() -> [URL] {
        let gpxFilesList: [URL]

        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: gpxFolderURL, includingPropertiesForKeys: nil)
            gpxFilesList = directoryContents.filter { $0.pathExtension == "gpx" }
        } catch {
            print(error)
            gpxFilesList = []
        }

        return gpxFilesList
    }

}
