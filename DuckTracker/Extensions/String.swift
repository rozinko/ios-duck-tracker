import Foundation
import CryptoKit

extension String {

    // from: https://sarunw.com/posts/how-to-capitalize-the-first-letter-in-swift/
    var capitalizedSentence: String {
            let firstLetter = self.prefix(1).capitalized
            let remainingLetters = self.dropFirst().lowercased()
            return firstLetter + remainingLetters
        }

    /// Generate random string
    public func random(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }

    func localized(withPrefix prefix: String = "") -> String {
        return NSLocalizedString(prefix + self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }

    /// MD5 hash function
    ///
    /// code from https://stackoverflow.com/questions/55356220/get-string-md5-in-swift-5
    public func md5() -> String {
        guard let d = self.data(using: .utf8) else {
            return ""
        }

        let digest = Insecure.MD5.hash(data: d)
        let h = digest.reduce("") { (res: String, element) in
            let hex = String(format: "%02x", element)
            let t = res + hex
            return t
        }
        return h
    }

    /// SHA256 hash function
    ///
    /// code from https://www.hackingwithswift.com/example-code/cryptokit/how-to-calculate-the-sha-hash-of-a-string-or-data-instance
    public func sha256() -> String {
        let inputData = Data(self.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }

    /// SHA512 hash function
    public func sha512() -> String {
        let inputData = Data(self.utf8)
        let hashed = SHA512.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }

}
