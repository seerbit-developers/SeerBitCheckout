//
//  utilityFunctions.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 27/10/2023.
//

import Foundation

public enum paymentMethods: String {
    case ussd = "USSD"
    case transfer = "TRANSFER"
    case card = "CARD"
    case account = "ACCOUNT"
    case momo = "MOMO"
}

internal func isMerchantTheFeeBearer(merchantDetails: MerchantDetailsDataModel) ->Bool{
    return merchantDetails.payload?.setting?.chargeOption == "MERCHANT"
}

internal func displayPaymentMethod (paymentMethod: String, merchantDetails: MerchantDetailsDataModel) -> Bool{
    var toDisplayMethod: Bool = false
    if((merchantDetails.payload?.paymentConfigs) != nil && ((merchantDetails.payload?.paymentConfigs?.isEmpty) == false)){
        
        //merchant has payment configuration
        merchantDetails.payload?.paymentConfigs?.forEach{paymentConfig in
            if(paymentConfig.code == paymentMethod){
                if( (merchantDetails.payload?.channelOptionStatus?.isEmpty) == false){
                    
                    merchantDetails.payload?.channelOptionStatus?.forEach { channelOptionStatus in
                        
                        if(paymentConfig.code == channelOptionStatus.name  && channelOptionStatus.allowOption == true && paymentConfig.status == "ACTIVE"){ toDisplayMethod = true}
                    }
                }else{
                    //channel option status is empty
                    merchantDetails.payload?.paymentConfigs?.forEach{paymentConfigs in
                        
                        if (paymentConfigs.code == paymentMethod && paymentConfigs.allowOption == true && paymentConfigs.status == "ACTIVE"){toDisplayMethod = true}
                    }
                }
            }
        }
    }else{
        //use default settings
        if((merchantDetails.payload?.paymentConfigs) != nil){
            merchantDetails.payload?.country?.defaultPaymentOptions?.forEach{defaultPaymentOption in
                if(defaultPaymentOption.code == paymentMethod){
                    if(merchantDetails.payload?.channelOptionStatus?.isEmpty == false){
                        merchantDetails.payload?.channelOptionStatus?.forEach{channelOptionStatus in
                            
                            if (defaultPaymentOption.code == channelOptionStatus.name && channelOptionStatus.allowOption == true && defaultPaymentOption.status == "ACTIVE"){toDisplayMethod = true}
                        }
                    }else{
                        
                        merchantDetails.payload?.country?.defaultPaymentOptions?.forEach { defaultPaymentOption in
                            if (defaultPaymentOption.code == paymentMethod && defaultPaymentOption.allowOption == true && defaultPaymentOption.status == "ACTIVE") {toDisplayMethod = true}
                        }
                    }
                }
            }
        }
    }
    
    return toDisplayMethod
}

internal func calculateFee(amount: String, paymentMethod: String, merchantDetails: MerchantDetailsDataModel, cardCountry: String = "")->String{
    
    var paymentFee = ""
    let  isCardInternational =  cardCountry.count == 0 ? false :   cardCountry.count > 0 && cardCountry.uppercased().contains(merchantDetails.payload?.country?.nameCode ?? "NIGERIA")
    
    if((merchantDetails.payload?.paymentConfigs) != nil && ((merchantDetails.payload?.paymentConfigs?.isEmpty) == false)){
        
        merchantDetails.payload?.paymentConfigs?.forEach{paymentConfig in
            
            if(paymentConfig.code == paymentMethod){
                
                var feeModeIsPercentage: Bool = isCardInternational ?
                paymentConfig.internationalPaymentOptionMode == "PERCENTAGE"
                : paymentConfig.paymentOptionFeeMode == "PERCENTAGE"
                
                var isCappedSettlement: Bool = paymentConfig.paymentOptionCapStatus?.cappedSettlement == "CAPPED"
                
                var cappedFee: Double = isCardInternational ?
                Double(paymentConfig.internationalPaymentOptionCapStatus?.inCappedAmount ?? 100)
                : Double(paymentConfig.paymentOptionCapStatus?.cappedAmount ?? 100)
                
                var feePercentage: Double = isCardInternational ?
                Double(paymentConfig.internationalPaymentOptionFee ?? 100.0)
                : Double(paymentConfig.paymentOptionFee ?? "100.0") ?? 100.0
                
                if(feeModeIsPercentage){
                    var fee = (feePercentage / 100) * (Double(amount) ?? 100.0)
                    
                    if(isCappedSettlement){
                        if(fee > cappedFee){paymentFee = String(cappedFee)}else{paymentFee = String(fee)}
                    }else{paymentFee = String(fee)}
                }else{
                    var fee = String(paymentConfig.paymentOptionFee ?? "100.0")
                    paymentFee = fee
                }
            }
        }
    }else{
        if((merchantDetails.payload?.country?.defaultPaymentOptions) != nil && (merchantDetails.payload?.country?.defaultPaymentOptions?.isEmpty) == false){
            
            merchantDetails.payload?.country?.defaultPaymentOptions?.forEach{paymentConfig in
                
                if(paymentConfig.code == paymentMethod){
                    
                    var feeModeIsPercentage: Bool = isCardInternational ?
                    paymentConfig.internationalPaymentOptionMode == "PERCENTAGE"
                    : paymentConfig.paymentOptionFeeMode == "PERCENTAGE"
                    
                    var isCappedSettlement: Bool = paymentConfig.paymentOptionCapStatus?.cappedSettlement == "CAPPED"
                    
                    var cappedFee: Double = isCardInternational ?
                    Double(paymentConfig.internationalPaymentOptionCapStatus?.inCappedAmount ?? 100)
                    : Double(paymentConfig.paymentOptionCapStatus?.cappedAmount ?? 100)
                    
                    var feePercentage: Double = isCardInternational ?
                    Double(paymentConfig.internationalPaymentOptionFee ?? 100.0)
                    : Double(paymentConfig.paymentOptionFee ?? "100.0") ?? 100.0
                    
                    if(feeModeIsPercentage){
                        var fee = (feePercentage / 100) * (Double(amount) ?? 100.0)
                        
                        if(isCappedSettlement){
                            if(fee > cappedFee){paymentFee = String(cappedFee)}else{paymentFee = String(fee)}
                        }else{paymentFee = String(fee)}
                    }else{
                        var fee = String(paymentConfig.paymentOptionFee ?? "100.0")
                        paymentFee = fee
                    }
                }
            }
        }
    }
    
    return formatInputDouble(input: paymentFee)
}

internal func formatInputDouble(input: String?) -> String {
    guard let input = input, !input.isEmpty, let value = Double(input) else {
        return ""
    }
    
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    formatter.roundingMode = .ceiling
    
    return formatter.string(from: NSNumber(value: value)) ?? String(value)
}


public func generateRandomReference() -> String {
    let characters = "ABCDEFGHIJKLMNOPQRSTNVabcdef6ghijklmnopqrstuvwxyzABCD123456789"
    var password = ""
    
    for _ in 1...8 {
        let randomIndex = Int.random(in: 0..<characters.count)
        let character = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
        password.append(character)
    }
    
    let uuid = UUID().uuidString
    let truncatedUuid = String(uuid.prefix(15))
    
    return "SBT-T" + truncatedUuid
}

