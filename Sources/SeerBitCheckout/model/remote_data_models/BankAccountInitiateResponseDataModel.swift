//
//  BankAccountInitiateResponseDataModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 18/12/2023.
//

import Foundation

// MARK: - BankAccountInitiateResponseDataModel
struct BankAccountInitiateResponseDataModel: Codable {
    let status: String?
    let data: BankAccountInitiateResponseDataClass?
    let message: String?
}

// MARK: - DataClass
struct BankAccountInitiateResponseDataClass: Codable {
    let code, message: String?
    let payments: BankAccountInitiateResponsePayments?
}

// MARK: - Payments
struct BankAccountInitiateResponsePayments: Codable {
    let paymentReference, linkingReference: String?
    let redirectURL: String?
    
    enum CodingKeys: String, CodingKey {
        case paymentReference, linkingReference
        case redirectURL = "redirectUrl"
    }
}
