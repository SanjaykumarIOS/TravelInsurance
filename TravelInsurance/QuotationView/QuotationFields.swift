//
//  QuotationFields.swift
//  TravelInsurance
//
//  Created by SANJAY  on 16/05/24.
//

import SwiftUI

var selectedDestinationListValue: [String] = []
var tripStartDateValue = ""
var tripEndDateValue = ""
var travelingDaysValue = ""
var numberOfTravelersValue = ""

var quotationIDValue = ""

var masterDataRelationshipInfo:[MasterDataResponseData.MasterDataRObj.RelationshipInfo] = []
var masterDatakRAPintype: [MasterDataResponseData.MasterDataRObj.KRAPinType] = []
var masterDataDeclaration: [MasterDataResponseData.MasterDataRObj.declaration] = []
var masterDataConsent: [MasterDataResponseData.MasterDataRObj.consent] = []

struct QuotationFields: View {
    
    @ObservedObject var viewModel = DateRangeViewModel()
    
    @State private var travelPurposeID = ""
    
    @State private var destinationField = ""
    @State private var showDestinationList = false
    @State private var destinationList = ["USA", "Thailand", "UK", "India", "Singapore", "Germany"]
    @State private var suggestions: [String] = []
    @State private var selectedDestinationList: [String] = []
    @State private var selectedCountries: [Country] = []
    @State private var travelingDaysField = ""
    @State private var numberOfTravelersField = ""
    
    @State private var startDateValue = ""
    @State private var endDateValue = ""
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
    
    @State private var isCheckeds = false
    
    @State private var count: Int = 0
    @State private var calculateAgeValue: [String] = []
    @State private var dateOfBirthValue: [String] = []
    @State private var selectedDates: [Date] = []
    @State private var selectedDate: Date?
    @State private var isChecked: [Bool] = []
    @State private var showNoOfTravellerDOB = false
    @State private var selectedIndex: Int?
    @State private var selectedProposerTraveler: Int?
    
    private var endDate: Date {
        Calendar.current.date(byAdding: DateComponents(year: -1), to: Date()) ?? Date()
    }
    
    @State private var MDTravelPurposeArrayDetails: [MasterDataResponseData.MasterDataRObj.TravelPurpose] = []
    @State private var MDGetCountriesArrayDetails: [MasterDataResponseData.MasterDataRObj.CountryInfo] = []
    @State private var selectedTravelPurpose: Int?

    @State private var navigateGetPremiumPage = false
    
    @State private var showTravelLoadingView = false
    @State private var currentIndex: Int = 0
    @State private var timer: Timer?

    private let texts = ["Checking for the best policy options available for you.", "Calculating premiums and benefits to match your travel need.", "Almost there! Just securing the best rates for your upcoming adventures.", "Finalizing the details of your Travel Insurance Policy.", "Thank you for your patience! The products that match your needs will be ready for you to choose from in just a few minutes."]
    
    @State private var show80AgeAlert = false
    
    @Binding var navigateDashboard: Bool
    
