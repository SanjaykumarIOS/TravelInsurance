//
//  OtpVerificationPage.swift
//  TravelInsurance
//
//  Created by SANJAY  on 23/05/24.
//

import SwiftUI


struct OtpVerificationPage: View {
    
    private let numberOfFields: Int
    @State private var enterValue: [String]
    @State private var navigateDashboardPage = false
    
    @FocusState private var fieldFocus: Int?
    @State private var oldValue = ""
    
    @Binding var navigateLoginPage: Bool
    
    @Binding var navigateDashboard: Bool
    
    init(numberOfFields: Int, navigateLoginPage: Binding<Bool>, navigateDashboard: Binding<Bool>) {
        self.numberOfFields = numberOfFields
        self._enterValue = State(initialValue: Array(repeating: "", count: numberOfFields))
        self._navigateLoginPage = navigateLoginPage
        self._navigateDashboard = navigateDashboard
    }
    
   
        
    @State private var secondsRemaining = 59
    @State private var timer: Timer?
    
    @State private var otpValue = 0
    @State private var authenticationUniqueCode = ""
    @State private var mfaAuthenticationTypeID = 0
    
    @State private var navigateProposalForm = false
    
    @State private var isLoading = false
    @State private var alertItem: AlertItem?
    
    var body: some View {
        NavigationStack {
            VStack {
              
                GeometryReader { geometry in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 15) {
                            
                            Image("otpverifynewicon")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 180,height: 150)
                                .foregroundColor(appTheme)
                            
                            VStack(alignment:.center) {
                                Text("An OTP has been sent to ")
                                    .font(isFontMedium(size: 20))
                                    .foregroundColor(.black.opacity(0.5))
                                + Text(emailValue.isEmpty ? "\(countryCodeValue) \(phoneNoValue)" : emailValue)
                                    .bold()
                                    .font(isFontMedium(size: 20))
                                    .foregroundColor(.black.opacity(0.5))
                                + Text(". Please enter the OTP to continue.")
                                    .font(isFontMedium(size: 20))
                                    .foregroundColor(.black.opacity(0.5))
                                
                            }
                            .multilineTextAlignment(.center)
                            .padding(.horizontal,15)
                            
                            
                            HStack {
                                ForEach(0..<numberOfFields, id: \.self) { index in
                                    TextField("", text: $enterValue[index], onEditingChanged: { editing in
                                        if editing {
                                            oldValue = enterValue[index]
                                        }
                                    })
                                    .bold()
                                    .font(isFontMedium(size: 18))
                                    .foregroundColor(.black)
                                    .keyboardType(.numberPad)
                                    .frame(width: 45, height: 40)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                    .background (
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(enterValue[index].isEmpty ? appTheme : Color.clear, lineWidth: 2)
                                    )
                                    .multilineTextAlignment(.center)
                                    .focused($fieldFocus, equals: index)
                                    .tag(index)
                                    .onChange(of: enterValue[index]) { newValue in
                                        otpValue = Int(enterValue.joined()) ?? 0
                                        if enterValue[index].count > 1 {
                                            let currentValue = Array(enterValue[index])
                                            
                                            if currentValue[0] == Character(oldValue) {
                                                enterValue[index] = String(enterValue[index].suffix(1))
                                            } else {
                                                enterValue[index] = String(enterValue[index].prefix(1))
                                            }
                                        }
                                        
                                        if !newValue.isEmpty {
                                            if index == numberOfFields - 1 {
                                                fieldFocus = nil
                                            } else {
                                                fieldFocus = (fieldFocus ?? 0) + 1
                                            }
                                        } else {
                                            fieldFocus = (fieldFocus ?? 0) - 1
                                        }
                                        
                                    }
                                }
                            }
                            .padding(.leading)
                            .padding(.trailing)
                            .onAppear {
                                DispatchQueue.main.async {
                                    UIApplication.shared.windows.first?.rootViewController?.view.endEditing(false)
                                }
                            }
                            
                            HStack {
                                if secondsRemaining > 0 {
                                    VStack {
                                        
                                        Text("Resend OTP in ")
                                            .bold()
                                            .font(isFontMedium(size: 20))
                                            .foregroundColor(grey)
                                        
                                        +  Text("\(secondsRemaining)")
                                            .bold()
                                            .font(isFontMedium(size: 20))
                                            .foregroundColor(appTheme)
                                    }
                                    
                                } else {
                                    
                                    VStack {
                                        
                                        Button(action: {
                                            startTimer()
                                            fetchOtp()
                                        }) {
                                            Text("Resend OTP")
                                                .font(isFontMedium(size: 20))
                                                .bold()
                                                .foregroundColor(appTheme)
                                                .underline()
                                                .padding(.top,1)
                                            
                                        }
                                    }
                                }
                            }
                            .padding(.vertical)
                            .onAppear {
                                startTimer()
                                fetchOtp()
                            }
                        }.frame(
                            width: geometry.size.width,
                            height: geometry.size.height,
                            alignment: .center
                        )
                    }
                    .frame(width: geometry.size.width)
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
                
                VStack {
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        fetchOtpValidate()
                        
                    }) {
                        Text("Proceed")
                            .padding(.top)
                            .frame(maxWidth: .infinity)
                            .background(appTheme)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .font(isFontBold(size: 22))
                    }
                    
                }
            }
            .onAppear {
                
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
                                navigateLoginPage = false
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        })
                        {
                            
                            Image(systemName: "arrow.backward")
                                .bold()
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding(.bottom)
                            
                        }
                        
                        Text("OTP Verification")
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
        }.navigationBarBackButtonHidden()
        
            .overlay {
                navigateDashboardPage ? DashboardPage() : nil
                
                navigateProposalForm ? ProposalForm(navigateGetPremiumPage: .constant(false)) : nil
            }
    }
    
    func startTimer() {
        secondsRemaining = 59
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if secondsRemaining > 0 {
                secondsRemaining -= 1
            } else {
                timer.invalidate()
                self.timer = nil
            }
        }
    }
    
    
    func fetchOtp() {
        
        isLoading = true
        
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
                
        let url = URL(string: "\(loginBaseURL)api/digital/core/Customer/Register")!
        print(url)
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("\(theJSONData)", forHTTPHeaderField: "clientInfo")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("6120", forHTTPHeaderField: "Orgappid")
        request.addValue("e6177150-0a4b-46f1-9c27-b55e848a69eb", forHTTPHeaderField: "Orggroupid")
        request.addValue("mobile", forHTTPHeaderField: "source")
//        request.addValue("", forHTTPHeaderField: "fingerprint")
          
        
        
        let parameters: [String: Any] = [
            "emailID": emailValue.isEmpty ? NSNull() : emailValue,
            "phoneNumber": phoneNoValue.isEmpty ? NSNull() : phoneNoValue,
            "countryCodeID": "5bde1eaa-2cd1-4a46-ad1f-a1b21020bdae"
        ]
        
        print(parameters)
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let data = data else {
                print("\("Error No data returned from server") \(String(describing: error))")
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
                
                DispatchQueue.main.async {
                    
                    let rcode = resultDictionary["rcode"] as? Int
                    
                    if rcode == 200 {
                        print(rcode ?? 0)
                        
                        if let rObj = resultDictionary["rObj"] as? [String: Any] {
                            
                            if let otp = rObj["OTP"] as? Int {
                                fieldFocus = nil
                                setOtp(otp: String(otp))
                                fieldFocus = nil // Ensure no field is focused after setting OTP
                                UIApplication.shared.windows.first?.rootViewController?.view.endEditing(true)
                                print(otp)
                                otpValue = otp
                            }
                            
                            
                            if let authenticationUniqueCode = rObj["authenticationUniqueCode"] as? String {
                                
                                self.authenticationUniqueCode = authenticationUniqueCode
                                print(authenticationUniqueCode)
                            }
                            
                            if let mfaAuthenticationTypeID = rObj["mfaAuthenticationTypeID"] as? Int {
                                
                                self.mfaAuthenticationTypeID = mfaAuthenticationTypeID
                            }
                        }
                        
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
    
    func setOtp(otp: String) {
        for (index, character) in otp.enumerated() {
            if index < numberOfFields {
                enterValue[index] = String(character)
            }
        }
        DispatchQueue.main.async {
            fieldFocus = nil // Ensure no field is focused after setting OTP
            UIApplication.shared.windows.first?.rootViewController?.view.endEditing(true) // Dismiss keyboard
        }
    }
    
    
    func fetchOtpValidate() {
        isLoading = true
        
        Extensions.token = ""
        
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
        
        
        let url = URL(string: "\(loginBaseURL)api/digital/core/Customer/ValidateOTP")!
        print(url)
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("\(theJSONData)", forHTTPHeaderField: "clientInfo")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("6120", forHTTPHeaderField: "Orgappid")
        request.addValue("e6177150-0a4b-46f1-9c27-b55e848a69eb", forHTTPHeaderField: "Orggroupid")
        request.addValue("mobile", forHTTPHeaderField: "source")
        
        let parameters: [String: Any] = [
            "authenticationUniqueCode": "\(authenticationUniqueCode)",
            "OTP": "\(otpValue)",
            "mfaAuthenticationTypeID": "\(mfaAuthenticationTypeID)"
        ]
        
        print(parameters)
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let data = data else {
                print("\("Error No data returned from server") \(String(describing: error))")
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
                
                DispatchQueue.main.async {
                    isLoading = false
                    
                    let rcode = resultDictionary["rcode"] as? Int
                    
                    if rcode == 200 {
                        print(rcode)
                        
                        if let rObj = resultDictionary["rObj"] as? [String: Any],
                           let token = rObj["token"] as? String {
                            Extensions.token = token
                            print(token)
                            
                        }
                        
                        if Extensions.navigateProposalForm == true {
                            withAnimation {
                                navigateProposalForm = true
                                Extensions.navigateProposalForm = false
                            }
                        } else {
                            withAnimation {
                                navigateDashboardPage = true
//                                navigateDashboard = false
//                                navigateLoginPage = false
                            }
                        }
                        
                        isLoading = false
                        
                    } else if rcode == 503 {
                        if let rmsgArray = resultDictionary["rmsg"] as? [[String: Any]] {
                            if let firstError = rmsgArray.first,
                               let errorText = firstError["errorText"] as? String {
                                // Handle the error message
                                print("Error: \(errorText)")
                                self.alertItem = AlertItem(title: Text("Alert" + "\n" + errorText))
                            }
                        }
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
//    OtpVerificationPage(numberOfFields: 6)
    LoginPage(navigateDashboard: .constant(false))
}
