//
//  PermissionPage.swift
//  TravelInsurance
//
//  Created by SANJAY  on 27/05/24.
//

import SwiftUI

struct PermissionPage: View {
    var body: some View {
        NavigationStack {
            
            VStack {
                
                Image("kenindia-logo")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180,height: 180)
                    .foregroundColor(appTheme)
                    .frame(width: 220,height: 220)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 3)
                
                Text("Permissions needed")
                    .font(isFontMedium(size: 26))
                    .padding()
                
                Text("To serve you best user experience we need permissions from location services and notifications.")
                    .font(isFontMedium(size: 20))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black.opacity(0.5))
                    .padding(.horizontal,10)
                
                Button(action: {
                    
                })
                {
                    Text("Allow")
                        .padding()
                        .font(isFontMedium(size: 20))
                        .foregroundColor(.white)
                        .frame(width:200, height: 60)
                        .background(appTheme)
                        .cornerRadius(8)
                        .padding(.top,40)
                }
            }
            
        }.navigationBarBackButtonHidden()
    }
}

#Preview {
    PermissionPage()
}
