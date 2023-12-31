//
//  TransactionStatusDataViewModel.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 27/12/2023.
//

import Foundation


public class TransactionStatusDataViewModel: ObservableObject {

    public init(){}
    
    @Published public var transactionStatusData : QueryTransactionDataModel? = nil
    
}
