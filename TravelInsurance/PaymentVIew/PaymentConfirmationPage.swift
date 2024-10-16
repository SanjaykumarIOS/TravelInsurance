//
//  PaymentConfirmationPage.swift
//  TravelInsurance
//
//  Created by SANJAY  on 13/06/24.
//

import SwiftUI

struct PaymentConfirmationPage: View {
    
    @State var policyNumber = ""
    @State var referenceNumber = ""
    @State var attachmentId = ""
    
    @State private var showTravelLoadingView = false
    @State private var currentIndex: Int = 0
    @State private var timer: Timer?

    private let texts = ["We're crafting your policy. Thanks for waiting!","Your policy is on its way. Hang in there!","Just a moment longer for your custom policy.","We're working on your policy. Almost done!", "Thanks for your patience while we generate your policy.", "Sit tight! Your policy is being tailored.", "Your policy is in progress. Appreciate your patience!", "Just a few more seconds for your personalized policy.", "Your policy is getting ready. Thanks for waiting!", "We're on it! Your policy will be ready soon."]
    
    @State var navigateDashboardPage = false
    @State var navigateMyPolicyPage = false
    
    @State var showingUnAuthorizedAlert = false
    
    @State var showingBackAlert = false
    
    @State private var isLoading = false
    @State private var alertItem: AlertItem?
        
