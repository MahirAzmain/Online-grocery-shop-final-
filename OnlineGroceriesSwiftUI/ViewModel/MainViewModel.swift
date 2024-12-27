//
//  MainViewModel.swift
//  OnlineGroceriesSwiftUI
//
//  Created by Mahir Azmain Haque on 15/11/24.
//

import SwiftUI
import FirebaseAuth
import Firebase

class MainViewModel: ObservableObject {
    static var shared: MainViewModel = MainViewModel()
    
    @Published var txtUsername: String = ""
    @Published var txtEmail: String = ""
    @Published var txtPassword: String = ""
    @Published var isShowPassword: Bool = false
    
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var isUserLogin: Bool = false
    @Published var userObj: UserModel = UserModel(dict: [:])
    
    init() {
        
        
        if( Utils.UDValueBool(key: Globs.userLogin) ) {
            // User Login
            self.setUserData(uDict: Utils.UDValue(key: Globs.userPayload) as? NSDictionary ?? [:] )
        }else{
            // User Not Login
        }
        
#if DEBUG
        txtUsername = "user4"
        txtEmail = "test@gmail.com"
        txtPassword = "123456"
#endif
        
    }
    
    func logout(){
        Utils.UDSET(data: false, key: Globs.userLogin)
        isUserLogin = false
    }
    
    //MARK: ServiceCall
    func serviceCallLogin(){
        
        
        if(!txtEmail.isValidEmail) {
            self.errorMessage = "please enter valid email address"
            self.showError = true
            return
        }
        
        if(txtPassword.isEmpty) {
            self.errorMessage = "please enter valid password"
            self.showError = true
            return
        }
        Auth.auth().signIn(withEmail: txtEmail, password: txtPassword) { [weak self] result, error in
              if let error = error {
                  self?.showError = true
                  self?.errorMessage = error.localizedDescription
                  return
              }
              
              // Login successful
              if let user = result?.user {
                  print("User \(user.email ?? "No Email") logged in successfully!")
              }
          }
        
        ServiceCall.post(parameter: ["email": txtEmail, "password": txtPassword, "dervice_token":"" ], path: Globs.SV_LOGIN) { responseObj in
            if let response = responseObj as? NSDictionary {
                if response.value(forKey: KKey.status) as? String ?? "" == "1" {
                    
                    
                    
                    self.setUserData(uDict: response.value(forKey: KKey.payload) as? NSDictionary ?? [:])
                    
                    
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
    
    func serviceCallSignUp(){
        
        if(txtUsername.isEmpty) {
            self.errorMessage = "please enter valid username"
            self.showError = true
            return
        }
        
        
        if(!txtEmail.isValidEmail) {
            self.errorMessage = "please enter valid email address"
            self.showError = true
            return
        }
        
        if(txtPassword.isEmpty) {
            self.errorMessage = "please enter valid password"
            self.showError = true
            return
        }
        Auth.auth().createUser(withEmail: txtEmail, password: txtPassword) { [weak self] result, error in
            if let error = error {
                self?.showError = true
                self?.errorMessage = error.localizedDescription
                return
            }
            
            // Successfully created a user
            if let user = result?.user {
                print("User \(user.email ?? "No Email") created successfully!")
            }
        }
    

        
        ServiceCall.post(parameter: [ "username": txtUsername , "email": txtEmail, "password": txtPassword, "dervice_token":"" ], path: Globs.SV_SIGN_UP) { responseObj in
            if let response = responseObj as? NSDictionary {
                if response.value(forKey: KKey.status) as? String ?? "" == "1" {
                    self.setUserData(uDict: response.value(forKey: KKey.payload) as? NSDictionary ?? [:])
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
    
    func setUserData(uDict: NSDictionary) {
        
        
        Utils.UDSET(data: uDict, key: Globs.userPayload)
        Utils.UDSET(data: true, key: Globs.userLogin)
        self.userObj = UserModel(dict: uDict)
        self.isUserLogin = true
        
        self.txtUsername = ""
        self.txtEmail = ""
        self.txtPassword = ""
        self.isShowPassword = false
    }
    
}
