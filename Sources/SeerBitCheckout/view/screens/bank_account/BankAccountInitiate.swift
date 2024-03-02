//
//  BankAccountInitiate.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 16/12/2023.
//

import SwiftUI

struct BankAccountInitiate: View {
    
    @EnvironmentObject var merchantDetailsViewModel: MerchantDetailsViewModel
    @EnvironmentObject var clientDetailsViewModel: ClientDetailsViewModel
    @StateObject  var bankAccountViewModel: BankAccountViewModel = BankAccountViewModel()
    
    @State private var showPaymentMethods: Bool = false
    @State private var initiatingBankTransaction: Bool = false
    @State private var showToast: Bool = false
    
    @State var showErrorDialog: Bool  =  false
    @State var errorDescription: String = "An error has occured"
    @State var goToRedirect: Bool = false
    @State var merchantBanks: [MerchantBank]? = nil
    
    @State var goToUssd: Bool = false
    @State var goToTransfer: Bool = false
    @State var goToMomo: Bool = false
    @State var goToCard: Bool = false
    @State var fetchingBanks: Bool = false
    @State var showBanks: Bool = false
    @State var chosenBankName: String = "Select bank"
    @State var chosenBank: MerchantBank? = nil
    @State var closeSdk: Bool = false
    
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0){
            CustomHeader(merchantDetails: merchantDetailsViewModel.merchantDetails!)
            Spacer().frame(height: 20)
            
            if (initiatingBankTransaction){
                VStack{
                    LoadingIndicator()
                    Spacer().frame(height: 30)
                }
            }else{
                if(showPaymentMethods){
                    PaymentOptions(onCard: {goToCard = true}, onUssd: {goToUssd = true}, onTransfer: {goToTransfer = true}, onBankAccount: {withAnimation{showPaymentMethods.toggle()}}, onMomo: {goToMomo = true}, onCancelPayment: {closeSdk = true},merchantDetails: merchantDetailsViewModel.merchantDetails)
                }else{
                    
                    Text("Choose your bank to start this payment")
                        .fontWeight(.regular)
                        .foregroundColor(Color(.dark))
                        .frame(alignment: .leading)
                        .font(.system(size: 15))
                    Spacer().frame(height: 20)
                    
                    if (fetchingBanks == false) {
                        HStack(){
                            Button( action: {
                                if(merchantBanks == nil || ((merchantBanks?.isEmpty) == true)){
                                    errorDescription = "List of banks not available. please try other payment methods"
                                    showErrorDialog = true
                                }else{showBanks.toggle()}
                                
                            }, label: {
                                HStack{
                                    Text(chosenBankName)
                                        .foregroundColor(Color(.starDust))
                                        .fontWeight(.bold)
                                        .font(.system(size: 14))
                                    Spacer()
                                    Image(systemName: "chevron.down").foregroundColor(Color(.starDust))
                                }
                                .padding(11)
                                .frame(width: .infinity)
                                .border(Color(.seaShell), width: 2)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                            })
                        }
                        
                        if (showBanks) {
                            ZStack{
                                ScrollView(showsIndicators: false){
                                    VStack(spacing: 15){
                                        ForEach(merchantBanks ?? [], id:\.bankCode) { bank in
                                            Button( action: {
                                                
                                                chosenBank = bank
                                                chosenBankName = bank.bankName ?? ""
                                                clientDetailsViewModel.bankCode = bank.bankCode ?? ""
                                                clientDetailsViewModel.accountName = clientDetailsViewModel.fullName
                                                showBanks.toggle()
                                                
                                            }, label: {
                                                VStack{
                                                    HStack{
                                                        Text(bank.bankName ?? "")
                                                            .foregroundColor(.black)
                                                            .fontWeight(.regular)
                                                            .font(.system(size: 11))
                                                            .frame( alignment:.trailing)
                                                        Spacer()
                                                    }
                                                    VStack{
                                                        Divider()
                                                            .frame(height: 0.3)
                                                            .overlay(Color(.starDust))
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
                                .background(Color(.porcelain))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .frame(height: 170, alignment: .leading)
                            .padding(0)
                            .border(Color(.seaShell), width: 2)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    
                    Spacer().frame(height: 30)
                    CustomButton(buttonLabel: clientDetailsViewModel.currency + formatInputDouble(input: clientDetailsViewModel.totalAmount)){
                        if(chosenBankName == "Select bank"){showToast = true}else {
                            initiatingBankTransaction = true
                            bankAccountViewModel.initiateBankAccountTransaction(body: BankAccountInitiateRequestDataModel(fullName: clientDetailsViewModel.fullName, mobileNumber: clientDetailsViewModel.mobileNumber, email: clientDetailsViewModel.email, publicKey: clientDetailsViewModel.publicKey, amount: clientDetailsViewModel.totalAmount, currency: clientDetailsViewModel.currency, country: clientDetailsViewModel.country, paymentReference: clientDetailsViewModel.paymentReference, productID: clientDetailsViewModel.productId, productDescription: clientDetailsViewModel.productDescription, redirectURL: clientDetailsViewModel.redirectURL, paymentType: "ACCOUNT", deviceType: clientDetailsViewModel.deviceType, sourceIP: clientDetailsViewModel.sourceIP, channelType: "", bankCode: chosenBank?.bankCode ?? "", accountName: clientDetailsViewModel.fullName, accountNumber: clientDetailsViewModel.accountNumber, bvn: clientDetailsViewModel.bvn, dateOfBirth: clientDetailsViewModel.dateOfBirth, scheduleID: clientDetailsViewModel.scheduleId, source: clientDetailsViewModel.source, fee: clientDetailsViewModel.fee, retry: clientDetailsViewModel.retry))
                            
                            clientDetailsViewModel.retry = true
                        }
                    }
                    Spacer().frame(height: 50)
                }
            }
            if(showPaymentMethods == false){
                ChangePaymentMethod(onChange: {
                    if (initiatingBankTransaction == false){showPaymentMethods.toggle()}
                }, onCancel: {closeSdk = true})
            }
            Spacer()
                .overlay(
                    overlayView: CustomToast(toastDetails: ToastDetails(title: "Please select bank"), showToast: $showToast), show: $showToast)
            CustomFooter()
        }
        .navigationDestination(isPresented: $goToRedirect){BankAccountBankAuthorisation(redirectUrl: bankAccountViewModel.bankAccountInitiateResponse?.data?.payments?.redirectURL ?? "")}
        .navigationDestination(isPresented: $goToCard){CardInitiate()}
        .navigationDestination(isPresented: $goToUssd){SelectUssdBank()}
        .navigationDestination(isPresented: $goToTransfer){TransferDetails(transactionReference: clientDetailsViewModel.paymentReference)}
        .navigationDestination(isPresented: $goToMomo){MomoInitiate()}
        .navigationDestination(isPresented: $closeSdk){InitSeerbitCheckout(amount: -123456789, fullName: "backhome", mobileNumber: "", publicKey: "", email: "")}
        
        .onReceive(bankAccountViewModel.$merchantBanks){ banksList in
            if(banksList?.status == "SUCCESS" && banksList?.data?.code == "00"){ merchantBanks = banksList?.data?.merchantBanks}
        }
        .onReceive(bankAccountViewModel.$bankAccountInitiateResponse){bankAccountInitiateResponse in
            
            if(bankAccountInitiateResponse?.data?.code == "S20" && bankAccountInitiateResponse?.data?.payments?.redirectURL != nil && bankAccountInitiateResponse?.data?.payments?.redirectURL?.isEmpty == false){
                initiatingBankTransaction = false
                //redirect
                goToRedirect = true
            }else if (bankAccountInitiateResponse != nil){
                initiatingBankTransaction = false
                errorDescription =  "An error has occured. Please use another payment method or choose another bank."
                showErrorDialog = true
            }
        }
        .onReceive(bankAccountViewModel.$bankAccountInitiateError){bankAccountInitiateError in
            if(bankAccountInitiateError != nil){
                initiatingBankTransaction = false
                errorDescription = "A netork error has occurred. Please try again"
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
            bankAccountViewModel.fetchMerchantBanks()
            clientDetailsViewModel.fee = ""
            clientDetailsViewModel.fee = calculateFee(amount: clientDetailsViewModel.amount, paymentMethod: paymentMethods.account.rawValue, merchantDetails: merchantDetailsViewModel.merchantDetails!)
            if(!isMerchantTheFeeBearer(merchantDetails: merchantDetailsViewModel.merchantDetails!)){
                clientDetailsViewModel.totalAmount = ""
                clientDetailsViewModel.totalAmount = String((Double(clientDetailsViewModel.amount) ?? 100.0) + (Double(clientDetailsViewModel.fee) ?? 2000.0))
            }else{
                clientDetailsViewModel.totalAmount = clientDetailsViewModel.amount
            }
        }
        .padding(20)
        .navigationBarBackButtonHidden(true)
    }
}
