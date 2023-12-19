//
//  MerchantDetailsViewModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 25/10/2023.
//

import Foundation


class MerchantDetailsViewModel: ObservableObject {
    
    @Published var merchantDetails : MerchantDetailsDataModel?
    @Published var merchantDetailsError : Error? = nil
    
   private  let merchantDetailsService: MerchantDetailsService
    
    init(merchantDetailsService:MerchantDetailsService = MerchantDetailsService()){
        self.merchantDetailsService = merchantDetailsService
    }
    
    func fetchMerchantDetailsData (publicKey: String){
        merchantDetailsService.fetchMerchantDetails(publicKey:publicKey){ result in
            print(result)
            DispatchQueue.main.async {
                switch result{
                case .success (let merchantDetails):
                    self.merchantDetails = merchantDetails
                    
                case .failure(let error):
                    self.merchantDetailsError = error
                    print(error.localizedDescription,"tanos")
                }
            }
            
        }
    }
}
