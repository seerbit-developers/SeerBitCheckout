//
//  MomoInitiateResponseDataModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 11/12/2023.
//

import Foundation

// MARK: - MomoInitiateResponseDataModel
struct MomoInitiateResponseDataModel: Codable {
    let status: String?
    let data: MomoInitiateResponseDataClass?
    let message: String?
}

// MARK: - DataClass
struct MomoInitiateResponseDataClass: Codable {
    let code, message: String?
    let payments: MomoInitiateResponsePayments?
}

// MARK: - Payments
struct MomoInitiateResponsePayments: Codable {
    let paymentReference, linkingReference: String?
}
