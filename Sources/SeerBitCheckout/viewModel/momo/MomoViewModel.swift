//
//  MomoViewModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 11/12/2023.
//

import Foundation

class MomoViewModel: ObservableObject {
    
    @Published var momoProvidersResponse : [MomoProvidersDataModel]? = nil
    @Published var momoProvidersResponseError : Error? = nil
    
    @Published var momoInitiateResponse : MomoInitiateResponseDataModel? = nil
    @Published var momoInitiateResponseError : Error? = nil
    
    @Published var momoOtpResponse : ConfirmMomoOtpResponseDataModel? = nil
    @Published var momoOtpResponseError : Error? = nil
    
    private  let momoService: MomoService
    
    init(momoService: MomoService = MomoService()){
        self.momoService = momoService
    }
    
    func fetchMomoProviders (countryCode: String, businessNumber: String){
        momoService.fetchMomoProviders(countryCode: countryCode, businessNumber: businessNumber){ result in
            print(result, "momo providers res")
            DispatchQueue.main.async {
                switch result{
                case .success (let momoNetworks):
                    self.momoProvidersResponse = momoNetworks
                    
                case .failure(let error):
                    self.momoProvidersResponseError = error
                    print(error.localizedDescription,"tanos momo providers")
                }
            }
        }
    }
    
    func initiateMomoTransaction (body: MomoInitiateRequestDataModel){
        momoService.initiateMomoTransaction(body: body){ result in
            print(result, "momo initiate res")
            DispatchQueue.main.async {
                switch result{
                case .success (let momoInitiateResponse):
                    self.momoInitiateResponse = momoInitiateResponse
                    
                case .failure(let error):
                    self.momoInitiateResponseError = error
                    print(error.localizedDescription,"tanos momo intiate error")
                }
            }
        }
    }
    
    func verifyMomoTransactionOtp (body: ConfirmMomoOtpRequestDataModel){
        momoService.verifyMomoTransactionOtp(body: body){ otpResult in

            DispatchQueue.main.async {
                switch otpResult{
                case .success (let momoOtpResponse):
                    self.momoOtpResponse = momoOtpResponse
                    
                case .failure(let error):
                    self.momoOtpResponseError = error
                    print(error.localizedDescription,"tanos momo otp error")
                }
            }
        }
    }
}
