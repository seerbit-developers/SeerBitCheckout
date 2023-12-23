//
//  CustomInput.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 20/10/2023.
//

import SwiftUI

struct CustomInput: View {
    @State var textForegroundColor:Color =  Color.black
    @State var backgroundColor: Color = Color.black
    @Binding  var value: String
    @State  var placeHolder: String
    @State var rightText: String = ""
    @State var borderWidth: Int = 2
    
    @State var keyboardType: UIKeyboardType = .default
    
    
    var body: some View {
        HStack{
            TextField(placeHolder, text: $value)
                .foregroundColor(textForegroundColor)
                .fontWeight(.regular)
                .font(.system(size: 12))
                .keyboardType(keyboardType)
            Spacer()
            Text(rightText)
                .foregroundColor(textForegroundColor)
                .fontWeight(.medium)
                .font(.system(size: 12))
        }
        .padding(.horizontal, 11)
        .padding(.vertical, 12)
        .border(Color(uiColor: UIColor(named: "seaShell", in: .module, compatibleWith: nil)!), width: CGFloat(borderWidth))
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}
