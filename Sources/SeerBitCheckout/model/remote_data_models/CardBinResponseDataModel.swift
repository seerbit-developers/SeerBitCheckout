//
//  CardBinResponseModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 08/12/2023.
//

import Foundation

// MARK: - CardBinResponseDataModel
struct CardBinResponseDataModel: Codable {
    let cardBin, cardName: String?
    let nigeriancard: Bool?
    let country, responseCode, responseMessage, transactionReference, message: String?
}
