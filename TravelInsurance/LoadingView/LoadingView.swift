//
//  LoadingView.swift
//  DynamicFileUpload
//
//  Created by SANJAY  on 28/12/23.
//

import SwiftUI

struct LoadingView<Content>: View where Content: View {
    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        ZStack {
            content()
                .disabled(isShowing)
            
            if isShowing {
                
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .primary)) // Apply a tint color to the progress view

                    Text("Loading...")
                        .bold()
                        .padding(.top)
                        .foregroundColor(.primary)
                }
                .frame(width: 110, height: 110) // Adjust the size of the loading view
                .background(Color.secondary.colorInvert())
                .cornerRadius(20)
                .opacity(isShowing ? 1 : 0)
            }
        }
    }
}
