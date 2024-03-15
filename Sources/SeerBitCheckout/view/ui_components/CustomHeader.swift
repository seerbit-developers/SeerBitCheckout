//
//  CustomHeader.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 20/10/2023.
//

import SwiftUI
import SDWebImageSwiftUI

@available(iOS 16.0, *)
struct CustomHeader: View {
    var merchantDetails : MerchantDetailsDataModel?  = nil
    @EnvironmentObject var merchantDetailsViewModel: MerchantDetailsViewModel
    @EnvironmentObject var   clientDetailsViewModel: ClientDetailsViewModel
    @StateObject  var cardViewModel: CardViewModel = CardViewModel()
    
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading ){
            Spacer().frame(height: 20)
            HStack(alignment: VerticalAlignment.center){
                if merchantDetails?.payload?.logo  == nil {
                    Image(uiImage: UIImage(named: "checkout_logo", in: HelperBundle.resolvedBundle, with: nil)!)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                }else{
                    if #available(iOS 15.0, *){
                        AsyncImage(url: URL(string: merchantDetails?.payload?.logo  ?? ""))
                        { image in image.resizable() } placeholder: { Color(uiColor: UIColor(named: "porcelain", in: HelperBundle.resolvedBundle, compatibleWith: nil)!) }
                            .clipShape(RoundedRectangle(cornerRadius: 2))
                            .frame(width: 50, height: 50)
                            .aspectRatio(contentMode: .fit)
                    }else{
                        WebImage(url: URL(string:merchantDetails?.payload?.logo ?? ""))
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 2))
                    }
                }
                Spacer()
                VStack(alignment: HorizontalAlignment.trailing){
                    Text(clientDetailsViewModel.fullName)
                        .fontWeight(.bold)
                        .foregroundColor(Color(uiColor: UIColor(named: "dark", in: HelperBundle.resolvedBundle, compatibleWith: nil)!))
                        .font(.system(size: 14))
                    
                    Text(clientDetailsViewModel.email)
                        .fontWeight(.regular)
                        .foregroundColor(Color(uiColor: UIColor(named: "dark", in: HelperBundle.resolvedBundle, compatibleWith: nil)!))
                        .font(.system(size: 14))
                }
            }.frame(maxWidth: getDeviceWidth())
            Spacer().frame(height: 30)
            VStack(alignment: HorizontalAlignment.leading){
                Text((clientDetailsViewModel.currency) + (formatInputDouble(input: clientDetailsViewModel.amount)))
                    .fontWeight(.bold)
                    .foregroundColor(Color(uiColor: UIColor(named: "dark", in: HelperBundle.resolvedBundle, compatibleWith: nil)!))
                    .font(.system(size: 14))
                Spacer().frame(height: 3)
                Text("Fee \(clientDetailsViewModel.fee)")
                    .foregroundColor(Color(uiColor: UIColor(named: "dark", in: HelperBundle.resolvedBundle, compatibleWith: nil)!))
                    .fontWeight(.light)
                    .font(.system(size: 12))
            }
        }
        .frame(maxWidth: getDeviceWidth())
    }
}
