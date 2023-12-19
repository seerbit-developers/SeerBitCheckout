//
//  TransferInitiateDataModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 01/11/2023.
//

import Foundation

// MARK: - TransferInitiateRequestDataModel
struct TransferInitiateRequestDataModel: Codable {
    let fullName, mobileNumber, email, publicKey: String?
    let amount, currency, country, paymentReference: String?
    let productID, productDescription, paymentType, channelType: String?
    let deviceType, sourceIP, source, fee: String?
    let retry: Bool?
    let amountControl, walletDaysActive: String?

    enum CodingKeys: String, CodingKey {
        case fullName, mobileNumber, email, publicKey, amount, currency, country, paymentReference
        case productID = "productId"
        case productDescription, paymentType, channelType, deviceType, sourceIP, source, fee, retry, amountControl, walletDaysActive
    }
}
