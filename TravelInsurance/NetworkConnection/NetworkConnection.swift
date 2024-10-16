//
//  NetworkConnection.swift
//  TravelInsurance
//
//  Created by SANJAY  on 16/05/24.
//

import SwiftUI

import SwiftUI
import Network
import Foundation

class NetworkMonitor: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkMonitor")
    @Published var isConnected = true
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self?.isConnected = true
                    print("Internet is connected")

                }
            } else {
                DispatchQueue.main.async {
                    self?.isConnected = false
                    print("Internet is not connected")

                }
            }
        }
        monitor.start(queue: queue)
    }
}
 
struct NetworkConnection: View {
    @StateObject var networkMonitor = NetworkMonitor()
        
    @State private var alertItem: AlertItem?
    
    var body: some View {
        VStack {
            if networkMonitor.isConnected {
            
            } else {
                
                Text("")
                    .onAppear {
                        NetworkValidation()
                    }
            }
        }
        
        // ALERT VIEW
        .alert(item: $alertItem) { alertItem in
            Alert(title: alertItem.title)
        }
    }
    
    func NetworkValidation() {
        if !networkMonitor.isConnected {
            if let errorDict = Extensions.getValidationDict() as? [String: String] {
                if let errorMessage = errorDict["ERR001"] {
                    self.alertItem = AlertItem(title: Text("ERR0001" + "\n" + errorMessage))
                }
            }
            return
        }
    }
}

#Preview {
    NetworkConnection()
}
