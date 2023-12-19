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
    
     public var body: some View {
        VStack{
                InitializationScreen(
                    amount: "2",
                    fullName: "eugene miracle",
                    mobileNumber: "08131248253",
                    publicKey: "SBTESTPUBK_t4G16GCA1O51AV0Va3PPretaisXubSw1",
                    email: "qwdfef@gmail.com")
        }
    }
}
//SBTESTPUBK_t4G16GCA1O51AV0Va3PPretaisXubSw1
//SBPUBK_WWEQK6UVR1PNZEVVUOBNIQHEIEIM1HJC
