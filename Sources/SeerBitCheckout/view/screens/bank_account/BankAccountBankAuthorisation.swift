//
//  BankAccountBankAuthorisation.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 16/12/2023.
//

import SwiftUI

struct BankAccountBankAuthorisation: View {
    
    @EnvironmentObject var merchantDetailsViewModel: MerchantDetailsViewModel
    @EnvironmentObject var clientDetailsViewModel: ClientDetailsViewModel
    @StateObject  var queryTransactionViewModel: QueryTransactionViewModel = QueryTransactionViewModel()
    @StateObject  var transactionStatusDataViewModel =  TransactionStatusDataViewModel()
    
    var redirectUrl: String
    @State private var showPaymentMethods: Bool = false
    
    @State var showErrorDialog: Bool  =  false
    @State var errorDescription: String = "An error has occured"
    @State var showSuccesDialog: Bool = false
    @State var confirmingTransaction: Bool  = false
    @State var goToUssd: Bool = false
    @State var goToTransfer: Bool = false
    @State var goToMomo: Bool = false
    @State var goToCard: Bool = false
    
    
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0){
            CustomHeader(merchantDetails: merchantDetailsViewModel.merchantDetails!)
            Spacer().frame(height: 20)
            
            if (confirmingTransaction){
                VStack{
                    LoadingIndicator()
                    Spacer().frame(height: 30)
                }
            }else{
                if(showPaymentMethods){
                    PaymentOptions(onCard: {goToCard = true}, onUssd: {goToUssd = true}, onTransfer: {goToTransfer = true}, onBankAccount: {withAnimation{showPaymentMethods.toggle()}}, onMomo: {goToMomo = true}, onCancelPayment: {},merchantDetails: merchantDetailsViewModel.merchantDetails)
                }else{
                    
                    Text("Please click the button below to authenticate with your bank")
                        .fontWeight(.regular)
                        .foregroundColor(Color(uiColor: UIColor(named: "dark", in: .module, compatibleWith: nil)!))
                        .frame(alignment: .leading)
                        .font(.system(size: 15))
                    Spacer().frame(height: 20)
                    
                    Spacer().frame(height: 30)
                    CustomButton(buttonLabel: "Authenticate Payment"){
                        confirmingTransaction = true
                        queryTransactionViewModel.queryTransaction(reference:clientDetailsViewModel.paymentReference)
                        if let url = URL(string: redirectUrl) {
                            UIApplication.shared.open(url)
                        }
                    }
                    Spacer().frame(height: 50)
                }
            }
            if(showPaymentMethods == false){
                ChangePaymentMethod(onChange: {
                    if (confirmingTransaction == false){showPaymentMethods.toggle()}
                }, onCancel: {transactionStatusDataViewModel.startSeerbitCheckout = true})
            }
            Spacer()
            CustomFooter()
            
        }
        .navigationDestination(isPresented: $goToCard){CardInitiate()}
        .navigationDestination(isPresented: $goToUssd){SelectUssdBank()}
        .navigationDestination(isPresented: $goToTransfer){TransferDetails(transactionReference: clientDetailsViewModel.paymentReference)}
        .navigationDestination(isPresented: $goToMomo){MomoInitiate()}
        .navigationDestination(isPresented: $transactionStatusDataViewModel.startSeerbitCheckout){InitSeerbitCheckout(amount: -123456789, fullName: "backhome", mobileNumber: "", publicKey: "", email: "")}
        
        .onReceive(queryTransactionViewModel.$queryTransactionResponse){queryTransactionResponse in
            
            if(queryTransactionResponse != nil
               && queryTransactionResponse?.data?.code == "00"){
                
                // transaction confirmed
                showSuccesDialog = true
                confirmingTransaction = false
                
            }else if(queryTransactionResponse != nil
                     && queryTransactionResponse?.data?.code == "S20"){
                queryTransactionViewModel.queryTransaction(
                    reference:clientDetailsViewModel.paymentReference
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
        .padding(20)
    }
}
