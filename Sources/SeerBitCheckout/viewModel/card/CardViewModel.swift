//
//  CardViewModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 27/11/2023.
//

import Foundation

class CardViewModel: ObservableObject {
    
    @Published var cardInitiateResponse : CardInitiateResponseDataModel? = nil
    @Published var cardInitiateResponseError : Error? = nil
    
    @Published var cardOtpResponse : CardOtpResponseDataModel? = nil
    @Published var cardOtpResponseError: Error? = nil
    
    @Published var cardBinDataResponse: CardBinResponseDataModel? = nil
    @Published var cardBinDataResponseError: Error? = nil
    
    private  let cardService: CardService
    
    init(cardService:CardService = CardService()){
        self.cardService = cardService
    }
    
    func initiateCardTransaction (body:CardInitiateRequestDataModel){
        cardService.initiateCardTransaction(body:body){ result in
            
            DispatchQueue.main.async {
                switch result{
                case .success (let cardInitiateResponse):
                    self.cardInitiateResponse = cardInitiateResponse
                    
                case .failure(let error):
                    self.cardInitiateResponseError = error
                }
            }
        }
    }
    
    func postCardTransactionOtp (body:CardOtpRequestDataModel){
        cardService.postCardTransactionOtp(body:body){ result in
            
            DispatchQueue.main.async {
                switch result{
                case .success (let otpResponse):
                    self.cardOtpResponse = otpResponse
                    
                case .failure(let error):
                    self.cardOtpResponseError = error
                }
            }
        }
    }
    
    func fetchCardBin (body:String){
        cardService.fetchCardBin(body:body){ result in
            
            DispatchQueue.main.async {
                switch result{
                case .success (let binResponse):
                    self.cardBinDataResponse = binResponse
                    
                case .failure(let error):
                    self.cardBinDataResponseError = error
                }
            }
        }
    }
}
