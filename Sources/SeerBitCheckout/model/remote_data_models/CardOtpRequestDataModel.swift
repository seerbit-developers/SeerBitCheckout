//
//  CardOtpRequestDataModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 08/12/2023.
//

import Foundation

// MARK: - CardOtpRequestDataModel
struct CardOtpRequestDataModel: Codable {
    let transaction: OtpTransaction?
}

// MARK: - Transaction
struct OtpTransaction: Codable {
    let linkingreference, otp: String?
}
