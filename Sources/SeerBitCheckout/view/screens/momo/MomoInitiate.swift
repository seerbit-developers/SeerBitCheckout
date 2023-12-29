//
//  MomoInitiate.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 11/12/2023.
//

import SwiftUI

struct MomoInitiate: View {
    
    @EnvironmentObject var merchantDetailsViewModel: MerchantDetailsViewModel
    @EnvironmentObject var clientDetailsViewModel: ClientDetailsViewModel
    @StateObject  var momoViewModel: MomoViewModel = MomoViewModel()
    @ObservedObject var queryTransactionViewModel = QueryTransactionViewModel()
    @StateObject  var transactionStatusDataViewModel =  TransactionStatusDataViewModel()
    
    @State private var mobileNumber: String = ""
    @State private var providerAvailable: Bool = false
    
    @State private var showPaymentMethods: Bool = false
    @State private var initiatingMomoTransaction: Bool = false
    @State private var loadingProviders: Bool = false
    @State var showErrorDialog: Bool  =  false
    @State var showSuccesDialog: Bool = false
    @State var errorDescription: String = "An error has occured"
    @State var showProviders: Bool = false
    @State var chosenProvider: String = "Select provider"
    @State var confirmingTransaction: Bool  = false
    @State var goToMomoOtp = false
    @State var linkingRefenece: String = ""
    @State var listOfProviders: [MomoProvidersDataModel] =  []
    
