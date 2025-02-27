//
//  ProductModel.swift
//  OnlineGroceriesSwiftUI
//
//  Created by Mahir Azmain Haque on 5/12/24.
//

import SwiftUI

struct ProductModel:  Identifiable, Equatable {
    var id: Int = 0
    var prodId: Int = 0
    var catId: Int = 0
    var brandId: Int = 0
    var typeId: Int = 0
    var orderId: Int = 0
    var qty: Int = 0
    var detail: String = ""
    var name: String = ""
    var unitName: String = ""
    var unitValue: String = ""
    var nutritionWeight: String = ""
    var image: String = ""
    var catName: String = ""
    var typeName: String = ""
    var offerPrice: Double?
    var itemPrice: Double = 0.0
    var totalPrice: Double = 0.0
    var price: Double = 0
    var startDate: Date = Date()
    var endDate: Date = Date()
    var isFav: Bool = false
    var avgRating: Int = 0



// MARK: - Initializers

// Default initializer
    init() {}

/// Initializer for NSDictionary (e.g., backend API)

    init(dict: NSDictionary) {
        self.id = dict.value(forKey: "prod_id") as? Int ?? 0
        self.prodId = dict.value(forKey: "prod_id") as? Int ?? 0
        self.catId = dict.value(forKey: "cat_id") as? Int ?? 0
        self.brandId = dict.value(forKey: "brand_id") as? Int ?? 0
        self.typeId = dict.value(forKey: "type_id") as? Int ?? 0
        self.orderId = dict.value(forKey: "order_id") as? Int ?? 0
        self.qty = dict.value(forKey: "qty") as? Int ?? 0
        self.isFav = dict.value(forKey: "is_fav") as? Int ?? 0 == 1
        
        self.detail = dict.value(forKey: "detail") as? String ?? ""
        self.name = dict.value(forKey: "name") as? String ?? ""
        self.unitName = dict.value(forKey: "unit_name") as? String ?? ""
        self.unitValue = dict.value(forKey: "unit_value") as? String ?? ""
        self.nutritionWeight = dict.value(forKey: "nutrition_weight") as? String ?? ""
        self.image = dict.value(forKey: "image") as? String ?? ""
        self.catName = dict.value(forKey: "cat_name") as? String ?? ""
        self.typeName = dict.value(forKey: "type_name") as? String ?? ""
        self.offerPrice = dict.value(forKey: "offer_price") as? Double
        self.price = dict.value(forKey: "price") as? Double ?? 0
        self.itemPrice = dict.value(forKey: "item_price") as? Double ?? 0
        self.totalPrice = dict.value(forKey: "total_price") as? Double ?? 0
        self.startDate = (dict.value(forKey: "start_date") as? String ?? "").stringDateToDate() ?? Date()
        self.endDate = (dict.value(forKey: "end_date") as? String ?? "").stringDateToDate() ?? Date()
        self.avgRating =  Int(dict.value(forKey: "avg_rating") as? Double ?? 0.0)
    }
    /// Initializer for Firestore or Swift dictionaries
    init(dict: [String: Any]) {
        self.id = dict["prod_id"] as? Int ?? 0
        self.prodId = dict["prod_id"] as? Int ?? 0
        self.catId = dict["cat_id"] as? Int ?? 0
        self.brandId = dict["brand_id"] as? Int ?? 0
        self.typeId = dict["type_id"] as? Int ?? 0
        self.orderId = dict["order_id"] as? Int ?? 0
        self.qty = dict["qty"] as? Int ?? 0
        self.isFav = (dict["is_fav"] as? Int ?? 0) == 1
        
        self.detail = dict["detail"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.unitName = dict["unit_name"] as? String ?? ""
        self.unitValue = dict["unit_value"] as? String ?? ""
        self.nutritionWeight = dict["nutrition_weight"] as? String ?? ""
        self.image = dict["image"] as? String ?? ""
        self.catName = dict["cat_name"] as? String ?? ""
        self.typeName = dict["type_name"] as? String ?? ""
        self.offerPrice = dict["offer_price"] as? Double
        self.price = dict["price"] as? Double ?? 0
        self.itemPrice = dict["item_price"] as? Double ?? 0
        self.totalPrice = dict["total_price"] as? Double ?? 0
        self.startDate = (dict["start_date"] as? String ?? "").stringDateToDate() ?? Date()
        self.endDate = (dict["end_date"] as? String ?? "").stringDateToDate() ?? Date()
        self.avgRating = Int(dict["avg_rating"] as? Double ?? 0.0)
    }
    
    static func == (lhs: ProductModel, rhs: ProductModel) -> Bool {
        return lhs.id == rhs.id
    }
}



// MARK: - Extension for Serialization
extension ProductModel {
    func toDict() -> [String: Any] {
        return [
            "prod_id": self.prodId,
            "cat_id": self.catId,
            "brand_id": self.brandId,
            "type_id": self.typeId,
            "order_id": self.orderId,
            "qty": self.qty,
            "detail": self.detail,
            "name": self.name,
            "unit_name": self.unitName,
            "unit_value": self.unitValue,
            "nutrition_weight": self.nutritionWeight,
            "image": self.image,
            "cat_name": self.catName,
            "type_name": self.typeName,
            "offer_price": self.offerPrice ?? 0,
            "item_price": self.itemPrice,
            "total_price": self.totalPrice,
            "price": self.price,
            "start_date": self.startDate.description,
            "end_date": self.endDate.description,
            "is_fav": self.isFav,
            "avg_rating": self.avgRating
        ]
    }
}
