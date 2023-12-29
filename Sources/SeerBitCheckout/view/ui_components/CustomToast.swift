//
//  CustomToast.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 31/10/2023.
//

import SwiftUI

struct ToastDetails {
  var title: String
  var image: String = "checkmark.circle.fill"
}


struct CustomToast: View {
    
    let toastDetails: ToastDetails
    @Binding var showToast: Bool
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Image(systemName: toastDetails.image)
                    .foregroundColor(.green)
                Text(toastDetails.title)
                    .foregroundColor(.green)
                    .fontWeight(.regular)
                    .font(.system(size: 14))
            }
            .font(.headline)
            .foregroundColor(.green)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(.green.opacity(0.2), in: Rectangle())
        }
        .frame(width: UIScreen.main.bounds.width / 1.25)
        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
        .onTapGesture {
            withAnimation {
                self.showToast = false
            }
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now()+3){
                withAnimation{
                    self.showToast = false
                }
            }
        })
        Spacer().frame(height: 30)
    }
}

struct Overlay<T:View>:ViewModifier {
    @Binding var show: Bool
    let overlayView: T
    
    func body(content: Content) -> some View {
        ZStack{
            content
            if(show){
                overlayView
            }
        }
    }
}

extension View {
    func overlay<T: View>(overlayView: T, show: Binding<Bool>) -> some View {
        self.modifier(Overlay(show: show, overlayView: overlayView))
    }
}
