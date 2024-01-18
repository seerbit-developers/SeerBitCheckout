//
//  CustomButton.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 20/10/2023.
//

import SwiftUI

struct CustomButton: View {
    
    var buttonLabel: String = ""
    @State var backgroundColor: Color = Color.black
    @State var textForegroundColor:Color =  Color.white
    var buttonDisabled: Bool = false
    var buttonDisabledColor: Color = Color.gray
    @State var onPress: ()-> Void

    
    var body: some View {
        
        HStack(){
            Button( action: {
                onPress()
            }, label: {
                HStack{
                    Spacer()
                    Text(buttonLabel)
                        .foregroundColor(textForegroundColor)
                        .fontWeight(.medium)
                        .font(.system(size: 14))
                    Spacer()
                }
                .padding(12)
                .background(buttonDisabled ? buttonDisabledColor : backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            })
            .disabled(buttonDisabled)
        }
    }
}
