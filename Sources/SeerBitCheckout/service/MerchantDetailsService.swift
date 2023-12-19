//
//  MerchantDetailsService.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 25/10/2023.
//

import Foundation

class MerchantDetailsService {
    private var apiClient = APIClient()
    func fetchMerchantDetails(publicKey: String, completion: @escaping (Result<MerchantDetailsDataModel, Error>) -> Void) {
        apiClient.makeAPIRequest(
            url: "https://seerbitapi.com/checkout/merchant/clear/"+publicKey,
            method: HTTPRequestMethod.get,
            parameters: "nil",
            completion: completion
        )
    }
    
}

