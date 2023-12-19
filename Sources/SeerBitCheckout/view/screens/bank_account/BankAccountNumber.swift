//
//  BankAccountChooseBank.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 16/12/2023.
//

import SwiftUI

struct BankAccountNumber: View {
    
    @EnvironmentObject var merchantDetailsViewModel: MerchantDetailsViewModel
    @EnvironmentObject var clientDetailsViewModel: ClientDetailsViewModel
    //    @StateObject  var cardViewModel: CardViewModel = CardViewModel()
    
    
    @State private var showPaymentMethods: Bool = false
    @State private var authorisingWithBank: Bool = false
    
    @State var showErrorDialog: Bool  =  false
    @State var errorDescription: String = "An error has occured"
    
    @State var goToUssd: Bool = false
    @State var goToTransfer: Bool = false
    @State var goToMomo: Bool = false
    @State var goToCard: Bool = false
    
    @State var bankAccount: String = ""
    @State var otp: String = ""
    @State var bvn: String = ""
    @State var dob  = Date()
    @State var dateOfBirth: String = "DD  /  MM  /  YYYY"
    
    @State var showAccountNumberInput: Bool = false
    @State var showOtpInput: Bool = false
    @State var showBvnInput: Bool = false
    @State var showDobInput: Bool = true
    @State var showDobInputSheet: Bool = false
    
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0){
            CustomHeader(merchantDetails: merchantDetailsViewModel.merchantDetails!)
            Spacer().frame(height: 20)
            
            if (authorisingWithBank){
                VStack{
                    LoadingIndicator()
                    Spacer().frame(height: 30)
                }
            }else{
                if(showPaymentMethods){
                    PaymentOptions(onCard: {goToCard = true}, onUssd: {goToUssd = true}, onTransfer: {goToTransfer = true}, onBankAccount: {withAnimation{showPaymentMethods.toggle()}}, onMomo: {goToMomo = true}, onCancelPayment: {},merchantDetails: merchantDetailsViewModel.merchantDetails)
                }else{
                    Text(showAccountNumberInput ? "Enter your  Access Bank  Account Number"
                         : showOtpInput ? "Kindly enter the OTP sent to your mobile number or email"
                         : showBvnInput ? "Please enter your BVN"
                         : showDobInput ? "Please enter your birthday" : ""
                    )
                        .fontWeight(.regular)
                        .foregroundColor(Color("dark"))
                        .frame(alignment: .leading)
                        .font(.system(size: 15))
                    Spacer().frame(height: 20)
                    
                    if(showAccountNumberInput){
                        CustomInput(value: $bankAccount, placeHolder: "10 Digits Bank Account Number", keyboardType: UIKeyboardType.numbersAndPunctuation)
                    }else if (showOtpInput){
                        CustomInput(value: $otp, placeHolder: "One time passcode", keyboardType: UIKeyboardType.numbersAndPunctuation)
                    }else if(showBvnInput){
                        CustomInput(value: $bvn, placeHolder: "11 Digits Bank Verification Number", keyboardType: UIKeyboardType.numbersAndPunctuation)
                    }else if(showDobInput){
                        HStack(){
                            Button( action: {
                                showDobInputSheet.toggle()
                            }, label: {
                                HStack{
                                    Text(dateOfBirth)
                                        .foregroundColor(Color("starDust"))
                                        .fontWeight(.bold)
                                        .font(.system(size: 14))
                                    Spacer()
                                    Image(systemName: "chevron.down").foregroundColor(Color("starDust"))
                                }
                                .padding(11)
                                .frame(width: .infinity)
                                .border(Color("seaShell"), width: 2)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                            })
                        }
                    }
                    Spacer().frame(height: 30)
                    CustomButton(buttonLabel: "Authorize"){
                        
                        
                        clientDetailsViewModel.retry = true
                    }
                    Spacer().frame(height: 50)
                }
            }
            if(showPaymentMethods == false){
                ChangePaymentMethod(onChange: {
                    if (authorisingWithBank == false){showPaymentMethods.toggle()}
                }, onCancel: {})
            }
            Spacer()
            CustomFooter()
            
            //            NavigationLink(destination: CardBankAuthentication(redirectUrl: cardViewModel.cardInitiateResponse?.data?.payments?.redirectURL ?? ""),
            //                           isActive: $goToRedirect, label: {EmptyView()})
            //
            //            NavigationLink(destination: CardPin(),
            //                           isActive: $goToCardPin, label: {EmptyView()})
            //
            //            NavigationLink(destination: SelectUssdBank(),
            //                           isActive: $goToUssd, label: {EmptyView()})
            //            NavigationLink(destination: TransferDetails(transactionReference: clientDetailsViewModel.paymentReference),
            //                           isActive: $goToTransfer, label: {EmptyView()})
            //            NavigationLink(destination: MomoInitiate(),
            //                           isActive: $goToMomo, label: {EmptyView()})
            //            NavigationLink(destination: BankAccountInitiate(),
            //                           isActive: $goToBankAccount, label: {EmptyView()})
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
        .sheet(isPresented: $showDobInputSheet){
            DatePicker(
                           "Select Date",
                           selection: $dob,
                           displayedComponents: [.date]
                       )
            .datePickerStyle(.graphical)
            .interactiveDismissDisabled(true)
            .presentationDetents([.fraction(0.55)])
            Spacer().frame(height: 20)
            HStack{
                Spacer().frame(width: 20)
                CustomButton(buttonLabel: "Done"){
                    dateOfBirth = dob.description
                    if let _dateOfBirth = dob.description.split(separator:" ").first {
                        dateOfBirth = String(_dateOfBirth)
                    }
                    showDobInputSheet.toggle()
                }
                Spacer().frame(width: 20)
            }
        }
        .onAppear{
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
    }
}
