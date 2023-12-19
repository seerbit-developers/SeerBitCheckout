//
//  MerchantDetailsDataModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 25/10/2023.
//

import Foundation

// MARK: - MerchantDetailsDataModel
struct MerchantDetailsDataModel: Codable {
    let payload: Payload?
    let message, status, responseCode: String?
}

// MARK: - Payload
struct Payload: Codable {
    let businessName, transLink, number, livePublicKey: String?
    let testPublicKey: String?
    let address: Address?
    let cardFee: CardFee?
    let transactionFee: TransactionFee?
    let defaultCurrency: String?
    let allowedCurrency: [String]?
    let logo: String?
    let supportEmail: String?
    let maxAmount, minAmount: Int?
    let setting: Setting?
    let status: String?
    let isWhiteLabelled: Bool?
    let country: Country?
    let paymentConfigs: [PaymentConfig]?
    let channelOptionStatus: [ChannelOptionStatus]?
    let checkoutPageConfig: CheckoutPageConfig?
    let activeForValidationService: Bool?
    let maxThreshold, minThreshold: String?
    let enableOvercharge, enableUnderCharge, enableCustomerForTransfer, enableForDiscount: Bool?
    let enableDescriptor: Bool?
    let partnerID: String?

    enum CodingKeys: String, CodingKey {
        case businessName = "business_name"
        case transLink, number
        case livePublicKey = "live_public_key"
        case testPublicKey = "test_public_key"
        case address, cardFee, transactionFee
        case defaultCurrency = "default_currency"
        case allowedCurrency, logo
        case supportEmail = "support_email"
        case maxAmount = "max_amount"
        case minAmount = "min_amount"
        case setting, status, isWhiteLabelled, country, paymentConfigs, channelOptionStatus, checkoutPageConfig, activeForValidationService
        case maxThreshold = "max_threshold"
        case minThreshold = "min_threshold"
        case enableOvercharge, enableUnderCharge, enableCustomerForTransfer, enableForDiscount
        case enableDescriptor = "enable_descriptor"
        case partnerID = "partnerId"
    }
}

// MARK: - PaymentConfig
struct PaymentConfig: Codable {
    let name, viewName, code, number: String?
    let type, description: String?
    let allowOption: Bool?
    let status, paymentOptionFeeMode: String?
    let applyFixCharge: Bool?
    let paymentOptionFee: String?
    let internationalPaymentOptionFee: Double?
    let internationalPaymentOptionMode: String?
    let paymentOptionCapStatus: PaymentOptionCapStatus?
    let internationalPaymentOptionCapStatus: InternationalPaymentOptionCapStatus?
    let fixCharge: String?

    enum CodingKeys: String, CodingKey {
        case name, viewName, code, number, type, description
        case allowOption = "allow_option"
        case status, paymentOptionFeeMode, applyFixCharge, paymentOptionFee, internationalPaymentOptionFee, internationalPaymentOptionMode, paymentOptionCapStatus, internationalPaymentOptionCapStatus, fixCharge
    }
}

// MARK: - Address
struct Address: Codable {
    let street, city, state: String?
}

// MARK: - CardFee
struct CardFee: Codable {
    let mc, verve, visa: String?
}

// MARK: - ChannelOptionStatus
struct ChannelOptionStatus: Codable {
    let name: String?
    let allowOption: Bool?

    enum CodingKeys: String, CodingKey {
        case name
        case allowOption = "allow_option"
    }
}

// MARK: - CheckoutPageConfig
struct CheckoutPageConfig: Codable {
    let backgroundColor, paybuttonColor, paychannelColor, checkAdvertStatus: String?
    let maxCheckAdvertCount: String?
//    let checkoutAdverts: [JSONAny]?
}

// MARK: - Country
struct Country: Codable {
    let name, nameCode, countryCode, countryCode2: String?
    let status: String?
    let websiteURL: String?
    let continent: String?
    let defaultCurrency: DefaultCurrency?
    let defaultPaymentOptions: [DefaultPaymentOption]?

    enum CodingKeys: String, CodingKey {
        case name, nameCode, countryCode, countryCode2, status
        case websiteURL = "websiteUrl"
        case continent, defaultCurrency, defaultPaymentOptions
    }
}

// MARK: - DefaultCurrency
struct DefaultCurrency: Codable {
    let country, currency, code, number: String?
}

// MARK: - DefaultPaymentOption
struct DefaultPaymentOption: Codable {
    let name, viewName, code, number: String?
    let type, description: String?
    let allowOption: Bool?
    let status, paymentOptionFeeMode: String?
    let applyFixCharge: Bool?
    let paymentOptionFee: String?
    let internationalPaymentOptionFee: Double?
    let internationalPaymentOptionMode: String?
    let paymentOptionCapStatus: PaymentOptionCapStatus?
    let internationalPaymentOptionCapStatus: InternationalPaymentOptionCapStatus?
    let fixCharge: String?

    enum CodingKeys: String, CodingKey {
        case name, viewName, code, number, type, description
        case allowOption = "allow_option"
        case status, paymentOptionFeeMode, applyFixCharge, paymentOptionFee, internationalPaymentOptionFee, internationalPaymentOptionMode, paymentOptionCapStatus, internationalPaymentOptionCapStatus, fixCharge
    }
}

// MARK: - InternationalPaymentOptionCapStatus
struct InternationalPaymentOptionCapStatus: Codable {
    let inCappedAmount: Int?
}

// MARK: - PaymentOptionCapStatus
struct PaymentOptionCapStatus: Codable {
    let cappedSettlement: String?
    let cappedAmount: Int?
}

// MARK: - Setting
struct Setting: Codable {
    let cardOption, bankOption, transferOption, displayFee: Bool?
    let emailReceiptCustomer, emailReceiptMerchant: Bool?
    let payday, mode, chargeOption: String?
    let applySettlementPattern: Bool?

    enum CodingKeys: String, CodingKey {
        case cardOption = "card_option"
        case bankOption = "bank_option"
        case transferOption = "transfer_option"
        case displayFee = "display_fee"
        case emailReceiptCustomer = "email_receipt_customer"
        case emailReceiptMerchant = "email_receipt_merchant"
        case payday, mode
        case chargeOption = "charge_option"
        case applySettlementPattern
    }
}

// MARK: - TransactionFee
struct TransactionFee: Codable {
    let cardTransactionFee, accountTransactionFee: AccountTransactionFeeClass?
    let defaultFee: DefaultFee?
    let transactionCapStatus: TransactionCapStatus?
}

// MARK: - AccountTransactionFeeClass
struct AccountTransactionFeeClass: Codable {
}

// MARK: - DefaultFee
struct DefaultFee: Codable {
    let mccCategory, mccPercentage: String?
}

// MARK: - TransactionCapStatus
struct TransactionCapStatus: Codable {
    let cappedSettlement, cappedAmount: String?
}

