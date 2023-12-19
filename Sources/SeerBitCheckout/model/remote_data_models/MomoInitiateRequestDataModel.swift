//
//  MomoInitiateRequestDataModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 11/12/2023.
//

import Foundation

// MARK: - MomoInitiateRequestDataModel
struct MomoInitiateRequestDataModel: Codable {
    let fullName, mobileNumber, email, publicKey: String?
    let amount, currency, country, paymentReference: String?
    let productID, productDescription: String?
    let redirectURL: String?
    let paymentType, channelType, deviceType, sourceIP: String?
    let source, fee: String?
    let retry: Bool?
    let network, voucherCode: String?

    enum CodingKeys: String, CodingKey {
        case fullName, mobileNumber, email, publicKey, amount, currency, country, paymentReference
        case productID = "productId"
        case productDescription
        case redirectURL = "redirectUrl"
        case paymentType, channelType, deviceType, sourceIP, source, fee, retry, network, voucherCode
    }
}
