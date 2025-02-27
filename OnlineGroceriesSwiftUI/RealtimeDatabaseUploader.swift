import FirebaseDatabase
import Foundation

class RealtimeDatabaseUploader {
    
    func uploadJSONToRealtimeDatabase() {
        let databaseRef = Database.database().reference().child("cart_detail")
        
        // Array of cart details to upload
        let cartDetails : [[String: Any]] =
        [
            ["cart_id":"1","user_id":"2","prod_id":"5","qty":"0","status":"2","created_date":"2023-08-06 16:50:58","modify_date":"2023-08-06 16:53:08"],
            ["cart_id":"2","user_id":"2","prod_id":"6","qty":"1","status":"2","created_date":"2023-08-06 16:52:48","modify_date":"2023-08-06 16:54:53"],
            ["cart_id":"3","user_id":"2","prod_id":"5","qty":"1","status":"2","created_date":"2023-08-08 08:18:57","modify_date":"2023-08-08 08:19:29"],
            ["cart_id":"4","user_id":"2","prod_id":"5","qty":"3","status":"2","created_date":"2023-08-08 09:37:44","modify_date":"2023-08-08 10:12:44"],
            ["cart_id":"5","user_id":"2","prod_id":"11","qty":"1","status":"2","created_date":"2023-08-08 09:38:01","modify_date":"2023-08-08 10:12:45"],
            ["cart_id":"6","user_id":"2","prod_id":"10","qty":"3","status":"2","created_date":"2023-08-08 09:38:02","modify_date":"2023-08-08 10:12:47"],
            ["cart_id":"7","user_id":"2","prod_id":"5","qty":"1","status":"2","created_date":"2023-08-08 10:13:04","modify_date":"2023-08-08 11:45:08"],
            ["cart_id":"8","user_id":"2","prod_id":"6","qty":"1","status":"2","created_date":"2023-08-08 10:13:06","modify_date":"2023-08-08 11:45:09"],
            ["cart_id":"9","user_id":"2","prod_id":"6","qty":"1","status":"2","created_date":"2023-08-08 10:13:08","modify_date":"2023-08-08 10:13:14"],
            ["cart_id":"10","user_id":"7","prod_id":"5","qty":"1","status":"2","created_date":"2023-08-08 11:18:33","modify_date":"2023-08-08 11:31:27"],
            ["cart_id":"11","user_id":"7","prod_id":"5","qty":"4","status":"2","created_date":"2023-08-08 11:19:31","modify_date":"2023-08-08 11:44:17"],
            ["cart_id":"12","user_id":"7","prod_id":"6","qty":"1","status":"2","created_date":"2023-08-08 11:19:55","modify_date":"2023-08-08 11:37:50"],
            ["cart_id":"13","user_id":"7","prod_id":"7","qty":"0","status":"2","created_date":"2023-08-08 11:21:24","modify_date":"2023-08-08 11:32:58"],
            ["cart_id":"14","user_id":"7","prod_id":"5","qty":"1","status":"2","created_date":"2023-08-08 11:46:21","modify_date":"2023-08-08 11:47:03"],
            ["cart_id":"15","user_id":"7","prod_id":"5","qty":"1","status":"2","created_date":"2023-08-08 11:47:08","modify_date":"2023-08-08 11:47:13"],
            ["cart_id":"16","user_id":"7","prod_id":"5","qty":"2","status":"1","created_date":"2023-08-08 11:50:56","modify_date":"2023-08-08 11:59:41"],
            ["cart_id":"17","user_id":"7","prod_id":"6","qty":"3","status":"1","created_date":"2023-08-08 11:51:03","modify_date":"2023-08-08 11:51:03"],
            ["cart_id":"18","user_id":"2","prod_id":"5","qty":"1","status":"2","created_date":"2023-08-08 11:53:14","modify_date":"2023-08-10 10:26:51"],
            ["cart_id":"19","user_id":"7","prod_id":"5","qty":"1","status":"1","created_date":"2023-08-10 10:37:12","modify_date":"2023-08-10 10:37:12"],
            ["cart_id":"20","user_id":"7","prod_id":"6","qty":"1","status":"1","created_date":"2023-08-10 10:37:14","modify_date":"2023-08-10 10:37:14"],
            ["cart_id":"21","user_id":"7","prod_id":"6","qty":"1","status":"1","created_date":"2023-08-10 10:37:16","modify_date":"2023-08-10 10:37:16"],
            ["cart_id":"22","user_id":"2","prod_id":"5","qty":"3","status":"2","created_date":"2023-08-10 10:38:03","modify_date":"2023-08-10 10:39:14"],
            ["cart_id":"23","user_id":"2","prod_id":"6","qty":"2","status":"2","created_date":"2023-08-10 10:38:10","modify_date":"2023-08-10 10:39:14"],
            ["cart_id":"24","user_id":"2","prod_id":"5","qty":"1","status":"2","created_date":"2023-08-10 17:56:55","modify_date":"2023-08-10 19:23:38"],
            ["cart_id":"25","user_id":"2","prod_id":"6","qty":"1","status":"2","created_date":"2023-08-10 17:56:57","modify_date":"2023-08-10 19:23:38"],
            ["cart_id":"26","user_id":"2","prod_id":"5","qty":"1","status":"2","created_date":"2023-08-10 19:24:33","modify_date":"2023-08-10 19:25:02"],
            ["cart_id":"27","user_id":"2","prod_id":"6","qty":"1","status":"2","created_date":"2023-08-10 19:24:35","modify_date":"2023-08-10 19:25:02"],
            ["cart_id":"28","user_id":"2","prod_id":"6","qty":"1","status":"2","created_date":"2023-08-10 19:24:37","modify_date":"2023-08-10 19:25:02"],
            ["cart_id":"29","user_id":"2","prod_id":"5","qty":"1","status":"2","created_date":"2023-08-10 19:27:56","modify_date":"2023-08-10 19:28:26"],
            ["cart_id":"30","user_id":"2","prod_id":"5","qty":"1","status":"2","created_date":"2023-08-10 19:28:53","modify_date":"2023-08-10 19:29:26"],
            ["cart_id":"31","user_id":"2","prod_id":"5","qty":"1","status":"2","created_date":"2023-08-10 19:31:36","modify_date":"2023-08-10 19:32:02"],
            ["cart_id":"32","user_id":"2","prod_id":"5","qty":"1","status":"2","created_date":"2023-08-10 19:34:46","modify_date":"2023-08-10 19:34:55"],
            ["cart_id":"33","user_id":"2","prod_id":"5","qty":"2","status":"2","created_date":"2023-08-10 19:35:51","modify_date":"2023-08-10 19:41:14"],
            ["cart_id":"34","user_id":"2","prod_id":"6","qty":"2","status":"2","created_date":"2023-08-10 19:35:54","modify_date":"2023-08-10 19:41:14"],
            ["cart_id":"35","user_id":"2","prod_id":"7","qty":"1","status":"2","created_date":"2023-08-10 19:36:04","modify_date":"2023-08-10 19:41:14"],
            ["cart_id":"36","user_id":"2","prod_id":"5","qty":"1","status":"1","created_date":"2023-08-11 16:32:23","modify_date":"2023-08-11 16:32:23"],
            ["cart_id":"37","user_id":"8","prod_id":"6","qty":"3","status":"1","created_date":"2024-12-26 21:33:18","modify_date":"2024-12-26 21:33:24"]
        ]
        
        
        // Loop through the array and add each cart detail
        for cartDetail in cartDetails {
            if let cartId = cartDetail["cart_id"] as? String {
                databaseRef.child(cartId).setValue(cartDetail) { error, _ in
                    if let error = error {
                        print("Error saving cart detail \(cartId): \(error.localizedDescription)")
                    } else {
                        print("Cart detail \(cartId) saved successfully!")
                    }
                }
            }
            //        uploadProductDetails()
            //        uploadNutritionDetails()
            //        uploadImageDetails()
            //        uploadCartDetails()
            //        uploadAddressDetails()
            //
            //        uploadJSONFile(fileName: "area_detail", toNode: "area_detail")
            //               uploadJSONFile(fileName: "brand_detail", toNode: "brand_detail")
            //               uploadJSONFile(fileName: "category_detail", toNode: "category_detail")
            //               uploadJSONFile(fileName: "favorite_detail", toNode: "favorite_detail")
            //               uploadJSONFile(fileName: "notification_detail", toNode: "notification_detail")
            //        uploadJSONFile(fileName: "offer_detail", toNode: "offer_detail")
            //        uploadJSONFile(fileName: "favorite_detail", toNode: "favorite_detail")
            //        uploadJSONFile(fileName: "favorite_detail", toNode: "favorite_detail")
            //        uploadJSONFile(fileName: "order_detail", toNode: "order_detail")
            //        uploadJSONFile(fileName: "order_payment_detail", toNode: "order_payment_detail")
            //        uploadJSONFile(fileName: "payment_method_detail", toNode: "payment_method_detail")
            //        uploadJSONFile(fileName: "promo_code_detail", toNode: "promo_code_detail")
            //        uploadJSONFile(fileName: "review_detail", toNode: "review_detail")
            //        uploadJSONFile(fileName: "type_detail", toNode: "type_detail")
            //        uploadJSONFile(fileName: "user_detail", toNode: "user_detail")
            //        uploadJSONFile(fileName: "zone_detail", toNode: "zone_detail")
            
            
        }
    }
    
