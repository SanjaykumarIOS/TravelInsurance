//
//  ProposalForm.swift
//  TravelInsurance
//
//  Created by SANJAY  on 24/05/24.
//

import SwiftUI

struct ProposalForm: View {
    
    @State private var productName = ""
    @State private var premiumAmount = ""
    @State private var countryCode = "+254"
    @State private var countryCodeList = ["+254"]
    @State private var showCountryCodeList = false
    @State private var selectedCountryCodeIndex: Int?
    @State private var fileUpload = ""
    @State private var isShowingFileUpload = false
    
    @State private var userInfoArray: [ProposalFormResponse.ProposalFormRObj] = []
    
    @State private var showDOBPopup = false
    @State private var selectedDate: Date?
    @State private var selectedDateIndex: Int?
    
    private var endDate: Date {
        Calendar.current.date(byAdding: DateComponents(year: -1), to: Date()) ?? Date()
    }
    
    @State private var showRelationshipPopup = false
    @State private var selectedRelationship: Int?
    
    @State private var isDocumentPickerPresented = false
    @State private var selectedFileIndex: Int?
    @State private var isImagePickerShown = false
    
    @Binding var navigateGetPremiumPage: Bool
    @State var showingBackAlert = false
    @State var navigateDashboardPage = false
    
    @State var showingUnAuthorizedAlert = false
    
    @State var navigatePaymentReviewPage = false
    
    @State private var isLoading = false
    @State private var alertItem: AlertItem?
    
