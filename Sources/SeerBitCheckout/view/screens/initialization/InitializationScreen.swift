//
//  InitializationScreen.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 26/10/2023.
//

import SwiftUI

struct InitializationScreen: View {
    @StateObject private var merchantDetailsViewModel = MerchantDetailsViewModel()
    @StateObject private var clientDetailsViewModel = ClientDetailsViewModel()
    @State var sdkReady: Bool = false
    
    var amount: String
    var fullName: String
    var mobileNumber: String
    var publicKey: String
    var email: String
    var paymentReference: String = ""
    var productId: String = ""
    var productDescription: String = ""
    var currency: String = ""
    
    var body: some View {
        VStack(alignment: .center){
            
            if merchantDetailsViewModel.merchantDetails  != nil {
                if sdkReady {
                    NavigationStack{CardInitiate()}
                        .environmentObject(merchantDetailsViewModel)
                        .environmentObject(clientDetailsViewModel)
                        .navigationBarBackButtonHidden(true)
                }else {
                    Image("checkout_logo")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                    Spacer().frame(height: 20)
                    Text(merchantDetailsViewModel.merchantDetails?.message ?? "An error has occured. Please be sure you hava a correct live public key")
                }
            }else if merchantDetailsViewModel.merchantDetailsError == nil{
                Image("checkout_logo")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                Spacer().frame(height: 40)
                Text("Initializing...")
                Spacer().frame(height: 20)
                LoadingIndicator()
                
            } else if merchantDetailsViewModel.merchantDetailsError != nil{
                Image("checkout_logo")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                Spacer().frame(height: 30)
                Text("Initialization failed. A network error occured. Please try again")
                    .padding(30)
            }
//            NavigationLink(destination: CardInitiate(),
//                           isActive: $sdkReady, label: {EmptyView()})
//            .environmentObject(merchantDetailsViewModel)
//            .environmentObject(clientDetailsViewModel)
//            .navigationBarBackButtonHidden(true)
        }
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
        .onAppear{
            clientDetailsViewModel.amount = amount
            clientDetailsViewModel.fullName = fullName
            clientDetailsViewModel.mobileNumber = mobileNumber
            clientDetailsViewModel.publicKey = publicKey
            clientDetailsViewModel.email = email
            merchantDetailsViewModel.fetchMerchantDetailsData(publicKey: clientDetailsViewModel.publicKey)
        }
    }
}
