//
//  FavouriteViewModel.swift
//  OnlineGroceriesSwiftUI
//
//  Created by Mahir Azmain Haque on 6/12/24.
//

import SwiftUI
import FirebaseDatabase

class FavouriteViewModel: ObservableObject
{
    static var shared: FavouriteViewModel = FavouriteViewModel()
    
    
    @Published var showError = false
    @Published var errorMessage = ""
    
    @Published var listArr: [ProductModel] = []
    private let realtimeDB = Database.database().reference()

    
    init() {
         serviceCallList()
        //fetchFavoriteList()
    }
    
    // MARK: - Fetch Favorite List from Realtime Database
        func fetchFavoriteList() {
            realtimeDB.child("favorite_details").observeSingleEvent(of: .value) { snapshot in
                guard let data = snapshot.value as? [[String: Any]] else {
                    self.errorMessage = "No favorite items found in the database."
                    self.showError = true
                    return
                }
                
                self.listArr = data.map { ProductModel(dict: $0 as NSDictionary) }
                print("Favorite list fetched successfully: \(self.listArr)")
            } withCancel: { error in
                self.errorMessage = error.localizedDescription
                self.showError = true
                print("Error fetching favorite details: \(error.localizedDescription)")
            }
        }
    
    //MARK: ServiceCall
    
    func serviceCallList(){
        ServiceCall.post(parameter: [:], path: Globs.SV_FAVORITE_LIST, isToken: true ) { responseObj in
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
