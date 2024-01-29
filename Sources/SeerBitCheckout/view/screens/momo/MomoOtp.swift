//
//  MomoOtp.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 11/12/2023.
//

import SwiftUI

struct MomoOtp: View {
    
    
    @EnvironmentObject var merchantDetailsViewModel: MerchantDetailsViewModel
    @EnvironmentObject var   clientDetailsViewModel: ClientDetailsViewModel
    @EnvironmentObject var transactionStatusDataViewModel: TransactionStatusDataViewModel
    @ObservedObject var queryTransactionViewModel = QueryTransactionViewModel()
    @StateObject  var momoViewModel: MomoViewModel = MomoViewModel()
    
    @State private var otp: String = ""
    @State private var showPaymentMethods: Bool = false
    @State var verifyingOtp: Bool  = false
    @State var confirmingTransaction: Bool  = false
    
    @State var showSuccesDialog: Bool = false
    @State var showErrorDialog: Bool  =  false
    @State var errorMessage: String = ""
    
    @State var phoneNumberSubstring = ""
    @State var emailSubstring = ""
    
    @State var linkingReference: String
    
    @State var goToCard: Bool = false
    @State var goToTransfer: Bool = false
    @State var goToUssd: Bool = false
    @State var goToBankAccount: Bool = false
    @State var closeSdk: Bool = false
    @State var goToSuccessScreen: Bool = false
    
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0){
            CustomHeader(merchantDetails: merchantDetailsViewModel.merchantDetails!)
            Spacer().frame(height: 20)
            
            if(showPaymentMethods){
                PaymentOptions(onCard: {goToCard = true}, onUssd: {goToUssd = true}, onTransfer: {goToTransfer = true}, onBankAccount: {goToBankAccount = true}, onMomo: {
                    withAnimation{showPaymentMethods.toggle()}
                }, onCancelPayment: {closeSdk = true}, merchantDetails: merchantDetailsViewModel.merchantDetails)
            }else{
                if(verifyingOtp || confirmingTransaction){
                    VStack{
                        Text("Hold on tight while we confirm this payment")
                            .fontWeight(.regular)
                            .font(.system(size: 14))
                            .foregroundColor(Color(uiColor: UIColor(named: "dark", in: .module, compatibleWith: nil)!))
                            .frame(alignment: .leading)
                        Spacer().frame(height: 20)
                        LoadingIndicator()
                        Spacer().frame(height: 20)
                    }
                }else {
                    VStack{
                        Spacer().frame(height: 5)
                        Text("Kindly enter the OTP sent to *******\(phoneNumberSubstring) and *******\(emailSubstring)")
                            .foregroundColor(Color(uiColor: UIColor(named: "dark", in: .module, compatibleWith: nil)!))
                            .fontWeight(.regular)
                            .font(.system(size: 13))
                        Spacer().frame(height: 40)
                        CustomInput(value: $otp, placeHolder: "Enter otp")
                        
                        Spacer().frame(height: 15)
                        //                        HStack{
                        //                            Spacer()
                        //                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        //                                Text("Resend OTP")
                        //                                    .foregroundColor(Color(uiColor: UIColor(named: "dark", in: .module, compatibleWith: nil)!))
                        //                                    .fontWeight(.regular)
                        //                                    .font(.system(size: 13))
                        //                            })
                        //                        }
                        
                        Spacer().frame(height: 50)
                        CustomButton(buttonLabel: "Authorize payment"){
                            verifyingOtp = true
                            momoViewModel.verifyMomoTransactionOtp(body: ConfirmMomoOtpRequestDataModel(linkingReference: linkingReference, otp: otp))
                        }
                        Spacer().frame(height: 50)
                    }
                }
                Spacer().frame(height: 100)
                ChangePaymentMethod(onChange: {showPaymentMethods.toggle()}, onCancel: {closeSdk = true})
            }
            
            Spacer()
            CustomFooter()
        }
        .navigationDestination(isPresented: $goToBankAccount){BankAccountInitiate()}
        .navigationDestination(isPresented: $goToUssd){SelectUssdBank()}
        .navigationDestination(isPresented: $goToTransfer){TransferDetails(transactionReference: clientDetailsViewModel.paymentReference)}
        .navigationDestination(isPresented: $goToCard){CardInitiate()}
        .navigationDestination(isPresented: $goToSuccessScreen){SuccessScreen()}
        .navigationDestination(isPresented: $closeSdk){InitSeerbitCheckout(amount: -123456789, fullName: "backhome", mobileNumber: "", publicKey: "", email: "")}
        
        .onReceive(momoViewModel.$momoOtpResponse){momoOtpResponse in
            if(momoOtpResponse != nil
               && momoOtpResponse?.data?.code == "S20"){
                // start transaction query
                verifyingOtp = false
                confirmingTransaction = true
                queryTransactionViewModel.queryTransaction(reference: clientDetailsViewModel.paymentReference)
                
            }else if (momoOtpResponse != nil){
                verifyingOtp = false
                errorMessage = momoOtpResponse?.data?.message ?? momoOtpResponse?.message ?? "An error occured. Please try again1"
                showErrorDialog = true
            }
        }
        .onReceive(momoViewModel.$momoOtpResponseError){momoOtpResponseError in
            if(momoOtpResponseError != nil){
                verifyingOtp = false
                errorMessage = momoOtpResponseError?.localizedDescription ?? "An error occured. Please try again"
                showErrorDialog = true
            }
        }
        .onReceive(queryTransactionViewModel.$queryTransactionResponse){queryTransactionResponse in
            
            if(queryTransactionResponse != nil
               && queryTransactionResponse?.data?.code == "00"){
                
                // transaction confirmed
                transactionStatusDataViewModel.transactionStatusData = queryTransactionResponse
                confirmingTransaction = false
                goToSuccessScreen = true
                
            }else if(queryTransactionResponse != nil
                     && queryTransactionResponse?.data?.code == "S20"){
                queryTransactionViewModel.queryTransaction(
                    reference:clientDetailsViewModel.paymentReference
                )
            }else if(queryTransactionResponse != nil
                     && queryTransactionResponse?.data?.code != "S20" && queryTransactionResponse?.data?.code != "00"){
                
                confirmingTransaction = false
                errorMessage = queryTransactionViewModel.queryTransactionResponse?.message ?? "Transaction query process has failed"
                showErrorDialog = true
            }
        }
        .onReceive(queryTransactionViewModel.$queryTransactionResponseError){queryTransactionResponseError in
            
            if(queryTransactionResponseError != nil){
                confirmingTransaction = false
                errorMessage = queryTransactionViewModel.queryTransactionResponseError?.localizedDescription ?? "Transaction query process has failed"
                showErrorDialog = true
            }
            
        }
        .sheet(isPresented: $showErrorDialog){
            ErrorModal(
                description:errorMessage,
                buttonLeftAction: {},
                buttonRightAction: {},
                singleButtonAction: {showErrorDialog.toggle()})
            .interactiveDismissDisabled(true)
            .presentationDetents([.fraction(0.4)])
        }
        .onAppear {
            var phoneNumberOffset = 0
            var emailOffset = 0
            if ((clientDetailsViewModel.mobileNumber.count - 5) > 0) {phoneNumberOffset = clientDetailsViewModel.mobileNumber.count - 5}
            if ((clientDetailsViewModel.email.count - 5) > 0) {emailOffset = clientDetailsViewModel.email.count - 5}
            
            phoneNumberSubstring = String(clientDetailsViewModel.momoMobileNumber.suffix(from: clientDetailsViewModel.mobileNumber.index(clientDetailsViewModel.mobileNumber.startIndex, offsetBy: phoneNumberOffset)
                                                                                        ))
            emailSubstring = String(clientDetailsViewModel.email.suffix(from: clientDetailsViewModel.email.index(clientDetailsViewModel.email.startIndex, offsetBy: emailOffset)))
        }
        .padding(20)
    }
}