    //    private func uploadJSONFile(fileName: String, toNode: String) {
    //            guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
    //                print("JSON file \(fileName) not found")
    //                return
    //            }
    //
    //            do {
    //                let data = try Data(contentsOf: URL(fileURLWithPath: path))
    //                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
    //                    for item in jsonArray {
    //                        if let id = item["\(fileName.split(separator: "_")[0])_id"] as? String {
    //                            ref.child(toNode).child(id).setValue(item) { error, _ in
    //                                if let error = error {
    //                                    print("Error uploading \(id) to \(toNode): \(error.localizedDescription)")
    //                                } else {
    //                                    print("Successfully uploaded \(id) to \(toNode)")
    //                                }
    //                            }
    //                        } else {
    //                            print("Missing ID in \(item) for file \(fileName)")
    //                        }
    //                    }
    //                } else {
    //                    print("Invalid JSON structure in file \(fileName)")
    //                }
    //            } catch {
    //                print("Error reading or parsing JSON file \(fileName): \(error.localizedDescription)")
    //            }
    //        }
    //    private func uploadAddressDetails() {
    //            guard let path = Bundle.main.path(forResource: "address_detail", ofType: "json") else {
    //                print("Address JSON file not found")
    //                return
    //            }
    //
    //            do {
    //                let data = try Data(contentsOf: URL(fileURLWithPath: path))
    //                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
    //                    for address in jsonArray {
    //                        if let addressId = address["address_id"] as? String, let userId = address["user_id"] as? String {
    //                            ref.child("address_detail").child(userId).child(addressId).setValue(address) { error, _ in
    //                                if let error = error {
    //                                    print("Error uploading address \(addressId): \(error.localizedDescription)")
    //                                } else {
    //                                    print("Address \(addressId) for user \(userId) uploaded successfully!")
    //                                }
    //                            }
    //                        } else {
    //                            print("Missing 'address_id' or 'user_id' in address: \(address)")
    //                        }
    //                    }
    //                }
    //            } catch {
    //                print("Error reading or parsing Address JSON file: \(error.localizedDescription)")
    //            }
    //        }
    //
    //    private func uploadProductDetails() {
    //           guard let path = Bundle.main.path(forResource: "product_detail", ofType: "json") else {
    //               print("Product JSON file not found")
    //               return
    //           }
    //
    //           do {
    //               // Read and parse the product_detail.json file
    //               let data = try Data(contentsOf: URL(fileURLWithPath: path))
    //               if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
    //                   for product in jsonArray {
    //                       if let prodId = product["prod_id"] as? String {
    //                           ref.child("product_detail").child(prodId).setValue(product) { error, _ in
    //                               if let error = error {
    //                                   print("Error uploading product \(prodId): \(error.localizedDescription)")
    //                               } else {
    //                                   print("Product \(prodId) uploaded successfully!")
    //                               }
    //                           }
    //                       } else {
    //                           print("Missing 'prod_id' in product: \(product)")
    //                       }
    //                   }
    //               }
    //           } catch {
    //               print("Error reading or parsing Product JSON file: \(error.localizedDescription)")
    //           }
    //       }
    //
    //       private func uploadNutritionDetails() {
    //           guard let path = Bundle.main.path(forResource: "nutrition_detail", ofType: "json") else {
    //               print("Nutrition JSON file not found")
    //               return
    //           }
    //
    //           do {
    //               // Read and parse the nutrition_detail.json file
    //               let data = try Data(contentsOf: URL(fileURLWithPath: path))
    //               if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
    //                   for nutrition in jsonArray {
    //                       if let nutritionId = nutrition["nutrition_id"] as? String, let prodId = nutrition["prod_id"] as? String {
    //                           ref.child("nutrition_detail").child(prodId).child(nutritionId).setValue(nutrition) { error, _ in
    //                               if let error = error {
    //                                   print("Error uploading nutrition \(nutritionId): \(error.localizedDescription)")
    //                               } else {
    //                                   print("Nutrition \(nutritionId) for product \(prodId) uploaded successfully!")
    //                               }
    //                           }
    //                       } else {
    //                           print("Missing 'nutrition_id' or 'prod_id' in nutrition: \(nutrition)")
    //                       }
    //                   }
    //               }
    //           } catch {
    //               print("Error reading or parsing Nutrition JSON file: \(error.localizedDescription)")
    //           }
    //       }
    //
    //
    //    private func uploadImageDetails() {
    //        guard let path = Bundle.main.path(forResource: "image_detail", ofType: "json") else {
    //            print("Image JSON file not found")
    //            return
    //        }
    //
    //        do {
    //            // Read and parse the image_detail.json file
    //            let data = try Data(contentsOf: URL(fileURLWithPath: path))
    //            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
    //                for image in jsonArray {
    //                    if let imgId = image["img_id"] as? String, let prodId = image["prod_id"] as? String {
    //                        ref.child("image_detail").child(prodId).child(imgId).setValue(image) { error, _ in
    //                            if let error = error {
    //                                print("Error uploading image \(imgId): \(error.localizedDescription)")
    //                            } else {
    //                                print("Image \(imgId) for product \(prodId) uploaded successfully!")
    //                            }
    //                        }
    //                    } else {
    //                        print("Missing 'img_id' or 'prod_id' in image: \(image)")
    //                    }
    //                }
    //            }
    //        } catch {
    //            print("Error reading or parsing Image JSON file: \(error.localizedDescription)")
    //        }
    //    }
    //
    //    private func uploadCartDetails() {
    //            guard let path = Bundle.main.path(forResource: "cart_detail", ofType: "json") else {
    //                print("Cart JSON file not found")
    //                return
    //            }
    //
    //            do {
    //                let data = try Data(contentsOf: URL(fileURLWithPath: path))
    //                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
    //                    for cart in jsonArray {
    //                        if let cartId = cart["cart_id"] as? String, let userId = cart["user_id"] as? String {
    //                            ref.child("cart_detail").child(userId).child(cartId).setValue(cart) { error, _ in
    //                                if let error = error {
    //                                    print("Error uploading cart \(cartId): \(error.localizedDescription)")
    //                                } else {
    //                                    print("Cart \(cartId) for user \(userId) uploaded successfully!")
    //                                }
    //                            }
    //                        } else {
    //                            print("Missing 'cart_id' or 'user_id' in cart: \(cart)")
    //                        }
    //                    }
    //                }
    //            } catch {
    //                print("Error reading or parsing Cart JSON file: \(error.localizedDescription)")
    //            }
    //        }
    //
    //
    //
    //}
}
