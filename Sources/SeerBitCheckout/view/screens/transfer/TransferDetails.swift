//
//  TransferDetails.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 31/10/2023.
//

import SwiftUI

struct TransferDetails: View {
    
    @EnvironmentObject var merchantDetailsViewModel: MerchantDetailsViewModel
    @EnvironmentObject var   clientDetailsViewModel: ClientDetailsViewModel
    @ObservedObject var queryTransactionViewModel = QueryTransactionViewModel()
    @StateObject  var transferViewModel: TransferViewModel = TransferViewModel()
    
    @State var fetchingDetails: Bool = false
    @State var errorFetchingDetails: Bool = false
    @State var queryingTransaction: Bool = false
    @State private var showToast: Bool = false
    @State private var showPaymentMethods: Bool = false
    
    @State var transactionReference: String
    @State var errorMessage: String = ""
    @State var showSuccesDialog: Bool = false
    @State var showErrorDialog: Bool  =  false
    
    @State var accountNumber: String = ""
    @State var beneficiary: String = ""
    @State var bankName: String = ""
    
    @State var goToCard: Bool = false
    @State var goToMomo: Bool = false
    @State var goToUssd: Bool = false
    @State var goToBankAccount: Bool = false
    
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0){
            CustomHeader(merchantDetails: merchantDetailsViewModel.merchantDetails!)
            Spacer().frame(height: 20)
            ScrollView(showsIndicators: false){
                if(queryingTransaction){
                    Text("Hold on tight while we confirm this payment")
                        .fontWeight(.regular)
                        .font(.system(size: 14))
                        .foregroundColor(Color("dark"))
                        .frame(alignment: .leading)
                    Spacer().frame(height: 20)
                }
                if (fetchingDetails || queryingTransaction) {
                    VStack{
                        LoadingIndicator()
                        Spacer().frame(height: 30)
                    }
                }else{
                    if(showPaymentMethods == false){
                        
                        VStack{
                            if(errorFetchingDetails){
                                Text("An error has occured. Please try other payment methods")
                                    .fontWeight(.regular)
                                    .foregroundColor(Color("redOrange"))
                                    .frame(width: .infinity, alignment: .leading)
                                    .font(.system(size: 14))
                            }else {
                                Text("Transfer exactly this amount including the decimals")
                                    .fontWeight(.regular)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color("redOrange"))
                                    .frame(alignment: .leading)
                                Spacer().frame(height: 20)
                                
                                HStack{
                                    Spacer()
                                    Text(formatInputDouble(input: clientDetailsViewModel.totalAmount)).font(.system(size: 25, design: .rounded)).fontWeight(.bold).foregroundColor(Color("dark"))
                                    Spacer()
                                }
                                .padding(8)
                                .background(Color("seaShell"))
                                .frame(width: 350)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                
                                Text("to")
                                    .font(.system(size: 14)).fontWeight(.medium)
                                    .foregroundColor(Color("dark"))
                                VStack{
                                    AccountDetailsItem(
                                        key: "Account Number",
                                        value: accountNumber,
                                        canCopy: true,
                                        toCopy: {
                                            let clipboard = UIPasteboard.general
                                            clipboard.string = accountNumber
                                            showToast = true
                                        }
                                    )
                                    Spacer().frame(height: 10)
                                    AccountDetailsItem(
                                        key: "Bank",
                                        value: bankName,
                                        canCopy: false,
                                        toCopy: {})
                                    Spacer().frame(height: 10)
                                    AccountDetailsItem(
                                        key: "Beneficiary",
                                        value: beneficiary,
                                        canCopy: false,
                                        toCopy: {})
                                    Spacer().frame(height: 10)
                                    AccountDetailsItem(
                                        key: "Validity",
                                        value: "30 minutes",
                                        canCopy: false,
                                        toCopy: {})
                                }
                                .padding(10)
                                .background(Color("seaShell"))
                                .frame(width: 350)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                
                                Text("Account number can only be used once")
                                    .fontWeight(.regular)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color("redOrange"))
                                    .frame(alignment: .leading)
                                
                                Spacer().frame(height: 25)
                                CustomButton(buttonLabel: "Confirm Payment"){
                                    queryingTransaction = true
                                    queryTransactionViewModel.queryTransaction(reference:transactionReference)
                                }
                                Spacer().frame(height: 15)
                            }
                        }
                    }
                }
                if(showPaymentMethods == true){Spacer().frame(height: 0)}else{Spacer().frame(height: 50)}
                if(showPaymentMethods){
                    PaymentOptions(onCard: {goToCard = true}, onUssd: {goToUssd = true}, onTransfer: {withAnimation{showPaymentMethods.toggle()}}, onBankAccount: {goToBankAccount = true}, onMomo: {goToMomo = true}, onCancelPayment: {}, merchantDetails: merchantDetailsViewModel.merchantDetails)
                }else{
                    ChangePaymentMethod(onChange: {
                        if (fetchingDetails == false && queryingTransaction == false){showPaymentMethods.toggle()}
                    }, onCancel: {})
                }
                Spacer()
            }
            .overlay(
                overlayView: CustomToast(toastDetails: ToastDetails(title: "Account copied"), showToast: $showToast), show: $showToast)
            CustomFooter()
            
            NavigationLink(destination: CardInitiate(),
                           isActive: $goToCard, label: {EmptyView()})
            NavigationLink(destination: MomoInitiate(),
                           isActive: $goToMomo, label: {EmptyView()})
            NavigationLink(destination: SelectUssdBank(),
                           isActive: $goToUssd, label: {EmptyView()})
            NavigationLink(destination: BankAccountInitiate(),
                           isActive: $goToBankAccount, label: {EmptyView()})
        }
        .onAppear{
            clientDetailsViewModel.fee = ""
            clientDetailsViewModel.fee = calculateFee(amount: clientDetailsViewModel.amount, paymentMethod: paymentMethods.transfer.rawValue, merchantDetails: merchantDetailsViewModel.merchantDetails!)
            if(!isMerchantTheFeeBearer(merchantDetails: merchantDetailsViewModel.merchantDetails!)){
                clientDetailsViewModel.totalAmount = ""
                clientDetailsViewModel.totalAmount = String((Double(clientDetailsViewModel.amount) ?? 100.0) + (Double(clientDetailsViewModel.fee) ?? 2000.0))
            }else{clientDetailsViewModel.totalAmount = clientDetailsViewModel.amount}
            fetchingDetails = true

            transferViewModel.initiateTransferTransaction(body: TransferInitiateRequestDataModel(fullName: clientDetailsViewModel.fullName, mobileNumber: clientDetailsViewModel.mobileNumber, email: clientDetailsViewModel.email, publicKey: clientDetailsViewModel.publicKey, amount: clientDetailsViewModel.totalAmount, currency: clientDetailsViewModel.currency, country: clientDetailsViewModel.country, paymentReference: clientDetailsViewModel.paymentReference, productID: clientDetailsViewModel.productId, productDescription: clientDetailsViewModel.productDescription, paymentType: "TRANSFER", channelType: "transfer", deviceType: clientDetailsViewModel.deviceType, sourceIP: clientDetailsViewModel.sourceIP, source: clientDetailsViewModel.source, fee: clientDetailsViewModel.fee, retry: clientDetailsViewModel.retry, amountControl: clientDetailsViewModel.amountControl, walletDaysActive: clientDetailsViewModel.walletDaysActive))
            clientDetailsViewModel.retry = true
        }
        .onReceive(transferViewModel.$transferInitiateResponse){ transferInitiateResponse in
            if (transferInitiateResponse?.data?.code == "00"){
                transactionReference = transferInitiateResponse?.data?.payments?.paymentReference ?? ""
                accountNumber = transferInitiateResponse?.data?.payments?.accountNumber ?? ""
                bankName =  transferInitiateResponse?.data?.payments?.bankName ?? ""
                beneficiary = transferInitiateResponse?.data?.payments?.walletName ?? ""
                fetchingDetails = false
                errorFetchingDetails = false
                
            }else if (transferInitiateResponse != nil){
                fetchingDetails = false
                errorFetchingDetails = true
                errorMessage = transferInitiateResponse?.message ?? "An error has occured"
                showErrorDialog = true
            }
        }
        .onReceive(transferViewModel.$transferInitiateResponseError){transferInitiateResponseError in
            
            if(transferInitiateResponseError != nil){
                errorMessage = "A netork error has occurred. Please try again"
                fetchingDetails = false
                errorFetchingDetails = true
                showErrorDialog = true
            }
        }
        .onReceive(queryTransactionViewModel.$queryTransactionResponse){queryTransactionResponse in
            
            if(queryTransactionResponse != nil
               && queryTransactionResponse?.data?.code == "00"){
                
                // transaction confirmed
                showSuccesDialog = true
                queryingTransaction.toggle()
                
            }else if(queryTransactionResponse != nil
                     && queryTransactionResponse?.data?.code == "S20"){
                queryTransactionViewModel.queryTransaction(
                    reference:transactionReference
                )
            }else if(queryTransactionResponse != nil
                     && queryTransactionResponse?.data?.code != "S20" && queryTransactionResponse?.data?.code != "00"){
                
                queryingTransaction.toggle()
                errorMessage = queryTransactionViewModel.queryTransactionResponse?.message ?? "Transaction query process has failed"
                showErrorDialog = true
            }
        }
        .onReceive(queryTransactionViewModel.$queryTransactionResponseError){queryTransactionResponseError in
            
            if(queryTransactionResponseError != nil){
                queryingTransaction.toggle()
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
        .padding(.horizontal,20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
    }
}
