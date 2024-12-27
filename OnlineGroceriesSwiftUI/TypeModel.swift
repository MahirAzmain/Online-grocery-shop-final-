import SwiftUI

struct TypeModel: Identifiable, Equatable {
    var id: Int = 0
    var name: String = ""
    var image: String = ""
    var color: Color = Color.primaryApp

    // MARK: - Initializers

    /// Default initializer
    init() {}

    /// Initializer for NSDictionary (e.g., backend API)
    init(dict: NSDictionary) {
        self.id = dict.value(forKey: "type_id") as? Int ?? 0
        self.name = dict.value(forKey: "type_name") as? String ?? ""
        self.image = dict.value(forKey: "image") as? String ?? ""
        self.color = Color(hex: dict.value(forKey: "color") as? String ?? "000000")
    }

    /// Initializer for Firestore or Swift dictionaries
    init(dict: [String: Any]) {
        self.id = dict["type_id"] as? Int ?? 0
        self.name = dict["type_name"] as? String ?? ""
        self.image = dict["image"] as? String ?? ""
        self.color = Color(hex: dict["color"] as? String ?? "000000")
    }

    // MARK: - Equatable Conformance
    static func == (lhs: TypeModel, rhs: TypeModel) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Extension for Serialization
extension TypeModel {
    /// Converts `TypeModel` to a dictionary for Firestore or API usage.
    func toDict() -> [String: Any] {
        return [
            "type_id": self.id,
            "type_name": self.name,
            "image": self.image,
            "color": self.color.toHexString()
        ]
    }
}

// MARK: - Extension for Color Hex Conversion
extension Color {
    /// Converts a `Color` object to a hex string for storing in Firestore or APIs.
    func toHexString() -> String {
        let components = UIColor(self).cgColor.components ?? [0, 0, 0, 1]
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}
