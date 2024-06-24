import Foundation

class DuckFileManager: NSObject {

    class var filesFolderURL: URL { FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] }

    class var gpxFolderURL: URL { FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("GPXFiles", isDirectory: true) }

}
