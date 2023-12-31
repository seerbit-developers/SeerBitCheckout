//
//  SuccessScreen.swift
//
//
//  Created by Miracle Eugene on 31/12/2023.
//

import SwiftUI

struct SuccessScreen: View {
    @EnvironmentObject var transactionStatusDataViewModel: TransactionStatusDataViewModel
    let title: String = "Success"
    let description: String = "Transaction is completed successfully"
    let buttonText: String  = "Close"
    
    @State var closeSdk: Bool = false
    
    var body: some View {
        VStack{
            Spacer().frame(height: 100)
            Text(title)
                .foregroundColor(Color(uiColor: UIColor(named: "dusk", in: .module, compatibleWith: nil)!))
                .fontWeight(.heavy)
                .font(.system(size: 18))
            Spacer().frame(height: 30)
            Image(uiImage: UIImage(named: "sdk_success2", in: .module, with: nil)!)
                .frame(width: 60, height: 60)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .aspectRatio(0.75, contentMode: .fit)
            Spacer().frame(height: 10)
            Text(description)
                .foregroundColor(Color(uiColor: UIColor(named: "dusk", in: .module, compatibleWith: nil)!))
                .fontWeight(.light)
                .font(.system(size: 14))
            Spacer().frame(height: 100)
            CustomButton(buttonLabel: buttonText){closeSdk = true}
            Spacer()
        }
        .navigationDestination(isPresented: $closeSdk){InitSeerbitCheckout(amount: -123456789, fullName: "backhome", mobileNumber: "", publicKey: "", email: "", transactionStatusData: transactionStatusDataViewModel.transactionStatusData)}
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
    }
}
