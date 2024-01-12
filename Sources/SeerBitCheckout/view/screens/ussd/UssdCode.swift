//
//  UssdCode.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 20/10/2023.
//

import SwiftUI

struct UssdCode: View {
    
    @EnvironmentObject var merchantDetailsViewModel: MerchantDetailsViewModel
    @EnvironmentObject var   clientDetailsViewModel: ClientDetailsViewModel
    @EnvironmentObject var transactionStatusDataViewModel: TransactionStatusDataViewModel
    @ObservedObject var queryTransactionViewModel = QueryTransactionViewModel()
    
    @State var ussdCode: String
    @State var transactionReference: String
    @State var queryErrorMessage: String = ""
    @State var showErrorDialog: Bool  =  false
    @State var confirmingTransaction: Bool  = false
    @State private var showToast: Bool = false
    @State private var showPaymentMethods: Bool = false
    
    @State var goToCard: Bool = false
    @State var goToTransfer: Bool = false
    @State var goToMomo: Bool = false
    @State var goToBankAccount: Bool = false
    @State var goToSuccessScreen: Bool = false
    @State var closeSdk: Bool = false
    
    @State private var canNavigateBack = false
    
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0){
            CustomHeader(merchantDetails: merchantDetailsViewModel.merchantDetails!)
            Spacer().frame(height: 20)
            ScrollView(showsIndicators: false){
                VStack{
                    if(confirmingTransaction){
                        Text("Hold on tight while we confirm this payment")
                            .fontWeight(.regular)
                            .font(.system(size: 14))
                            .foregroundColor(Color(uiColor: UIColor(named: "dark", in: .module, compatibleWith: nil)!))
                            .frame(alignment: .leading)
                        Spacer().frame(height: 20)
                    }else {
                        Text("")
                            .fontWeight(.regular)
                            .foregroundColor(Color(uiColor: UIColor(named: "dark", in: .module, compatibleWith: nil)!))
                            .frame(alignment: .leading)
                    }
                    if (confirmingTransaction) {
                        VStack{
                            LoadingIndicator()
                            Spacer().frame(height: 30)
                        }
                    }else{
                        HStack{
                            Spacer()
                            Text(ussdCode).font(.system(size: 28, design: .rounded)).fontWeight(.heavy)
                            Spacer()
                        }
                        .padding(10)
                        .background(Color(uiColor: UIColor(named: "seaShell", in: .module, compatibleWith: nil)!))
                        .frame(width: 350)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        
                        Spacer().frame(height: 20)
                        Text("Click to copy code")
                            .font(.system(size: 15))
                            .onTapGesture {
                                let clipboard = UIPasteboard.general
                                clipboard.string = ussdCode
                                showToast = true
                            }
                        
                        Spacer().frame(height: 15)
                        CustomButton(buttonLabel: "Confirm Payment"){
                            canNavigateBack = true
                            confirmingTransaction = true
                            queryTransactionViewModel.queryTransaction(reference: transactionReference)
                        }
                        Spacer().frame(height: 15)
                    }
                }
                if(showPaymentMethods){
                    PaymentOptions(onCard: {goToCard = true}, onUssd: {withAnimation{showPaymentMethods.toggle()}}, onTransfer: {goToTransfer = true}, onBankAccount: {goToBankAccount = true}, onMomo: {goToMomo = true}, onCancelPayment: {}, merchantDetails: merchantDetailsViewModel.merchantDetails)
                }else{
                    if(confirmingTransaction){Spacer().frame(height: 50)}else{Spacer().frame(height: 120)}
                    ChangePaymentMethod(onChange: {
                        if (true){showPaymentMethods.toggle()}
                    }, onCancel: {closeSdk = true})
                }
                Spacer()
            }
            .overlay(
                overlayView: CustomToast(toastDetails: ToastDetails(title: "code copied"), showToast: $showToast), show: $showToast)
            CustomFooter()
            
        }
        .navigationDestination(isPresented: $goToBankAccount){BankAccountInitiate()}
        .navigationDestination(isPresented: $goToTransfer){TransferDetails(transactionReference: clientDetailsViewModel.paymentReference)}
        .navigationDestination(isPresented: $goToMomo){MomoInitiate()}
        .navigationDestination(isPresented: $goToCard){CardInitiate()}
        .navigationDestination(isPresented: $closeSdk){InitSeerbitCheckout(amount: -123456789, fullName: "backhome", mobileNumber: "", publicKey: "", email: "")}
        .navigationDestination(isPresented: $goToSuccessScreen){SuccessScreen()}
        
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
                    reference:transactionReference
                )
            }else if(queryTransactionResponse != nil
                     && queryTransactionResponse?.data?.code != "S20" && queryTransactionResponse?.data?.code != "00"){
                canNavigateBack = false
                confirmingTransaction = false
                queryErrorMessage = queryTransactionViewModel.queryTransactionResponse?.message ?? "Transaction query process has failed"
                showErrorDialog = true
            }
        }
        .onReceive(queryTransactionViewModel.$queryTransactionResponseError){queryTransactionResponseError in
            
            if(queryTransactionResponseError != nil){
                canNavigateBack = false
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
        .padding(.horizontal,20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(canNavigateBack)
    }
}
