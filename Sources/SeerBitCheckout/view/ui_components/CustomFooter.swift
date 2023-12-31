//
//  CustomFooter.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 24/10/2023.
//

import SwiftUI

struct CustomFooter: View {
    var body: some View {
        HStack{
            Image(uiImage: UIImage(named: "footer_lock", in: .module, with: nil)!)
            Text("Secured by")
                .foregroundColor(Color(uiColor: UIColor(named: "dark", in: .module, compatibleWith: nil)!))
                .fontWeight(.regular)
                .font(.system(size: 15))
//            Text("SeerBit").font(.custom("Android 101", size: 15)).bold()
            Text("SeerBit").font(.custom("Android 101", size: 20)).bold()
        }
    }
}
