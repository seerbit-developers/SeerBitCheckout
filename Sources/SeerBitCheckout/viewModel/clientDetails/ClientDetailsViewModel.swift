//
//  ClientDetailsViewModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 27/10/2023.
//

import Foundation
class ClientDetailsViewModel: ObservableObject {
    
    @Published var fullName: String = ""
    @Published var amount = ""
    @Published var totalAmount = ""
    @Published var publicKey = ""
    @Published var mobileNumber = ""
    @Published var email = ""
    @Published var currency = ""
    @Published var country = ""
    @Published var paymentReference = ""
    @Published var fee = ""
    @Published var paymentType = ""
    @Published var cardNumber = ""
    @Published var cvv = ""
    @Published var linkingreference = ""
    @Published var expiryMonth = ""
    @Published var expiryYear = ""
    @Published var cardType = ""
    @Published var pin = ""
    @Published var retry = false
    @Published var rememberMe = false
    @Published var productId = ""
    @Published var source = "seerbit_checkout"
    @Published var redirectURL = "http://tinyurl.com/vbezu3tk" // seerbitioscheckout://app
    @Published var productDescription = "seerbit payment"
    @Published var deviceType = "iPhone"
    @Published var sourceIP = "102.88.63.64"
    @Published var isCardInternational = "LOCAL"
    @Published var amountControl = "FIXEDAMOUNT"
    @Published var walletDaysActive = "1"
    @Published var network = ""
    @Published var voucherCode = ""
    @Published var momoMobileNumber = ""
    @Published var accountNumber = ""
    @Published var bvn = ""
    @Published var dateOfBirth = ""
    @Published var scheduleId = ""
    @Published var accountName = ""
    @Published var bankCode = ""
}
