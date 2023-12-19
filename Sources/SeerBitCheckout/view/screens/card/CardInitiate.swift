//
//  CardInitiate.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 02/11/2023.
//

import SwiftUI

struct CardInitiate: View {
    
    @EnvironmentObject var merchantDetailsViewModel: MerchantDetailsViewModel
    @EnvironmentObject var clientDetailsViewModel: ClientDetailsViewModel
    @StateObject  var cardViewModel: CardViewModel = CardViewModel()
    
    @State private var cardNumber: String = ""
    @State private var expiryDate: String = ""
    @State private var expiryMonth: String = ""
    @State private var expiryYear: String = ""
    @State private var cvv: String = ""
    
    @State private var showPaymentMethods: Bool = false
    @State private var initiatingCardTransaction: Bool = false
    
    @State var showErrorDialog: Bool  =  false
    @State var errorDescription: String = "An error has occured"
    @State var goToRedirect: Bool = false
    @State var goToCardPin: Bool = false
    @State var cardIcon: String = ""
    
    @State var goToUssd: Bool = false
    @State var goToTransfer: Bool = false
    @State var goToMomo: Bool = false
    @State var goToBankAccount: Bool = false
    
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0){
            CustomHeader(merchantDetails: merchantDetailsViewModel.merchantDetails!)
            Spacer().frame(height: 20)
            
            if (initiatingCardTransaction){
                VStack{
                    LoadingIndicator()
                    Spacer().frame(height: 30)
                }
            }else{
                if(showPaymentMethods){
                    PaymentOptions(onCard: {withAnimation{showPaymentMethods.toggle()}}, onUssd: {goToUssd = true}, onTransfer: {goToTransfer = true}, onBankAccount: {goToBankAccount = true}, onMomo: {goToMomo = true}, onCancelPayment: {},merchantDetails: merchantDetailsViewModel.merchantDetails)
                }else{
                    HStack{
                        CustomInput(value: $cardNumber, placeHolder: "Card Number", borderWidth: 0, keyboardType: UIKeyboardType.numbersAndPunctuation)
                        HStack{Image(cardIcon)}
                    }
                    .padding(.horizontal, 11)
                    .border(Color("seaShell"), width: 2)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    Spacer().frame(height: 10)
                    HStack{
                        CustomInput(value: $expiryDate, placeHolder: "MM/YY", keyboardType: UIKeyboardType.numbersAndPunctuation)
                        Spacer().frame(width: 10)
                        CustomInput(value: $cvv, placeHolder: "CVV", keyboardType: UIKeyboardType.numbersAndPunctuation)
                    }
                    Spacer().frame(height: 30)
                    CustomButton(buttonLabel: clientDetailsViewModel.currency + formatInputDouble(input: clientDetailsViewModel.totalAmount)){
                        if let year = expiryDate.split(separator:"/").last {
                            clientDetailsViewModel.expiryYear = String(year)
                        }
                        if let month = expiryDate.split(separator:"/").first {
                            clientDetailsViewModel.expiryMonth = String(month)
                        }
                        clientDetailsViewModel.cardNumber = cardNumber
                        clientDetailsViewModel.cvv = cvv
                        
                        initiatingCardTransaction = true
                        cardViewModel.initiateCardTransaction(body: CardInitiateRequestDataModel(fullName: clientDetailsViewModel.fullName, mobileNumber: clientDetailsViewModel.mobileNumber, email: clientDetailsViewModel.email, publicKey: clientDetailsViewModel.publicKey, amount: clientDetailsViewModel.totalAmount, currency: clientDetailsViewModel.currency, country: clientDetailsViewModel.country, paymentReference: clientDetailsViewModel.paymentReference, productID: clientDetailsViewModel.productId, redirectURL: clientDetailsViewModel.redirectURL, paymentType: "CARD", channelType: clientDetailsViewModel.cardType, deviceType: clientDetailsViewModel.deviceType, sourceIP: clientDetailsViewModel.sourceIP, cardNumber: clientDetailsViewModel.cardNumber, cvv: clientDetailsViewModel.cvv, expiryMonth: clientDetailsViewModel.expiryMonth, expiryYear: clientDetailsViewModel.expiryYear, source: clientDetailsViewModel.source, fee: clientDetailsViewModel.fee, pin: clientDetailsViewModel.pin, retry: clientDetailsViewModel.retry, rememberMe: clientDetailsViewModel.rememberMe, isCardInternational: clientDetailsViewModel.isCardInternational))
                        
                        clientDetailsViewModel.retry = true
                    }
                    Spacer().frame(height: 50)
                }
            }
            if(showPaymentMethods == false){
                ChangePaymentMethod(onChange: {
                    if (initiatingCardTransaction == false){showPaymentMethods.toggle()}
                }, onCancel: {})
            }
            Spacer()
            CustomFooter()
            
            NavigationLink(destination: CardBankAuthentication(redirectUrl: cardViewModel.cardInitiateResponse?.data?.payments?.redirectURL ?? ""),
                           isActive: $goToRedirect, label: {EmptyView()})
            
            NavigationLink(destination: CardPin(),
                           isActive: $goToCardPin, label: {EmptyView()})
            
            NavigationLink(destination: SelectUssdBank(),
                           isActive: $goToUssd, label: {EmptyView()})
            NavigationLink(destination: TransferDetails(transactionReference: clientDetailsViewModel.paymentReference),
                           isActive: $goToTransfer, label: {EmptyView()})
            NavigationLink(destination: MomoInitiate(),
                           isActive: $goToMomo, label: {EmptyView()})
            NavigationLink(destination: BankAccountInitiate(),
                           isActive: $goToBankAccount, label: {EmptyView()})
        }
        .onReceive(cardViewModel.$cardInitiateResponse){ cardInitiateResponse in
            
            if(cardInitiateResponse?.data?.code == "S20"){
                initiatingCardTransaction = false
                
                if(((cardInitiateResponse?.data?.payments?.redirectURL?.isEmpty) == false)){
                    // redirect to browser
                    goToRedirect = true
                }else if(cardInitiateResponse?.data?.message == "Kindly enter your PIN"){
                    //navigate to pin screen
                    goToCardPin = true
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
        .onReceive(cardViewModel.$cardBinDataResponse){cardBinDataResponse in
            if(cardBinDataResponse?.responseCode == "00" && (cardBinDataResponse?.cardName) != nil){
                
                if((cardBinDataResponse?.cardName?.uppercased().contains("MASTERCARD")) == true){
                    cardIcon = "mastercard_icon"
                }else if ((cardBinDataResponse?.cardName?.uppercased().contains("VISA")) == true){
                    cardIcon = "visa_icon"
                }else if ((cardBinDataResponse?.cardName?.uppercased().contains("VERVE")) == true){
                    cardIcon = "verve_icon"
                }else{cardIcon = ""}
            }else{cardIcon = ""}
        }
        .onReceive(cardViewModel.$cardBinDataResponseError){cardBinDataResponseError in
            if(cardBinDataResponseError != nil){cardIcon = ""}
        }
        .onChange(of: cardNumber){cardNumber in
            if(cardNumber.count == 6){
                cardIcon = ""
                cardViewModel.fetchCardBin(body: cardNumber)
            }else if (cardNumber.count < 6){cardIcon = ""}
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
        .onAppear{
            clientDetailsViewModel.fee = ""
            clientDetailsViewModel.fee = calculateFee(amount: clientDetailsViewModel.amount, paymentMethod: paymentMethods.card.rawValue, merchantDetails: merchantDetailsViewModel.merchantDetails!, cardCountry: cardViewModel.cardBinDataResponse?.country ?? "NIGERIA")
            if(!isMerchantTheFeeBearer(merchantDetails: merchantDetailsViewModel.merchantDetails!)){
                clientDetailsViewModel.totalAmount = ""
                clientDetailsViewModel.totalAmount = String((Double(clientDetailsViewModel.amount) ?? 100.0) + (Double(clientDetailsViewModel.fee) ?? 2000.0))
            }else{
                clientDetailsViewModel.totalAmount = clientDetailsViewModel.amount
            }
        }
        .onReceive(cardViewModel.$cardBinDataResponse){cardBinDataResponse in
            clientDetailsViewModel.fee = ""
            clientDetailsViewModel.fee = calculateFee(amount: clientDetailsViewModel.amount, paymentMethod: paymentMethods.card.rawValue, merchantDetails: merchantDetailsViewModel.merchantDetails!, cardCountry: cardBinDataResponse?.country ?? "NIGERIA")
            if(!isMerchantTheFeeBearer(merchantDetails: merchantDetailsViewModel.merchantDetails!)){
                clientDetailsViewModel.totalAmount = ""
                clientDetailsViewModel.totalAmount = String((Double(clientDetailsViewModel.amount) ?? 100.0) + (Double(clientDetailsViewModel.fee) ?? 2000.0))
            }else{
                clientDetailsViewModel.totalAmount = clientDetailsViewModel.amount
            }
        }
        .onAppear{
            if(!displayPaymentMethod(paymentMethod: paymentMethods.card.rawValue, merchantDetails: merchantDetailsViewModel.merchantDetails!)){
                showPaymentMethods = true
            }
        }
        .padding(20)
        .navigationBarBackButtonHidden(true)
    }
}
