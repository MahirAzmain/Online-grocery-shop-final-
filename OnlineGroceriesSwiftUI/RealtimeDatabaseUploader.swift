import FirebaseDatabase
import Foundation

class RealtimeDatabaseUploader {
    private let ref = Database.database().reference() // Reference to Realtime Database

    func uploadJSONToRealtimeDatabase() {
        // Path to your JSON file in the project
        guard let path = Bundle.main.path(forResource: "product_detail", ofType: "json") else {
            print("JSON file not found")
            return
        }

        do {
            // Read and parse the JSON file
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                // Iterate through the array and upload each item to Firebase
                for product in jsonArray {
                    if let prodId = product["prod_id"] as? String {
                        ref.child("products").child(prodId).setValue(product) { error, _ in
                            if let error = error {
                                print("Error uploading product \(prodId): \(error.localizedDescription)")
                            } else {
                                print("Product \(prodId) uploaded successfully!")
                            }
                        }
                    } else {
                        print("Missing 'prod_id' in product: \(product)")
                    }
                }
            }
        } catch {
            print("Error reading or parsing JSON file: \(error.localizedDescription)")
        }
    }
}
