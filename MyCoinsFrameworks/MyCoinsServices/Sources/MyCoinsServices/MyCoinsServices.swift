//
//  MyCoinsServices.swift
//  
//
//  Created by Arthur Gradim Givigir on 02/05/21.
//

import Firebase

public struct MyCoinsServices {
    
    public static let shared = MyCoinsServices()
    
    public func setupFirebase() {
        FirebaseApp.configure()
    }
}