    @State private var isLoading = false
    @State private var alertItem: AlertItem?
    
    
    var body: some View {
        NavigationStack {
            LoadingView(isShowing: $isLoading) {
                VStack {
                    ScrollView {
                        VStack {
                            VStack(spacing:10) {
                                Text("Let's Get You A Customized Travel Insurance Plan")
                                    .font(isFontMedium(size: 20))
                                    .bold()
                                    .foregroundColor(rose)
                                    .multilineTextAlignment(.center)
                                  
                                Text("\("Travel Purpose") \("*")")
                                    .halfTextColorChange(fullText: "\("Travel Purpose") \("*")", changeText: "*")
                                    .font(isFontMedium(size: 18))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top,10)
                                
//                                LazyHGrid(rows: [GridItem()],spacing: 20) {
                                HStack {
                                    ForEach(MDTravelPurposeArrayDetails.indices, id: \.self) { index in
                                        let masterData = MDTravelPurposeArrayDetails[index]
                                        
                                        Button(action: {
                                            travelPurposeID = masterData.masterDataID ?? ""
                                            
                                            if selectedTravelPurpose == index {
                                                selectedTravelPurpose = nil
                                            } else {
                                                selectedTravelPurpose = index
                                            }
                                           
                                        })
                                        {
                                            Text(masterData.mdTitle ?? "")
                                                .font(isFontMedium(size: 18))
                                                .foregroundColor(selectedTravelPurpose == index ? Color.white : Color.black)
//                                                .frame(width: 100, height: 50)
                                                .padding()
                                                .background(selectedTravelPurpose == index ? rose : Color.gray.opacity(0.2))
                                                .cornerRadius(8)
                                                .frame(maxWidth:.infinity)
                                        }
                                           
                                    }
                                }

                                
                                Text("\("Destination(s)") \("*")")
                                    .halfTextColorChange(fullText: "\("Destination(s)") \("*")", changeText: "*")
                                    .font(isFontMedium(size: 18))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top,10)
                                
                                TextField("Choose your destination(s)", text: $destinationField)
                                    .padding(.all)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .font(isFontMedium(size: 18))
                                    .autocapitalization(.none)
                                    .autocorrectionDisabled()
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.black)
                                    .cornerRadius(8)
                                    .onChange(of: destinationField) { newValue in
                                        if newValue.count >= 2 {
                                            updateSuggestions(for: newValue)
                                            withAnimation {
                                                showDestinationList = !suggestions.isEmpty
                                            }
                                        } else {
                                            withAnimation {
                                                suggestions = []
                                                showDestinationList = false
                                            }
                                        }
                                    }
                                
                                if !selectedDestinationList.isEmpty {
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
                                        
                                        TextField("dd/mm/yyyy", text: $startDateValue)
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
                                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                            }
                                    }
                                    
                                    VStack {
                                        Text("\("Trip end date") \("*")")
                                            .halfTextColorChange(fullText: "\("Trip end date") \("*")", changeText: "*")
                                            .font(isFontMedium(size: 16))
                                            .bold()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        TextField("dd/mm/yyyy", text: $endDateValue)
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
                                                
                                                if startDateValue.isEmpty {
                                                    if let errorDict = Extensions.getValidationDict() as? [String: String] {
                                                        if let errorMessage = errorDict["VAL001"] {
                                                            self.alertItem = AlertItem(title: Text("VAL001 \n \(errorMessage)"))
                                                        }
                                                    }
                                                } else {
                                                    showEndDate = true
                                                }
                                                
                                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                            }
                                    }
                                }
                                .padding(.top,10)
                                
                                Text("\("Travelling Days") \("*")")
                                    .halfTextColorChange(fullText: "\("Travelling Days") \("*")", changeText: "*")
                                    .font(isFontMedium(size: 18))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top,10)
                                
                                TextField("Total no of days", text: $travelingDaysField)
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
                                
