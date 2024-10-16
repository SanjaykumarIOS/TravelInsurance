//
//  AlertModel.swift
//  TravelInsurance
//
//  Created by SANJAY  on 16/05/24.
//

import SwiftUI

struct AlertItem: Identifiable {
    var id = UUID()
    var title: Text
}




extension View {
    func customAlert(isPresented: Binding<Bool>, title: String, message: String, primaryButtonAction: @escaping () -> Void) -> some View {
        self.alert(isPresented: isPresented) {
            Alert(
                title: Text(title),
                message: Text(message),
                primaryButton: .default(Text("Yes"), action: primaryButtonAction),
                secondaryButton: .cancel(Text("No")) {
                    isPresented.wrappedValue = false
                }
            )
        }
    }
}

//            .customAlert(
//                isPresented: $showingBackAlert2,
//                title: "Alert 2",
//                message: "This is a different alert message. Are you sure?",
//                primaryButtonAction: {
//                    withAnimation {
//                        navigateDashboardPage = true
//                    }
//                    selectedDestinationListValue = []
//                    showingBackAlert2 = false
//                }
//            )
