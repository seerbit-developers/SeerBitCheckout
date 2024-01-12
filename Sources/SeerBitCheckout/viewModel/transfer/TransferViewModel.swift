//
//  TransferViewModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 01/11/2023.
//

import Foundation

class TransferViewModel: ObservableObject {
    
    @Published var transferInitiateResponse : TransferInitiateResponseDataModel? = nil
    @Published var transferInitiateResponseError : Error? = nil
    
    private  let transferService: TransferService
     
     init(transferService:TransferService = TransferService()){
         self.transferService = transferService
     }
    
    func initiateTransferTransaction (body:TransferInitiateRequestDataModel){

        transferService.initiateTransferTransaction(body: body){ result in

            DispatchQueue.main.async {
                switch result{
                case .success (let transferInitiateResponse):
                    self.transferInitiateResponse = transferInitiateResponse
                    
                case .failure(let error):
                    self.transferInitiateResponseError = error
                }
            }
        }
    }
}
