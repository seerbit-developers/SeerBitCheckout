//
//  BankAccountInitiateRequestDataModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 18/12/2023.
//

import Foundation

// MARK: - BankAccountInitiateRequestDataModel
struct BankAccountInitiateRequestDataModel: Codable {
    let fullName, mobileNumber, email, publicKey: String?
    let amount, currency, country, paymentReference: String?
    let productID, productDescription, redirectURL, paymentType: String?
    let deviceType, sourceIP, channelType, bankCode: String?
    let accountName, accountNumber, bvn, dateOfBirth: String?
    let scheduleID, source, fee: String?
    let retry: Bool?

    enum CodingKeys: String, CodingKey {
        case fullName, mobileNumber, email, publicKey, amount, currency, country, paymentReference
        case productID = "productId"
        case productDescription
        case redirectURL = "redirectUrl"
        case paymentType, deviceType, sourceIP, channelType, bankCode, accountName, accountNumber, bvn, dateOfBirth
        case scheduleID = "scheduleId"
        case source, fee, retry
    }
}
