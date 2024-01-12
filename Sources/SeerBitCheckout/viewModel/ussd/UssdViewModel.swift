//
//  UssdViewModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 25/10/2023.
//

import Foundation

class UssdViewModel: ObservableObject {
    
    @Published var ussdInitiateResponse : UssdInitiateResponseDataModel? = nil
    @Published var ussdInitiateResponseError : Error? = nil

   private  let ussdService: UssdService
    
    init(ussdService:UssdService = UssdService()){
        self.ussdService = ussdService
    }
    
    func initiateUssdTransaction (body:UssdInitiateRequestDataModel){
        ussdService.initiateUssd(body:body){ result in

            DispatchQueue.main.async {
                switch result{
                case .success (let ussdInitiateResponse):
                    self.ussdInitiateResponse = ussdInitiateResponse
                    
                case .failure(let error):
                    self.ussdInitiateResponseError = error
                }
            }
        }
    }
}
