//
//  ContentView.swift
//  TravelInsurance
//
//  Created by SANJAY  on 16/05/24.
//

import SwiftUI
import Combine


struct ContentView: View {
    var body: some View {
        NavigationView {
            
          
            if Extensions.showLandingPage {
                LandingPage()
                    
            } else {
                DashboardPage()
//                GetPremiumPage(navigateGetQuotePage: .constant(false))
//                ProposalForm(navigateGetPremiumPage: .constant(false))
                                
            }
            
        }
    }
}




#Preview {
    ContentView()
}


