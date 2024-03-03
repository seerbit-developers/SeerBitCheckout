//
//  AccountDetailsItem.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 01/11/2023.
//

import SwiftUI

struct AccountDetailsItem: View {
   let key: String
   let value: String
   let canCopy: Bool?
   let toCopy: ()-> Void
   
   var body: some View {
       HStack{
           Text(key)
               .font(.system(size: 13)).fontWeight(.light)
               .foregroundColor(Color(uiColor: UIColor(named: "dark", in: .module, compatibleWith: nil)!))
           Spacer()
           if canCopy ?? false {
               HStack{
                   Text(value)
                       .font(.system(size: 12)).fontWeight(.medium)
                       .foregroundColor(Color(uiColor: UIColor(named: "dark", in: .module, compatibleWith: nil)!))
                   Image(systemName: "doc.on.doc")
                       .resizable()
                       .onTapGesture {toCopy()}
                       .frame(width: 15, height: 15)
                       .aspectRatio(contentMode: .fit)
               }
           }else {
               Text(value)
                   .font(.system(size: 12)).fontWeight(.medium)
                   .foregroundColor(Color(uiColor: UIColor(named: "dark", in: .module, compatibleWith: nil)!))
           }
       }
   }
}
