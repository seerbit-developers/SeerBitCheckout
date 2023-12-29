//
//  QueryTransactionService.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 28/10/2023.
//

import Foundation

class QueryTransactionService {
    
    private var apiClient = APIClient()
    
    func queryTransaction(reference: String,completion: @escaping (Result<QueryTransactionDataModel, Error>) -> Void) {
        apiClient.makeAPIRequest(
            url: "\(baseUrl)/query/"+reference,
            method: HTTPRequestMethod.get,
            parameters: "nil",
            completion: completion
        )
    }
}
