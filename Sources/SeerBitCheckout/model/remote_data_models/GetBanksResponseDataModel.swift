//
//  GetBanksResponseDataModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 18/12/2023.
//

import Foundation


// MARK: - GetBanksResponseDataModel
struct GetBanksResponseDataModel: Codable {
    let status: String?
    let data: GetBanksResponseDataClass?
}

// MARK: - DataClass
struct GetBanksResponseDataClass: Codable {
    let code: String?
    let merchantBanks: [MerchantBank]?
    let message: String?
}

// MARK: - MerchantBank
struct MerchantBank: Codable {
    let bankName, bankCode, directConnection, url: String?
    let logo, status, operation: String?
    let minimumAmount: Int?
    let requiredFields: RequiredFields?
}

// MARK: - RequiredFields
struct RequiredFields: Codable {
    let accountName, accountNumber, isBankCode, bvn: String?
    let dateOfBirth, mobileNumber: String?
}
