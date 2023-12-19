//
//  CardOtpResponseDataModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 08/12/2023.
//

import Foundation

// MARK: - CardOtpResponseDataModel
struct CardOtpResponseDataModel: Codable {
    let status: String?
    let data: OtpDataClass?
}

// MARK: - DataClass
struct OtpDataClass: Codable {
    let code: String?
    let payments: OtpPayments?
    let message: String?
}

// MARK: - Payments
struct OtpPayments: Codable {
    let reference, linkingReference: String?
}
