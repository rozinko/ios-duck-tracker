import Foundation

public extension URL {

    // solution from https://stackoverflow.com/questions/28268145/get-file-size-in-swift
    var fileSize: Int? {
        let value = try? resourceValues(forKeys: [.fileSizeKey])
        return value?.fileSize
    }
}
