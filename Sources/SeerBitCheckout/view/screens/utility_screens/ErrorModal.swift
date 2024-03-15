//
//  ErrorModal.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 20/10/2023.
//

import SwiftUI

@available(iOS 16.0, *)
struct ErrorModal: View {
    let title: String = "Error"
    let description: String?
    let buttonLeftText: String  = "Close"
    let singleButtonText: String  = "Close"
    let buttonRightText: String  = "Retry"
    let buttonLeftAction: ()-> Void
    let buttonRightAction: ()-> Void
    let singleButtonAction: ()-> Void
    let useSingleButton: Bool = true
    
    var body: some View {
        VStack{
            Text(title)
                .foregroundColor(Color(uiColor: UIColor(named: "dusk", in: HelperBundle.resolvedBundle, compatibleWith: nil)!))
                .fontWeight(.heavy)
                .font(.system(size: 18))
            Spacer().frame(height: 30)
            Image(uiImage: UIImage(named: "sdk_failure2", in: HelperBundle.resolvedBundle, with: nil)!)
                .frame(width: 60, height: 60)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .aspectRatio(0.75, contentMode: .fit)
            Spacer().frame(height: 10)
            Text(description ?? "An error occured")
                .foregroundColor(Color(uiColor: UIColor(named: "dusk", in: HelperBundle.resolvedBundle, compatibleWith: nil)!))
                .fontWeight(.light)
                .font(.system(size: 14))
            Spacer().frame(height: 40)
            if(useSingleButton){
                CustomButton(buttonLabel: singleButtonText){singleButtonAction()}
            }else{
                HStack{
                    CustomButton(buttonLabel: buttonLeftText){buttonLeftAction()}
                    CustomButton(buttonLabel: buttonRightText){buttonRightAction()}
                }
            }
        }.padding(.horizontal)
    }}
