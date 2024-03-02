//
//  ChangePaymentMethod.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 21/11/2023.
//

import SwiftUI

struct ChangePaymentMethod: View {
    @State var onChange: ()-> Void
    @State var onCancel: ()-> Void
    var OnChangeText = "Change payment method"
    var onCancelText = "Cancel payment"
    
    var body: some View {
        
        HStack{
            Button(action: {withAnimation{onChange()}}, label: {
                Text(OnChangeText)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 12)
                    .fontWeight(.regular)
                    .font(.system(size: 13))
                    .foregroundColor(Color(.pureRed))
                    .background(Color(.fadedRed))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            })
            
            Button(action: {withAnimation{onCancel()}}, label: {
                Text(onCancelText)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .foregroundColor(Color(.dark))
                    .fontWeight(.regular)
                    .font(.system(size: 13))
                    .background(Color(.dark))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            })
        }
    }
}
