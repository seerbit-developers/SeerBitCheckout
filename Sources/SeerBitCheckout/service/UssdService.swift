//
//  UssdService.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 26/10/2023.
//

import Foundation


class UssdService {
    
    private var apiClient = APIClient()
    
    
    func initiateUssd(body:UssdInitiateRequestDataModel, completion: @escaping (Result<UssdInitiateResponseDataModel, Error>) -> Void) {
        apiClient.makeAPIRequest(
            url: "\(baseUrl)/initiates",
            method: HTTPRequestMethod.post,
            parameters: body,
            completion: completion
        )
    }
    
}
