//
//  ClientDetailsModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 27/10/2023.
//

import Foundation

struct ClientDetailsDataModel: Codable {
    let amount,
        fullName,
        publicKey,
        mobileNumber,
        email,
        currency,
        country,
        paymentReference,
        productId,
        fee,
        productDescription: String
}
