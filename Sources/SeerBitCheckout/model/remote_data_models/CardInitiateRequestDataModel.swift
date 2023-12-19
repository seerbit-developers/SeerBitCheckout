//
//  CardInitiateRequestDataModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 27/11/2023.
//

import Foundation

// MARK: - CardInitiateRequestDataModel
struct CardInitiateRequestDataModel: Codable {
    let fullName, mobileNumber, email, publicKey: String?
    let amount, currency, country, paymentReference: String?
    let productID: String?
    let redirectURL: String?
    let paymentType, channelType, deviceType, sourceIP: String?
    let cardNumber, cvv, expiryMonth, expiryYear: String?
    let source, fee, pin: String?
    let retry, rememberMe: Bool?
    let isCardInternational: String?
    
    enum CodingKeys: String, CodingKey {
        case fullName, mobileNumber, email, publicKey, amount, currency, country, paymentReference
        case productID = "productId"
        case redirectURL = "redirectUrl"
        case paymentType, channelType, deviceType, sourceIP, cardNumber, cvv, expiryMonth, expiryYear, source, fee, pin, retry, rememberMe, isCardInternational
    }
}
