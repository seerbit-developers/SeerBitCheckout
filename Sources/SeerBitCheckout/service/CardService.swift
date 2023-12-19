//
//  CardService.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 27/11/2023.
//

import Foundation
class CardService {
    
    private var apiClient = APIClient()
    
    func initiateCardTransaction(body:CardInitiateRequestDataModel,completion: @escaping (Result<CardInitiateResponseDataModel, Error>) -> Void) {
        apiClient.makeAPIRequest(
            url: "https://seerbitapi.com/sandbox/initiates",
            method: HTTPRequestMethod.post,
            parameters: body,
            completion: completion
        )
    }
    
    func postCardTransactionOtp(body:CardOtpRequestDataModel,completion: @escaping (Result<CardOtpResponseDataModel, Error>) -> Void) {
        apiClient.makeAPIRequest(
            url: "https://seerbitapi.com/sandbox/otp",
            method: HTTPRequestMethod.post,
            parameters: body,
            completion: completion
        )
    }
    
    func fetchCardBin(body:String,completion: @escaping (Result<CardBinResponseDataModel, Error>) -> Void) {
        apiClient.makeAPIRequest(
            url: "https://seerbitapi.com/checkout/bin/"+body,
            method: HTTPRequestMethod.get,
            parameters: body,
            completion: completion
        )
    }
}
//5123450000000008
//4485275742308327
