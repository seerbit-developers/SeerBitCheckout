//
//  CardOtp.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 02/11/2023.
//

import SwiftUI

struct CardOtp: View {
    
    @EnvironmentObject var merchantDetailsViewModel: MerchantDetailsViewModel
    @EnvironmentObject var   clientDetailsViewModel: ClientDetailsViewModel
    @ObservedObject var queryTransactionViewModel = QueryTransactionViewModel()
    @StateObject  var cardViewModel: CardViewModel = CardViewModel()
    @StateObject  var transactionStatusDataViewModel =  TransactionStatusDataViewModel()
    
    @State private var otp: String = ""
    @State private var showPaymentMethods: Bool = false
    @State var verifyingOtp: Bool  = false
    
    @State var showSuccesDialog: Bool = false
    @State var showErrorDialog: Bool  =  false
    @State var errorMessage: String = ""
    
    @State var phoneNumberSubstring = ""
    @State var emailSubstring = ""
    
    @State var goToUssd: Bool = false
    @State var goToTransfer: Bool = false
    @State var goToMomo: Bool = false
    @State var goToBankAccount: Bool = false
    
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0){
            CustomHeader(merchantDetails: merchantDetailsViewModel.merchantDetails!)
            Spacer().frame(height: 20)
            
            if(showPaymentMethods){
                PaymentOptions(onCard: {withAnimation{showPaymentMethods.toggle()}}, onUssd: {goToUssd = true}, onTransfer: {goToTransfer = true}, onBankAccount: {goToBankAccount = true}, onMomo: {goToMomo = true}, onCancelPayment: {}, merchantDetails: merchantDetailsViewModel.merchantDetails)
            }else{
                if(verifyingOtp){
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
                        Text("Kindly enter the OTP sent to *******\(phoneNumberSubstring) and *******\(emailSubstring) or enter the OTP genrated on your hardware token device")
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
                        //                                    .foregroundColor(Color("dark"))
                        //                                    .fontWeight(.regular)
                        //                                    .font(.system(size: 13))
                        //                            })
                        //                        }
                        
                        Spacer().frame(height: 50)
                        CustomButton(buttonLabel: "Authorize payment"){
                            verifyingOtp = true
                            cardViewModel.postCardTransactionOtp(body: CardOtpRequestDataModel(transaction: OtpTransaction(linkingreference: clientDetailsViewModel.linkingreference, otp: otp)))
                        }
                        Spacer().frame(height: 50)
                    }
                }
                Spacer().frame(height: 100)
                ChangePaymentMethod(onChange: {showPaymentMethods.toggle()}, onCancel: {transactionStatusDataViewModel.startSeerbitCheckout = true})
            }
            
            Spacer()
            CustomFooter()
        }
        .navigationDestination(isPresented: $goToBankAccount){BankAccountInitiate()}
        .navigationDestination(isPresented: $goToUssd){SelectUssdBank()}
        .navigationDestination(isPresented: $goToTransfer){TransferDetails(transactionReference: clientDetailsViewModel.paymentReference)}
        .navigationDestination(isPresented: $goToMomo){MomoInitiate()}
        .navigationDestination(isPresented: $transactionStatusDataViewModel.startSeerbitCheckout){InitSeerbitCheckout(amount: -123456789, fullName: "backhome", mobileNumber: "", publicKey: "", email: "")}
        
        .onReceive(cardViewModel.$cardOtpResponse){cardOtpResponse in
            
            if(cardOtpResponse != nil
               && cardOtpResponse?.data?.code == "00"){
                
                // transaction confirmed
                showSuccesDialog = true
                verifyingOtp = false
                
            }else if (cardOtpResponse != nil){
                verifyingOtp = false
                errorMessage = cardOtpResponse?.data?.message ?? "An error occured. Please try again1"
                showErrorDialog = true
            }
        }
        .onReceive(cardViewModel.$cardOtpResponseError){cardOtpResponseError in
            if(cardOtpResponseError != nil){
                verifyingOtp = false
                errorMessage = cardViewModel.cardOtpResponseError?.localizedDescription ?? "An error occured. Please try again2"
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
        .sheet(isPresented: $showSuccesDialog){
            SuccessModal(
                buttonAction: {
                    // close the sdk
                    showSuccesDialog.toggle()
                }
            )
            .interactiveDismissDisabled(true)
            .presentationDetents([.fraction(0.4)])
        }
        .onAppear {
            var phoneNumberOffset = 0
            var emailOffset = 0
            if ((clientDetailsViewModel.mobileNumber.count - 5) > 0) {phoneNumberOffset = clientDetailsViewModel.mobileNumber.count - 5}
            if ((clientDetailsViewModel.email.count - 5) > 0) {emailOffset = clientDetailsViewModel.email.count - 5}
            
            phoneNumberSubstring = String(clientDetailsViewModel.mobileNumber.suffix(from: clientDetailsViewModel.mobileNumber.index(clientDetailsViewModel.mobileNumber.startIndex, offsetBy: phoneNumberOffset)
                                                                                    ))
            emailSubstring = String(clientDetailsViewModel.email.suffix(from: clientDetailsViewModel.email.index(clientDetailsViewModel.email.startIndex, offsetBy: emailOffset)))
        }
        .padding(20)
    }
}
