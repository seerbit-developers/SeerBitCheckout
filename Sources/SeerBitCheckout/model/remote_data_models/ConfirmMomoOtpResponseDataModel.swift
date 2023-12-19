//
//  ConfirmMomoOtpResponseDataModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 12/12/2023.
//

import Foundation



// MARK: - ConfirmMomoOtpResponseDataModel
struct ConfirmMomoOtpResponseDataModel: Codable {
    let status: String?
    let data: ConfirmMomoOtpResponse?
    let message: String?
}

// MARK: - DataClass
struct ConfirmMomoOtpResponse: Codable {
    let code: String?
    let payments: ConfirmMomoOtpResponsePayments?
    let message: String?
}

// MARK: - Payments
struct ConfirmMomoOtpResponsePayments: Codable {
    let linkingreference: String?
}