    var body: some View {
        NavigationStack {
            LoadingView(isShowing: $isLoading) {
                VStack {
                    VStack(alignment: .center,spacing:15) {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 40,height: 40)
                            .foregroundColor(.green)
                        
                        Text("Travel Insurance - Policy Confirmation")
                            .font(isFontBlack(size: 22))
                            .multilineTextAlignment(.center)
                            .foregroundColor(rose)
                        
                        Text("Thank You for choosing us!")
                            .font(isFontMedium(size: 18))
                            .multilineTextAlignment(.center)
                            .foregroundColor(rose)
                        
                        Text("Policy Number : ")
                            .font(isFontBold(size: 19))
                          
                        +
                        Text(policyNumber)
                            .font(isFontMedium(size: 20))
                       
                        
                        Text("Reference Number : ")
                            .font(isFontBold(size: 19))
                        +
                        Text(referenceNumber)
                            .font(isFontMedium(size: 20))
                        
                        Text("We truly appreciate your decision to choose our travel insurance, your policy document has been sent to your email.")
                            .font(isFontMedium(size: 18))
                            .multilineTextAlignment(.center)
                        
                        Button(action:{
                            withAnimation {
                                navigateMyPolicyPage = true
                            }
                        })
                        {
                            Text("Go to My Policy")
                                .font(isFontBlack(size: 18))
                                .foregroundColor(.white)
                                .frame(maxWidth:.infinity)
                                .padding()
                                .background(appTheme)
                                .cornerRadius(8)
                                .padding(.horizontal,40)
                        }
                        
                        Button(action: {
                            fetchDownloadPdf(attachment: self.attachmentId)
                        })
                        {
                            Text("Download quotation")
                                .font(isFontBlack(size: 18))
                                .foregroundColor(.white)
                                .frame(maxWidth:.infinity)
                                .padding()
                                .background(appTheme)
                                .cornerRadius(8)
                                .padding(.horizontal)
                        }

                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                }
                .onAppear {
                    fetchQuotationStatusUpdate()
                }
                
                // ALERT VIEW
                .alert(item: $alertItem) { alertItem in
                    Alert(title: alertItem.title)
                }
                
                //  TOOL BAR
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        
                        HStack {
                            
                            Button(action: {
                                withAnimation {
                                    showingBackAlert = true
                                }
                            })
                            {
                                
                                Image(systemName: "arrow.backward")
                                    .bold()
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding(.bottom)
                                
                            }
                            .alert(isPresented: $showingBackAlert) {
                                Alert(
                                    title: Text("Alert"),
                                    message: Text("Are you sure, you want to exit?"),
                                    primaryButton: .default(Text("Yes")) {
                                        
                                        withAnimation {
                                            navigateDashboardPage = true
                                        }
                                        showingBackAlert = false
                                        
                                    },
                                    secondaryButton: .cancel(Text("No")) {
                                        showingBackAlert = false
                                    }
                                    
                                )
                            }
                          
                            Text("Payment Confirmation")
                                .bold()
                                .font(isFontBlack(size: 22))
                                .foregroundColor(.white)
                                .padding(.bottom,8)
                           
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
                
                navigateMyPolicyPage ? MyPolicyPage() : nil
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
        
            .overlay {
                if showTravelLoadingView {
                    Color.white
                        .ignoresSafeArea()
                    
                    VStack(alignment:.center, spacing: 30) {
                       Image("travelInsurance")
                            .resizable()
                            .frame(width: 320, height: 350)
                        
                        Text(texts[currentIndex])
                            .font(isFontBlack(size: 20))
                            .multilineTextAlignment(.center)
                            .padding()

                    }
                    .onAppear {
                        startTimer()
                    }
                }
            }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            if currentIndex < texts.count - 1 {
                currentIndex += 1
            } else {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    func fetchQuotationStatusUpdate() {
        isLoading = true
        withAnimation {
            showTravelLoadingView = true
        }
        
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
                
        let url = URL(string: "\(baseURL)api/Quotation/QuotationStatusUpdate")!
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
            "QuotationID": getPremiumQuotationIDValue,
            "PaymentMethodID": "5d3154a9-5d2e-4c84-915e-b62b5ea2670a"
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
                withAnimation {
                    showTravelLoadingView = false
                }
                return
            }
            
            do {
                
                var resultDictionary:NSDictionary! = NSDictionary()
                resultDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                print("Response = \(String(describing: resultDictionary))")
                
//                let decoder = JSONDecoder()
//                let getResponse = try decoder.decode(QuotationInfoResponseModel.self, from: data)
                
                withAnimation {
                    showTravelLoadingView = false
                }
                
                DispatchQueue.main.async {
                    isLoading = false
                    
                    let rcode = resultDictionary["rcode"] as? Int
                    
                    if rcode == 200 {
                                                
                        if let rObj = resultDictionary["rObj"] as? [String: Any] {
                            if let attachmentID = rObj["AttachmentID"] as? String {
                                print("AttachmentID: \(attachmentID)")
                                self.attachmentId = attachmentID
                            }
                            if let referenceNumber = rObj["ReferenceNumber"] as? String {
                                print("ReferenceNumber: \(referenceNumber)")
                                self.referenceNumber = referenceNumber
                            }
                            if let responseMessage = rObj["ResponseMessage"] as? String {
                                print("ResponseMessage: \(responseMessage)")
                               
                            }
                            if let policyNo = rObj["policyNo"] as? String {
                                print("policyNo: \(policyNo)")
                                self.policyNumber = policyNo
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
                withAnimation {
                    showTravelLoadingView = false
                }
            }
        }
        task.resume()
    }
    
    
    
    func fetchDownloadPdf(attachment: String) {
        isLoading = true
        let url = URL(string: "\(baseURL)api/Download/DownloadUserProfile")!
        print(url)
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        let authToken:String! = "Bearer " + Extensions.token

        request.addValue(authToken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("{\"orgAppID\":\"6120\",\"orgGroupID\":\"e6177150-0a4b-46f1-9c27-b55e848a69eb\"}", forHTTPHeaderField: "Webapirequest")
        request.addValue("mobile", forHTTPHeaderField: "source")

        let parameters: [String: Any] = [
            "AttachmentID": attachment
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
                        
                        if let rObj = resultDictionary["rObj"] as? [String: Any],
                           let urlString = rObj["URL"] as? String {
                            print("URL: \(urlString)")
                            
                            openFile(fileURLString: urlString)
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
    
    func openFile(fileURLString: String) {
        if let url = URL(string: fileURLString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    PaymentConfirmationPage()
}
