//
//  CustomPinComponent.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 27/11/2023.
//

import SwiftUI

@available(iOS 16.0, *)
struct CustomPinComponent: View {
    @State var firstPin: String = ""
    @State var secondPin: String = ""
    @State var thirdPin: String = ""
    @State var fourthPin: String = ""
    @State var width: CGFloat = 23
    @State var height: CGFloat = 23
    
    @FocusState private var isFirstPinFocused: Bool
    @FocusState private var isSecondPinFocused: Bool
    @FocusState private var isThirdPinFocused: Bool
    @FocusState private var isFourthPinFocused: Bool
    
    @Binding var pin: String
    
    @State var keyboardType: UIKeyboardType = .numberPad
    
    
    var body: some View {
        
        HStack{
            Spacer()
            HStack{
                Spacer()
                TextField("", text: $firstPin)
                    .foregroundColor(Color.black)
                    .fontWeight(.regular)
                    .font(.system(size: 12))
                    .focused($isFirstPinFocused)
                    .onAppear {isFirstPinFocused = true}
                    .onChange(of: firstPin){firstPin in
                        pin = self.firstPin + secondPin + thirdPin + fourthPin
                        if(!firstPin.isEmpty){isSecondPinFocused = true}
                    }
                    .keyboardType(keyboardType)
                Spacer()
            }
            .frame(width: width, height: height)
            .padding(.horizontal, 11)
            .padding(.vertical, 12)
            .border(Color(uiColor: UIColor(named: "seaShell", in: HelperBundle.resolvedBundle, compatibleWith: nil)!), width: CGFloat(2))
            .clipShape(RoundedRectangle(cornerRadius: 4))
            Spacer().frame(width: 40)
            
            HStack{
                Spacer()
                TextField("", text: $secondPin)
                    .foregroundColor(Color.black)
                    .fontWeight(.regular)
                    .font(.system(size: 12))
                    .focused($isSecondPinFocused)
                    .onChange(of: secondPin){secondPin in
                        pin = firstPin + self.secondPin + thirdPin + fourthPin
                        if(!secondPin.isEmpty){isThirdPinFocused = true}
                    }
                    .keyboardType(keyboardType)
                Spacer()
            }
            .frame(width: width, height: height)
            .padding(.horizontal, 11)
            .padding(.vertical, 12)
            .border(Color(uiColor: UIColor(named: "seaShell", in: HelperBundle.resolvedBundle, compatibleWith: nil)!), width: CGFloat(2))
            .clipShape(RoundedRectangle(cornerRadius: 4))
            Spacer().frame(width: 40)
            
            HStack{
                Spacer()
                TextField("", text: $thirdPin)
                    .foregroundColor(Color.black)
                    .fontWeight(.regular)
                    .font(.system(size: 12))
                    .focused($isThirdPinFocused)
                    .onChange(of: thirdPin){thirdPin in
                        pin = firstPin + secondPin + self.thirdPin + fourthPin
                        if(!thirdPin.isEmpty){isFourthPinFocused = true}
                    }
                    .keyboardType(keyboardType)
                Spacer()
            }
            .frame(width: width, height: height)
            .padding(.horizontal, 11)
            .padding(.vertical, 12)
            .border(Color(uiColor: UIColor(named: "seaShell", in: HelperBundle.resolvedBundle, compatibleWith: nil)!), width: CGFloat(2))
            .clipShape(RoundedRectangle(cornerRadius: 4))
            Spacer().frame(width: 40)
            
            HStack{
                Spacer()
                TextField("", text: $fourthPin)
                    .foregroundColor(Color.black)
                    .fontWeight(.regular)
                    .font(.system(size: 12))
                    .focused($isFourthPinFocused)
                    .onChange(of: fourthPin){fourthPin in
                        pin = firstPin + secondPin + thirdPin + self.fourthPin
                        if(!fourthPin.isEmpty){isFourthPinFocused = false}
                    }
                    .keyboardType(keyboardType)
                Spacer()
            }
            .frame(width: width, height: height)
            .padding(.horizontal, 11)
            .padding(.vertical, 12)
            .border(Color(uiColor: UIColor(named: "seaShell", in: HelperBundle.resolvedBundle, compatibleWith: nil)!), width: CGFloat(2))
            .clipShape(RoundedRectangle(cornerRadius: 4))
            Spacer()
        }
    }
}
