//
//  QueryTransactionViewModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 28/10/2023.
//

import Foundation

class QueryTransactionViewModel: ObservableObject {
    
    @Published var queryTransactionResponse : QueryTransactionDataModel?
    @Published var queryTransactionResponseError : Error? = nil
    
    private  let queryTransactionService = QueryTransactionService()
    
    
    func queryTransaction (reference:String){
        queryTransactionService.queryTransaction(reference: reference){ result in

            DispatchQueue.main.async {
                switch result{
                case .success (let queryTransactionResponse):
                    self.queryTransactionResponse = queryTransactionResponse
                    
                case .failure(let error):
                    self.queryTransactionResponseError = error
                }
            }
        }
    }
}
