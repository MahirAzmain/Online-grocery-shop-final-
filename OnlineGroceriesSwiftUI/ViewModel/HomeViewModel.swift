//
//  HomeViewModel.swift
//  OnlineGroceriesSwiftUI
//
//  Created by Mahir Azmain Haque on 5/12/24.
//


import SwiftUI
import FirebaseFirestore
import FirebaseDatabase


class HomeViewModel: ObservableObject
{
    static var shared: HomeViewModel = HomeViewModel()
    
    @Published var selectTab: Int = 0
    @Published var txtSearch: String = ""
    
    
    @Published var showError = false
    @Published var errorMessage = ""
    
    @Published var offerArr: [ProductModel] = []
    @Published var bestArr: [ProductModel] = []
    @Published var listArr: [ProductModel] = []
    @Published var typeArr: [TypeModel] = []
    
    private let db = Firestore.firestore()
    private let realtimeDB = Database.database().reference()
    init() {
//        serviceCallList()
        /*fetchDataFromFirestore*/()
        fetchDataFromRealtimeDatabase()
    }
    
    
    
    //MARK: ServiceCall
    
    func serviceCallList(){
        ServiceCall.post(parameter: [:], path: Globs.SV_HOME, isToken: true ) { responseObj in
            if let response = responseObj as? NSDictionary {
                if response.value(forKey: KKey.status) as? String ?? "" == "1" {
                    
                    if let payloadObj = response.value(forKey: KKey.payload) as? NSDictionary {
                        self.offerArr = (payloadObj.value(forKey: "offer_list") as? NSArray ?? []).map({ obj in
                            
                            return ProductModel(dict: obj as? NSDictionary ?? [:])
                        })
                        
                        self.bestArr = (payloadObj.value(forKey: "best_sell_list") as? NSArray ?? []).map({ obj in
                            
                            return ProductModel(dict: obj as? NSDictionary ?? [:])
                        })
                        
                        self.listArr = (payloadObj.value(forKey: "list") as? NSArray ?? []).map({ obj in
                            
                            return ProductModel(dict: obj as? NSDictionary ?? [:])
                        })
                        
                        self.typeArr = (payloadObj.value(forKey: "type_list") as? NSArray ?? []).map({ obj in
                            
                            return TypeModel(dict: obj as? NSDictionary ?? [:])
                        })
                    }
                    
                    
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
    // MARK: Fetch Data from Firestore
    func fetchDataFromFirestore() {
        db.collection("homeData").getDocuments { snapshot, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.showError = true
                return
            }
            
            guard let documents = snapshot?.documents else {
                self.errorMessage = "No data found"
                self.showError = true
                return
            }
            
            self.offerArr = documents.compactMap { doc -> ProductModel? in
                if let data = doc.data()["offer_list"] as? [String: Any] {
                    return ProductModel(dict: data)
                }
                return nil
            }
            
            self.bestArr = documents.compactMap { doc -> ProductModel? in
                if let data = doc.data()["best_sell_list"] as? [String: Any] {
                    return ProductModel(dict: data)
                }
                return nil
            }
            
            self.listArr = documents.compactMap { doc -> ProductModel? in
                if let data = doc.data()["list"] as? [String: Any] {
                    return ProductModel(dict: data)
                }
                return nil
            }
            
            self.typeArr = documents.compactMap { doc -> TypeModel? in
                if let data = doc.data()["type_list"] as? [String: Any] {
                    return TypeModel(dict: data)
                }
                return nil
            }
        }
    }
    
    // MARK: Save Data to Firestore
    func saveDataToFirestore() {
        let data: [String: Any] = [
            "offer_list": offerArr.map { $0.toDict() },
            "best_sell_list": bestArr.map { $0.toDict() },
            "list": listArr.map { $0.toDict() },
            "type_list": typeArr.map { $0.toDict() }
        ]
        
        db.collection("homeData").document("homeDataDoc").setData(data) { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.showError = true
                return
            }
            print("Data saved successfully to Firestore")
        }
    }
    
    
    // MARK: Fetch Data from Firebase Realtime Database
    func fetchDataFromRealtimeDatabase() {
        realtimeDB.child("homeData").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                self.errorMessage = "No data found in Realtime Database"
                self.showError = true
                return
            }
            
            if let offerList = value["offer_list"] as? [[String: Any]] {
                self.offerArr = offerList.map { ProductModel(dict: $0 as NSDictionary) }
            }
            
            if let bestSellList = value["best_sell_list"] as? [[String: Any]] {
                self.bestArr = bestSellList.map { ProductModel(dict: $0 as NSDictionary) }
            }
            
            if let list = value["list"] as? [[String: Any]] {
                self.listArr = list.map { ProductModel(dict: $0 as NSDictionary) }
            }
            
            if let typeList = value["type_list"] as? [[String: Any]] {
                self.typeArr = typeList.map { TypeModel(dict: $0 as NSDictionary) }
            }
        } withCancel: { error in
            self.errorMessage = error.localizedDescription
            self.showError = true
            print("Error fetching data from Realtime Database: \(error.localizedDescription)")
        }
    }
    
    // MARK: Save Data to Firebase Realtime Database
    func saveDataToRealtimeDatabase() {
        let data: [String: Any] = [
            "offer_list": offerArr.map { $0.toDict() },
            "best_sell_list": bestArr.map { $0.toDict() },
            "list": listArr.map { $0.toDict() },
            "type_list": typeArr.map { $0.toDict() }
        ]
        
        realtimeDB.child("homeData").setValue(data) { error, _ in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.showError = true
                print("Error saving data to Realtime Database: \(error.localizedDescription)")
            } else {
                print("Data saved successfully to Realtime Database")
            }
        }
    }
}
    
    

  


    


