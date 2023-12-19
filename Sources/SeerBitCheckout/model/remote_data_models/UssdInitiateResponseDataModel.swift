//
//  UssdInitiateResponseDataModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 26/10/2023.
//

import Foundation

// MARK: - UssdInitiateResponseDataModel
struct UssdInitiateResponseDataModel: Codable {
    let status: String?
    let data: UssdData?
    let message: String?
    let error: String?
}

// MARK: - DataClass
struct UssdData: Codable {
    let code, message: String?
    let payments: Payments?
}

// MARK: - Payments
struct Payments: Codable {
    let paymentReference, linkingReference, providerreference, ussdDailCode: String?
}
