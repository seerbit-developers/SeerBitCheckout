//
//  TransferInitiateResponseDataModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 01/11/2023.
//

import Foundation

// MARK: - TransferInitiateResponseDataModel
struct TransferInitiateResponseDataModel: Codable {
    let status: String?
    let data: TransferResponseData?
    let message: String?
    let error: String?
}

// MARK: - DataClass
struct TransferResponseData: Codable {
    let code, message: String?
    let payments: TransferPayments?
}

// MARK: - Payments
struct TransferPayments: Codable {
    let paymentReference, linkingReference, walletName, wallet: String?
    let bankName, accountNumber: String?
}
