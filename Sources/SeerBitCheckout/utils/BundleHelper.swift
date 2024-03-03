//
//  BundleHelper.swift
//  
//
//  Created by Miracle Eugene on 03/03/2024.
//

import Foundation

 class HelperBundle {
    static var resolvedBundle: Bundle {
        #if SWIFT_PACKAGE
            return Bundle.module
        #else
        return Bundle(for: HelperBundle.self)
        #endif
    }
}
