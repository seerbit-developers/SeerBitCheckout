//
//  QueryTransactionDataModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 28/10/2023.
//

import Foundation

struct QueryTransactionDataModel: Codable {
    let status: String?
    let message: String?
    let  error: String?
    let data: QueryData?
}

struct QueryData: Codable {
    let code: String?
    let message: String?
}

