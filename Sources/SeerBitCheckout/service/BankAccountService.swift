//
//  BankAccountService.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 18/12/2023.
//

import Foundation

class BankAccountService {
    
    private var apiClient = APIClient()
    
    func fetchMerchantBanks(completion: @escaping (Result<GetBanksResponseDataModel, Error>) -> Void) {
        apiClient.makeAPIRequest(
            url: "https://seerbitapi.com/checkout/banks",
            method: HTTPRequestMethod.get,
            parameters: "nil",
            completion: completion
        )
    }
    
    internal  func initiateBankAccountTransaction(body: BankAccountInitiateRequestDataModel, completion: @escaping (Result<BankAccountInitiateResponseDataModel, Error>) -> Void) {
        apiClient.makeAPIRequest(
            url: "https://seerbitapi.com/checkout/initiates",
            method: HTTPRequestMethod.post,
            parameters: body,
            completion: completion
        )
    }
}
