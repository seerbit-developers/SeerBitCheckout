//
//  ConfirmMomoOtpRequestDataModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 12/12/2023.
//

import Foundation

// MARK: - ConfirmMomoOtpRequestDataModel
struct ConfirmMomoOtpRequestDataModel: Codable {
    let linkingReference, otp: String?
}
