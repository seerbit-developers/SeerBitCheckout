//
//  MomoService.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 11/12/2023.
//

import Foundation

class MomoService {
    
    private var apiClient = APIClient()
    
    func fetchMomoProviders(countryCode: String, businessNumber: String, completion: @escaping (Result<[MomoProvidersDataModel], Error>) -> Void) {
        apiClient.makeAPIRequest(
            url: "https://seerbitapi.com/tranmgt/networks/"+countryCode+"/"+businessNumber,
            method: HTTPRequestMethod.get,
            parameters: "nil",
            completion: completion
        )
    }
    
    func initiateMomoTransaction(body: MomoInitiateRequestDataModel, completion: @escaping (Result<MomoInitiateResponseDataModel, Error>) -> Void) {
        apiClient.makeAPIRequest(
            url: "\(baseUrl)/initiates",
            method: HTTPRequestMethod.post,
            parameters: body,
            completion: completion
        )
    }
    
    func verifyMomoTransactionOtp(body: ConfirmMomoOtpRequestDataModel, completion: @escaping (Result<ConfirmMomoOtpResponseDataModel, Error>) -> Void) {
        apiClient.makeAPIRequest(
            url: "\(baseUrl)/momo/otp",
            method: HTTPRequestMethod.post,
            parameters: body,
            completion: completion
        )
    }
}
