//
//  CartViewModel.swift
//  OnlineGroceriesSwiftUI
//
//  Created by Mahir Azmain Haque on 14/12/24.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

class CartViewModel: ObservableObject
{
    static var shared: CartViewModel = CartViewModel()
    
    
    @Published var showError = false
    @Published var showOrderAccept = false
    @Published var errorMessage = ""
    
    @Published var listArr: [CartItemModel] = []
    @Published var total: String = "0.0"
    
    @Published var showCheckout: Bool = false
    
    @Published var showPickerAddress: Bool = false
    @Published var showPickerPayment: Bool = false
    @Published var showPickerPromoCode: Bool = false
    
    @Published var deliveryType: Int = 1
    @Published var paymentType: Int = 1
    @Published var deliverObj: AddressModel?
    @Published var paymentObj: PaymentModel?
    @Published var promoObj: PromoCodeModel?
    
    @Published var deliverPriceAmount: String = ""
    @Published var discountAmount: String = ""
    @Published var userPayAmount: String = ""
    
    @Published var userId: String? = nil

    init() {
         serviceCallList()
        //fetchCartDetails()
    }
    
    func fetchLoggedInUserId() {
          if let user = Auth.auth().currentUser {
              self.userId = user.uid
              print("Logged in user ID: \(self.userId ?? "No user ID found")")
          } else {
              self.errorMessage = "No user is currently logged in."
              self.showError = true
          }
      }
    func fetchCartDetails() {
        guard let userId = self.userId else {
            print("User ID not available. Cannot fetch cart details.")
            return
        }

        let databaseRef = Database.database().reference()
        databaseRef.child("cart_detail").queryOrdered(byChild: "user_id").queryEqual(toValue: userId).observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String: Any] else {
                print("No cart details found for user_id: \(userId)")
                return
            }

            self.listArr = data.compactMap { key, value in
                if let cartDict = value as? [String: Any] {
                    return CartItemModel(dict: cartDict as NSDictionary)
                }
                return nil
            }

