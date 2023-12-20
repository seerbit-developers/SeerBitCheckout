//
//  ContentView.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 18/10/2023.
//

import SwiftUI
import SwiftData

@available(iOS 16.0, *)
public struct InitSeerbitCheckout: View {
    
    var amount: Double
    var fullName: String
    var mobileNumber: String
    var publicKey: String
    var email: String
    
    public init (amount:Double, fullName:String, mobileNumber:String, publicKey:String, email:String){
        self.amount = amount
        self.fullName = fullName
        self.mobileNumber = mobileNumber
        self.publicKey = publicKey
        self.email = email
    }
    
    public var body: some View {
        VStack{
            InitializationScreen(
                amount: String(amount),
                fullName: fullName,
                mobileNumber: mobileNumber,
                publicKey: publicKey,
                email: email                )
        }
    }
}
//SBTESTPUBK_t4G16GCA1O51AV0Va3PPretaisXubSw1
//SBPUBK_WWEQK6UVR1PNZEVVUOBNIQHEIEIM1HJC
