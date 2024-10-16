//
//  MyQuotations.swift
//  TravelInsurance
//
//  Created by SANJAY  on 24/05/24.
//

import SwiftUI


extension MyQuotationResponse.MyQuotationRObj.MyQuotation: Equatable {
    static func == (lhs: MyQuotationResponse.MyQuotationRObj.MyQuotation, rhs: MyQuotationResponse.MyQuotationRObj.MyQuotation) -> Bool {
        // Implement equality check based on your requirements
        // For example, you might compare properties like quotationRequestID
        return lhs.QuotationID == rhs.QuotationID
    }
}

struct MyQuotations: View {
    
//    @State private var items: [Quotation] = [
//          Quotation(quotation: "QAGDOD1239B2", expireon: "08/06/2024", destination: "United Arab Emirates (UAE) Oman, Kuwait", travelDates: "12/05/2024 - 20/05/2024", status: "Valid", source: "Direct"),
//          Quotation(quotation: "QAGDOD1239B3", expireon: "07/05/2024", destination: "Singapore, Malaysia", travelDates: "14/05/2024 - 20/05/2024", status: "Valid", source: "Intermediary"),
//          Quotation(quotation: "QAGDOD1239B4", expireon: "30/04/2024", destination: "Hong Kong. Thailand", travelDates: "09/05/2024 - 18/05/2024", status: "Expired", source: "B20")
//      ]
    
    @State private var searchBox = ""
    
    @State private var myQuotationDetailArray: [MyQuotationResponse.MyQuotationRObj.MyQuotation] = []
    @State private var pageNo = 1
    
    @State private var fromDate = ""
    @State private var toDate = ""
    @State private var fromDateValue = ""
    @State private var toDateValue = ""
    @State private var showCompareQuotation = false
    
    @State private var selectedDate: Date?
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var showStartDate = false
    @State private var showEndDate = false
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    var selectedDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    @State private var navigateGetPremiumPage = false
    @Binding var navigateMyQuotationPage: Bool
    
    @State private var showingUnAuthorizedAlert = false
    
    @State private var isLoading = false
    @State private var alertItem: AlertItem?
    
 
    