    private var apiDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }
    
    private var isoDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }
    
    var filteredRelationshipInfo: [MasterDataResponseData.MasterDataRObj.RelationshipInfo] {
        return masterDataRelationshipInfo.filter { $0.mdTitle != "Self" }
    }
    
    @State private var selectedDeclaration: [String] = []
    @State private var selectedConsent: [String] = []
    
    var body: some View {
        NavigationStack {
            LoadingView(isShowing: $isLoading) {
                VStack {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing:10) {
                            
                            ForEach(userInfoArray.indices, id: \.self) { index in
                                let quotes = userInfoArray[index]
                                
                                if let quotationID = quotes.Quotations {
                                    Text("Quotation ID: \(quotationID.QuotationNumber ?? "")")
                                        .font(isFontMedium(size: 24))
                                        .bold()
                                        .foregroundColor(rose)
                                }
                            }
                            
                            
                            Text("\("Product Name") \("*")")
                                .halfTextColorChange(fullText: "\("Product Name") \("*")", changeText: "*")
                                .font(isFontMedium(size: 18))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top,10)
                            
                            TextField("Enter product name", text: .constant(productName))
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
                                .overlay {
                                    Color.gray.opacity(0.4)
                                        .cornerRadius(8)
                                }
                            
                            Text("\("Premium Amount") \("*")")
                                .halfTextColorChange(fullText: "\("Premium Amount") \("*")", changeText: "*")
                                .font(isFontMedium(size: 18))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top,10)
                            
                            TextField("Enter premium amount", text: .constant(premiumAmount))
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
                                .overlay {
                                    Color.gray.opacity(0.4)
                                        .cornerRadius(8)
                                }
                            
                            Text("\("Destination(s)") \("*")")
                                .halfTextColorChange(fullText: "\("Destination(s)") \("*")", changeText: "*")
                                .font(isFontMedium(size: 18))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top,10)
                            
                            if !selectedDestinationListValue.isEmpty {
                                HStack {
                                    self.generateContent()
                                    Spacer()
                                }
                            }
                            
                            HStack {
                                VStack {
                                    
                                    Text("\("Trip start date") \("*")")
                                        .halfTextColorChange(fullText: "\("Trip start date") \("*")", changeText: "*")
                                        .font(isFontMedium(size: 16))
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    TextField("dd/mm/yyyy", text: .constant(tripStartDateValue))
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
                                        .overlay {
                                            Color.gray.opacity(0.4)
                                                .cornerRadius(8)
                                        }
                                    
                                }
                                
                                VStack {
                                    Text("\("Trip end date") \("*")")
                                        .halfTextColorChange(fullText: "\("Trip end date") \("*")", changeText: "*")
                                        .font(isFontMedium(size: 16))
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    TextField("dd/mm/yyyy", text: .constant(tripEndDateValue))
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
                                        .overlay {
                                            Color.gray.opacity(0.4)
                                                .cornerRadius(8)
                                        }
                                    
                                }
                            }
                            .padding(.top,10)
                            
                            Text("\("Travelling Days") \("*")")
                                .halfTextColorChange(fullText: "\("Travelling Days") \("*")", changeText: "*")
                                .font(isFontMedium(size: 18))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top,10)
                            
                            TextField("Total no of days", text: .constant(travelingDaysValue))
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
                                .overlay {
                                    Color.gray.opacity(0.4)
                                        .cornerRadius(8)
                                }
                            
                            Text("\("No of Travellers") \("*")")
                                .halfTextColorChange(fullText: "\("No of Travellers") \("*")", changeText: "*")
                                .font(isFontMedium(size: 18))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top,10)
                            
                            TextField("Enter travellers count", text: .constant(numberOfTravelersValue))
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
                                .overlay {
                                    Color.gray.opacity(0.4)
                                        .cornerRadius(8)
                                }
                            
                            VStack {
                                
                                Text("\("KRA Pin Type") \("*")")
                                    .halfTextColorChange(fullText: "\("KRA Pin Type") \("*")", changeText: "*")
                                    .font(isFontMedium(size: 18))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top,10)
                                
                                HStack(spacing:15) {
                                    ForEach(masterDatakRAPintype.indices, id: \.self) { index in
                                        let value = masterDatakRAPintype[index]
                                        
                                        Button(action: {
                                            isLoading = true
                                            userInfoArray.first?.Quotations?.KRAPinTypeID = value.masterDataID ?? ""
                                            isLoading = false
                                        }) {
                                            HStack {
                                                Image(systemName:  userInfoArray.first?.Quotations?.KRAPinTypeID == value.masterDataID ? "largecircle.fill.circle" : "circle")
                                                    .resizable()
                                                    .frame(width: 25, height: 25)
                                                    .foregroundColor(rose)
                                                
                                                Text(value.mdTitle ?? "")
                                                    .font(isFontMedium(size: 18))
                                                    .foregroundColor(.black)
                                                
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                                
                                
                                Text("\("KRA Pin Number") \("*")")
                                    .halfTextColorChange(fullText: "\("KRA Pin Number") \("*")", changeText: "*")
                                    .font(isFontMedium(size: 18))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top,10)
                                
                                TextField("", text: Binding (
                                    get: { userInfoArray.first?.Quotations?.KRAPinNumber ?? "" },
                                    set: { userInfoArray.first?.Quotations?.KRAPinNumber = $0 }
                                ))
                                .padding(.all)
                                .textInputAutocapitalization(.characters)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .font(isFontMedium(size: 18))
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                                .background(Color.gray.opacity(0.2))
                                .foregroundColor(.black)
                                .cornerRadius(8)
                                .overlay {
                                    ZStack {
                                        if userInfoArray.first?.Quotations?.KRAPinTypeID?.isEmpty ?? true || userInfoArray.first?.Quotations?.KRAPinTypeID == "00000000-0000-0000-0000-000000000000" {
                                            Color.gray.opacity(0.4)
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                                .onChange(of: userInfoArray.first?.Quotations?.KRAPinNumber ?? "") { newValue in
                                    isLoading = true
                                    isLoading = false
                                    userInfoArray.first?.Quotations?.KRAPinNumber = newValue.uppercased()
                                }
                                
                                Text("Ex: A123456789X")
                                    .font(isFontMedium(size: 15))
                                    .foregroundColor(.black.opacity(0.5))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                
                                Text("\("Insured's Occupation") \("*")")
                                    .halfTextColorChange(fullText: "\("Insured's Occupation") \("*")", changeText: "*")
                                    .font(isFontMedium(size: 18))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top,10)
                                
                                TextField("", text: Binding (
                                    get: { userInfoArray.first?.Quotations?.Occupation ?? "" },
                                    set: { userInfoArray.first?.Quotations?.Occupation = $0 }
                                ))
                                .padding(.all)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .font(isFontMedium(size: 18))
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                                .background(Color.gray.opacity(0.2))
                                .foregroundColor(.black)
                                .cornerRadius(8)
                                
                                Text("\("Beneficiary Name") \("*")")
                                    .halfTextColorChange(fullText: "\("Beneficiary Name") \("*")", changeText: "*")
                                    .font(isFontMedium(size: 18))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top,10)
                                
                                TextField("", text: Binding (
                                    get: { userInfoArray.first?.Quotations?.BeneficiaryName ?? "" },
                                    set: { userInfoArray.first?.Quotations?.BeneficiaryName = $0 }
                                ))
                                .padding(.all)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .font(isFontMedium(size: 18))
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                                .background(Color.gray.opacity(0.2))
                                .foregroundColor(.black)
                                .cornerRadius(8)
                                
                                Text("\("Beneficiary Mobile Number") \("*")")
                                    .halfTextColorChange(fullText: "\("Beneficiary Mobile Number") \("*")", changeText: "*")
                                    .font(isFontMedium(size: 18))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top,10)
                                
                                TextField("", text: Binding (
                                    get: { userInfoArray.first?.Quotations?.BeneficiaryPhoneNumber ?? "" },
                                    set: { userInfoArray.first?.Quotations?.BeneficiaryPhoneNumber = $0 }
                                ))
                                .padding(.all)
                                .keyboardType(.numberPad)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .font(isFontMedium(size: 18))
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                                .background(Color.gray.opacity(0.2))
                                .foregroundColor(.black)
                                .cornerRadius(8)
                                .onChange(of: userInfoArray.first?.Quotations?.BeneficiaryPhoneNumber ?? "") { newValue in
                                    isLoading = true
                                    isLoading = false
                                    let filtered = newValue.filter { $0.isNumber }
                                    if filtered.count > 9 {
                                        userInfoArray.first?.Quotations?.BeneficiaryPhoneNumber = String(filtered.prefix(9))
                                    } else {
                                        userInfoArray.first?.Quotations?.BeneficiaryPhoneNumber = filtered
                                    }
                                }
                            }
                            
                            
                            VStack {
                                Text("Address")
                                    .font(isFontMedium(size: 24))
                                    .bold()
                                    .foregroundColor(rose)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top,10)
                                
                                Text("\("House Number") \("*")")
                                    .halfTextColorChange(fullText: "\("House Number") \("*")", changeText: "*")
                                    .font(isFontMedium(size: 18))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top,10)
                                
                                TextField("", text: Binding (
                                    get: { userInfoArray.first?.Quotations?.AddressLine1 ?? "" },
                                    set: { userInfoArray.first?.Quotations?.AddressLine1 = $0 }
                                ))
                                .padding(.all)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .font(isFontMedium(size: 18))
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                                .background(Color.gray.opacity(0.2))
                                .foregroundColor(.black)
                                .cornerRadius(8)
                                
                                Text("\("Road Name") \("*")")
                                    .halfTextColorChange(fullText: "\("Road Name") \("*")", changeText: "*")
                                    .font(isFontMedium(size: 18))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top,10)
                                
                                TextField("", text: Binding(
                                    get: { userInfoArray.first?.Quotations?.AddressLine2 ?? "" },
                                    set: { userInfoArray.first?.Quotations?.AddressLine2 = $0 }
                                ))
                                .padding(.all)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .font(isFontMedium(size: 18))
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                                .background(Color.gray.opacity(0.2))
                                .foregroundColor(.black)
                                .cornerRadius(8)
                                
                                Text("\("Pin Code") \("*")")
                                    .halfTextColorChange(fullText: "\("Pin Code") \("*")", changeText: "*")
                                    .font(isFontMedium(size: 18))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top,10)
                                
                                TextField("", text: Binding(
                                    get: { userInfoArray.first?.Quotations?.AddressLine3 ?? "" },
                                    set: { userInfoArray.first?.Quotations?.AddressLine3 = $0 }
                                ))
                                .keyboardType(.numberPad)
                                .padding(.all)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .font(isFontMedium(size: 18))
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                                .background(Color.gray.opacity(0.2))
                                .foregroundColor(.black)
                                .cornerRadius(8)
                                
                                ForEach(userInfoArray.indices, id: \.self) { index in
                                    let quotes = userInfoArray[index]
                                    
                                    if let traveller = quotes.Traveller {
                                        ForEach(traveller.indices, id: \.self) { indexValue in
                                            let travel = traveller[indexValue]
                                            
                                            VStack {
                                                HStack {
                                                    Text("Traveler \(indexValue + 1)")
                                                        .font(isFontMedium(size: 20))
                                                        .bold()
                                                        .foregroundColor(rose)
                                                    
                                                    Spacer()
                                                    
                                                    Text("Is this Proposer?")
                                                        .font(isFontMedium(size: 15))
                                                        .foregroundColor(.gray)
                                                    
                                                    Button(action: {
                                                        
                                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                                    })
                                                    {
                                                        Image(systemName: travel.IsPolicyHolder ? "checkmark.square.fill" : "square")
                                                            .font(isFontMedium(size: 21))
                                                            .bold()
                                                            .foregroundColor(rose)
                                                    }
                                                    .disabled(true)
                                                    
                                                }
                                                
                                                HStack {
                                                    VStack {
                                                        
                                                        Text("\("First Name") \("*")")
                                                            .halfTextColorChange(fullText: "\("First Name") \("*")", changeText: "*")
                                                            .font(isFontMedium(size: 18))
                                                            .bold()
                                                            .frame(maxWidth: .infinity, alignment: .leading)
                                                        
                                                        TextField("", text: Binding(
                                                            get: { travel.FirstName ?? "" },
                                                            set: { travel.FirstName = $0 }
                                                        ))
                                                        .padding(.all)
                                                        .frame(maxWidth: .infinity)
                                                        .frame(height: 50)
                                                        .font(isFontMedium(size: 18))
                                                        .autocapitalization(.none)
                                                        .autocorrectionDisabled()
                                                        .background(Color.gray.opacity(0.2))
                                                        .foregroundColor(.black)
                                                        .cornerRadius(8)
                                                        
                                                    }
                                                    
                                                    VStack {
                                                        Text("\("Last Name") \("*")")
                                                            .halfTextColorChange(fullText: "\("Last Name") \("*")", changeText: "*")
                                                            .font(isFontMedium(size: 16))
                                                            .bold()
                                                            .frame(maxWidth: .infinity, alignment: .leading)
                                                        
                                                        TextField("", text: Binding(
                                                            get: { travel.LastName ?? "" },
                                                            set: { travel.LastName = $0 }
                                                        ))
                                                        .padding(.all)
                                                        .frame(maxWidth: .infinity)
                                                        .frame(height: 50)
                                                        .font(isFontMedium(size: 18))
                                                        .autocapitalization(.none)
                                                        .autocorrectionDisabled()
                                                        .background(Color.gray.opacity(0.2))
                                                        .foregroundColor(.black)
                                                        .cornerRadius(8)
                                                        
                                                    }
                                                }
                                                .padding(.top,10)
                                                
                                                VStack(alignment:.leading) {
                                                    Text("\("Name as per the passport") \("*")")
                                                        .halfTextColorChange(fullText: "\("Name as per the passport") \("*")", changeText: "*")
                                                        .font(isFontMedium(size: 18))
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .padding(.top,10)
                                                    
                                                    TextField("", text: Binding(
                                                        get: { travel.Fullname ?? "" },
                                                        set: { travel.Fullname = $0 }
                                                    ))
                                                    .padding(.all)
                                                    .frame(maxWidth: .infinity)
                                                    .frame(height: 50)
                                                    .font(isFontMedium(size: 18))
                                                    .autocapitalization(.none)
                                                    .autocorrectionDisabled()
                                                    .background(Color.gray.opacity(0.2))
                                                    .foregroundColor(.black)
                                                    .cornerRadius(8)
                                                }
                                                
                                                
                                                Text("\("Email") \("*")")
                                                    .halfTextColorChange(fullText: "\("Email") \("*")", changeText: "*")
                                                    .font(isFontMedium(size: 18))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.top,10)
                                                
                                                TextField("", text: Binding(
                                                    get: { travel.EmailId ?? "" },
                                                    set: { travel.EmailId = $0 }
                                                ))
                                                .padding(.all)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 50)
                                                .font(isFontMedium(size: 18))
                                                .autocapitalization(.none)
                                                .autocorrectionDisabled()
                                                .background(Color.gray.opacity(0.2))
                                                .foregroundColor(.black)
                                                .cornerRadius(8)
                                                .keyboardType(.emailAddress)
                                                
                                                HStack {
                                                    
                                                    VStack {
                                                        Text("\("Date of birth") \("*")")
                                                            .halfTextColorChange(fullText: "\("Date of birth") \("*")", changeText: "*")
                                                            .font(isFontMedium(size: 18))
                                                            .frame(maxWidth: .infinity, alignment: .leading)
                                                            .padding(.top,10)
                                                        
                                                        TextField("", text: Binding (
                                                            get: {
                                                                if let dob = travel.DOB, let date = isoDateFormatter.date(from: dob) {
                                                                    return dateFormatter.string(from: date)
                                                                }
                                                                return ""
                                                            },
                                                            set: {
                                                                if let date = dateFormatter.date(from: $0) {
                                                                    travel.DOB = isoDateFormatter.string(from: date)
                                                                } else {
                                                                    travel.DOB = nil
                                                                }
                                                            }
                                                        ))
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
                                                            showDOBPopup = true
                                                            selectedDateIndex = indexValue
                                                            selectedDate = nil
                                                        }
                                                    }
                                                    
                                                    VStack {
                                                        Text("\("Age") \("*")")
                                                            .halfTextColorChange(fullText: "\("Age") \("*")", changeText: "*")
                                                            .font(isFontMedium(size: 18))
                                                            .frame(maxWidth: .infinity, alignment: .leading)
                                                            .padding(.top,10)
                                                        
                                                        var ageString = travel.Age != nil ? String(travel.Age!) : ""
                                                        TextField("", text: Binding(
                                                            get: { ageString },
                                                            set: { ageString = $0 }
                                                        ))
                                                        .disabled(true)
                                                        .padding(.all)
                                                        .frame(width: 100,height: 50)
                                                        .font(isFontMedium(size: 18))
                                                        .autocapitalization(.none)
                                                        .autocorrectionDisabled()
                                                        .background(Color.gray.opacity(0.2))
                                                        .foregroundColor(.black)
                                                        .cornerRadius(8)
                                                        .overlay {
                                                            Color.gray.opacity(0.4)
                                                                .cornerRadius(8)
                                                        }
                                                    }
                                                    .frame(width: 100)
                                                }
                                                
                                                Text("\("Mobile Number") \("*")")
                                                    .halfTextColorChange(fullText: "\("Mobile Number") \("*")", changeText: "*")
                                                    .font(isFontMedium(size: 18))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.top,10)
                                                
                                                HStack {
                                                    HStack {
                                                        var phoneNumberCountryCode: String {
                                                            get {
                                                                if let code = travel.PhoneNumberCountryCode, code != 0 {
                                                                    return "+\(code)"
                                                                } else {
                                                                    return ""
                                                                }
                                                            }
                                                            set {
                                                                // Remove the "+" prefix if present
                                                                let sanitizedValue = newValue.trimmingCharacters(in: CharacterSet(charactersIn: "+"))
                                                                if let newCode = Int(sanitizedValue) {
                                                                    travel.PhoneNumberCountryCode = newCode
                                                                } else {
                                                                    travel.PhoneNumberCountryCode = 0
                                                                }
                                                            }
                                                        }
                                                        
                                                        TextField("Select", text: Binding(
                                                            get: { phoneNumberCountryCode },
                                                            set: { phoneNumberCountryCode = $0 }
                                                        ))
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
                                                        selectedCountryCodeIndex = indexValue
                                                    }
                                                    
                                                    
                                                    TextField("", text: Binding (
                                                        get: { travel.sPhoneNumber ?? "" },
                                                        set: {
                                                            let filtered = $0.filter { $0.isNumber }
                                                            if filtered.count <= 9 {
                                                                travel.sPhoneNumber = filtered
                                                            }
                                                        }
                                                    ))
                                                    .padding(.all)
                                                    .frame(maxWidth: .infinity)
                                                    .frame(height: 50)
                                                    .font(isFontMedium(size: 18))
                                                    .autocapitalization(.none)
                                                    .autocorrectionDisabled()
                                                    .background(Color.gray.opacity(0.2))
                                                    .foregroundColor(.black)
                                                    .cornerRadius(8)
                                                    .keyboardType(.numberPad)
                                                    .onChange(of: travel.sPhoneNumber ?? "") { newValue in
                                                        let filtered = newValue.filter { $0.isNumber }
                                                        if filtered.count > 9 {
                                                            travel.sPhoneNumber = String(filtered.prefix(9))
                                                        } else {
                                                            travel.sPhoneNumber = filtered
                                                        }
                                                    }
                                                }
                                                
                                                HStack(alignment:.bottom) {
                                                    
                                                    VStack {
                                                        Text("\("Passport Number") \("*")")
                                                            .halfTextColorChange(fullText: "\("Passport Number") \("*")", changeText: "*")
                                                            .font(isFontMedium(size: 18))
                                                            .frame(maxWidth: .infinity, alignment: .leading)
                                                            .padding(.top,10)
                                                        
                                                        TextField("", text: Binding (
                                                            get: { travel.PolicyHolderPassPortNumber ?? "" },
                                                            set: { travel.PolicyHolderPassPortNumber = $0 }
                                                        ))
                                                        .padding(.all)
                                                        .frame(maxWidth: .infinity)
                                                        .frame(height: 50)
                                                        .font(isFontMedium(size: 18))
                                                        .autocapitalization(.none)
                                                        .autocorrectionDisabled()
                                                        .background(Color.gray.opacity(0.2))
                                                        .foregroundColor(.black)
                                                        .cornerRadius(8)
                                                    }
                                                    
                                                    VStack {
                                                        Text("\("Relationship with the proposer") \("*")")
                                                            .halfTextColorChange(fullText: "\("Relationship with the proposer") \("*")", changeText: "*")
                                                            .font(isFontMedium(size: 18))
                                                            .frame(maxWidth: .infinity, alignment: .leading)
                                                            .padding(.top,10)
                                                        
                                                        HStack {
                                                            
                                                            TextField("Select", text: Binding(
                                                                get: { travel.RelationshipName ?? "" },
                                                                set: { travel.RelationshipName = $0 }
                                                            ))
                                                            .disabled(true)
                                                            .font(isFontMedium(size: 18))
                                                            .autocapitalization(.none)
                                                            .autocorrectionDisabled()
                                                            .overlay {
                                                                
                                                                Image(systemName: "chevron.down")
                                                                    .bold()
                                                                    .foregroundColor(.black)
                                                                    .font(isFontMedium(size: 18))
                                                                    .frame(maxWidth: .infinity,alignment:.trailing)
                                                            }
                                                            
                                                        }
                                                        .padding(.all)
                                                        .frame(maxWidth: .infinity)
                                                        .frame(height: 50)
                                                        .background(Color.gray.opacity(0.2))
                                                        .foregroundColor(.black)
                                                        .cornerRadius(8)
                                                        .overlay {
                                                            ZStack {
                                                                if travel.IsPolicyHolder {
                                                                    Color.gray.opacity(0.4)
                                                                        .cornerRadius(8)
                                                                }
                                                            }
                                                        }
                                                        .onTapGesture {
                                                            if !masterDataRelationshipInfo.isEmpty {
                                                                showRelationshipPopup = true
                                                                
                                                                selectedRelationship = indexValue
                                                            }
                                                        }
                                                        .disabled(travel.IsPolicyHolder)
                                                        
                                                    }
                                                    .onAppear {
                                                        if travel.IsPolicyHolder {
                                                            isLoading = true
                                                            isLoading = false
                                                            travel.RelationshipName = "Self"
                                                            travel.RelationshipTypeID =
                                                            "eaf41d97-4dd2-4406-b351-5424e55507b2"
                                                            
                                                        }
                                                        
                                                        if travel.PassportAttachmentID != "00000000-0000-0000-0000-000000000000" {
                                                            
                                                            isLoading = true
                                                            isLoading = false
                                                            
                                                            travel.FileUpload = "File Uploaded"
                                                        }
                                                    }
                                                }
                                                
                                                
                                                Text("\("Upload Passport") \("*")")
                                                    .halfTextColorChange(fullText: "\("Upload Passport") \("*")", changeText: "*")
                                                    .font(isFontMedium(size: 18))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.top,10)
                                                
                                                HStack(spacing:0) {
                                                    
                                                    HStack {
                                                        Text("Choose \n file")
                                                            .padding(.horizontal,10)
                                                            .font(isFontMedium(size: 15))
                                                            .autocapitalization(.none)
                                                            .autocorrectionDisabled()
                                                            .multilineTextAlignment(.center)
                                                    }
                                                    .frame(height: 50)
                                                    .background(appTheme)
                                                    .foregroundColor(.white)
                                                    .fixedSize(horizontal: true, vertical: true)
                                                    
                                                    TextField("", text: Binding(
                                                        get: { travel.FileUpload ?? "No file choosen" },
                                                        set: { travel.FileUpload = $0 }
                                                    ))
                                                    .disabled(true)
                                                    .padding(.horizontal,10)
                                                    .font(isFontMedium(size: 18))
                                                    .autocapitalization(.none)
                                                    .autocorrectionDisabled()
                                                    .foregroundColor(.black)
                                                    .frame(height: 50)
                                                    .overlay {
                                                        Color.gray.opacity(0.4)
                                                            .cornerRadius(8)
                                                    }
                                                    
                                                }
                                                .padding(.vertical)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 50)
                                                .background(Color.gray.opacity(0.2))
                                                .cornerRadius(8)
                                                .onTapGesture {
                                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                                    
                                                    selectedFileIndex = indexValue
                                                    isShowingFileUpload = true
                                                }
                                                .sheet(isPresented: $isDocumentPickerPresented) {
                                                    UIKitDocumentPickerViewController(completion: { urls in
                                                        if let selectedURL = urls.first {
                                                            
                                                            let fileSize = fileSizeInMB(for: selectedURL)
                                                            if fileSize <= 2.0 {
                                                                fetchFileUpload(currentFile: selectedURL)
                                                                
                                                                print("File Name = \(selectedURL.lastPathComponent)")
                                                                
                                                            } else {
                                                                print("Please upload the Image file that does not exceed 2 MB.")
                                                                
                                                                self.alertItem = AlertItem(title: Text("Please upload the Image file that does not exceed 2 MB."))
                                                                
                                                            }
                                                        }
                                                    })
                                                }
                                                .sheet(isPresented: $isImagePickerShown) {
                                                    ImagePicker(isShown: $isImagePickerShown) { url in
                                                        fetchFileUpload(currentFile: url)
                                                    }
                                                }
                                                
                                            }
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.white)
                                            .cornerRadius(8)
                                            .shadow(radius: 4)
                                            .padding(.vertical,6)
                                            
                                        }
                                    }
                                }
                                
                            }
                            
                            VStack {
                                
                                Button(action: {
                                    if selectedDeclaration.count == masterDataDeclaration.count {
                                        selectedDeclaration.removeAll()
                                    } else {
                                        selectedDeclaration = masterDataDeclaration.map { $0.masterDataID ?? "" }
                                    }
                                }) {
                                    HStack(alignment:.top) {
                                        Image(systemName: selectedDeclaration.count == masterDataDeclaration.count ? "checkmark.square.fill" : "square")
                                            .resizable()
                                            .frame(width:20,height:20)
                                            .foregroundColor(rose)
                                        
                                        Text("DECLARATION (I/We declare that) :")
                                            .foregroundColor(appTheme)
                                            .font(isFontBlack(size: 20))
                                        
                                        Spacer()
                                    }
                                }
                                
                                ForEach(masterDataDeclaration.indices, id: \.self) { indexValue in
                                    
                                    let declaration = masterDataDeclaration[indexValue]
                                    
                                    Button(action: {
                                        
                                        if let id = declaration.masterDataID {
                                            if selectedDeclaration.contains(id) {
                                                selectedDeclaration.removeAll(where: { $0 == id })
                                            } else {
                                                selectedDeclaration.append(id)
                                            }
                                        }
                                        
                                    }) {
                                        HStack(alignment:.top,spacing:8) {
                                            Image(systemName: selectedDeclaration.contains(declaration.masterDataID ?? "") ? "checkmark.square.fill" : "square")
                                                .resizable()
                                                .frame(width:20,height:20)
                                                .foregroundColor(rose)
                                            
                                            Text(declaration.mdTitle ?? "")
                                                .foregroundColor(.black)
                                                .font(isFontMedium(size: 17))
                                                .multilineTextAlignment(.leading)
                                            
                                            Spacer()
                                        }
                                        .padding(.vertical,5)
                                    }
                                    
                                }
                                
                                
                                Button(action: {
                                    if selectedConsent.count == masterDataConsent.count {
                                        selectedConsent.removeAll()
                                    } else {
                                        selectedConsent = masterDataConsent.map { $0.masterDataID ?? "" }
                                    }
                                }) {
                                    HStack(alignment:.top) {
                                        Image(systemName: selectedConsent.count == masterDataConsent.count ? "checkmark.square.fill" : "square")
                                            .resizable()
                                            .frame(width:20,height:20)
                                            .foregroundColor(rose)
                                        
                                        Text("CONSENT (I/We Consent that) :")
                                            .foregroundColor(appTheme)
                                            .font(isFontBlack(size: 20))
                                        
                                        Spacer()
                                    }
                                    .padding(.top,10)
                                }
                                
                                ForEach(masterDataConsent.indices, id: \.self) { indexValue in
                                    
                                    let declaration = masterDataConsent[indexValue]
                                    
                                    Button(action: {
                                        
                                        if let id = declaration.masterDataID {
                                            if selectedConsent.contains(id) {
                                                selectedConsent.removeAll(where: { $0 == id })
                                            } else {
                                                selectedConsent.append(id)
                                            }
                                        }
                                        
                                    }) {
                                        HStack(alignment:.top,spacing:8) {
                                            Image(systemName: selectedConsent.contains(declaration.masterDataID ?? "") ? "checkmark.square.fill" : "square")
                                                .resizable()
                                                .frame(width:20,height:20)
                                                .foregroundColor(rose)
                                            
                                            Text(declaration.mdTitle ?? "")
                                                .foregroundColor(.black)
                                                .font(isFontMedium(size: 17))
                                                .multilineTextAlignment(.leading)
                                            
                                            Spacer()
                                        }
                                        .padding(.vertical,5)
                                    }
                                    
                                }
                                
                            }
                            .padding(.top,12)
                        }
                        .padding()
                        
                    }
                    
                    VStack {
                        
                        Button(action: {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            
                            proposalFormValidation()
                            
                        }) {
                            Text("PROCEED TO BUY >>")
                                .padding(.top)
                                .frame(maxWidth: .infinity)
                                .background(rose)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .font(isFontBold(size: 22))
                        }
                        
                    }
                }
                .onAppear {
                    
                    isLoading = true
                    fetchUserInfo()
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
                                
                                //                                if Extensions.navigateProposalForm == true {
                                //                                    showingBackAlert = true
                                //                                } else {
                                //                                    withAnimation {
                                //                                        navigateGetPremiumPage = false
                                //                                    }
                                //                                }
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                
                                showingBackAlert = true
                            })
                            {
                                Image(systemName: "arrow.backward")
                                    .bold()
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding(.bottom)
                            }
                            
                            .alert(isPresented: $showingBackAlert) {
                                Alert (
                                    title: Text("Alert"),
                                    message: Text("If you click Yes, all previously stored data will be deleted. Are you sure?"),
                                    primaryButton: .default(Text("Yes")) {
                                        
                                        withAnimation {
                                            navigateDashboardPage = true
                                        }
                                        selectedDestinationListValue = []
                                        showingBackAlert = false
                                        //                                        Extensions.navigateProposalForm = false
                                        
                                    },
                                    secondaryButton: .cancel(Text("No")) {
                                        showingBackAlert = false
                                    }
                                )
                            }
                            
                            Text("Proposal Form")
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
                navigatePaymentReviewPage ? PaymentReviewPage(productName: $productName, premiumAmount: $premiumAmount, navigatePaymentReviewPage: $navigatePaymentReviewPage) : nil
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
                if showRelationshipPopup {
                    ZStack {
                        Color.black.opacity(0.1)
                            .ignoresSafeArea()
                            .onTapGesture {
                                showRelationshipPopup = false
                            }
                        
                        List {
                            ForEach(filteredRelationshipInfo.indices, id: \.self) { index in
                                let relation = filteredRelationshipInfo[index]
                                
                                Button(action: {
                                    for value in userInfoArray {
                                        if let data = value.Traveller {
                                            for (index, travel) in data.enumerated() {
                                                if selectedRelationship == index {
                                                    travel.RelationshipName = relation.mdTitle ?? ""
                                                    travel.RelationshipTypeID = relation.masterDataID ?? ""
                                                }
                                            }
                                        }
                                    }
                                    
                                    showRelationshipPopup = false
                                }) {
                                    Text(relation.mdTitle ?? "")
                                        .font(isFontMedium(size: 18))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundColor(.black)
                                        .padding(.vertical, 10)
                                }
                            }
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .frame(height: 300)
                        .cornerRadius(1)
                        .shadow(radius: 1)
                    }
                }
                
                if showDOBPopup {
                    ZStack {
                        Color.black
                            .opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                showDOBPopup = false
                            }
                        
                        VStack {
                            
                            DatePicker (
                                "Select Date",
                                selection: Binding (
                                    get: {
                                        selectedDate ?? Date()
                                    },
                                    set: {
                                        selectedDate = $0
                                    }
                                ),
                                in: ...endDate,
                                displayedComponents: .date
                            )
                            .font(isFontMedium(size: 18))
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding(.top)
                            .padding(.horizontal)
                            
                            
                            HStack(alignment: .top) {
                                
                                Spacer()
                                
                                Button(action: {
                                    
                                    self.showDOBPopup = false
                                    
                                }) {
                                    Text("CANCEL")
                                        .font(isFontMedium(size: 18))
                                        .foregroundColor(.teal)
                                        .padding(.trailing,30)
                                    
                                    Button(action: {
                                        
                                        self.showDOBPopup.toggle()
                                        
                                        for value in userInfoArray {
                                            if let data = value.Traveller {
                                                for (index, travel) in data.enumerated() {
                                                    if selectedDateIndex == index {
                                                        
                                                        travel.DOB = isoDateFormatter.string(from: selectedDate ?? endDate)
                                                        travel.Age = calculateAge(from:  travel.DOB ?? "") ?? 0
                                                    }
                                                }
                                            }
                                        }
                                        
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
                
                if showCountryCodeList {
                    ZStack {
                        Color.black.opacity(0.1)
                            .ignoresSafeArea()
                            .onTapGesture {
                                showCountryCodeList = false
                            }
                        
                        VStack {
                            ForEach(countryCodeList, id: \.self) { code in
                                
                                Button(action: {
                                    showCountryCodeList = false
                                    for value in userInfoArray {
                                        if let data = value.Traveller {
                                            for (index, travel) in data.enumerated() {
                                                if selectedCountryCodeIndex == index {
                                                    
                                                    travel.PhoneNumberCountryCode = Int(code.trimmingCharacters(in: CharacterSet(charactersIn: "+"))) ?? 0
                                                    
                                                }
                                            }
                                        }
                                    }
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
                
                if isShowingFileUpload {
                    ZStack {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                            .onTapGesture {
                                isShowingFileUpload = false
                            }
                        
                        VStack {
                            
                            HStack {
                                Image(systemName: "xmark")
                                    .font(isFontMedium(size: 22))
                                    .bold()
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        isShowingFileUpload = false
                                    }
                                
                                Spacer()
                                Text("Upload File")
                                    .font(isFontMedium(size: 20))
                                    .bold()
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(appTheme)
                            
                            HStack {
                                VStack(spacing:10) {
                                    Image("camera")
                                        .resizable()
                                        .frame(width: 40,height: 40)
                                    
                                    Text("Camera")
                                        .font(isFontMedium(size: 18))
                                        .bold()
                                }
                                .padding(20)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(.horizontal,20)
                                .onTapGesture {
                                    isImagePickerShown = true
                                    isShowingFileUpload = false
                                }
                                
                                Spacer()
                                
                                VStack(spacing:10) {
                                    Image("gallery")
                                        .resizable()
                                        .frame(width: 40,height: 40)
                                    
                                    Text("Gallery")
                                        .font(isFontMedium(size: 18))
                                        .bold()
                                }
                                .padding(20)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(.horizontal,20)
                                .onTapGesture {
                                    isDocumentPickerPresented = true
                                    isShowingFileUpload = false
                                }
                            }
                            .padding()
                            
                            
                        }
                        .frame(maxWidth:.infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding()
                    }
                }
            }
    }
    
    func calculateAge(from dateString: String, format: String = "yyyy-MM-dd'T'HH:mm:ss") -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let birthDate = dateFormatter.date(from: dateString) else {
            return nil
        }
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
        return ageComponents.year
    }
    
    private func fileSizeInMB(for url: URL) -> Double {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: url.path)
            if let fileSize = fileAttributes[FileAttributeKey.size] as? Double {
                return fileSize / (1024 * 1024)
            }
        } catch {
            print("Error: \(error)")
        }
        return 0.0
    }
    
    private func generateContent() -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(selectedDestinationListValue.indices, id: \.self) { index in
                let platform = selectedDestinationListValue[index]
                self.item(for: platform, index: index)
                    .padding(5)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > UIScreen.main.bounds.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if index == selectedDestinationListValue.count - 1 {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if index == selectedDestinationListValue.count - 1 {
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
                .foregroundColor(.black)
        }
        .frame(height: 35)
        .frame(width: .infinity)
        .padding(.horizontal,8)
        .background(Color.gray.opacity(0.2))
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
            "QuotationID": getPremiumQuotationIDValue, "QuotesID": quotesIDValue
            //            "QuotationID": "f8fe0260-7f0c-48a8-b60a-6fe985c0f67a", "QuotesID": "085917fe-08fd-465b-9471-9b94576dbe68"
            //            "QuotationID": "7a640e89-5504-4edb-ae0c-39e0fe689dba", "QuotesID": "f233ff8a-4d43-474e-befd-18401bfff036"
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
                
                if let rObjs = resultDictionary["rObj"] as? NSDictionary,
                   let quotes = rObjs["Quotes"] as? NSDictionary,
                   let totalAmount = quotes["TotalAmount"] as? Double {
                    print("Total Amount: \(totalAmount)")
                } else {
                    print("Total Amount not found in the JSON response.")
                }
                
                if rcode == 200 {
                    let decoder = JSONDecoder()
                    let getResponse = try decoder.decode(ProposalFormResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        isLoading = false
                        
                        if getResponse.rcode == 200 {
                            
                            print(getResponse.rcode)
                            
                            userInfoArray = [getResponse.rObj]
                            
                            productName = getResponse.rObj.Quotes?.ProductName ?? ""
                            premiumAmount = getResponse.rObj.Quotes?.sTotalAmount ?? ""
                            tripStartDateValue = getResponse.rObj.Quotations?.FromDateString ?? ""
                            tripEndDateValue = getResponse.rObj.Quotations?.ToDateString ?? ""
                            travelingDaysValue = String(getResponse.rObj.Quotations?.NoofDays ?? 0)
                            numberOfTravelersValue = String(getResponse.rObj.Quotations?.NoofTravellers ?? 0)
                            
                            for data in userInfoArray {
                                if let declaration = data.declarations {
                                    for value in declaration {
                                        
                                        if let declarationID = value.declarationid {
                                            
                                            for masterData in masterDataDeclaration {
                                                if masterData.masterDataID == declarationID {
                                                    selectedDeclaration.append(declarationID)
                                                }
                                            }
                                            
                                            for consentMasterData in masterDataConsent {
                                                if consentMasterData.masterDataID == declarationID {
                                                    selectedConsent.append(declarationID)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            if let destinationCountryName = getResponse.rObj.Quotations?.DestinationCountryName {
                                selectedDestinationListValue = destinationCountryName.split(separator: ",").map { String($0) }
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
                print("\("Error decoding response") \(error)")
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
    
    func fetchFileUpload(currentFile: URL) {
        
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
        
        let url = URL(string: "\(baseURL)api/FileUpload/InsertPassport")!
        
        let boundary = UUID().uuidString
        
        let request = NSMutableURLRequest(url: url)
        
        request.httpMethod = "POST"
        
        let authToken:String! = "Bearer " + Extensions.token
        
        request.addValue("\(theJSONData)", forHTTPHeaderField: "clientInfo")
        request.addValue(authToken, forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("{\"orgAppID\":\"6120\",\"orgGroupID\":\"e6177150-0a4b-46f1-9c27-b55e848a69eb\"}", forHTTPHeaderField: "Webapirequest")
        request.addValue("mobile", forHTTPHeaderField: "source")
        
        var data = Data()
        
        // Add file data
        do {
            let fileData = try Data(contentsOf: currentFile)
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"file\"; fileName=\"\(currentFile.lastPathComponent)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
            data.append(fileData)
            
            data.append("\r\n".data(using: .utf8)!)
            
        } catch {
            print("Error loading file data: \(error)")
            return
        }
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let data = data else {
                print("Error: No data returned from server. \(error?.localizedDescription ?? "")")
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
                        
                        if let rObj = resultDictionary["rObj"] as? [String: Any],
                           let attachmentID = rObj["AttachmentID"] as? String {
                            print("AttachmentID = \(attachmentID)")
                            
                            for value in userInfoArray {
                                if let data = value.Traveller {
                                    for (index, travel) in data.enumerated() {
                                        if selectedFileIndex == index {
                                            travel.PassportAttachmentID = attachmentID
                                            travel.FileUpload = "File Uploaded"
                                        }
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
                    
                }
                
                isLoading = false
                
            } catch {
                print("Error decoding response: \(error.localizedDescription)")
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
    
    
    func fetchUserProposal() {
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
        
        let url = URL(string: "\(baseURL)api/Quotation/UserProposal")!
        print(url)
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        let authToken:String! = "Bearer " + Extensions.token
        
        request.addValue("\(theJSONData)", forHTTPHeaderField: "clientInfo")
        request.addValue(authToken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("{\"orgAppID\":\"6120\",\"orgGroupID\":\"e6177150-0a4b-46f1-9c27-b55e848a69eb\"}", forHTTPHeaderField: "Webapirequest")
        request.addValue("mobile", forHTTPHeaderField: "source")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        guard let tripStartDate = dateFormatter.date(from: tripStartDateValue) else {
            fatalError("Could not convert tripStartDateValue to Date")
        }
        guard let tripEndDate = dateFormatter.date(from: tripEndDateValue) else {
            fatalError("Could not convert tripEndDateValue to Date")
        }
        
        // Convert Date to String in "yyyy-MM-dd" format
        let apiDateFormatter = DateFormatter()
        apiDateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedStartDate = apiDateFormatter.string(from: tripStartDate)
        let formattedEndDate = apiDateFormatter.string(from: tripEndDate)
        
        let QuotesID = userInfoArray.first?.Quotes?.QuotesID ?? ""
        let ProductName = userInfoArray.first?.Quotes?.ProductName ?? ""
        let ProductID = userInfoArray.first?.Quotes?.ProductID ?? ""
        let ProductSourceID = userInfoArray.first?.Quotes?.ProductSourceID ?? 0
        let TotalAmount = userInfoArray.first?.Quotes?.TotalAmount
        
        let KRAPinTypeID = userInfoArray.first?.Quotations?.KRAPinTypeID ?? ""
        let KRAPinNumber = userInfoArray.first?.Quotations?.KRAPinNumber ?? ""
        let Occupation = userInfoArray.first?.Quotations?.Occupation ?? ""
        let BeneficiaryName = userInfoArray.first?.Quotations?.BeneficiaryName ?? ""
        let BeneficiaryPhoneNumber = userInfoArray.first?.Quotations?.BeneficiaryPhoneNumber ?? ""
        
        let houseNumber = userInfoArray.first?.Quotations?.AddressLine1 ?? ""
        let roadName = userInfoArray.first?.Quotations?.AddressLine2 ?? ""
        let pinCode = userInfoArray.first?.Quotations?.AddressLine3 ?? ""
        
        let travellers = userInfoArray.compactMap { userInfo -> [ProposalFormResponse.Traveller]? in
            return userInfo.Traveller
        }.flatMap { $0 }
        
        let travellerInfo = travellers.map { traveller -> [String: Any] in
            return [
                "FirstName": traveller.FirstName ?? "",
                "LastName": traveller.LastName ?? "",
                "FullName": traveller.Fullname ?? "",
                "DOB": traveller.DOB ?? "",
                "Age": traveller.Age ?? 0,
                "CountryCode": traveller.PhoneNumberCountryCode ?? 0,
                "MobileNumber": traveller.sPhoneNumber ?? "",
                "Email": traveller.EmailId ?? "",
                "PassportNumber": traveller.PolicyHolderPassPortNumber ?? "",
                "RelationshipID": traveller.RelationshipTypeID ?? "",
                "Relationship": traveller.RelationshipName ?? "",
                "PassportID": traveller.PassportAttachmentID ?? "",
                "IsPolicyHolder": traveller.IsPolicyHolder
            ]
        }
        
        let TravellersInformation = travellerInfo
        
        let parameters: [String: Any] = [
            
            "QuotationID": userInfoArray.first?.QuotationID ?? "",
            "QuotesID": QuotesID,
            "ProductName": ProductName,
            "ProductID": ProductID,
            "ProductSourceID": ProductSourceID,
            "TotalAmount": TotalAmount,
            "ToCountriesId": userInfoArray.flatMap { userInfo in
                userInfo.DestinationCountry?.map { country in
                    return [
                        "CountrySourceId": country.DestinationSourceID ?? 0,
                        "CountryId": country.DestinationCountryID ?? "",
                        "CountryName": country.DestinationCountryName ?? "",
                        "CountryCode": country.DestinationCountryCode ?? ""
                    ]
                } ?? []
            },
            "AddressLine1": houseNumber,
            "AddressLine2": roadName,
            "AddressLine3": pinCode,
            "AddressLine4": "",
            "AddressLine5": "",
            "FromDate": formattedStartDate,
            "ToDate": formattedEndDate,
            "NoofDays": travelingDaysValue,
            "NoofTravellers": numberOfTravelersValue,
            "TravellersInformation": TravellersInformation,
            "KRAPinTypeID": KRAPinTypeID,
            "KRAPinNumber": KRAPinNumber,
            "Occupation": Occupation,
            "Postaladdress": NSNull(),
            "DeclarationInfo": selectedDeclaration.map { id in
                ["DeclarationId": id]
            },
            "ConsentInfo": selectedConsent.map { id in
                ["ConsentId": id]
            },
            "BeneficiaryName": BeneficiaryName,
            "BeneficiaryPhoneNumber": BeneficiaryPhoneNumber,
            
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
                //                let getResponse = try decoder.decode(ProposalFormResponse.self, from: data)
                
                DispatchQueue.main.async {
                    isLoading = false
                    
                    let rcode = resultDictionary["rcode"] as? Int
                    
                    if rcode == 200 {
                        
                        print(rcode)
                        
                        withAnimation {
                            navigatePaymentReviewPage = true
                        }
                        
                        isLoading = false
                        
                    } else if rcode == 401 {
                        showingUnAuthorizedAlert = true
                        
                        isLoading = false
                    } else if rcode == 504 {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["VAL504"] {
                                self.alertItem = AlertItem(title: Text("VAL504" + "\n" + errorMessage))
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
    
    func proposalFormValidation() {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        let kraPinRegexPattern = "^[A-Za-z]\\d{9}[A-Za-z]$"
        let kraPinTest = NSPredicate(format:"SELF MATCHES %@", kraPinRegexPattern)
        
        
        for (index, value) in userInfoArray.enumerated() {
            if let data = value.Traveller {
                for (travelIndex, travel) in data.enumerated() {
                    
                    if (value.Quotations?.KRAPinTypeID == "00000000-0000-0000-0000-000000000000") {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["VAL037"] {
                                self.alertItem = AlertItem(title: Text("VAL037 \n \(errorMessage)"))
                            }
                        }
                        return
                    } else if ((value.Quotations?.KRAPinNumber?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)) {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["VAL038"] {
                                self.alertItem = AlertItem(title: Text("VAL038 \n \(errorMessage)"))
                            }
                        }
                        return
                    } else if !kraPinTest.evaluate(with: value.Quotations?.KRAPinNumber ?? "") {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["VAL042"] {
                                self.alertItem = AlertItem(title: Text("VAL042 \n \(errorMessage)"))
                            }
                        }
                        return
                    } else if ((value.Quotations?.Occupation?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)) {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["VAL040"] {
                                self.alertItem = AlertItem(title: Text("VAL040 \n \(errorMessage)"))
                            }
                        }
                        return
                    } else if ((value.Quotations?.BeneficiaryName?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)) {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["VAL039"] {
                                self.alertItem = AlertItem(title: Text("VAL039 \n \(errorMessage)"))
                            }
                        }
                        return
                    } else if ((value.Quotations?.BeneficiaryPhoneNumber?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)) {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["VAL041"] {
                                self.alertItem = AlertItem(title: Text("VAL041 \n \(errorMessage)"))
                            }
                        }
                        return
                    } else if ((value.Quotations?.AddressLine1?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)) {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["VAL019"] {
                                self.alertItem = AlertItem(title: Text("VAL019 \n \(errorMessage)"))
                            }
                        }
                        return
                    } else if ((value.Quotations?.AddressLine2?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)) {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["VAL020"] {
                                self.alertItem = AlertItem(title: Text("VAL020 \n \(errorMessage)"))
                            }
                        }
                        return
                    } else if ((value.Quotations?.AddressLine3?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)) {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["VAL021"] {
                                self.alertItem = AlertItem(title: Text("VAL021 \n \(errorMessage)"))
                            }
                        }
                        return
                    } else if ((travel.FirstName?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)) {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["VAL023"] {
                                let formattedErrorMessage = String(format: errorMessage, travelIndex + 1)
                                self.alertItem = AlertItem(title: Text("VAL023 \n \(formattedErrorMessage)"))
                            }
                        }
                        return
                    } else if ((travel.LastName?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)) {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["VAL024"] {
                                let formattedErrorMessage = String(format: errorMessage, travelIndex + 1)
                                self.alertItem = AlertItem(title: Text("VAL024 \n \(formattedErrorMessage)"))
                            }
                        }
                        return
                    } else if ((travel.Fullname?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)) {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["VAL025"] {
                                let formattedErrorMessage = String(format: errorMessage, travelIndex + 1)
                                self.alertItem = AlertItem(title: Text("VAL025 \n \(formattedErrorMessage)"))
                            }
                        }
                        return
                    } else if ((travel.EmailId?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)) {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["VAL026"] {
                                let formattedErrorMessage = String(format: errorMessage, travelIndex + 1)
                                self.alertItem = AlertItem(title: Text("VAL026 \n \(formattedErrorMessage)"))
                            }
                        }
                        return
                    } else if !emailTest.evaluate(with: travel.EmailId) {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["VAL033"] {
                                let formattedErrorMessage = String(format: errorMessage, travelIndex + 1)
                                self.alertItem = AlertItem(title: Text("VAL033 \n \(formattedErrorMessage)"))
                            }
                        }
                        return
                    } else if ((travel.DOB?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)) {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["VAL027"] {
                                let formattedErrorMessage = String(format: errorMessage, travelIndex + 1)
                                self.alertItem = AlertItem(title: Text("VAL027 \n \(formattedErrorMessage)"))
                            }
                        }
                        return
                    } else if let age = travel.Age, age.description.isEmpty {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["VAL028"] {
                                let formattedErrorMessage = String(format: errorMessage, travelIndex + 1)
                                self.alertItem = AlertItem(title: Text("VAL028 \n \(formattedErrorMessage)"))
                            }
                        }
                        return
                    } else if let phoneNumberCountryCode = travel.PhoneNumberCountryCode, phoneNumberCountryCode == 0 {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["VAL029"] {
                                let formattedErrorMessage = String(format: errorMessage, travelIndex + 1)
                                self.alertItem = AlertItem(title: Text("VAL029 \n \(formattedErrorMessage)"))
                            }
                        }
                        return
                    } else if ((travel.sPhoneNumber?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)) {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["VAL030"] {
                                let formattedErrorMessage = String(format: errorMessage, travelIndex + 1)
                                self.alertItem = AlertItem(title: Text("VAL030 \n \(formattedErrorMessage)"))
                            }
                        }
                        return
                    } else if ((travel.PolicyHolderPassPortNumber?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)) {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["VAL031"] {
                                let formattedErrorMessage = String(format: errorMessage, travelIndex + 1)
                                self.alertItem = AlertItem(title: Text("VAL031 \n \(formattedErrorMessage)"))
                            }
                        }
                        return
                    } else if ((travel.RelationshipName?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)) {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["VAL032"] {
                                let formattedErrorMessage = String(format: errorMessage, travelIndex + 1)
                                self.alertItem = AlertItem(title: Text("VAL032 \n \(formattedErrorMessage)"))
                            }
                        }
                        return
                    } else if ((travel.FileUpload?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)) {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["VAL036"] {
                                let formattedErrorMessage = String(format: errorMessage, travelIndex + 1)
                                self.alertItem = AlertItem(title: Text("VAL036 \n \(formattedErrorMessage)"))
                            }
                        }
                        return
                    } else if selectedDeclaration.count != masterDataDeclaration.count {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["VAL043"] {
                                self.alertItem = AlertItem(title: Text("VAL043 \n \(errorMessage)"))
                            }
                        }
                        return
                    } else if selectedConsent.count != masterDataConsent.count {
                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                            if let errorMessage = errorDict["VAL044"] {
                                self.alertItem = AlertItem(title: Text("VAL044 \n \(errorMessage)"))
                            }
                        }
                        return
                    }
                }
            }
        }
        
        fetchUserProposal()
    }
    
}

#Preview {
    ProposalForm(navigateGetPremiumPage: .constant(false))
}
