//
//  CardBankAuthentication.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 27/11/2023.
//

import SwiftUI

@available(iOS 16.0, *)
struct CardBankAuthentication: View {
    
    @EnvironmentObject var merchantDetailsViewModel: MerchantDetailsViewModel
    @EnvironmentObject var   clientDetailsViewModel: ClientDetailsViewModel
    @EnvironmentObject var transactionStatusDataViewModel: TransactionStatusDataViewModel
    @ObservedObject var queryTransactionViewModel = QueryTransactionViewModel()
    
    var redirectUrl: String
    
    @State var queryErrorMessage: String = ""
    @State var showSuccesDialog: Bool = false
    @State var showErrorDialog: Bool  =  false
    @State var confirmingTransaction: Bool  = false
    @State private var showPaymentMethods: Bool = false
    
    @State var goToUssd: Bool = false
    @State var goToTransfer: Bool = false
    @State var goToMomo: Bool = false
    @State var goToBankAccount: Bool = false
    @State var goToSuccessScreen: Bool = false
    @State var closeSdk: Bool = false
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0){
            CustomHeader(merchantDetails: merchantDetailsViewModel.merchantDetails!)
            Spacer().frame(height: 20)
            
            if(showPaymentMethods){
                PaymentOptions(onCard: {withAnimation{showPaymentMethods.toggle()}}, onUssd: {goToUssd = true}, onTransfer: {goToTransfer = true}, onBankAccount: {goToBankAccount = true}, onMomo: {goToMomo = true}, onCancelPayment: {closeSdk = true}, merchantDetails: merchantDetailsViewModel.merchantDetails)
            }else{
                if(confirmingTransaction){
                    Text("Hold on tight while we confirm this payment")
                        .fontWeight(.regular)
                        .font(.system(size: 14))
                        .foregroundColor(Color(uiColor: UIColor(named: "dark", in: HelperBundle.resolvedBundle, compatibleWith: nil)!))
                        .frame(alignment: .leading)
                    Spacer().frame(height: 20)
                }else {
                    Text("")
                        .fontWeight(.regular)
                        .foregroundColor(Color(uiColor: UIColor(named: "dark", in: HelperBundle.resolvedBundle, compatibleWith: nil)!))
                        .frame(alignment: .leading)
                }
                if (confirmingTransaction) {
                    VStack{
                        LoadingIndicator()
                        Spacer().frame(height: 30)
                    }
                }else{
                    VStack{
                        Spacer().frame(height: 5)
                        Text("Please click the button below to authenticate with your bank")
                            .foregroundColor(Color(uiColor: UIColor(named: "dark", in: HelperBundle.resolvedBundle, compatibleWith: nil)!))
                            .fontWeight(.regular)
                            .font(.system(size: 13))
                            .multilineTextAlignment(.center)
                        Spacer().frame(height: 40)
                        CustomButton(buttonLabel: "Authorize payment"){
                            confirmingTransaction = true
                            queryTransactionViewModel.queryTransaction(reference:clientDetailsViewModel.paymentReference)
                            if let url = URL(string: redirectUrl) {
                                UIApplication.shared.open(url)
                            }
                        }
                        Spacer().frame(height: 20)
                    }
                }
                Spacer().frame(height: 50)
                ChangePaymentMethod(onChange: {showPaymentMethods.toggle()}, onCancel: {closeSdk = true})
            }
            Spacer()
            CustomFooter()
        }
        .navigationDestination(isPresented: $goToBankAccount){BankAccountInitiate()}
        .navigationDestination(isPresented: $goToUssd){SelectUssdBank()}
        .navigationDestination(isPresented: $goToTransfer){TransferDetails(transactionReference: clientDetailsViewModel.paymentReference)}
        .navigationDestination(isPresented: $goToMomo){MomoInitiate()}
        .navigationDestination(isPresented: $goToSuccessScreen){SuccessScreen()}
        .navigationDestination(isPresented: $closeSdk){InitSeerbitCheckout(amount: -123456789, fullName: "backhome", mobileNumber: "", publicKey: "", email: "")}
        
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
                queryErrorMessage = queryTransactionViewModel.queryTransactionResponse?.message ?? "Transaction query process has failed"
                showErrorDialog = true
            }
        }
        .onReceive(queryTransactionViewModel.$queryTransactionResponseError){queryTransactionResponseError in
            
            if(queryTransactionResponseError != nil){
                confirmingTransaction = false
                queryErrorMessage = queryTransactionViewModel.queryTransactionResponseError?.localizedDescription ?? "Transaction query has failed"
                showErrorDialog = true
            }
        }
        .sheet(isPresented: $showErrorDialog){
            ErrorModal(
                description:queryErrorMessage,
                buttonLeftAction: {},
                buttonRightAction: {},
                singleButtonAction: {showErrorDialog.toggle()})
            .interactiveDismissDisabled(true)
            .presentationDetents([.fraction(0.4)])
        }
        .padding(20)
    }
}
