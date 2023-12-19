//
//  PaymentOptionItem.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 20/10/2023.
//

import SwiftUI

struct PaymentOptionItem: View {
    
    var title : String
    let onPress: () -> Void
    
    var body: some View {
        HStack(){
            Button( action: {
                onPress()
            }, label: {
                HStack{
                    Text(title)
                        .foregroundColor(.black)
                        .fontWeight(.medium)
                        .font(.system(size: 12))
                    Spacer()
                    if title == "Debit/Credit Card"{
                        HStack{
                            Image("verve_icon")
                            Image("visa_icon")
                            Image("mastercard_icon")
                        }
                    }
                    
                    if title.lowercased() == "ussd"{
                       Text("*bank ussd code#")
                            .foregroundColor(.black)
                            .fontWeight(.regular)
                            .font(.system(size: 11))
                    }
                    
                }
                .padding(15)
                .background(Color("seaShell"))
                .frame(width: 350)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                
            })
        }
    }
}
