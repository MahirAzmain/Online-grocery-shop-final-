//
//  ExploreItemViewModel.swift
//  OnlineGroceriesSwiftUI
//
//  Created by Mahir Azmain Haque on 14/12/24.
//


import SwiftUI
import FirebaseDatabase

class ExploreItemViewModel: ObservableObject
{
    @Published var cObj: ExploreCategoryModel = ExploreCategoryModel(dict: [:])
    @Published var showError = false
    @Published var errorMessage = ""
    
    @Published var listArr: [ProductModel] = []
    @Published var categories: [ExploreCategoryModel] = [] // Add this property

    private let realtimeDB = Database.database().reference()

    
    init(catObj: ExploreCategoryModel) {
        self.cObj = catObj
        
         serviceCallList()
        //fetchCategoriesFromFirebase()
    }
    
    
    func fetchCategoriesFromFirebase() {
        let databaseRef = Database.database().reference()
        
        // Assuming `product_detail` is structured based on category IDs
        databaseRef.child("product_detail").queryOrdered(byChild: "cat_id").queryEqual(toValue: "\(self.cObj.id)").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                self.errorMessage = "No data found for the selected category."
                self.showError = true
                return
            }
            
            // Map the fetched data to ProductModel
            self.listArr = value.compactMap { _, productData in
                guard let productDict = productData as? [String: Any] else { return nil }
                return ProductModel(dict: productDict as NSDictionary)
            }
        } withCancel: { error in
            self.errorMessage = error.localizedDescription
            self.showError = true
            print("Error fetching data from Firebase: \(error.localizedDescription)")
        }
    }



    
    //MARK: ServiceCall
    
    func serviceCallList(){
        ServiceCall.post(parameter: ["cat_id": self.cObj.id ], path: Globs.SV_EXPLORE_ITEMS_LIST, isToken: true ) { responseObj in
            if let response = responseObj as? NSDictionary {
                if response.value(forKey: KKey.status) as? String ?? "" == "1" {
                    
                    self.listArr = (response.value(forKey: KKey.payload) as? NSArray ?? []).map({ obj in
                        
                        return ProductModel(dict: obj as? NSDictionary ?? [:])
                    })
                }else{
                    self.errorMessage = response.value(forKey: KKey.message) as? String ?? "Fail"
                    self.showError = true
                }
            }
        } failure: { error in
            self.errorMessage = error?.localizedDescription ?? "Fail"
            self.showError = true
        }
    }
    
}
