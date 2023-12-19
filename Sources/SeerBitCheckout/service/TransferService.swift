//
//  TransferService.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 01/11/2023.
//

import Foundation

class TransferService {
    
    private var apiClient = APIClient()
    
    func initiateTransferTransaction(body:TransferInitiateRequestDataModel, completion: @escaping (Result<TransferInitiateResponseDataModel, Error>) -> Void) {
        apiClient.makeAPIRequest(
            url: "https://seerbitapi.com/checkout/initiates",
            method: HTTPRequestMethod.post,
            parameters: body,
            completion: completion
        )
    }
    
}
