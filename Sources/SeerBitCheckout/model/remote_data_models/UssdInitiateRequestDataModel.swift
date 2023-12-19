//
//  UssdInitiateRequestDataModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 26/10/2023.
//

import Foundation

// MARK: - UssdInitiateRequestDataModel
struct UssdInitiateRequestDataModel: Codable {
    let fullName, mobileNumber, email, publicKey: String?
    let amount, currency, country, paymentReference: String?
    let productID, productDescription: String?
    let redirectURL: String?
    let paymentType, channelType, ddeviceType, sourceIP: String?
    let source, fee: String?
    let retry: Bool?
    let bankCode: String?

    enum CodingKeys: String, CodingKey {
        case fullName, mobileNumber, email, publicKey, amount, currency, country, paymentReference
        case productID = "productId"
        case productDescription
        case redirectURL = "redirectUrl"
        case paymentType, channelType, ddeviceType, sourceIP, source, fee, retry, bankCode
    }
}
