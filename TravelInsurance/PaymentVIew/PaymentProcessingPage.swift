//
//  PaymentProcessingPage.swift
//  TravelInsurance
//
//  Created by SANJAY  on 11/06/24.
//

import SwiftUI

struct PaymentProcessingPage: View {
    
    @StateObject private var timerManager = TimerManager()
    
    @State private var timer = Timer.publish(every: 5.0, on: .main, in: .common).autoconnect()
    
    @State private var isFailedPayment = false
    @State private var isSuccessPayment = false
    
    @State var showingBackAlert = false
    @State var navigateDashboardPage = false
    
    @State var navigatePaymentConfimationPage = false
    
    @State var showingUnAuthorizedAlert = false
        
    @State private var isLoading = false
    @State private var alertItem: AlertItem?
        
    var body: some View {
        NavigationStack {
            LoadingView(isShowing: $isLoading) {
                VStack {
                    
                    if timerManager.secondsRemaining <= 0 || isFailedPayment == true {
                        
                        LottieView(animationFileName: "unsuccessful_payment", loopMode: .loop)
                            .aspectRatio(contentMode: .fit)
                        
                        Text("We're sorry, but your payment was unsuccessful. Please check your payment details and try again. If you need assistance, our support team is here to help. Take a deep breath, and give it another go!")
                            .font(isFontBlack(size: 20))
                            .foregroundColor(.black.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding()
                        
                    } else {
                        
                        LottieView(animationFileName: "payment_animation", loopMode: .loop)
                            .aspectRatio(contentMode: .fit)
                        
                        Text("PROCESSING PAYMENT...")
                            .bold()
                            .font(isFontBold(size: 22))
                            .foregroundColor(appTheme)
                        
                        Text("We are redirecting you to the payment gateway. Please wait a few moments, have a cup of coffee, and complete the payment. We'll be here waiting for you to finish!")
                            .font(isFontBlack(size: 20))
                            .foregroundColor(.black.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        
                        Text(timeString(time: timerManager.secondsRemaining))
                            .font(isFontBlack(size: 25))
                            .foregroundColor(.cyan)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button(action: {
                        showingBackAlert = true
                    })
                    {
                        Text("Cancel Payment")
                            .font(isFontBlack(size: 20))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(appTheme)
                            .cornerRadius(10)
                            .padding()
                            .padding(.horizontal,30)
                    }
                    
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity, alignment:.top)
                .onAppear {
                    timerManager.start()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        openFile(fileURLString: "https://kenindiab2c-travel.insure.digital/policy/payment-external/\(getPremiumQuotationIDValue)/\(quotesIDValue)#token=\(Extensions.token)&sourceType=android")
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        fetchPaymentResponse()
                    }
                }
                .onDisappear {
                    self.timer.upstream.connect().cancel()
                }
                .onReceive(timer) { _ in
                    if timerManager.secondsRemaining <= 0 {
                        self.timer.upstream.connect().cancel()
                    } else {
                        fetchPaymentResponse()
                    }
                }
                
                // ALERT VIEW
                .alert(item: $alertItem) { alertItem in
                    Alert(title: alertItem.title)
                }
                
                //  TOOL BAR
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        
                        HStack {
                          
                            Text("Payment Processing")
                                .bold()
                                .font(isFontBlack(size: 22))
                                .foregroundColor(.white)
                                .padding(.bottom,8)
                           
                        }
                        .alert(isPresented: $showingBackAlert) {
                            Alert(
                                title: Text("Alert"),
                                message: Text("Are you sure you want to cancel the payment?"),
                                primaryButton: .default(Text("Yes")) {
                                    
                                    withAnimation {
                                        navigateDashboardPage = true
                                    }
                                    showingBackAlert = false
                                    
                                    self.timer.upstream.connect().cancel()
                                    
                                },
                                secondaryButton: .cancel(Text("No")) {
                                    showingBackAlert = false
                                }
                                
                            )
                        }
                    }

                }
                .toolbarBackground(appTheme,for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
            }
        }.navigationBarBackButtonHidden()
            .overlay {
                navigateDashboardPage ? DashboardPage() : nil
                
                navigatePaymentConfimationPage ? PaymentConfirmationPage() : nil
            }
        
            .overlay {
                                
                if showingUnAuthorizedAlert {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea(.all)
                       
                    VStack {
                        Text("Your session has been expired. Please login again to continue")
                            .font(isFontMedium(size: 18))
                        
                        Text("OK")
                            .font(isFontMedium(size: 18))
                            .foregroundColor(appTheme)
                            .padding(10)
                            .frame(maxWidth:.infinity, alignment:.trailing)
                            .onTapGesture {
                                withAnimation {
                                    navigateDashboardPage = true
                                }
                                showingUnAuthorizedAlert = false
                                
                                Extensions.token = ""
                                
                            }
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .padding(.horizontal)
                }
            }
    }
    
    func timeString(time: Int) -> String {
           let minutes = time / 60
           let seconds = time % 60
           return String(format: "%02d:%02d", minutes, seconds)
       }
    
    func openFile(fileURLString: String) {
        if let url = URL(string: fileURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    
    func fetchPaymentResponse() {
//        isLoading = true
        
        let mobileParameters: [String: Any] = [
            "deviceID": deviceUDID,
            "deviceID2": "",
            "deviceTimeZone": currentTimeZone,
            "deviceDateTime": currentDateTime,
            "deviceIpAddress": strIPAddress,
            "deviceUserID": deviceUDID,
            "deviceLatitude": deviceLatitude,
            "deviceLongitude": devicelongitude,
            "deviceType": "iOS",
            "deviceVersion": systemOsVersion,
            "deviceAppVersion": "1.0.0",
            "deviceModel": devicemodel,
            "deviceIsJailBroken": deviceJailbroken
        ]
        
            print("mobileParameters = \(mobileParameters)")

        
        var postData : Data
     
        postData = try! JSONSerialization.data(withJSONObject: mobileParameters, options: JSONSerialization.WritingOptions(rawValue: 0))
     
        let theJSONData = (NSString(data: postData, encoding: String.Encoding.utf8.rawValue)! as String).replacingOccurrences(of: "%20", with: " ")
                
        let url = URL(string: "\(baseURL)api/Response/WaitingPaymentResponse")!
        print(url)
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        let authToken:String! = "Bearer " + Extensions.token
        
        request.addValue("\(theJSONData)", forHTTPHeaderField: "clientInfo")
        request.addValue(authToken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("{\"orgAppID\":\"6120\",\"orgGroupID\":\"e6177150-0a4b-46f1-9c27-b55e848a69eb\"}", forHTTPHeaderField: "Webapirequest")
        request.addValue("mobile", forHTTPHeaderField: "source")

        let parameters: [String: Any] = [
            "QuotationID": getPremiumQuotationIDValue
        ]
        
        print(parameters)
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let data = data else {
                print("\("Error No data returned from server") \(error?.localizedDescription ?? "")")
                if let errorDict = Extensions.getValidationDict() as? [String: String] {
                    if let errorMessage = errorDict["API001"] {
                        self.alertItem = AlertItem(title: Text("API001" + "\n" + errorMessage))
                    }
                }
                isLoading = false
                return
            }
            
            do {
                
                var resultDictionary:NSDictionary! = NSDictionary()
                resultDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                print("Response = \(String(describing: resultDictionary))")
                
//                let decoder = JSONDecoder()
//                let getResponse = try decoder.decode(QuotationInfoResponseModel.self, from: data)
                
                DispatchQueue.main.async {
                    isLoading = false
                    
                    let rcode = resultDictionary["rcode"] as? Int
                    
                    if rcode == 200 {
                                                
                        if let rObj = resultDictionary["rObj"] as? NSDictionary {
                            if let isFailedPayment = rObj["isFailedPayment"] as? Bool,
                               let isSuccessPayment = rObj["isSuccessPayment"] as? Bool,
                               let isWaitingPayment = rObj["isWaitingPayment"] as? Bool {
                                
                                print("isFailedPayment = \(isFailedPayment)")
                                print("isSuccessPayment = \(isSuccessPayment)")
                                print("isWaitingPayment = \(isWaitingPayment)")
                                
                                self.isFailedPayment = isFailedPayment
                                self.isSuccessPayment = isSuccessPayment
                               
                                if isWaitingPayment == true {
                                    self.timer = Timer.publish(every: 5.0, on: .main, in: .common).autoconnect()
                                }
                                
                                if isFailedPayment == true {
                                    self.timer.upstream.connect().cancel()
                                } else if isSuccessPayment == true {
                                    self.timer.upstream.connect().cancel()
                                    
                                    withAnimation {
                                        navigatePaymentConfimationPage = true
                                    }
                                }
                                
                            }
                        }
                        
                        isLoading = false
                        
                    } else if rcode == 401 {
                        showingUnAuthorizedAlert = true
                        
                        isLoading = false
                    } else {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["API001"] {
                                self.alertItem = AlertItem(title: Text("API001" + "\n" + errorMessage))
                            }
                        }
                        isLoading = false
                    }
                    
                }
            } catch {
                print("\("Error decoding response") \(error.localizedDescription)")
                if let errorDict = Extensions.getValidationDict() as? [String: String] {
                    if let errorMessage = errorDict["API001"] {
                        self.alertItem = AlertItem(title: Text("API001" + "\n" + errorMessage))
                    }
                }
                isLoading = false
            }
        }
        task.resume()
    }
    
   
}

#Preview {
    PaymentProcessingPage()
}



import SwiftUI
import Combine

class TimerManager: ObservableObject {
    @Published var secondsRemaining: Int
    var timer: AnyCancellable?
    let totalTime: Int
    
    init(totalTime: Int = 899) { // Default to 900 seconds (15 minutes)
        self.totalTime = totalTime
        self.secondsRemaining = totalTime
    }
    
    func start() {
        timer?.cancel()
        secondsRemaining = totalTime
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if self.secondsRemaining > 0 {
                    self.secondsRemaining -= 1
                } else {
                    self.timer?.cancel()
                }
            }
    }
    
    func stop() {
        timer?.cancel()
    }
}