    @State var goToCard: Bool = false
    @State var goToTransfer: Bool = false
    @State var goToUssd: Bool = false
    @State var goToBankAccount: Bool = false
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0){
            CustomHeader(merchantDetails: merchantDetailsViewModel.merchantDetails!)
            Spacer().frame(height: 20)
            if(confirmingTransaction){
                VStack{
                    Text("Hold on tight while we confirm this payment")
                        .fontWeight(.regular)
                        .font(.system(size: 14))
                        .foregroundColor(Color(uiColor: UIColor(named: "dark", in: .module, compatibleWith: nil)!))
                        .frame(alignment: .leading)
                    Spacer().frame(height: 20)
                }
            }
            
            if (initiatingMomoTransaction || loadingProviders || confirmingTransaction){
                VStack{
                    LoadingIndicator()
                    Spacer().frame(height: 30)
                }
            }else{
                if(showPaymentMethods){
                    PaymentOptions(onCard: {goToCard = true}, onUssd: {goToUssd = true}, onTransfer: {goToTransfer = true}, onBankAccount: {goToBankAccount = true}, onMomo: {withAnimation{showPaymentMethods.toggle()}}, onCancelPayment: {}, merchantDetails: merchantDetailsViewModel.merchantDetails)
                }else{
                    HStack{
                        CustomInput(value: $mobileNumber, placeHolder: "Mobile number", borderWidth: 0, keyboardType: UIKeyboardType.numbersAndPunctuation)
                    }
                    .padding(.horizontal, 11)
                    .border(Color(uiColor: UIColor(named: "seaShell", in: .module, compatibleWith: nil)!), width: 2)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    Spacer().frame(height: 20)
                    
                    HStack{
                        Button( action: {
                            if(providerAvailable){showProviders.toggle()}else{
                                errorDescription = "Provider not available"
                                showErrorDialog = true
                            }
                        }, label: {
                            HStack{
                                Text(chosenProvider)
                                    .foregroundColor(Color(uiColor: UIColor(named: "starDust", in: .module, compatibleWith: nil)!))
                                    .fontWeight(.bold)
                                    .font(.system(size: 14))
                                Spacer()
                                Image(systemName: "chevron.down").foregroundColor(Color(uiColor: UIColor(named: "starDust", in: .module, compatibleWith: nil)!))
                            }
                            .padding(11)
                            .frame(width: .infinity)
                            .border(Color(uiColor: UIColor(named: "seaShell", in: .module, compatibleWith: nil)!), width: 2)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        })
                    }
                    Spacer().frame(height: 5)
                    if(showProviders){
                        ZStack{
                            ScrollView(showsIndicators: false){
                                VStack(spacing: 15){
                                    ForEach(listOfProviders, id:\.id) { network in
                                        
                                        Button( action: {
                                            showProviders.toggle()
                                            chosenProvider = network.networks ?? ""
                                        }, label: {
                                            VStack{
                                                HStack{
                                                    Text((network.networks ?? ""))
                                                        .foregroundColor(.black)
                                                        .fontWeight(.regular)
                                                        .font(.system(size: 11))
                                                        .frame( alignment:.trailing)
                                                    Spacer()
                                                }
                                                VStack{
                                                    Divider()
                                                        .frame(height: 0.3)
                                                        .overlay(Color(uiColor: UIColor(named: "starDust", in: .module, compatibleWith: nil)!))
                                                }
                                            }
                                        })
                                    }
                                }
                                .frame( maxWidth: .infinity, alignment: .trailing)
                                .padding(.vertical, 15)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .frame(alignment: .leading)
                            .padding(.horizontal)
                            .background(Color(uiColor: UIColor(named: "porcelain", in: .module, compatibleWith: nil)!))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .frame(height: 150, alignment: .leading)
                        .padding(0)
                        .border(Color(uiColor: UIColor(named: "seaShell", in: .module, compatibleWith: nil)!), width: 2)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                Spacer().frame(height: 30)
                if(showPaymentMethods == false){
                    CustomButton(buttonLabel: clientDetailsViewModel.currency + (clientDetailsViewModel.totalAmount)){
                        initiatingMomoTransaction = true
                        
                        clientDetailsViewModel.network = chosenProvider
                        clientDetailsViewModel.momoMobileNumber = mobileNumber
                        
                        momoViewModel.initiateMomoTransaction(body: MomoInitiateRequestDataModel(fullName: clientDetailsViewModel.fullName, mobileNumber: clientDetailsViewModel.momoMobileNumber, email: clientDetailsViewModel.email, publicKey: clientDetailsViewModel.publicKey, amount: clientDetailsViewModel.totalAmount, currency: clientDetailsViewModel.currency, country: clientDetailsViewModel.country, paymentReference: clientDetailsViewModel.paymentReference, productID: clientDetailsViewModel.productId, productDescription: clientDetailsViewModel.productDescription, redirectURL: clientDetailsViewModel.redirectURL, paymentType: "MOMO", channelType: "wallet", deviceType: clientDetailsViewModel.deviceType, sourceIP: clientDetailsViewModel.sourceIP, source: clientDetailsViewModel.source, fee: clientDetailsViewModel.fee, retry: clientDetailsViewModel.retry, network: clientDetailsViewModel.network, voucherCode: clientDetailsViewModel.voucherCode))
                        
                        clientDetailsViewModel.retry = true
                    }
                    Spacer().frame(height: 50)
                }
            }
            if(showPaymentMethods == false){
                ChangePaymentMethod(onChange: {
                    if (initiatingMomoTransaction == false){showPaymentMethods.toggle()}
                }, onCancel: {transactionStatusDataViewModel.startSeerbitCheckout = true})
            }
            Spacer()
            CustomFooter()
        }
        .navigationDestination(isPresented: $goToMomoOtp){MomoOtp(linkingReference: linkingRefenece)}
        .navigationDestination(isPresented: $goToBankAccount){BankAccountInitiate()}
        .navigationDestination(isPresented: $goToUssd){SelectUssdBank()}
        .navigationDestination(isPresented: $goToTransfer){TransferDetails(transactionReference: clientDetailsViewModel.paymentReference)}
        .navigationDestination(isPresented: $goToCard){CardInitiate()}
        .navigationDestination(isPresented: $transactionStatusDataViewModel.startSeerbitCheckout){InitSeerbitCheckout(amount: -123456789, fullName: "backhome", mobileNumber: "", publicKey: "", email: "")}
        
        .onReceive(momoViewModel.$momoProvidersResponse){momoProvidersResponse in
            
            if(momoProvidersResponse != nil && momoProvidersResponse?.count ?? 0 > 0){
                listOfProviders = momoProvidersResponse ?? []
                providerAvailable = true
                loadingProviders = false
            }else if (momoProvidersResponse != nil && ((momoProvidersResponse?.isEmpty) == true)){
                providerAvailable = false
                loadingProviders = false
            }
        }
        .onReceive(momoViewModel.$momoProvidersResponseError){momoProvidersResponseError in
            if(momoProvidersResponseError != nil){
                providerAvailable = false
                loadingProviders = false
            }
        }
        .onReceive(momoViewModel.$momoInitiateResponse){momoInitiateResponse in
            if(momoInitiateResponse != nil && momoInitiateResponse?.data?.code == "INP" && momoInitiateResponse?.data?.message == "Kindly Enter Otp"){
                //navigate to momo otp
                initiatingMomoTransaction = false
                linkingRefenece = momoInitiateResponse?.data?.payments?.linkingReference ?? ""
                goToMomoOtp = true
            } else if (momoInitiateResponse != nil && momoInitiateResponse?.data?.code == "S20" && momoInitiateResponse?.data?.message == "Transaction is pending"){
                // query transaction
                initiatingMomoTransaction = false
                confirmingTransaction = true
                queryTransactionViewModel.queryTransaction(reference: momoInitiateResponse?.data?.payments?.paymentReference ?? "")
            }
            else if(momoInitiateResponse != nil){
                initiatingMomoTransaction = false
                errorDescription = momoInitiateResponse?.data?.message ?? momoInitiateResponse?.message ?? "A netork error has occurred. Please try again"
                showErrorDialog = true
            }
        }
        .onReceive(momoViewModel.$momoInitiateResponseError){momoInitiateResponseError in
            if(momoInitiateResponseError != nil){
                initiatingMomoTransaction = false
                errorDescription = "A netork error has occurred. Please try again"
                showErrorDialog = true
            }
        }
        .onReceive(queryTransactionViewModel.$queryTransactionResponse){queryTransactionResponse in
            
            if(queryTransactionResponse != nil
               && queryTransactionResponse?.data?.code == "00"){
                
                // transaction confirmed
                showSuccesDialog = true
                confirmingTransaction = false
                
            }else if(queryTransactionResponse != nil
                     && queryTransactionResponse?.data?.code == "S20"){
                queryTransactionViewModel.queryTransaction(
                    reference: clientDetailsViewModel.paymentReference
                )
            }else if(queryTransactionResponse != nil
                     && queryTransactionResponse?.data?.code != "S20" && queryTransactionResponse?.data?.code != "00"){
                
                confirmingTransaction = false
                errorDescription = queryTransactionViewModel.queryTransactionResponse?.message ?? "Transaction query process has failed"
                showErrorDialog = true
            }
        }
        .onReceive(queryTransactionViewModel.$queryTransactionResponseError){queryTransactionResponseError in
            
            if(queryTransactionResponseError != nil){
                confirmingTransaction = false
                errorDescription = queryTransactionViewModel.queryTransactionResponseError?.localizedDescription ?? "Transaction query process has failed"
                showErrorDialog = true
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
        .onAppear{
            clientDetailsViewModel.fee = ""
            clientDetailsViewModel.fee = calculateFee(amount: clientDetailsViewModel.amount, paymentMethod: paymentMethods.momo.rawValue, merchantDetails: merchantDetailsViewModel.merchantDetails!)
            if(!isMerchantTheFeeBearer(merchantDetails: merchantDetailsViewModel.merchantDetails!)){
                clientDetailsViewModel.totalAmount = ""
                clientDetailsViewModel.totalAmount = String((Double(clientDetailsViewModel.amount) ?? 100.0) + (Double(clientDetailsViewModel.fee) ?? 2000.0))
            }else{clientDetailsViewModel.totalAmount = clientDetailsViewModel.amount}
            loadingProviders = true
            momoViewModel.fetchMomoProviders(countryCode: merchantDetailsViewModel.merchantDetails?.payload?.country?.countryCode ?? "", businessNumber: merchantDetailsViewModel.merchantDetails?.payload?.number ?? "")
        }
        .navigationBarBackButtonHidden(true)
        .padding(20)
    }
}