                                TextField("Enter travellers count", text: $numberOfTravelersField)
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
                                    .onChange(of: numberOfTravelersField) { newValue in
                                        if let newCount = Int(newValue), newCount <= 50 {
                                            numberOfTravelersValue = newValue
                                            count = newCount
                                            dateOfBirthValue = Array(repeating: "", count: newCount)
                                            calculateAgeValue = Array(repeating: "", count: newCount)
                                            selectedDates = Array(repeating: endDate, count: newCount)
                                            isChecked = Array(repeating: false, count: newCount)
                                        } else if let newCount = Int(newValue), newCount > 50 {
                                            count = 0
                                            dateOfBirthValue = Array(repeating: "", count: 50)
                                            calculateAgeValue = Array(repeating: "", count: 50)
                                            selectedDates = Array(repeating: endDate, count: 50)
                                            isChecked = Array(repeating: false, count: 50)
                                            numberOfTravelersField = "" // Update the text field to show the max value
                                            numberOfTravelersValue = ""
                                            if let errorDict = Extensions.getValidationDict() as? [String: String] {
                                                if let errorMessage = errorDict["VAL003"] {
                                                    self.alertItem = AlertItem(title: Text("VAL003 \n \(errorMessage)"))
                                                }
                                            }
                                        }
                                    }
                                
                            }
                            
                            VStack(spacing:10) {
                                
                                ForEach(0..<count, id: \.self) { index in
                                    VStack(alignment:.leading) {
                                        
                                        HStack {
                                            Text("Traveler \(index + 1)")
                                                .font(isFontMedium(size: 20))
                                                .bold()
                                                .foregroundColor(rose)
                                            
                                            Spacer()
                                            
                                            Text("Is this Proposer?")
                                                .font(isFontMedium(size: 15))
                                                .foregroundColor(.gray)
                                            
                                            Button(action: {
                                                if selectedProposerTraveler == index {
                                                    selectedProposerTraveler = nil
                                                } else {
                                                    selectedProposerTraveler = index
                                                }
                                                
                                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                            })
                                            {
                                                Image(systemName: selectedProposerTraveler == index ? "checkmark.square.fill" : "square")
                                                    .font(isFontMedium(size: 21))
                                                    .bold()
                                                    .foregroundColor(rose)
                                            }
                                            
                                        }
                                        
                                        Text("\("Date of birth") \("*")")
                                            .halfTextColorChange(fullText: "\("Date of birth") \("*")", changeText: "*")
                                            .font(isFontMedium(size: 17))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding([.leading, .top],5)
                                        
                                        TextField("dd/mm/yyyy", text: $dateOfBirthValue[index])
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
                                            .padding(.leading,5)
                                            .onTapGesture {
                                                selectedDate = nil
                                                showNoOfTravellerDOB = true
                                                selectedIndex = index
                                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                            }
                                        
                                        Text("\("Age") \("*")")
                                            .halfTextColorChange(fullText: "\("Age") \("*")", changeText: "*")
                                            .font(isFontMedium(size: 17))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding([.leading, .top],5)
                                        
                                        TextField("Traveller age", text: $calculateAgeValue[index])
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
                                            .padding(.leading,5)
                                        
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(10)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(radius: 2)
                                    .padding(.top,10)
                                }
                                
                            }
                        }
                        .padding()
                        
                        
                    }
                    
                    VStack {
                        
                        Button(action: {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            quotationValidation()
                            
                        }) {
                            Text("GET QUOTE >>")
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
                    fetchMasterData()
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
                                    selectedDestinationListValue = []
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
                            
                            Text("Quotation")
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
                navigateGetPremiumPage ? GetPremiumPage(navigateGetQuotePage: $navigateGetPremiumPage) : nil
            }
        
        .overlay {
            if showDestinationList {
                ZStack {
                    Color.black
                        .ignoresSafeArea()
                        .opacity(0.1)
                        .onTapGesture {
                            showDestinationList = false
                        }
                    
                    List {
                        ForEach(suggestions, id: \.self) { suggestion in
                            
                            VStack {
                                Button(action:{
                                    
                                    withAnimation {
                                        showDestinationList = false
                                        destinationField = ""
                                        suggestions = []
                                        if !selectedDestinationList.contains(suggestion) {
                                            selectedDestinationList.append(suggestion)
//                                            selectedDestinationListValue.append(suggestion)
                                            
                                            if let country = MDGetCountriesArrayDetails.first(where: { $0.ToCountryName == suggestion }) {
                                                let mappedCountry = Country(
                                                    countrySourceId: country.ToCountrySourceId ?? 0,
                                                    countryId: country.TocountryID ?? "",
                                                    countryName: country.ToCountryName ?? "",
                                                    countryCode: country.ToCountryCode ?? ""
                                                )
                                                selectedCountries.append(mappedCountry)
                                            }
                                        }
                                    }
                                })
                                {
                                    Text(suggestion)
                                        .font(isFontMedium(size: 18))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundColor(.black)
                                        .padding(.vertical,10)
                                        
                                    
                                }
                            }
                          
                        }
                    }
                    .listStyle(.plain)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .cornerRadius(1)
                    .shadow(radius: 1)
                    
                }
            }
        }
        
        .overlay {
            if showStartDate {
                
                ZStack {
                    Color.black
                        .ignoresSafeArea()
                        .opacity(0.3)
                        .onTapGesture {
                            showStartDate = false
                        }
                    
                    VStack {
                        
                        DatePicker("Start Date", selection: $viewModel.startDate, in: Date()..., displayedComponents: [.date])
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
                            }
                            
                            Button(action: {
                                
                                // Close the date picker
                                self.showStartDate.toggle()
                                
                                startDateValue = dateFormatter.string(from: viewModel.startDate)
                                tripStartDateValue = dateFormatter.string(from: viewModel.startDate)
                                
                                
                                if !endDateValue.isEmpty {
                                    travelingDaysField = String(viewModel.calculateNumberOfDays())
                                    travelingDaysValue = String(viewModel.calculateNumberOfDays())
                                    endDateValue = ""
                                    
                                    if endDateValue.isEmpty {
                                        travelingDaysField = ""
                                        travelingDaysValue = ""
                                    }
                                }
                                
                            }) {
                                Text("OK")
                                    .font(isFontMedium(size: 18))
                                    .foregroundColor(.teal)
                                    .padding(.trailing)
                                
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
                        .opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showEndDate = false
                        }
                    
                    VStack {
                        
                        DatePicker("End Date", selection: $viewModel.endDate, in: viewModel.startDate..., displayedComponents: [.date])
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
                                
                            }
                            
                            Button(action: {
                                
                                // Close the date picker
                                self.showEndDate.toggle()
                                
                                if !startDateValue.isEmpty {
                                    travelingDaysField = String(viewModel.calculateNumberOfDays())
                                    travelingDaysValue = String(viewModel.calculateNumberOfDays())
                                    
                                }
                                
                                endDateValue = dateFormatter.string(from: viewModel.endDate)
                                tripEndDateValue = dateFormatter.string(from: viewModel.endDate)
                                
                            }) {
                                Text("OK")
                                    .font(isFontMedium(size: 18))
                                    .foregroundColor(.teal)
                                    .padding(.trailing)
                                
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
            
            if showNoOfTravellerDOB {
                ZStack {
                    Color.black
                        .opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showNoOfTravellerDOB = false
                        }
                    
                    VStack {
                        
                        DatePicker(
                            "Select Date",
                            selection: Binding(
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
                                
                                self.showNoOfTravellerDOB = false
                                
                            }) {
                                Text("CANCEL")
                                    .font(isFontMedium(size: 18))
                                    .foregroundColor(.teal)
                                    .padding(.trailing,30)
                                
                                Button(action: {
                                    
                                    self.showNoOfTravellerDOB.toggle()
                                    
                                    if let index = selectedIndex {
                                        dateOfBirthValue[index] = dateFormatter.string(from: selectedDate ?? endDate)
                                        calculateAgeValue[index] = String(calculateAge(from:  dateOfBirthValue[index]) ?? 0)
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
            
        }
        
        .overlay {
            
            if show80AgeAlert {
                
                ZStack {
                    Color.black
                        .ignoresSafeArea()
                        .opacity(0.3)
                        .onTapGesture {
                            show80AgeAlert = false
                        }
                    
                    VStack(alignment:.leading) {
                        Text("VAL045")
                            .font(isFontMedium(size: 22))
                            .foregroundColor(.black)
                            .frame(maxWidth:.infinity, alignment:.leading)
                        
                        
                        Text("We are sorry for the inconvenience!")
                            .font(isFontBlack(size: 20))
                            .foregroundColor(appTheme)
                            .frame(maxWidth:.infinity, alignment:.leading)
                            .padding(.top,12)
                        
                        Text("Unfortunately, due to age restrictions, we are unable to offer a travel policy to individuals over 80 years old. We understand this might be disappointing, and we’re here to help with any questions or concerns you may have.")
                            .font(isFontMedium(size: 18))
                            .foregroundColor(.black)
                            .frame(maxWidth:.infinity, alignment:.leading)
                        
                        Text("Feel free to reach out to us at travel@kenindia.com or visit our office for further assistance. Thank you for your understanding!")
                            .font(isFontMedium(size: 18))
                            .foregroundColor(.black)
                            .frame(maxWidth:.infinity, alignment:.leading)
                            .padding(.top)
                        
                        
                        Text("OKAY")
                            .font(isFontMedium(size: 22))
                            .foregroundColor(appTheme)
                            .frame(maxWidth:.infinity, alignment:.trailing)
                            .padding([.top, .horizontal])
                            .onTapGesture {
                                show80AgeAlert = false
                            }
                    }
                    .padding(20)
                    .frame(maxWidth:.infinity)
                    .background(Color.white)
                    .padding(.horizontal,30)
                    
                }
            }
            
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
    
    private func updateSuggestions(for query: String) {
        let prefix = query.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if prefix.isEmpty {
            suggestions = []
        } else {
            suggestions = MDGetCountriesArrayDetails
                .filter { ($0.ToCountryName?.uppercased().hasPrefix(prefix) ?? false) }
                .map { $0.ToCountryName ?? "" }
        }
    }

    
    private func generateContent() -> some View {
           var width = CGFloat.zero
           var height = CGFloat.zero

           return ZStack(alignment: .topLeading) {
               ForEach(self.selectedDestinationList.indices, id: \.self) { index in
                   let platform = self.selectedDestinationList[index]
                   self.item(for: platform, index: index)
                       .padding(5)
                       .alignmentGuide(.leading, computeValue: { d in
                           if (abs(width - d.width) > UIScreen.main.bounds.width)
                           {
                               width = 0
                               height -= d.height
                           }
                           let result = width
                           if index == self.selectedDestinationList.count - 1 {
                               width = 0 //last item
                           } else {
                               width -= d.width
                           }
                           return result
                       })
                       .alignmentGuide(.top, computeValue: {d in
                           let result = height
                           if index == self.selectedDestinationList.count - 1 {
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
               
               Image(systemName: "xmark.circle.fill")
                   .font(isFontMediumItalic(size: 18))
                   .foregroundColor(.black)
                   .onTapGesture {
                       let removedDestination = selectedDestinationList[index]
                       selectedDestinationList.remove(at: index)
                       if let countryIndex = selectedCountries.firstIndex(where: { $0.countryName == removedDestination }) {
                           selectedCountries.remove(at: countryIndex)
                       }
                   }
                   
           }
           .frame(height: 35)
           .frame(width: .infinity)
           .padding(.horizontal,8)
           .background(Color.gray.opacity(0.2))
           .cornerRadius(18)

       }
    
    func calculateAge(from dateString: String, format: String = "dd/MM/yyyy") -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let birthDate = dateFormatter.date(from: dateString) else {
            return nil
        }
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
        return ageComponents.year
    }
    
    
    func fetchMasterData() {
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
        
        let url = URL(string: "\(baseURL)api/Quotation/GetMasterData")!
        print(url)
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("\(theJSONData)", forHTTPHeaderField: "clientInfo")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("{\"orgAppID\":\"6120\",\"orgGroupID\":\"e6177150-0a4b-46f1-9c27-b55e848a69eb\"}", forHTTPHeaderField: "Webapirequest")
        
        
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
                print("Get Proposal Form response = \(String(describing: resultDictionary))")
                
                let decoder = JSONDecoder()
                let getResponse = try decoder.decode(MasterDataResponseData.self, from: data)
                
                DispatchQueue.main.async {
                    isLoading = false
                    
                    if getResponse.rcode == 200 {
                        
                        print(getResponse.rcode)
                        
                        MDTravelPurposeArrayDetails = getResponse.rObj.GetTravelPurpose
                        MDGetCountriesArrayDetails = getResponse.rObj.GetCountries
                        masterDataRelationshipInfo = getResponse.rObj.Relationship
                        masterDatakRAPintype = getResponse.rObj.kRAPintype
                        masterDataDeclaration = getResponse.rObj.declaration
                        masterDataConsent = getResponse.rObj.consent
                        
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
                isLoading = false
                print("\("Error decoding response") \(error.localizedDescription)")
                if let errorDict = Extensions.getValidationDict() as? [String: String] {
                    if let errorMessage = errorDict["API001"] {
                        self.alertItem = AlertItem(title: Text("API001" + "\n" + errorMessage))
                    }
                }
            }
        }
        task.resume()
    }
    
    func fetchGetQuote() {
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
        
        
        guard let url = URL(string: "\(baseURL)api/Quotation/GetB2CQuotes") else {
            print("Invalid URL")
            isLoading = false
            return
        }
        
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
//        let authToken:String! = "Bearer " + Extensions.token
//       
//        request.addValue(authToken, forHTTPHeaderField: "Authorization")
        request.addValue("\(theJSONData)", forHTTPHeaderField: "clientInfo")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("{\"orgAppID\":\"6120\",\"orgGroupID\":\"e6177150-0a4b-46f1-9c27-b55e848a69eb\"}", forHTTPHeaderField: "Webapirequest")
        request.addValue("mobile", forHTTPHeaderField: "source")

        let travelersInfo = (0..<count).compactMap { index -> [String: Any]? in
            guard let dateOfBirth = dateFormatter.date(from: dateOfBirthValue[index]) else {
                print("Invalid date format for index \(index)")
                return nil
            }
            return [
                "DateofBirth": selectedDateFormatter.string(from: dateOfBirth),
                "Age": Int(calculateAgeValue[index]) ?? 0,
                "IsPolicyHolder": selectedProposerTraveler == index
            ]
        }

        let parameters: [String: Any] = [
            "FromCountryID": "771C2959-B859-47A5-89BB-B31F3F5DD07A",
            "TravelPurposeID": travelPurposeID,
            "ToCountriesId": selectedCountries.map { country in
                return [
                    "CountrySourceId": country.countrySourceId,
                    "CountryId": country.countryId,
                    "CountryName": country.countryName,
                    "CountryCode": country.countryCode
                ]
            },
            "FromDate": selectedDateFormatter.string(from: viewModel.startDate),
            "ToDate": selectedDateFormatter.string(from: viewModel.endDate),
            "NoofDays": Int(travelingDaysField) ?? 0,
            "NoofTravellers": Int(numberOfTravelersField) ?? 0,
            "TravellersInfo": travelersInfo
        ]

        print(parameters)
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])

        // Set timeout interval for the request to 2 minutes (120 seconds)
        request.timeoutInterval = 120.0

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                withAnimation {
                    showTravelLoadingView = false
                }
            }

            if let error = error {
                print("Error: \(error.localizedDescription)")
                if (error as NSError).code == NSURLErrorTimedOut {
                    DispatchQueue.main.async {
                        if let errorDict = Extensions.getValidationDict() as? [String: String], let errorMessage = errorDict["API001"] {
                            self.alertItem = AlertItem(title: Text("API001" + "\n" + errorMessage))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        if let errorDict = Extensions.getValidationDict() as? [String: String], let errorMessage = errorDict["API001"] {
                            self.alertItem = AlertItem(title: Text("API001" + "\n" + errorMessage))
                        }
                    }
                }
                return
                isLoading = false
                showTravelLoadingView = false
            }

            guard let data = data else {
                print("Error: No data returned from server")
                DispatchQueue.main.async {
                    if let errorDict = Extensions.getValidationDict() as? [String: String], let errorMessage = errorDict["API001"] {
                        self.alertItem = AlertItem(title: Text("API001" + "\n" + errorMessage))
                    }
                }
                return
                isLoading = false
                showTravelLoadingView = false
            }

            do {
                let resultDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                print("Get Proposal Form response = \(String(describing: resultDictionary))")
                
                DispatchQueue.main.async {
                    isLoading = false
                    let rcode = resultDictionary?["rcode"] as? Int
                    if rcode == 200 {
                        print(rcode ?? 0)
                        
                        if let rObj = resultDictionary?["rObj"] as? [String: Any] {
                            if let quotationID = rObj["QuotationID"] as? String {
                                quotationIDValue = quotationID
                                print(quotationID)
                            }
                        }
                        
                        withAnimation {
                            navigateGetPremiumPage = true
                            showTravelLoadingView = false
                        }
                        
                    } else {
                        showTravelLoadingView = false
                        if let errorDict = Extensions.getValidationDict() as? [String: String], let errorMessage = errorDict["API001"] {
                            self.alertItem = AlertItem(title: Text("API001" + "\n" + errorMessage))
                        }
                    }
                }
            } catch {
                showTravelLoadingView = false
                isLoading = false
                print("Error decoding response: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    if let errorDict = Extensions.getValidationDict() as? [String: String], let errorMessage = errorDict["API001"] {
                        self.alertItem = AlertItem(title: Text("API001" + "\n" + errorMessage))
                    }
                }
            }
        }
        task.resume()
    }

    
    func quotationValidation() {
        
        var isValid = true

        for dateOfBirth in dateOfBirthValue {
            if let age = calculateAge(from: dateOfBirth), age > 80 {
                isValid = false
                break
            }
        }
        
        if selectedTravelPurpose == nil {
            if let errorDict = Extensions.getValidationDict() as? [String: String] {
                if let errorMessage = errorDict["VAL016"] {
                    self.alertItem = AlertItem(title: Text("VAL016 \n \(errorMessage)"))
                }
            }
        } else if selectedDestinationList.isEmpty {
            if let errorDict = Extensions.getValidationDict() as? [String: String] {
                if let errorMessage = errorDict["VAL009"] {
                    self.alertItem = AlertItem(title: Text("VAL009 \n \(errorMessage)"))
                }
            }
        } else if startDateValue.isEmpty {
            if let errorDict = Extensions.getValidationDict() as? [String: String] {
                if let errorMessage = errorDict["VAL005"] {
                    self.alertItem = AlertItem(title: Text("VAL005 \n \(errorMessage)"))
                }
            }
        } else if endDateValue.isEmpty {
            if let errorDict = Extensions.getValidationDict() as? [String: String] {
                if let errorMessage = errorDict["VAL006"] {
                    self.alertItem = AlertItem(title: Text("VAL006 \n \(errorMessage)"))
                }
            }
        } else if numberOfTravelersField.isEmpty {
            if let errorDict = Extensions.getValidationDict() as? [String: String] {
                if let errorMessage = errorDict["VAL004"] {
                    self.alertItem = AlertItem(title: Text("VAL004 \n \(errorMessage)"))
                }
            }
        } else if let index = dateOfBirthValue.firstIndex(where: { $0.trimmingCharacters(in: .whitespaces).isEmpty }) {
            if let errorDict = Extensions.getValidationDict() as? [String: String] {
                if let errorMessageTemplate = errorDict["VAL007"] {
                    let errorMessage = String(format: errorMessageTemplate, index + 1)
                    self.alertItem = AlertItem(title: Text("VAL007 \n \(errorMessage)"))
                }
            }
        } else if !dateOfBirthValue.contains(where: {
            if let age = calculateAge(from: $0), age > 3 {
                return true
            }
            return false
        }) {
            if let errorDict = Extensions.getValidationDict() as? [String: String] {
                if let errorMessage = errorDict["VAL008"] {
                    self.alertItem = AlertItem(title: Text("VAL008 \n \(errorMessage)"))
                }
            }
        } else if !isValid {
            
            show80AgeAlert = true
            
//            if let errorDict = Extensions.getValidationDict() as? [String: String] {
//                if let errorMessage = errorDict["VAL045"] {
//                    self.alertItem = AlertItem(title: Text("VAL045 \n \(errorMessage)"))
//                }
//            }
        } else if selectedProposerTraveler == nil {
            if let errorDict = Extensions.getValidationDict() as? [String: String] {
                if let errorMessage = errorDict["VAL018"] {
                    self.alertItem = AlertItem(title: Text("VAL018 \n \(errorMessage)"))
                }
            }

        } else {
          
            fetchGetQuote()
        }
    }

   
   
}



struct Country {
    let countrySourceId: Int
    let countryId: String
    let countryName: String
    let countryCode: String
}


#Preview {
    QuotationFields(navigateDashboard: .constant(false))

}


