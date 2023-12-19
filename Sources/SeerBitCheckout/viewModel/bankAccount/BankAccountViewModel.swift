//
//  BankAccountViewModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 18/12/2023.
//

import Foundation

class BankAccountViewModel: ObservableObject {
    
    @Published var merchantBanks: GetBanksResponseDataModel? = nil
    @Published var merchantBanksError: Error? = nil
    
    @Published var bankAccountInitiateResponse: BankAccountInitiateResponseDataModel? = nil
    @Published var bankAccountInitiateError: Error? = nil
    
    private  let bankAccountService: BankAccountService
     
     init(bankAccountService:BankAccountService = BankAccountService()){
         self.bankAccountService = bankAccountService
     }
    
    internal  func fetchMerchantBanks(){
        bankAccountService.fetchMerchantBanks{ result in
            print(result, " list of banks")
            DispatchQueue.main.async {
                switch result{
                case .success (let banks):
                    self.merchantBanks = banks
                    
                case .failure(let error):
                    self.merchantBanksError = error
                    print(error.localizedDescription,"tanos merchantBanksError")
                }
            }
        }
    }
    
    internal func initiateBankAccountTransaction(body: BankAccountInitiateRequestDataModel){
        bankAccountService.initiateBankAccountTransaction(body: body){ result in
            
            print(result, " init bankaccount res")
            DispatchQueue.main.async {
                switch result{
                case .success (let bankaccountResponse):
                    self.bankAccountInitiateResponse = bankaccountResponse
                    
                case .failure(let error):
                    self.bankAccountInitiateError = error
                    print(error.localizedDescription,"tanos bank account Error")
                }
            }
        }
    }
    
    
}
