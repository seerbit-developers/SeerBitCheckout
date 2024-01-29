//
//  SelectBank.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 20/10/2023.
//

import SwiftUI

struct SelectUssdBank: View {
    @EnvironmentObject var merchantDetailsViewModel: MerchantDetailsViewModel
    @EnvironmentObject var   clientDetailsViewModel: ClientDetailsViewModel
    @StateObject  var ussdViewModel: UssdViewModel = UssdViewModel()
    
    var listOfBanks =  ussdBanks
    @State var showUssdBanks = false
    @State var showLoadingIndicator = false
    @State var chosenBankName: String = "Select Bank"
    @State var chosenBankCode: String? = nil
    @State var ussdCode: String = ""
    @State var showErrorDialog: Bool  =  false
    @State var fetchingUssdCode: Bool = false
    @State var goToUssdCode: Bool = false
    @State var errorDescription: String = "An error has occured"
    @State private var showPaymentMethods: Bool = false
    
    @State var goToCard: Bool = false
    @State var goToTransfer: Bool = false
    @State var goToMomo: Bool = false
    @State var goToBankAccount: Bool = false
    @State var closeSdk: Bool = false
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0){
            CustomHeader(merchantDetails: merchantDetailsViewModel.merchantDetails!)
            Spacer().frame(height: 20)
            ScrollView(showsIndicators: false){
                VStack{
                    if(showPaymentMethods){
                        PaymentOptions(onCard: {goToCard = true}, onUssd: {withAnimation{showPaymentMethods.toggle()}}, onTransfer: {goToTransfer = true}, onBankAccount: {goToBankAccount = true}, onMomo: {goToMomo = true}, onCancelPayment: {closeSdk = true}, merchantDetails: merchantDetailsViewModel.merchantDetails)
                    }else{
                        if fetchingUssdCode{
                            Text("")
                                .fontWeight(.regular)
                                .foregroundColor(Color(uiColor: UIColor(named: "dark", in: .module, compatibleWith: nil)!))
                                .frame(alignment: .leading)
                            Spacer().frame(height: 20)
                        }else {
                            Text("Choose your bank to start this payment")
                                .fontWeight(.regular)
                                .foregroundColor(Color(uiColor: UIColor(named: "dark", in: .module, compatibleWith: nil)!))
                                .frame(alignment: .leading)
                                .font(.system(size: 15))
                            Spacer().frame(height: 20)
                        }
                        if (fetchingUssdCode == false) {
                            HStack(){
                                Button( action: {
                                    showUssdBanks.toggle()
                                }, label: {
                                    HStack{
                                        Text(chosenBankName)
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
                        }
                        
                        if fetchingUssdCode{
                            VStack{
                                LoadingIndicator()
                                Spacer().frame(height: 30)
                            }
                        }
                        
                        if (showUssdBanks) {
                            ZStack{
                                ScrollView(showsIndicators: false){
                                    VStack(spacing: 15){
                                        ForEach(listOfBanks, id:\.bankCode) { bank in
                                            Button( action: {
                                                showUssdBanks.toggle()
                                                chosenBankName = bank.bankName
                                                chosenBankCode = bank.bankCode
                                                fetchingUssdCode = true
                                                ussdViewModel.initiateUssdTransaction(body: UssdInitiateRequestDataModel(fullName: clientDetailsViewModel.fullName, mobileNumber: clientDetailsViewModel.mobileNumber, email: clientDetailsViewModel.email, publicKey: clientDetailsViewModel.publicKey, amount: clientDetailsViewModel.totalAmount, currency: clientDetailsViewModel.currency, country: clientDetailsViewModel.country, paymentReference: clientDetailsViewModel.paymentReference, productID: clientDetailsViewModel.productId, productDescription: clientDetailsViewModel.productDescription, redirectURL: clientDetailsViewModel.redirectURL, paymentType: "USSD", channelType: "ussd", ddeviceType: clientDetailsViewModel.deviceType, sourceIP: clientDetailsViewModel.sourceIP, source: clientDetailsViewModel.source, fee: clientDetailsViewModel.fee, retry: clientDetailsViewModel.retry, bankCode: chosenBankCode))
                                                clientDetailsViewModel.retry = true
                                                
                                            }, label: {
                                                VStack{
                                                    HStack{
                                                        Text("\(bank.bankName)")
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
                            .frame(height: 250, alignment: .leading)
                            .padding(0)
                            .border(Color(uiColor: UIColor(named: "seaShell", in: .module, compatibleWith: nil)!), width: 2)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    Spacer().frame(height: 15)
                }
                if(showPaymentMethods == false){
                    if(fetchingUssdCode){Spacer().frame(height: 50)}else{Spacer().frame(height: 120)}
                    ChangePaymentMethod(onChange: {
                        if (fetchingUssdCode == false){showPaymentMethods.toggle()}
                    }, onCancel: {closeSdk = true})
                }
                Spacer()
            }
            CustomFooter()
        }
        .navigationDestination(isPresented: $goToUssdCode){UssdCode(ussdCode: ussdCode, transactionReference: ussdViewModel.ussdInitiateResponse?.data?.payments?.paymentReference ?? "")}
        .navigationDestination(isPresented: $goToBankAccount){BankAccountInitiate()}
        .navigationDestination(isPresented: $goToTransfer){TransferDetails(transactionReference: clientDetailsViewModel.paymentReference)}
        .navigationDestination(isPresented: $goToMomo){MomoInitiate()}
        .navigationDestination(isPresented: $goToCard){CardInitiate()}
        .navigationDestination(isPresented: $closeSdk){InitSeerbitCheckout(amount: -123456789, fullName: "backhome", mobileNumber: "", publicKey: "", email: "")}
        
        .onReceive(ussdViewModel.$ussdInitiateResponse){ussdInitiateResponse in
            if (ussdInitiateResponse?.data?.code) == "S20"{
                fetchingUssdCode = false
                ussdCode = ussdInitiateResponse?.data?.payments?.ussdDailCode ?? "code not available"
                goToUssdCode = true
                
            }else if(ussdInitiateResponse != nil){
                errorDescription = ussdInitiateResponse?.message ?? "An error occured"
                fetchingUssdCode = false
                showErrorDialog = true
            }
        }
        .onReceive(ussdViewModel.$ussdInitiateResponseError){ussdInitiateResponseError in
            if(ussdInitiateResponseError != nil){
                errorDescription = "A netork error has occurred. Please try again"
                fetchingUssdCode = false
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
        .onAppear{
            clientDetailsViewModel.fee = ""
            clientDetailsViewModel.fee = calculateFee(amount: clientDetailsViewModel.amount, paymentMethod: paymentMethods.ussd.rawValue, merchantDetails: merchantDetailsViewModel.merchantDetails!)
            if(!isMerchantTheFeeBearer(merchantDetails: merchantDetailsViewModel.merchantDetails!)){
                clientDetailsViewModel.totalAmount = ""
                clientDetailsViewModel.totalAmount = String((Double(clientDetailsViewModel.amount) ?? 100.0) + (Double(clientDetailsViewModel.fee) ?? 2000.0))
            }else{clientDetailsViewModel.totalAmount = clientDetailsViewModel.amount}
        }
        .padding(.horizontal,20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
    }
}
