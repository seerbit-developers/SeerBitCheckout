//
//  MomoProvidersDataModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 11/12/2023.
//

import Foundation

// MARK: - MomoProvidersDataModel
struct MomoProvidersDataModel: Codable {
    let id: Int?
    let networks, networkCode, countryCode, status: String?
    let processorCode: String?
    let voucherCode: Bool?
}
