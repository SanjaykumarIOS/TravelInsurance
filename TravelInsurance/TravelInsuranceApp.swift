//
//  TravelInsuranceApp.swift
//  TravelInsurance
//
//  Created by SANJAY  on 16/05/24.
//

import SwiftUI

var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
}

@main
struct TravelInsuranceApp: App {
    @StateObject var networkMonitor = NetworkMonitor()
    @StateObject private var locationManagerDelegate = LocationManagerDelegate()
    
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .overlay {
                    !networkMonitor.isConnected ? NetworkConnection() : nil
                }
                .onAppear {
                    deviceLatitude = String(format: "%.6f", locationManagerDelegate.latitude)
                    devicelongitude = String(format: "%.6f", locationManagerDelegate.longitude)
                }
        }
    }
}




