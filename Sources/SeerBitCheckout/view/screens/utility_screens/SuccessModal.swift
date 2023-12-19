//
//  SuccessScreen.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 20/10/2023.
//

import SwiftUI

struct SuccessModal: View {
    let title: String = "Success"
    let description: String = "Transaction is completed successfully"
    let buttonText: String  = "Close"
    let buttonAction: ()-> Void

    
    var body: some View {
        VStack{
            Text(title)
                .foregroundColor(Color("dusk"))
                .fontWeight(.heavy)
                .font(.system(size: 18))
            Spacer().frame(height: 30)
            Image("sdk_success2")
                .frame(width: 60, height: 60)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .aspectRatio(0.75, contentMode: .fit)
            Spacer().frame(height: 10)
            Text(description)
                .foregroundColor(Color("dusk"))
                .fontWeight(.light)
                .font(.system(size: 14))
            Spacer().frame(height: 40)
            CustomButton(buttonLabel: buttonText){buttonAction()}
        }.padding(.horizontal)
    }
}
