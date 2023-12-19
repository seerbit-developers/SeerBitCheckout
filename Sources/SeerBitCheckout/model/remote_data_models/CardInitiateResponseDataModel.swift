//
//  CardInitiateResponseDataModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 27/11/2023.
//

import Foundation

// MARK: - CardInitiateResponseDataModel
struct CardInitiateResponseDataModel: Codable {
    let status: String?
    let data: DataClass?
    let message: String?
    let error: String?
}

// MARK: - DataClass
struct DataClass: Codable {
    let code: String?
    let payments: CardPayments?
    let message: String?
}

// MARK: - Payments
struct CardPayments: Codable {
    let paymentReference, linkingReference, cardToken: String?
    let redirectURL: String?
    
    enum CodingKeys: String, CodingKey {
        case paymentReference, linkingReference, cardToken
        case redirectURL = "redirectUrl"
    }
}
