//
//  TransactionStatusDataModel.swift
//
//
//  Created by Miracle Eugene on 29/12/2023.
//

import Foundation

// MARK: - TransactionStatusDataModel
public struct TransactionStatusDataModel: Codable {
    let status: String?
    let data: TransactionStatusDataClass?
}

// MARK: - DataClass
struct TransactionStatusDataClass: Codable {
    let code, message: String?
    let payments: TransactionStatusPayments?
    let customers: TransactionStatusCustomers?
}

// MARK: - Customers
struct TransactionStatusCustomers: Codable {
    let customerID, customerName, customerMobile, customerEmail: String?
    let fee: String?

    enum CodingKeys: String, CodingKey {
        case customerID = "customerId"
        case customerName, customerMobile, customerEmail, fee
    }
}

// MARK: - Payments
struct TransactionStatusPayments: Codable {
    let redirectLink: String?
    let amount: Double?
    let fee, mobilenumber, publicKey, paymentType: String?
    let productID, productDescription, gatewayMessage, gatewayCode: String?
    let gatewayref, businessName, mode, redirecturl: String?
    let channelType, sourceIP, country, currency: String?
    let paymentReference, bankCode, reason, transactionProcessedTime: String?

    enum CodingKeys: String, CodingKey {
        case redirectLink, amount, fee, mobilenumber, publicKey, paymentType
        case productID = "productId"
        case productDescription, gatewayMessage, gatewayCode, gatewayref, businessName, mode, redirecturl, channelType, sourceIP, country, currency, paymentReference, bankCode, reason, transactionProcessedTime
    }
}
