//
//  UssdBanksModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 26/10/2023.
//

import Foundation
struct UssdBanksModel {
    let bankCode: String
    let bankName: String
    let abb: String
}

var ussdBanks: [UssdBanksModel] = [
    UssdBanksModel(
        bankCode: "063",
        bankName: "ACCESS DIAMOND PLC",
        abb: "ACCESS DIAMOND's"),
    UssdBanksModel(
        bankCode: "044",
        bankName: "ACCESS BANK PLC",
        abb: "ACCESS BANK's"
    ),
    UssdBanksModel(
        
        bankCode: "050",
        bankName: "ECOBANK BANK PLC",
        abb: "ECOBANK's"
    ),
    UssdBanksModel(
        bankCode: "070",
        bankName: "FIDELITY BANK PLC",
        abb: "FIDELITY BANK's"
    ),
    UssdBanksModel(
        
        bankCode: "011",
        bankName: "FIRST BANK OF NIGERIA PLC",
        abb: "FIRST BANK's"
    ),
    UssdBanksModel(
        
        bankCode: "214",
        bankName: "FIRST CITY MONUMENT BANK PLC",
        abb: "FCMB"
    ),
    UssdBanksModel(
        
        bankCode: "058",
        bankName: "Guarantee Trust Bank PLC",
        abb: "GTBank's"
    ),
    UssdBanksModel(
        bankCode: "082",
        bankName: "KEYSTONE BANK",
        abb: "KEYSTONE BANK's"
    ),
    UssdBanksModel(
        
        bankCode: "090175",
        bankName: "HIGHSTREET MICROFINANCE BANK",
        abb: "HIGHSTREET's"
    ),
    
    UssdBanksModel(
        bankCode: "221",
        bankName: "STANBIC IBTC BANK PLC",
        abb: "STANBIC IBTC's"
    ),
    
    UssdBanksModel(
        bankCode: "032",
        bankName: "UNION BANK OF NIGERIA PLC",
        abb: "UNION BANK's"
    ),
    
    UssdBanksModel(
        bankCode: "215",
        bankName: "UNITY BANK PLC",
        abb: "UNITY BANK's"
    ),
    UssdBanksModel(
        bankCode: "090110",
        bankName: "VFD MICROFINANCE BANK",
        abb: "VFD's"
    ),
    
    UssdBanksModel(
        bankCode: "035",
        bankName: "WEMA BANK PLC",
        abb: "WEMA BANK's"
    ),
    
    UssdBanksModel(
        bankCode: "057",
        bankName: "ZENITH BANK PLC",
        abb: "ZENITH BANK's"
    ),
    
    UssdBanksModel(
        bankCode: "322",
        bankName: "Zenith Mobile",
        abb: "Zenith Mobile's"
    )
]
