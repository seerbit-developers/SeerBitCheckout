//
//  ContentView.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 18/10/2023.
//

import SwiftUI

@available(iOS 16.0, *)
public struct InitSeerbitCheckout: View {
    @StateObject private var transactionStatusDataViewModel = TransactionStatusDataViewModel()
    @StateObject private var merchantDetailsViewModel = MerchantDetailsViewModel()
    @StateObject private var clientDetailsViewModel = ClientDetailsViewModel()
    
    
    var amount: Double
    var fullName: String
    var mobileNumber: String
    var publicKey: String
    var email: String
    var transactionStatusData: QueryTransactionDataModel? = nil
    var paymentReference: String = ""
    var productId: String = ""
    var productDescription: String = ""
    var currency: String = ""
    var country: String = ""
    var pocketReference: String = ""
    var vendorId: String = ""
    var tokenize: Bool = false
    
    
    @State var checksComplete: Bool = false
    @State var errorMessage: String = "Amount cannot be a negative value"
    @State var showErrorDialog: Bool  =  false
    @State var sdkReady: Bool = false
    
    
    public init (
        amount:Double,
        fullName:String,
        mobileNumber:String,
        publicKey:String,
        email:String,
        transactionStatusData: QueryTransactionDataModel? = nil,
        paymentReference: String = "",
        productId: String = "",
        productDescription: String = "",
        currency: String = "",
        country: String = "",
        pocketReference: String = "",
        vendorId: String = "",
        tokenize: Bool = false
    ){
        
        self.amount = amount
        self.fullName = fullName
        self.mobileNumber = mobileNumber
        self.publicKey = publicKey
        self.email = email
        self.transactionStatusData = transactionStatusData
        self.paymentReference = paymentReference
        self.productId = productId
        self.productDescription = productDescription
        self.currency = currency
        self.country = country
        self.pocketReference = pocketReference
        self.vendorId = vendorId
        self.tokenize = tokenize
        
    }
    
    
    // Function to notify observers
    private func onCloseCheckout() {
        
        let data = transactionStatusData
        
        // Convert to Data
        if let jsonData = try? JSONEncoder().encode(data) {
            NotificationCenter.default.post(
                name: .closeCheckout,
                object: nil,
                userInfo: [NotificationListenerConstants.jsonData.rawValue: jsonData]
            )
        }else{NotificationCenter.default.post(name: .closeCheckout, object: nil)}
    }
    
    
    public var body: some View {
        
        VStack{
            if(checksComplete){
                
                VStack(alignment: .center){
                    
                    if merchantDetailsViewModel.merchantDetails  != nil {
                        if sdkReady {
                            NavigationStack{CardInitiate()}
                                .environmentObject(merchantDetailsViewModel)
                                .environmentObject(clientDetailsViewModel)
                                .environmentObject(transactionStatusDataViewModel)
                                .navigationBarBackButtonHidden(true)
                                .preferredColorScheme(.light)
                        }else {
                            Image(uiImage: UIImage(named: "checkout_logo", in: HelperBundle.resolvedBundle, with: nil)!)
                                .resizable()
                                .frame(width: 60, height: 60)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 2))
                            Spacer().frame(height: 20)
                            Text(merchantDetailsViewModel.merchantDetails?.message ?? "An error has occured. Please be sure you hava a correct live public key")
                                .multilineTextAlignment(.center)
                            Spacer().frame(height: 45)
                            ChangePaymentMethod(onChange: {
                                showErrorDialog = false
                                checksComplete = true
                                merchantDetailsViewModel.merchantDetails = nil
                                merchantDetailsViewModel.merchantDetailsError = nil
                                merchantDetailsViewModel.fetchMerchantDetailsData(publicKey: clientDetailsViewModel.publicKey)
                            }, onCancel: {
                                onCloseCheckout()
                                checksComplete = true
                            }, OnChangeText: "Retry", onCancelText: "Cancel")
                        }
                    }else if merchantDetailsViewModel.merchantDetailsError == nil{
                        Image(uiImage: UIImage(named: "checkout_logo", in: HelperBundle.resolvedBundle, with: nil)!)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 2))
                        Spacer().frame(height: 40)
                        Text("Initializing...")
                        Spacer().frame(height: 20)
                        LoadingIndicator()
                        
                    } else if merchantDetailsViewModel.merchantDetailsError != nil{
                        Image(uiImage: UIImage(named: "checkout_logo", in: HelperBundle.resolvedBundle, with: nil)!)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 2))
                        Spacer().frame(height: 30)
                        Text("Initialization failed. A network error occured. Please try again")
                            .multilineTextAlignment(.center)
                            .padding(30)
                        
                        Spacer().frame(height: 45)
                        ChangePaymentMethod(onChange: {
                            showErrorDialog = false
                            checksComplete = true
                            merchantDetailsViewModel.merchantDetails = nil
                            merchantDetailsViewModel.merchantDetailsError = nil
                            merchantDetailsViewModel.fetchMerchantDetailsData(publicKey: clientDetailsViewModel.publicKey)
                        }, onCancel: {
                            onCloseCheckout()
                            checksComplete = true
                        }, OnChangeText: "Retry", onCancelText: "Cancel")
                    }
                }
                .preferredColorScheme(.light)
                .onReceive(merchantDetailsViewModel.$merchantDetails){merchantDetails in
                    if(merchantDetails?.responseCode  == "00" ){
                        
                        clientDetailsViewModel.country = merchantDetails?.payload?.country?.countryCode ?? ""
                        clientDetailsViewModel.currency = currency.isEmpty ? merchantDetails?.payload?.country?.defaultCurrency?.code ?? "" : currency
                        clientDetailsViewModel.paymentReference = paymentReference.isEmpty ? generateRandomReference() : paymentReference
                        clientDetailsViewModel.productId = productId.isEmpty ? "seerbit" : productId
                        clientDetailsViewModel.productDescription = productDescription.isEmpty ? "seerbit" : productDescription
                        sdkReady = true
                    }
                }
            }else{EmptyView()}
        }
        .onAppear{
            if(amount > 0){
                checksComplete = true
                clientDetailsViewModel.amount = String(amount)
                clientDetailsViewModel.fullName = fullName
                clientDetailsViewModel.mobileNumber = mobileNumber
                clientDetailsViewModel.publicKey = publicKey
                clientDetailsViewModel.email = email
                merchantDetailsViewModel.fetchMerchantDetailsData(publicKey: clientDetailsViewModel.publicKey)
            }
            else if(amount < 0 && fullName == "backhome"){
                onCloseCheckout()
                checksComplete = true
            }else{
                errorMessage = "Amount cannot be a negative value"
                checksComplete = false
                showErrorDialog = true
            }
        }
        .sheet(isPresented: $showErrorDialog){
            ErrorModal(
                description:errorMessage,
                buttonLeftAction: {},
                buttonRightAction: {},
                singleButtonAction: {
                    showErrorDialog.toggle()
                    onCloseCheckout()
                })
            .interactiveDismissDisabled(true)
            .presentationDetents([.fraction(0.4)])
        }
        .navigationBarBackButtonHidden(true)
    }
}

// Define a notification name
extension Notification.Name {
    static let closeCheckout = Notification.Name(NotificationListenerConstants.closeCheckout.rawValue)
}
