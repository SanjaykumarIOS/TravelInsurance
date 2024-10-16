//
//  PolicyDetailsPage.swift
//  TravelInsurance
//
//  Created by SANJAY  on 12/06/24.
//

import SwiftUI

var myPolicyQuotationId = ""
var myPolicyQuotesId = ""


struct PolicyDetailsPage: View {
    
    @State private var userInfoArray: [ProposalFormResponse.ProposalFormRObj] = []
    @State var coverageValues: [String] = []
    
    @State private var isLoading = false
    @State private var alertItem: AlertItem?
    
    @Binding var navigatePolicyDetails: Bool
    
    @State var navigateDashboardPage = false
    
    @State var showingUnAuthorizedAlert = false
    
    private var isoDateFormatter: DateFormatter {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
           return formatter
       }

       private var dateFormatter: DateFormatter {
           let formatter = DateFormatter()
           formatter.dateFormat = "dd/MM/yyyy"
           return formatter
       }

        
    var body: some View {
        NavigationStack {
            LoadingView(isShowing: $isLoading) {
                VStack {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment:.leading,spacing: 10) {
                            Text("Quote Information :")
                                .font(isFontBlack(size: 22))
                                .foregroundColor(rose)
                            
                            HStack(alignment:.top) {
                                Text("Quotation Number")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(isFontMedium(size: 18))
                                    .frame(width: 170)
                                
                                
                                Text(": \(userInfoArray.first?.Quotations?.QuotationNumber ?? "")")
                                    .font(isFontBold(size: 19))
                                    .bold()
                            }
                            .padding(.top,5)
                            
                            HStack(alignment:.top) {
                                Text("Travel Purpose")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(isFontMedium(size: 18))
                                    .frame(width: 170)
                                
                                
                                Text(": \(userInfoArray.first?.Quotations?.TravelPurposeName ?? "")")
                                    .font(isFontBold(size: 19))
                                    .bold()
                            }
                            
                            Text("Proposal Form :")
                                .font(isFontBlack(size: 22))
                                .foregroundColor(rose)
                                .padding(.top,12)
                            
                            HStack(alignment:.top) {
                                Text("Product Name")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(isFontMedium(size: 18))
                                    .frame(width: 170)
                                
                                Text(": \(userInfoArray.first?.Quotes?.ProductName ?? "")")
                                    .font(isFontBold(size: 19))
                                    .bold()
                            }
                            .padding(.top,5)
                            
                            HStack(alignment:.top) {
                                Text("Premium Amount")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(isFontMedium(size: 18))
                                    .frame(width: 170)
                                
                                Text(": \(userInfoArray.first?.Quotes?.sTotalAmount ?? "")")
                                    .font(isFontBold(size: 19))
                                    .bold()
                            }
                            
                            HStack(alignment:.top) {
                                Text("Travel Purpose")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(isFontMedium(size: 18))
                                    .frame(width: 170)
                                
                                Text(": \(userInfoArray.first?.Quotations?.TravelPurposeName ?? "")")
                                    .font(isFontBold(size: 19))
                                    .bold()
                            }
                            
                            HStack(alignment:.top) {
                                Text("Destionation")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(isFontMedium(size: 18))
                                    .frame(width: 170)
                                
                                Text(": \(userInfoArray.first?.Quotations?.DestinationCountryName ?? "")")
                                    .font(isFontBold(size: 19))
                                    .bold()
                            }
                            
                            HStack(alignment:.top) {
                                Text("Trip Start Date")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(isFontMedium(size: 18))
                                    .frame(width: 170)
                                
                                Text(": \(userInfoArray.first?.Quotations?.FromDateString ?? "")")
                                    .font(isFontBold(size: 19))
                                    .bold()
                            }
                            
                            HStack(alignment:.top) {
                                Text("Trip End Date")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(isFontMedium(size: 18))
                                    .frame(width: 170)
                                
                                Text(": \(userInfoArray.first?.Quotations?.ToDateString ?? "")")
                                    .font(isFontBold(size: 19))
                                    .bold()
                            }
                            
                            HStack(alignment:.top) {
                                Text("Travelling Days")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(isFontMedium(size: 18))
                                    .frame(width: 170)
                                
                                Text(": \(userInfoArray.first?.Quotations?.NoofDays.map(String.init) ?? "")")
                                    .font(isFontBold(size: 19))
                                    .bold()
                            }
                            
                            HStack(alignment:.top) {
                                Text("Number of Travelers")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(isFontMedium(size: 18))
                                    .frame(width: 170)
                                
                                Text(": \(userInfoArray.first?.Quotations?.NoofTravellers.map(String.init) ?? "")")
                                    .font(isFontBold(size: 19))
                                    .bold()
                            }
                            
                            HStack(alignment:.top) {
                                Text("KRA Pin Type")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(isFontMedium(size: 18))
                                    .frame(width: 170)
                                
                                ForEach(masterDatakRAPintype, id: \.masterDataID) { masterData in
                                    if masterData.masterDataID == userInfoArray.first?.Quotations?.KRAPinTypeID {
                                        Text(": \(masterData.mdTitle ?? "")")
                                            .font(isFontBold(size: 19))
                                            .bold()
                                    }
                                }
                               
                            }
                            
                            HStack(alignment:.top) {
                                Text("KRA Pin Number")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(isFontMedium(size: 18))
                                    .frame(width: 170)
                                
                                Text(": \(userInfoArray.first?.Quotations?.KRAPinNumber ?? "")")
                                    .font(isFontBold(size: 19))
                                    .bold()
                            }
                            
                            HStack(alignment:.top) {
                                Text("Insured's Occupation")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(isFontMedium(size: 18))
                                    .frame(width: 170)
                                
                                Text(": \(userInfoArray.first?.Quotations?.Occupation ?? "")")
                                    .font(isFontBold(size: 19))
                                    .bold()
                            }
                            
                            HStack(alignment:.top) {
                                Text("Beneficiary Name")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(isFontMedium(size: 18))
                                    .frame(width: 170)
                                
                                Text(": \(userInfoArray.first?.Quotations?.BeneficiaryName ?? "")")
                                    .font(isFontBold(size: 19))
                                    .bold()
                            }
                            
                            HStack(alignment:.top) {
                                Text("Beneficiary Mobile Number")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(isFontMedium(size: 18))
                                    .frame(width: 170)
                                
                                Text(": \(userInfoArray.first?.Quotations?.BeneficiaryPhoneNumber ?? "")")
                                    .font(isFontBold(size: 19))
                                    .bold()
                            }
                            
                            Text("Address :")
                                .font(isFontBlack(size: 22))
                                .foregroundColor(rose)
                                .padding(.top,12)
                            
                            HStack(alignment:.top) {
                                Text("House Number")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(isFontMedium(size: 18))
                                    .frame(width: 170)
                                
                                Text(": \(userInfoArray.first?.Quotations?.AddressLine1 ?? "")")
                                    .font(isFontBold(size: 19))
                                    .bold()
                            }
                            
                            HStack(alignment:.top) {
                                Text("Road Name")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(isFontMedium(size: 18))
                                    .frame(width: 170)
                                
                                Text(": \(userInfoArray.first?.Quotations?.AddressLine2 ?? "")")
                                    .font(isFontBold(size: 19))
                                    .bold()
                            }
                            
                            HStack(alignment:.top) {
                                Text("Pincode")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(isFontMedium(size: 18))
                                    .frame(width: 170)
                                
                                Text(": \(userInfoArray.first?.Quotations?.AddressLine3 ?? "")")
                                    .font(isFontBold(size: 19))
                                    .bold()
                            }
                            
                            VStack(alignment:.leading,spacing:10) {
                                Text("Travellers Details :")
                                    .font(isFontBlack(size: 22))
                                    .foregroundColor(rose)
                                    .padding(.top,12)
                                
                                ForEach(userInfoArray.indices, id: \.self) { index in
                                    let quotes = userInfoArray[index]
                                    
                                    if let traveller = quotes.Traveller {
                                        ForEach(traveller.indices, id: \.self) { indexValue in
                                            let travel = traveller[indexValue]
                                            
                                            VStack {
                                                HStack {
                                                    Text("Travellers \(indexValue + 1)")
                                                        .font(isFontMedium(size: 18))
                                                        .bold()
                                                        .foregroundColor(.white)
                                                    
                                                    Spacer()
                                                    
                                                    Text("Is this Proposer?")
                                                        .font(isFontMedium(size: 18))
                                                        .foregroundColor(.white)
                                                    
                                                    Image(systemName: travel.IsPolicyHolder ? "checkmark.square.fill" : "square")
                                                        .font(isFontMedium(size: 21))
                                                        .bold()
                                                        .foregroundColor(rose)
                                                     
                                                }
                                                .frame(maxWidth: .infinity)
                                                .padding()
                                                .background(appTheme)
                                                
                                                VStack {
                                                    HStack {
                                                        VStack(alignment:.leading,spacing:8) {
                                                            Text("First Name")
                                                                .font(isFontMedium(size: 19))
                                                                .bold()
                                                            
                                                            Text(travel.FirstName ?? "")
                                                                .font(isFontMedium(size: 18))
                                                        }
                                                        .frame(maxWidth:.infinity, alignment:.leading)
                                                        
                                                        VStack(alignment:.leading,spacing:8) {
                                                            Text("Last Name")
                                                                .font(isFontMedium(size: 19))
                                                                .bold()
                                                            
                                                            Text(travel.LastName ?? "")
                                                                .font(isFontMedium(size: 18))
                                                        }
                                                        .frame(maxWidth:.infinity, alignment:.leading)
                                                        
                                                    }
                                                    
                                                    HStack(alignment:.bottom) {
                                                        VStack(alignment:.leading,spacing:8) {
                                                            Text("Name as per the passport")
                                                                .font(isFontMedium(size: 19))
                                                                .bold()
                                                            
                                                            Text(travel.Fullname ?? "")
                                                                .font(isFontMedium(size: 18))
                                                        }
                                                        .frame(maxWidth:.infinity, alignment:.leading)
                                                        
                                                        VStack(alignment:.leading,spacing:8) {
                                                            Text("Email ID")
                                                                .font(isFontMedium(size: 19))
                                                                .bold()
                                                            
                                                            Text(travel.EmailId ?? "")
                                                                .font(isFontMedium(size: 18))
                                                        }
                                                        .frame(maxWidth:.infinity, alignment:.leading)
                                                        
                                                    }
                                                    .padding(.top,8)
                                                    
                                                    
                                                    HStack(alignment:.bottom) {
                                                        VStack(alignment:.leading,spacing:8) {
                                                            Text("Date of birth")
                                                                .font(isFontMedium(size: 19))
                                                                .bold()
                                                            
                                                            Text(formattedDateOfBirth)
                                                                .font(isFontMedium(size: 18))
                                                        }
                                                        .frame(maxWidth:.infinity, alignment:.leading)
                                                        
                                                        VStack(alignment:.leading,spacing:8) {
                                                            Text("Age")
                                                                .font(isFontMedium(size: 19))
                                                                .bold()
                                                            
                                                            Text(travel.Age.map(String.init) ?? "")
                                                                .font(isFontMedium(size: 18))
                                                        }
                                                        .frame(maxWidth:.infinity, alignment:.leading)
                                                        
                                                    }
                                                    .padding(.top,8)
                                                    
                                                    HStack(alignment:.bottom) {
                                                        VStack(alignment:.leading,spacing:8) {
                                                            Text("Mobile Number")
                                                                .font(isFontMedium(size: 19))
                                                                .bold()
                                                            
                                                            Text("+\(travel.PhoneNumberCountryCode.map(String.init) ?? "") \(travel.sPhoneNumber ?? "")")
                                                                .font(isFontMedium(size: 18))
                                                        }
                                                        .frame(maxWidth:.infinity, alignment:.leading)
                                                        
                                                        VStack(alignment:.leading,spacing:8) {
                                                            Text("Passport Number")
                                                                .font(isFontMedium(size: 19))
                                                                .bold()
                                                            
                                                            Text(travel.PolicyHolderPassPortNumber ?? "")
                                                                .font(isFontMedium(size: 18))
                                                        }
                                                        .frame(maxWidth:.infinity, alignment:.leading)
                                                        
                                                    }
                                                    .padding(.top,8)
                                                    
                                                    HStack(alignment:.bottom) {
                                                        VStack(alignment:.leading,spacing:8) {
                                                            Text("Relationship with the proposer")
                                                                .font(isFontMedium(size: 19))
                                                                .bold()
                                                            
                                                            Text(travel.RelationshipName ?? "")
                                                                .font(isFontMedium(size: 18))
                                                        }
                                                        .frame(maxWidth:.infinity, alignment:.leading)
                                                        
                                                    }
                                                    .padding(.top,8)


                                                    
                                                }
                                                .padding(7)
                                                
                                            }
                                            .frame(maxWidth:.infinity)
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .shadow(radius: 2)
                                            .padding([.vertical, .horizontal],5)
                                            
                                            
                                        }
                                    }
                                }
                                
                            }
                            
                            VStack(alignment:.leading,spacing:10) {
                                Text("Coverage Details :")
                                    .font(isFontBlack(size: 22))
                                    .foregroundColor(rose)
                                    .padding(.top,12)
                                
                                Text("The following coverages are included in this product :")
                                    .font(isFontMedium(size: 19))
                                    .foregroundColor(.black.opacity(0.5))
                                
                                    if !self.coverageValues.isEmpty {
                                            self.generateContent()
                                    }
                                
                            }
                            
                           
                           
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top,10)
                    }
                    
                }
                .padding([.horizontal],10)
                .onAppear {
                    fetchUserInfo()
                    
                    isLoading = true
                    let model = QuotationFields(navigateDashboard: .constant(false))
                    model.fetchMasterData()
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
                                    navigatePolicyDetails = false
                                }
                            })
                            {
                                Image(systemName: "arrow.backward")
                                    .bold()
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding(.bottom)
                            }
                            
                            Text("Policy Details")
                                .bold()
                                .font(isFontBlack(size: 22))
                                .foregroundColor(.white)
                                .padding(.bottom,8)
                            
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        Image("downloadPdf")
                            .resizable()
                            .frame(width:25,height:27)
                            .bold()
                            .padding(.bottom,8)
                            .onTapGesture {
                                
                                if userInfoArray.first?.Quotations?.AttachmentID == "00000000-0000-0000-0000-000000000000" {
                                    fetchDownloadPdf(attachment: "")
                                } else {
                                    fetchDownloadPdf(attachment: userInfoArray.first?.Quotations?.AttachmentID ?? "")
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
                
                navigateDashboardPage ? DashboardPage() : nil
                
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
    
    private var formattedDateOfBirth: String {
        
        for value in userInfoArray {
            if let travel = value.Traveller {
                for data in travel {
                    if let dob = data.DOB, let date = isoDateFormatter.date(from: dob) {
                        return dateFormatter.string(from: date)
                    }
                }
            }
        }
        
            
            return "N/A"
        }
    
    
    private func generateContent() -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(self.coverageValues.indices, id: \.self) { index in
                let platform = self.coverageValues[index]
                self.item(for: platform, index: index)
                    .padding(5)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > UIScreen.main.bounds.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if index == self.coverageValues.count - 1 {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if index == self.coverageValues.count - 1 {
                            height = 0
                        }
                        return result
                    })
            }
            
        }
    }

       func item(for destination: String, index: Int) -> some View {
           HStack {
               Text(destination)
                   .font(isFontMediumItalic(size: 16))
                   .foregroundColor(.white)
           }
           .frame(height: 35)
           .frame(width: .infinity)
           .padding(.horizontal,10)
           .background(appTheme)
           .cornerRadius(18)

       }
    
    func fetchUserInfo() {
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
                
        let url = URL(string: "\(baseURL)api/Quotation/UserInfo")!
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
            "QuotationID": myPolicyQuotationId, "QuotesID": myPolicyQuotesId
//            "QuotesID": "181dd9bc-4858-42e4-8963-34450d7f7585", "QuotationID": "6a89547f-8d09-42ef-a21a-b17b186793c8"
            //            "QuotationID":"fdba3749-1e70-4ba9-baca-d13bb502a6ef","QuotesID":"d094776d-e380-46f2-a0e6-5e88b6e0691a"
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
                
                let rcode = resultDictionary["rcode"] as? Int
                
                if rcode == 200 {
                    
                    let decoder = JSONDecoder()
                    let getResponse = try decoder.decode(ProposalFormResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        isLoading = false
                        
                        if getResponse.rcode == 200 {
                            
                            print(getResponse.rcode)
                            
                            userInfoArray = [getResponse.rObj]
                            
                            if let coverageTitle = getResponse.rObj.Quotes?.CoverageTitle, !coverageTitle.isEmpty {
                                self.coverageValues = coverageTitle.split(separator: ",").map { String($0) }
                            } else {
                                self.coverageValues = []
                            }
                            
                            isLoading = false
                            
                        } else {
                            if let errorDict = Extensions.getValidationDict() as? [String: String] {
                                if let errorMessage = errorDict["API001"] {
                                    self.alertItem = AlertItem(title: Text("API001" + "\n" + errorMessage))
                                }
                            }
                        }
                        
                    }
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
    PolicyDetailsPage(navigatePolicyDetails: .constant(false))
}
