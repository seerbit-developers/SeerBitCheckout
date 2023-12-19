//
//  LoadingIndicator.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 20/10/2023.
//

import SwiftUI

struct LoadingIndicator: View {
    var body: some View {
        VStack{
            Spacer().frame(height: 20)
            ProgressView()
              .progressViewStyle(.circular)
              .scaleEffect(2.0)
        }
    }
}
