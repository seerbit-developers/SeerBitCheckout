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
            url: "\(baseUrl)/banks",
            method: HTTPRequestMethod.get,
            parameters: "nil",
            completion: completion
        )
    }
    
    internal  func initiateBankAccountTransaction(body: BankAccountInitiateRequestDataModel, completion: @escaping (Result<BankAccountInitiateResponseDataModel, Error>) -> Void) {
        apiClient.makeAPIRequest(
            url: "\(baseUrl)/initiates",
            method: HTTPRequestMethod.post,
            parameters: body,
            completion: completion
        )
    }
}
