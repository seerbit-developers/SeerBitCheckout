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
    var body: some View {
        
        HStack{
            Button(action: {withAnimation{onChange()}}, label: {
                Text("Change payment method")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .fontWeight(.regular)
                    .font(.system(size: 13))
                    .foregroundColor(Color("pureRed"))
                    .font(.system(size: 13))
                    .background(Color("fadedRed"))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            })
            
            Button(action: {withAnimation{onCancel()}}, label: {
                Text("Cancel payment")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .foregroundColor(Color("dark"))
                    .fontWeight(.regular)
                    .font(.system(size: 13))
                    .background(Color("seaShell"))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            })
        }
    }
}
