//
//  PaymentOptions.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 03/11/2023.
//

import SwiftUI

struct PaymentOptions: View {
    let onCard: () -> Void
    let onUssd: () -> Void
    let onTransfer: () -> Void
    let onBankAccount: () -> Void
    let onMomo: () -> Void
    let onCancelPayment: () -> Void
    
    let merchantDetails: MerchantDetailsDataModel?
    
    var body: some View {
        VStack(alignment:.center){
            Spacer().frame(height: 20)
            Text("Other payment channels")
                .foregroundColor(.black)
                .fontWeight(.regular)
                .font(.system(size: 13))
                .frame(alignment: .trailing)
            Spacer().frame(height: 10)
            
            if(displayPaymentMethod(paymentMethod: paymentMethods.card.rawValue, merchantDetails: merchantDetails!)){
                PaymentOptionItem(title: "Debit/Credit Card"){onCard()}
                Spacer().frame(height: 10)
            }
            
            if(displayPaymentMethod(paymentMethod: paymentMethods.ussd.rawValue, merchantDetails: merchantDetails!)){
                PaymentOptionItem(title: "USSD"){onUssd()}
                Spacer().frame(height: 10)
            }
           
            if(displayPaymentMethod(paymentMethod: paymentMethods.account.rawValue, merchantDetails: merchantDetails!)){
                PaymentOptionItem(title: "Bank Account"){onBankAccount()}
                Spacer().frame(height: 10)
            }
            
            if(displayPaymentMethod(paymentMethod: paymentMethods.transfer.rawValue, merchantDetails: merchantDetails!)){
                PaymentOptionItem(title: "Transfer"){onTransfer()}
                Spacer().frame(height: 10)
            }
            
            if(displayPaymentMethod(paymentMethod: paymentMethods.momo.rawValue, merchantDetails: merchantDetails!)){
                PaymentOptionItem(title: "MOMO"){onMomo()}
            }
            
            Spacer().frame(height: 60)
            CustomButton(
                buttonLabel: "Cancel payment",
                backgroundColor: Color(uiColor: UIColor(named: "fadedRed", in: .module, compatibleWith: nil)!),
                textForegroundColor: Color(uiColor: UIColor(named: "pureRed", in: .module, compatibleWith: nil)!)
            ) {onCancelPayment()}
                .padding(.horizontal, 5)
                .padding(.vertical, 10)
                .frame( alignment: .center)
        }
    }
}