            print("Cart items fetched successfully for user_id: \(userId)")
        } withCancel: { error in
            print("Failed to fetch cart details: \(error.localizedDescription)")
        }
    }
    
    func serviceCallUpdateQtyFirebase(cObj: CartItemModel, newQty: Int) {
        let cartRef = Database.database().reference().child("cart_details").child("\(cObj.cartId)")
        
        // Update the quantity in the cart
        cartRef.updateChildValues(["qty": newQty]) { error, _ in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.showError = true
                print("Error updating quantity: \(error.localizedDescription)")
            } else {
                // Refresh the cart list after update
                self.fetchCartDetails()
                print("Quantity updated successfully for cartId: \(cObj.cartId)")
            }
        }
    }
    
    func serviceCallRemoveFirebase(cObj: CartItemModel) {
        let cartRef = Database.database().reference().child("cart_details").child("\(cObj.cartId)")
        
        // Remove the cart item
        cartRef.removeValue { error, _ in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.showError = true
                print("Error removing cart item: \(error.localizedDescription)")
            } else {
                // Refresh the cart list after removal
                self.fetchCartDetails()
                print("Cart item removed successfully for cartId: \(cObj.cartId)")
            }
        }
    }

    func serviceCallOrderPlaceFirebase() {
        if deliveryType == 1 && deliverObj == nil {
            self.errorMessage = "Please select delivery address"
            self.showError = true
            return
        }
        
        if paymentType == 2 && paymentObj == nil {
            self.errorMessage = "Please select payment method"
            self.showError = true
            return
        }
        
        let orderRef = Database.database().reference().child("order_details").childByAutoId()
        let orderData: [String: Any] = [
            "address_id": deliveryType == 2 ? "" : "\(deliverObj?.id ?? 0)",
            "deliver_type": deliveryType,
            "payment_type": paymentType,
            "pay_id": paymentType == 1 ? "" : "\(paymentObj?.id ?? 0)",
            "promo_code_id": promoObj?.id ?? "",
            "order_status": "pending",
            "created_date": Date().displayDate(format: "yyyy-MM-dd HH:mm:ss")
        ]
        
        orderRef.setValue(orderData) { error, _ in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.showError = true
            } else {
                self.deliverObj = nil
                self.paymentObj = nil
                self.promoObj = nil
                self.showCheckout = false
                self.errorMessage = "Order placed successfully!"
                self.showError = true
                self.serviceCallList()
                self.showOrderAccept = true
                print("Order placed successfully!")
            }
        }
    }
    class func serviceCallAddToCartFirebase(prodId: Int, qty: Int, didDone: ((_ isDone: Bool, _ message: String) -> ())?) {
        let cartRef = Database.database().reference().child("cart_details").childByAutoId()
        let cartData: [String: Any] = [
            "prod_id": prodId,
            "qty": qty,
            "status": "active",
            "created_date": Date().displayDate(format: "yyyy-MM-dd HH:mm:ss")
        ]
        
        cartRef.setValue(cartData) { error, _ in
            if let error = error {
                didDone?(false, error.localizedDescription)
            } else {
                didDone?(true, "Product added to cart successfully!")
                print("Product added to cart: \(prodId) with qty: \(qty)")
            }
        }
    }

    //MARK: ServiceCall
    
    func serviceCallList(){
        ServiceCall.post(parameter: ["promo_code_id": promoObj?.id ?? "", "delivery_type": deliveryType ], path: Globs.SV_CART_LIST, isToken: true ) { responseObj in
            if let response = responseObj as? NSDictionary {
                if response.value(forKey: KKey.status) as? String ?? "" == "1" {
                    
                    self.total = response.value(forKey: "total") as? String ?? "0.0"
                    self.discountAmount = response.value(forKey: "discount_amount") as? String ?? "0.0"
                    self.deliverPriceAmount = response.value(forKey: "deliver_price_amount") as? String ?? "0.0"
                    self.userPayAmount = response.value(forKey: "user_pay_price") as? String ?? "0.0"
                    
                   
                    self.listArr = (response.value(forKey: KKey.payload) as? NSArray ?? []).map({ obj in
                        return CartItemModel(dict: obj as? NSDictionary ?? [:])
                    })
                
                }else{
                    self.total = response.value(forKey: "total") as? String ?? "0.0"
                    self.discountAmount = response.value(forKey: "discount_amount") as? String ?? "0.0"
                    self.deliverPriceAmount = response.value(forKey: "deliver_price_amount") as? String ?? "0.0"
                    self.userPayAmount = response.value(forKey: "user_pay_price") as? String ?? "0.0"
                    
                    self.errorMessage = response.value(forKey: KKey.message) as? String ?? "Fail"
                    self.showError = true
                }
            }
        } failure: { error in
            self.errorMessage = error?.localizedDescription ?? "Fail"
            self.showError = true
        }
    }
    
    func serviceCallUpdateQty(cObj: CartItemModel, newQty: Int ){
        ServiceCall.post(parameter: ["cart_id": cObj.cartId, "prod_id": cObj.prodId, "new_qty": newQty ], path: Globs.SV_UPDATE_CART, isToken: true ) { responseObj in
            if let response = responseObj as? NSDictionary {
                if response.value(forKey: KKey.status) as? String ?? "" == "1" {
                    
                    
                    self.serviceCallList()
                
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
    
    func serviceCallRemove(cObj: CartItemModel){
        ServiceCall.post(parameter: ["cart_id": cObj.cartId, "prod_id": cObj.prodId ], path: Globs.SV_REMOVE_CART, isToken: true ) { responseObj in
            if let response = responseObj as? NSDictionary {
                if response.value(forKey: KKey.status) as? String ?? "" == "1" {
                    
                    self.serviceCallList()
                
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
    
    func serviceCallOrderPlace(){
            
        if(deliveryType == 1 && deliverObj == nil ) {
            self.errorMessage = "Please select delivery address"
            self.showError = true
            return
        }
        
        if(paymentType == 2 && paymentObj == nil ) {
            self.errorMessage = "Please select payment method"
            self.showError = true
            return
        }
        
        ServiceCall.post(parameter: ["address_id": deliveryType == 2 ? "" : "\( deliverObj?.id ?? 0)",
                                     "deliver_type": deliveryType,
                                     "payment_type": paymentType,
                                     "pay_id": paymentType == 1 ? "" : "\( paymentObj?.id ?? 0)",
                                     "promo_code_id": promoObj?.id ?? ""  ], path: Globs.SV_ORDER_PLACE, isToken: true ) { responseObj in
            if let response = responseObj as? NSDictionary {
                if response.value(forKey: KKey.status) as? String ?? "" == "1" {
                    
                    
                    self.deliverObj = nil
                    self.paymentObj = nil
                    self.promoObj = nil
                    self.showCheckout = false
                    self.errorMessage = response.value(forKey: KKey.message) as? String ?? "Success"
                    self.showError = true
                    self.serviceCallList()
                    
                    self.showOrderAccept = true
                
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
    
    class func serviceCallAddToCart(prodId: Int, qty: Int, didDone: ((_ isDone: Bool,_ message: String  )->())? ) {
        ServiceCall.post(parameter: ["prod_id":  prodId, "qty": qty], path: Globs.SV_ADD_CART, isToken: true ) { responseObj in
            if let response = responseObj as? NSDictionary {
                if response.value(forKey: KKey.status) as? String ?? "" == "1" {
                    didDone?(true, response.value(forKey: KKey.message) as? String ?? "Done" )
                }else{
                    didDone?(false, response.value(forKey: KKey.message) as? String ?? "Fail" )
                }
            }
        } failure: { error in
            didDone?(false,  error?.localizedDescription ?? "Fail" )
        }

    }
    
}