    var body: some View {
        NavigationStack {
            LoadingView(isShowing: $isLoading) {
                VStack {
                    
                    TextField("Quotation Id", text: $searchBox)
                        .padding(.all)
                        .padding(.leading,30)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .font(isFontMedium(size: 18))
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .cornerRadius(8)
                        .overlay {
                            Image(systemName: "magnifyingglass")
                                .font(isFontMedium(size: 23))
                                .bold()
                                .foregroundColor(appTheme)
                                .frame(maxWidth: .infinity, alignment:.leading)
                                .padding(.horizontal,10)
                            
                        }
                        .padding([.horizontal, .top])
                    
                    VStack {
                        
                        if myQuotationDetailArray.isEmpty {
                            Text("There are no quotation available")
                                .font(isFontBold(size: 20))
                                .foregroundColor(.black.opacity(0.6))
                                .frame(maxWidth:.infinity, maxHeight:.infinity, alignment:.center)
                            
                        } else {
                            
                            List {
                                ForEach(filteredItems(searchText: searchBox), id: \.QuotationID) { quotation in
                                    
                                    VStack {
                                        ZStack {
                                            Color.white
                                            
                                            VStack {
                                                VStack {
                                                    ZStack {
                                                        appTheme
                                                        
                                                        Text("Quotation # \(quotation.QuotationNumber ?? "")")
                                                            .font(isFontMedium(size: 17))
                                                            .foregroundColor(.white)
                                                            .frame(maxWidth: .infinity, alignment: .leading)
                                                            .padding(.leading)
                                                        
                                                        
                                                    }
                                                    .frame(maxWidth: .infinity)
                                                    .frame(height: 40)
                                                    
                                                    Spacer()
                                                }
                                                
                                                HStack(alignment:.top) {
                                                    VStack(alignment:.leading, spacing:10) {
                                                        
                                                        Text("Expire on")
                                                            .bold()
                                                            .font(isFontMedium(size: 18))
                                                        
                                                        Text(quotation.ExpiredString ?? "")
                                                            .font(isFontMedium(size: 16))
                                                        
                                                        Text("Destination")
                                                            .bold()
                                                            .font(isFontMedium(size: 18))
                                                        
                                                        Text(quotation.DestinationCountryName ?? "")
                                                            .font(isFontMedium(size: 16))
                                                        
                                                        
                                                    }
                                                    .frame(width: 170,alignment:.leading)
                                                    .padding(.leading)
                                                    .fixedSize(horizontal: false, vertical: true)
                                                    
                                                    VStack(alignment:.leading, spacing:10) {
                                                        
                                                        Text("Status")
                                                            .bold()
                                                            .font(isFontMedium(size: 18))
                                                        
                                                        if quotation.QuotationStatusName == "Form Submitted" {
                                                            Text(quotation.QuotationStatusName ?? "")
                                                                .font(isFontMedium(size: 16))
                                                                .foregroundColor(.green)
                                                        } else if quotation.QuotationStatusName == "Requested" {
                                                            Text(quotation.QuotationStatusName ?? "")
                                                                .font(isFontMedium(size: 16))
                                                                .foregroundColor(.blue)
                                                        } else {
                                                            Text(quotation.QuotationStatusName ?? "")
                                                                .font(isFontMedium(size: 16))
                                                                .foregroundColor(.red)
                                                        }
                                                        
                                                        Text("Travel Dates")
                                                            .bold()
                                                            .font(isFontMedium(size: 18))
                                                        
                                                        Text("\(quotation.FromDateString ?? "") - \(quotation.ToDateString ?? "")")
                                                            .font(isFontMedium(size: 16))
                                                        
                                                    }
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .fixedSize(horizontal: false, vertical: true)
                                                    
                                                }
                                                .padding(.vertical,5)
                                                
                                            }
                                        }
                                        .frame(maxWidth: .infinity)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .cornerRadius(10)
                                        .shadow(radius: 2)
                                        .onTapGesture {
                                            quotationIDValue = quotation.QuotationID ?? ""
                                            withAnimation {
                                                navigateGetPremiumPage = true
                                            }
                                        }
                                    }
                                    .onAppear {
                                        if quotation == myQuotationDetailArray.last {
                                            fetchMoreData()
                                        }
                                    }
                                    
                                }
                                .listRowSeparator(.hidden)
                            }
                            .listStyle(.plain)
                        }
                        
                    }
                    
                }
                .onAppear {
                    fetchInitialData()
//                    fetchUserInfo()
                    
                    let model = QuotationFields(navigateDashboard: .constant(false))
                    model.fetchMasterData()
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
                                    navigateMyQuotationPage = false
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
                            
                            Text("My Quotations")
                                .bold()
                                .font(isFontBlack(size: 22))
                                .foregroundColor(.white)
                                .padding(.bottom,8)
                            
                        }
                        
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        HStack(spacing:20) {
                            
                            Button(action: {
                                fromDate = ""
                                toDate = ""
                                fromDateValue = ""
                                toDateValue = ""
                                myQuotationDetailArray = []
                                fetchMyQuotationInfo(pageNo: 1)
                            })
                            {
                                Image(systemName: "arrow.clockwise")
                                    .bold()
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding(.bottom)
                            }
                            
                            Image(systemName: "calendar")
                                .bold()
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding(.bottom)
                                .onTapGesture {
                                    showCompareQuotation = true
                                    fromDate = ""
                                    toDate = ""
                                    fromDateValue = ""
                                    toDateValue = ""
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
                navigateGetPremiumPage ? GetPremiumPage(navigateGetQuotePage: $navigateGetPremiumPage) : nil
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
                                    navigateMyQuotationPage = false
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
                if showCompareQuotation {
                    ZStack {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                showCompareQuotation = false
                            }
                        VStack {
                            HStack {
                                Image(systemName: "xmark")
                                    .font(isFontMedium(size: 22))
                                    .bold()
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        showCompareQuotation = false
                                    }
                                
                                Spacer()
                                Text("Filter Quotations")
                                    .font(isFontMedium(size: 20))
                                    .bold()
                                    .foregroundColor(.white)
                                
                                Spacer()
                            
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(appTheme)
                            
                            VStack(alignment:.leading, spacing:10) {
                                Text("From Date")
                                    .font(isFontMedium(size: 22))
                                    .bold()
                                    .foregroundColor(.black)
                                
                                TextField("From Date", text: $fromDate)
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
                                    .onTapGesture {
                                        showStartDate = true
                                        selectedDate = nil
                                    }
                                
                                Text("End Date")
                                    .font(isFontMedium(size: 22))
                                    .bold()
                                    .foregroundColor(.black)
                                    .padding(.top,10)
                                
                                TextField("End Date", text: $toDate)
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
                                    .onTapGesture {
                                       
                                        if fromDate.isEmpty {
                                            if let errorDict = Extensions.getValidationDict() as? [String: String] {
                                                if let errorMessage = errorDict["VAL001"] {
                                                    self.alertItem = AlertItem(title: Text("VAL001 \n \(errorMessage)"))
                                                }
                                            }
                                        } else {
                                            selectedDate = nil
                                            showEndDate = true
                                            
                                        }
                                    }
                                   
                            }
                            .frame(maxWidth:.infinity,alignment:.leading)
                            .padding()
                            
                            HStack(spacing:20) {
                                
                                Button(action:{
                                    fromDate = ""
                                    toDate = ""
                                })
                                {
                                    Text("CLEAR")
                                        .padding(.all)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .font(isFontMedium(size: 18))
                                        .foregroundColor(.white)
                                        .background(appTheme)
                                        .foregroundColor(.black)
                                        .cornerRadius(8)
                                }
                                
                                Button(action:{
                                    
                                    if fromDate.isEmpty {
                                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                                            if let errorMessage = errorDict["VAL034"] {
                                                self.alertItem = AlertItem(title: Text("VAL034 \n \(errorMessage)"))
                                            }
                                        }
                                    } else {
                                        showCompareQuotation = false
                                        myQuotationDetailArray = []
                                        fetchMyQuotationInfo(pageNo: 1)
                                    }
                                   
                                })
                                {
                                    Text("SEARCH")
                                        .padding(.all)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .font(isFontMedium(size: 18))
                                        .foregroundColor(.white)
                                        .background(appTheme)
                                        .foregroundColor(.black)
                                        .cornerRadius(8)
                                }
                            }
                            .padding([.horizontal, .bottom])
                            
                            
                        }
                        .frame(maxWidth:.infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
                
                if showStartDate {
                    
                    ZStack {
                        Color.black
                            .ignoresSafeArea()
                            .opacity(0.3)
                            .onTapGesture {
                                showStartDate = false
                            }
                        
                        VStack {
                            
                            DatePicker("Start Date", selection: Binding(
                                get: { startDate },
                                set: { startDate = $0 }
                            ), /*in: Date()...,*/ displayedComponents: [.date])
                            .font(isFontMedium(size: 18))
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding(.top)
                            .padding(.trailing)
                            .padding(.leading)
                            
                            HStack(alignment: .top) {
                                
                                Spacer()
                                
                                Button(action: {
                                    
                                    self.showStartDate = false
                                    
                                }) {
                                    Text("CANCEL")
                                        .font(isFontMedium(size: 18))
                                        .foregroundColor(.teal)
                                        .padding(.trailing,30)
                                    
                                    Button(action: {
                                        
                                        // Close the date picker
                                        self.showStartDate.toggle()
                                        
                                        fromDate = dateFormatter.string(from: startDate)
                                        fromDateValue = selectedDateFormatter.string(from: startDate)
                                        
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
                
                if showEndDate {
                    
                    ZStack {
                        Color.black
                            .ignoresSafeArea()
                            .opacity(0.3)
                            .onTapGesture {
                                showEndDate = false
                            }
                        
                        VStack {
                            
                            DatePicker("End Date", selection: Binding(
                                get: { endDate },
                                set: { endDate = $0 }
                            ),in: startDate...,
                            displayedComponents: [.date])
                            .font(isFontMedium(size: 18))
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding(.top)
                            .padding(.trailing)
                            .padding(.leading)
                            
                            HStack(alignment: .top) {
                                
                                Spacer()
                                
                                Button(action: {
                                    
                                    self.showEndDate = false
                                    
                                }) {
                                    Text("CANCEL")
                                        .font(isFontMedium(size: 18))
                                        .foregroundColor(.teal)
                                        .padding(.trailing,30)
                                    
                                    Button(action: {
                                        
                                        // Close the date picker
                                        self.showEndDate.toggle()
                                        
                                        toDate = dateFormatter.string(from: endDate)
                                        toDateValue = selectedDateFormatter.string(from: endDate)
                                        
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
    
    func filteredItems(searchText: String) -> [MyQuotationResponse.MyQuotationRObj.MyQuotation] {
        if searchText.isEmpty {
            return myQuotationDetailArray
        } else {
            
            let filteredItems = myQuotationDetailArray.filter { product in
                return product.QuotationNumber!.lowercased().contains(searchText.lowercased())
            }
            return filteredItems
        }
       
    }
    
    func fetchInitialData() {
        fetchMyQuotationInfo(pageNo: pageNo)
    }
    
    func fetchMoreData() {
        pageNo += 1
        fetchMyQuotationInfo(pageNo: pageNo)
    }
    
    func fetchMyQuotationInfo(pageNo: Int) {
        
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
        
       
        let url = URL(string: "\(baseURL)api/Quotation/MyQuotation")!
        print(url)
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        let authToken:String! = "Bearer " + Extensions.token
                
        request.addValue("\(theJSONData)", forHTTPHeaderField: "clientInfo")
        request.addValue(authToken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("{\"orgAppID\":\"6120\",\"orgGroupID\":\"e6177150-0a4b-46f1-9c27-b55e848a69eb\"}", forHTTPHeaderField: "Webapirequest")
        request.addValue("mobile", forHTTPHeaderField: "source")

        let parameters: [String: Any?] = [
            "PageNo":pageNo,
            "PageSize":10,
            "QuotationNumber":nil,
            "FromDate": fromDateValue.isEmpty ? nil : fromDateValue,
            "ToDate": toDateValue.isEmpty ? nil : toDateValue
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
                    let getResponse = try decoder.decode(MyQuotationResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        isLoading = false
                        
                        if getResponse.rcode == 200 {
                            
                            print(getResponse.rcode)
                            
                            myQuotationDetailArray.append(contentsOf: getResponse.rObj.MyQuotation ?? [])
                            
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
    
}


#Preview {
    MyQuotations(navigateMyQuotationPage: .constant(false))
}






//struct Quotation: Identifiable, Equatable {
//    let id = UUID()
//    let quotation: String
//    let expireon: String
//    let destination: String
//    let travelDates: String
//    let status: String
//    let source: String
//    
//    static func == (lhs: Quotation, rhs: Quotation) -> Bool {
//        return lhs.id == rhs.id
//    }
//}






//ForEach(items.indices, id: \.self) { index in
//    let value = items[index]
//    VStack {
//        ZStack {
//            Color.white
//            
//            VStack {
//                VStack {
//                    ZStack {
//                        appTheme
//                        
//                        Text("Quotation # \(value.quotation)")
//                            .font(isFontMedium(size: 17))
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding(.leading)
//                        
//                        
//                    }
//                    .frame(maxWidth: .infinity)
//                    .frame(height: 40)
//                    
//                    Spacer()
//                }
//                
//                HStack(alignment:.top) {
//                    VStack(alignment:.leading, spacing:10) {
//                        
//                        Text("Expire on")
//                            .bold()
//                            .font(isFontMedium(size: 18))
//                        
//                        Text(value.expireon)
//                            .font(isFontMedium(size: 16))
//                        
//                        Text("Destination")
//                            .bold()
//                            .font(isFontMedium(size: 18))
//                        
//                        Text(value.destination)
//                            .font(isFontMedium(size: 16))
//                        
//                        Text("Travel Dates")
//                            .bold()
//                            .font(isFontMedium(size: 18))
//                        
//                        Text(value.travelDates)
//                            .font(isFontMedium(size: 16))
//                        
//                        
//                    }
//                    .frame(width: 170,alignment:.leading)
//                    .padding(.leading)
//                    .fixedSize(horizontal: false, vertical: true)
//                    
//                    VStack(alignment:.leading, spacing:10) {
//                        
//                        Text("Status")
//                            .bold()
//                            .font(isFontMedium(size: 18))
//                        
//                        Text(value.status)
//                            .font(isFontMedium(size: 16))
//                        
//                        Text("Source")
//                            .bold()
//                            .font(isFontMedium(size: 18))
//                        
//                        Text(value.source)
//                            .font(isFontMedium(size: 16))
//                        
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .fixedSize(horizontal: false, vertical: true)
//                    
//                }
//                .padding(.vertical,5)
//                
//            }
//        }
//        .frame(maxWidth: .infinity)
//        .fixedSize(horizontal: false, vertical: true)
//        .cornerRadius(10)
//        .shadow(radius: 2)
//        .padding(.vertical,5)
//    }
//    .onAppear {
//        if value == items.last {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                items.append(Quotation(quotation: "QAGDOD1239B4", expireon: "30/04/2024", destination: "Hong Kong. Thailand", travelDates: "09/05/2024 - 18/05/2024", status: "Expired", source: "B20"))
//            }
//        }
//    }
//}
