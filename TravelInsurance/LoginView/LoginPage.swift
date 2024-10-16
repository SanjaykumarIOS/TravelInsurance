//
//  LoginPage.swift
//  TravelInsurance
//
//  Created by SANJAY  on 21/05/24.
//

import SwiftUI

var phoneNoValue = ""
var countryCodeValue = ""
var emailValue = ""

struct LoginPage: View {
    
    @State private var selectedTab: Int? = nil
    
    @State private var phoneNumber = ""
    @State private var countryCode = "+254"
    @State private var countryCodeList = ["+254"]
    @State private var showCountryCodeList = false
    
    @State private var email = ""
    @State private var policyID = ""
    @State private var policyIdDOB = ""
    @State private var showPolicyDataPicker = false
    @State private var selectionDate = Date()
    
    @State private var navigateOtpPage = false
    
    @Binding var navigateDashboard: Bool
    
    @State private var isLoading = false
    @State private var alertItem: AlertItem?
    
    var body: some View {
        NavigationStack {
            LoadingView(isShowing: $isLoading) {
                VStack {
                    ScrollView {
                        
                        ZStack {
                            VStack {
                                appTheme
                                    .frame(maxWidth: .infinity)
                                    .frame(height: UIScreen.main.bounds.height / 2)
                                    .edgesIgnoringSafeArea(.all)
                                Spacer()
                            }
                            
                            
                            VStack {
                                Spacer(minLength: 120)
                                Image("kenindia-logo")
                                    .resizable()
                                    .frame(width: 200,height: 100)
                                
                                Text("Login to your account")
                                    .font(isFontMedium(size: 26))
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding()
                                
                                VStack {
                                    HStack {
                                        Spacer()
                                        
                                        VStack {
                                            Text("PHONE NO")
                                                .font(isFontMedium(size: 18))
                                            
                                            Divider()
                                                .frame(height: 3)
                                                .frame(maxWidth: .infinity)
                                                .background(selectedTab == 0 ? appTheme : Color.clear)
                                                .padding(.vertical,7)
                                            
                                        }
                                        .onTapGesture {
                                            withAnimation {
                                                selectedTab = 0
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        VStack {
                                            Text("EMAIL")
                                                .font(isFontMedium(size: 18))
                                            
                                            Divider()
                                                .frame(height: 3)
                                                .frame(maxWidth: .infinity)
                                                .background(selectedTab == 1 ? appTheme : Color.clear)
                                                .padding(.vertical,7)
                                        }
                                        .onTapGesture {
                                            withAnimation {
                                                selectedTab = 1
                                            }
                                        }
                                        
                                        Spacer()
                                        
//                                        VStack {
//                                            
//                                            Text("POLICY ID")
//                                                .font(isFontMedium(size: 18))
//                                            
//                                            Divider()
//                                                .frame(height: 3)
//                                                .frame(maxWidth: .infinity)
//                                                .background(selectedTab == 2 ? appTheme : Color.clear)
//                                                .padding(.vertical,7)
//                                            
//                                        }
//                                        .onTapGesture {
//                                            withAnimation {
//                                                selectedTab = 2
//                                                
//                                            }
//                                        }
//                                        
//                                        Spacer()
                                    }
                                    
                                    if selectedTab == 0 {
                                        
                                        Text("Phone Number")
                                            .font(isFontMedium(size: 18))
                                            .frame(maxWidth: .infinity, alignment:.leading)
                                            .padding([.horizontal, .top])
                                        
                                        HStack {
                                            
                                            HStack {
                                                TextField("", text: $countryCode)
                                                    .disabled(true)
                                                    .font(isFontMedium(size: 18))
                                                    .autocapitalization(.none)
                                                    .autocorrectionDisabled()
                                                
                                                
                                                Image(systemName: "chevron.down")
                                                    .bold()
                                                    .foregroundColor(.black)
                                                    .font(isFontMedium(size: 18))
                                                    .frame(maxWidth: .infinity,alignment:.trailing)

                                                
                                            }
                                            .padding(.all)
                                            .frame(height: 50)
                                            .background(Color.gray.opacity(0.2))
                                            .foregroundColor(.black)
                                            .cornerRadius(8)
                                            .fixedSize(horizontal: true, vertical: false)
                                            .onTapGesture {
                                                showCountryCodeList = true
                                            }
                                            
                                            
                                            TextField("Enter phone number", text: $phoneNumber)
                                                .padding(.all)
                                                .toolbar {
                                                    ToolbarItemGroup(placement: .keyboard) {
                                                        Button("Done") {
                                                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                                            isLoading = true
                                                            isLoading = false
                                                        }
                                                        .font(isFontMedium(size: 18))
                                                        .foregroundColor(.blue)
                                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                                        .padding(.horizontal)
                                                        
                                                    }
                                                }
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 50)
                                                .font(isFontMedium(size: 18))
                                                .autocapitalization(.none)
                                                .autocorrectionDisabled()
                                                .background(Color.gray.opacity(0.2))
                                                .foregroundColor(.black)
                                                .cornerRadius(8)
                                                .keyboardType(.numberPad)
                                                .onChange(of: phoneNumber) { newValue in
                                                    // Filter out non-numeric characters
                                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                                    // Limit to 9 characters
                                                    if filtered.count > 9 {
                                                        phoneNumber = String(filtered.prefix(9))
                                                    } else {
                                                        phoneNumber = filtered
                                                    }
                                                }
                                                
                                            
                                            
                                        }
                                        .padding(.horizontal)
                                    }
                                    
                                    if selectedTab == 1 {
                                        Text("Email Address")
                                            .font(isFontMedium(size: 18))
                                            .frame(maxWidth: .infinity, alignment:.leading)
                                            .padding([.horizontal, .top])
                                        
                                        TextField("Enter your email", text: $email)
                                            .keyboardType(.emailAddress)
                                            .padding(.all)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 50)
                                            .font(isFontMedium(size: 18))
                                            .autocapitalization(.none)
                                            .autocorrectionDisabled()
                                            .background(Color.gray.opacity(0.2))
                                            .foregroundColor(.black)
                                            .cornerRadius(8)
                                            .padding(.horizontal)
                                        
                                    }
                                    
                                    
                                    if selectedTab == 2 {
                                        Text("Policy Id")
                                            .font(isFontMedium(size: 18))
                                            .frame(maxWidth: .infinity, alignment:.leading)
                                            .padding([.horizontal, .top])
                                        
                                        TextField("Enter your Policy Id", text: $policyID)
                                            .padding(.all)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 50)
                                            .font(isFontMedium(size: 18))
                                            .autocapitalization(.none)
                                            .autocorrectionDisabled()
                                            .background(Color.gray.opacity(0.2))
                                            .foregroundColor(.black)
                                            .cornerRadius(8)
                                            .padding(.horizontal)
                                        
                                        Text("Date of Birth")
                                            .font(isFontMedium(size: 18))
                                            .frame(maxWidth: .infinity, alignment:.leading)
                                            .padding([.horizontal, .top])
                                        
                                        TextField("dd/mm/yyyy", text: $policyIdDOB)
                                            .disabled(true)
                                            .padding(.all)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 50)
                                            .font(isFontMedium(size: 18))
                                            .autocapitalization(.none)
                                            .autocorrectionDisabled()
                                            .background(Color.gray.opacity(0.2))
                                            .foregroundColor(.black)
                                            .cornerRadius(8)
                                            .padding(.horizontal)
                                            .onTapGesture {
                                                showPolicyDataPicker = true
                                            }
                                    }
                                    
                                    Button(action: {
                                        loginValidation()
                                        if selectedTab == 0 {
                                            phoneNoValue = phoneNumber
                                            countryCodeValue = countryCode
                                            emailValue = ""
                                        } else {
                                            emailValue = email
                                            phoneNoValue = ""
                                            countryCodeValue = ""
                                        }
                                    })
                                    {
                                        Text("Proceed")
                                            .padding()
                                            .font(isFontMedium(size: 20))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .background(appTheme)
                                            .cornerRadius(8)
                                            .padding()
                                    }
                                    
                                    Text("Having trouble logging in?")
                                        .font(isFontMedium(size: 17))
                                        .underline()
                                        .foregroundColor(.blue)
                                        .padding(.vertical)
                                        .onTapGesture {
                                            
                                        }
                                    
                                }
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 10)
                                .padding()
                                
                            }
                            .onAppear {
                                selectedTab = 0
                            }
                        }
                        
                    
                    }
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
                .onAppear {
                    isLoading = true
                    isLoading = false
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
                                    navigateDashboard = false
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
                          
                            
                        }
                    }
                }
                .toolbarBackground(appTheme,for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
  
            }
            
        }.navigationBarBackButtonHidden()
        
            .overlay {
                navigateOtpPage ? OtpVerificationPage(numberOfFields: 6, navigateLoginPage: $navigateOtpPage, navigateDashboard: $navigateDashboard) : nil
            }
        
        .overlay {
            if showCountryCodeList {
                ZStack {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showCountryCodeList = false
                        }
                    
                    VStack {
                        ForEach(countryCodeList, id: \.self) { code in
                            
                            Button(action: {
                                showCountryCodeList = false
                                countryCode = code
                            })
                            {
                                Text(code)
                                    .font(isFontMedium(size: 18))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical)
                            }
                        }
                        
                    }
                    .padding()
                    .frame(maxWidth:.infinity)
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(radius: 2)
                    .padding(30)
                }
            }
            
            if showPolicyDataPicker {
                ZStack {
                    Color.black
                        .ignoresSafeArea()
                        .opacity(0.3)
                        .onTapGesture {
                            showPolicyDataPicker = false
                        }
                    
                    VStack {
                        
                        DatePicker("Start Date", selection: $selectionDate, displayedComponents: [.date])
                            .font(isFontMedium(size: 18))
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding(.top)
                            .padding(.trailing)
                            .padding(.leading)
                        
                        HStack(alignment: .top) {
                            
                            Spacer()
                            
                            Button(action: {
                                
                                self.showPolicyDataPicker = false
                                
                            }) {
                                Text("CANCEL")
                                    .font(isFontMedium(size: 18))
                                    .foregroundColor(.teal)
                                    .padding(.trailing,30)
                                
                                Button(action: {
                                    
                                    // Close the date picker
                                    self.showPolicyDataPicker.toggle()
                                    
                                    policyIdDOB = dateFormatter.string(from: selectionDate)
                                    
                                   
                                }) {
                                    Text("OK")
                                        .font(isFontMedium(size: 18))
                                        .foregroundColor(.teal)
                                        .padding(.trailing)
                                    
                                }
                                
                                
                            }
                            
                            
                        }
                        .padding(.trailing)
                        .padding(.bottom)
                        .padding(.top,30)
                    }
                    .frame(width: 360)
                    .fixedSize(horizontal: false, vertical: true)
                    .background(Color.white)
                    .cornerRadius(8)
                    
                }
            }
        }

    }
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    func loginValidation() {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        if selectedTab == 0 && countryCode.isEmpty {
            if let errorDict = Extensions.getValidationDict() as? [String: String] {
                if let errorMessage = errorDict["VAL010"] {
                    self.alertItem = AlertItem(title: Text("VAL010 \n \(errorMessage)"))
                }
            }
        } else if selectedTab == 0 && phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty {
            if let errorDict = Extensions.getValidationDict() as? [String: String] {
                if let errorMessage = errorDict["VAL011"] {
                    self.alertItem = AlertItem(title: Text("VAL011 \n \(errorMessage)"))
                }
            }
        } else if selectedTab == 1 && email.trimmingCharacters(in: .whitespaces).isEmpty {
            if let errorDict = Extensions.getValidationDict() as? [String: String] {
                if let errorMessage = errorDict["VAL012"] {
                    self.alertItem = AlertItem(title: Text("VAL012 \n \(errorMessage)"))
                }
            }
        } else if selectedTab == 1 && (!emailTest.evaluate(with: email)) {
            if let errorDict = Extensions.getValidationDict() as? [String: String] {
                if let errorMessage = errorDict["VAL013"] {
                    self.alertItem = AlertItem(title: Text("VAL013 \n \(errorMessage)"))
                }
            }
            
        } else if selectedTab == 2 && policyID.trimmingCharacters(in: .whitespaces).isEmpty {
            if let errorDict = Extensions.getValidationDict() as? [String: String] {
                if let errorMessage = errorDict["VAL014"] {
                    self.alertItem = AlertItem(title: Text("VAL014 \n \(errorMessage)"))
                }
            }
        } else if selectedTab == 2 && policyIdDOB.trimmingCharacters(in: .whitespaces).isEmpty {
            if let errorDict = Extensions.getValidationDict() as? [String: String] {
                if let errorMessage = errorDict["VAL015"] {
                    self.alertItem = AlertItem(title: Text("VAL015 \n \(errorMessage)"))
                }
            }
        } else {
            withAnimation {
                navigateOtpPage = true
            }
        }
        
    }
    
    
}


#Preview {
    LoginPage(navigateDashboard: .constant(false))
}
