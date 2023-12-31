//
//  QueryTransactionDataModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 28/10/2023.
//

import Foundation

public struct QueryTransactionDataModel: Codable {
    public  let status: String?
    public  let message: String?
    public let  error: String?
    public let data: QueryData?
}

public struct QueryData: Codable {
    let code: String?
    let message: String?
    let payments: QueryDataPayments?
    let customers: QueryDataCustomers?
}

// MARK: - Customers
public struct QueryDataCustomers: Codable {
    public   let customerID, customerName, customerMobile, customerEmail: String?
    public   let fee: String?
    
    enum CodingKeys: String, CodingKey {
        case customerID = "customerId"
        case customerName, customerMobile, customerEmail, fee
    }
}

// MARK: - Payments
public struct QueryDataPayments: Codable {
    public  let redirectLink: String?
    public   let amount: Double?
    public  let fee, mobilenumber, publicKey, paymentType: String?
    public  let productID, productDescription, gatewayMessage, gatewayCode: String?
    public let gatewayref, businessName, mode, redirecturl: String?
    public let channelType, sourceIP, country, currency: String?
    public  let paymentReference, bankCode, reason, transactionProcessedTime: String?
    
    enum CodingKeys: String, CodingKey {
        case redirectLink, amount, fee, mobilenumber, publicKey, paymentType
        case productID = "productId"
        case productDescription, gatewayMessage, gatewayCode, gatewayref, businessName, mode, redirecturl, channelType, sourceIP, country, currency, paymentReference, bankCode, reason, transactionProcessedTime
    }
}
