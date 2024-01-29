//
//  CardPin.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 02/11/2023.
//

import SwiftUI

struct CardPin: View {
    
    @EnvironmentObject var merchantDetailsViewModel: MerchantDetailsViewModel
    @EnvironmentObject var   clientDetailsViewModel: ClientDetailsViewModel
    @ObservedObject var queryTransactionViewModel = QueryTransactionViewModel()
    @StateObject  var cardViewModel: CardViewModel = CardViewModel()
    
    @State private var pin: String = ""
    @State private var showPaymentMethods: Bool = false
    @State private var initiatingCardTransaction: Bool = false
    @State var goToCardOtp: Bool = false
    
    @State var showErrorDialog: Bool  =  false
    @State var errorDescription: String = "An error has occured"
    
    @State var goToUssd: Bool = false
    @State var goToTransfer: Bool = false
    @State var goToMomo: Bool = false
    @State var goToBankAccount: Bool = false
    @State var closeSdk: Bool = false
    
    func acceptCardPin (){
        initiatingCardTransaction = true
        clientDetailsViewModel.pin = pin
        
        cardViewModel.initiateCardTransaction(body: CardInitiateRequestDataModel(fullName: clientDetailsViewModel.fullName, mobileNumber: clientDetailsViewModel.mobileNumber, email: clientDetailsViewModel.email, publicKey: clientDetailsViewModel.publicKey, amount: clientDetailsViewModel.totalAmount, currency: clientDetailsViewModel.currency, country: clientDetailsViewModel.country, paymentReference: clientDetailsViewModel.paymentReference, productID: clientDetailsViewModel.productId, redirectURL: clientDetailsViewModel.redirectURL, paymentType: "CARD", channelType: clientDetailsViewModel.cardType, deviceType: clientDetailsViewModel.deviceType, sourceIP: clientDetailsViewModel.sourceIP, cardNumber: clientDetailsViewModel.cardNumber, cvv: clientDetailsViewModel.cvv, expiryMonth: clientDetailsViewModel.expiryMonth, expiryYear: clientDetailsViewModel.expiryYear, source: clientDetailsViewModel.source, fee: clientDetailsViewModel.fee, pin: clientDetailsViewModel.pin, retry: clientDetailsViewModel.retry, rememberMe: clientDetailsViewModel.rememberMe, isCardInternational: clientDetailsViewModel.isCardInternational))
    }
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0){
            CustomHeader(merchantDetails: merchantDetailsViewModel.merchantDetails!)
            Spacer().frame(height: 20)
            
            if(showPaymentMethods){
                PaymentOptions(onCard: {withAnimation{showPaymentMethods.toggle()}}, onUssd: {goToUssd = true}, onTransfer: {goToTransfer = true}, onBankAccount: {goToBankAccount = true}, onMomo: {goToMomo = true}, onCancelPayment: {closeSdk = true}, merchantDetails: merchantDetailsViewModel.merchantDetails)
            }else{
                if(initiatingCardTransaction){
                    VStack{
                        LoadingIndicator()
                        Spacer().frame(height: 30)
                    }
                }else{
                    VStack{
                        Spacer().frame(height: 5)
                        Text("Enter your 4-digit card pin to authorize this payment")
                            .foregroundColor(Color(uiColor: UIColor(named: "dark", in: .module, compatibleWith: nil)!))
                            .fontWeight(.regular)
                            .font(.system(size: 13))
                        Spacer().frame(height: 40)
                        CustomPinComponent(pin: $pin)
                    }
                }
                
                Spacer().frame(height: 100)
                ChangePaymentMethod(onChange: {showPaymentMethods.toggle()}, onCancel: {closeSdk = true})
            }
            
            Spacer()
            CustomFooter()
        }
        .navigationDestination(isPresented: $goToCardOtp){CardOtp()}
        .navigationDestination(isPresented: $goToBankAccount){BankAccountInitiate()}
        .navigationDestination(isPresented: $goToUssd){SelectUssdBank()}
        .navigationDestination(isPresented: $goToTransfer){TransferDetails(transactionReference: clientDetailsViewModel.paymentReference)}
        .navigationDestination(isPresented: $goToMomo){MomoInitiate()}
        .navigationDestination(isPresented: $closeSdk){InitSeerbitCheckout(amount: -123456789, fullName: "backhome", mobileNumber: "", publicKey: "", email: "")}
        
        .onReceive(cardViewModel.$cardInitiateResponse){ cardInitiateResponse in
            
            if(cardInitiateResponse?.data?.code == "S20"){
                initiatingCardTransaction = false
                
                if(((cardInitiateResponse?.data?.payments?.redirectURL?.isEmpty) == false)){
                    // redirect to browser
                    //                    goToRedirect = true
                }else if(cardInitiateResponse?.data?.message?.uppercased().contains("OTP") == true){
                    //navigate to otp screen
                    clientDetailsViewModel.linkingreference = cardInitiateResponse?.data?.payments?.linkingReference ?? ""
                    goToCardOtp = true
                }
            }else if(cardInitiateResponse != nil){
                initiatingCardTransaction = false
                errorDescription = cardInitiateResponse?.message ?? cardInitiateResponse?.data?.message ?? "An error occured"
                showErrorDialog = true
            }
        }
        .onReceive(cardViewModel.$cardInitiateResponseError){cardInitiateResponseError in
            if(cardInitiateResponseError != nil){
                initiatingCardTransaction = false
                errorDescription = "A netork error has occurred. Please try again"
                showErrorDialog = true
            }
        }
        .onChange(of: pin){pin in
            if(pin.count == 4){
                acceptCardPin()
            }
        }
        .sheet(isPresented: $showErrorDialog){
            ErrorModal(
                description:errorDescription,
                buttonLeftAction: {},
                buttonRightAction: {},
                singleButtonAction: {showErrorDialog.toggle()})
            .interactiveDismissDisabled(true)
            .presentationDetents([.fraction(0.4)])
        }
        .padding(20)
    }
}
