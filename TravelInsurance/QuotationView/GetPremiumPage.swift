//
//  GetPremiumPage.swift
//  TravelInsurance
//
//  Created by SANJAY  on 30/05/24.
//

import SwiftUI

var quotesIDValue = ""
var getPremiumQuotationIDValue = ""

struct GetPremiumPage: View {
    
    @State private var quotationInfoArray:[QuotationInfoResponseModel.QuotationInfoRobj] = []
    @State private var selectedPolicy: Int?
    @State private var selectedCoverages: Int?
    @State private var selectedBreakDown: String?
    
    @State private var showCoveragePopup = false
    @State private var showBreakDownPopup = false
        
    @State private var showProductPopUp = false
    @State private var showComparePopup = false
    @State private var showCompareButton = false
    @State private var selectedIndices: Set<String> = []
    @State private var navigateComparePage = false
    
    
    @State private var navigateLoginPage = false
    
    @State private var navigateProposalForm = false
    
    @Binding var navigateGetQuotePage: Bool
    
    @State private var isLoading = false
    @State private var alertItem: AlertItem?
        
    var body: some View {
        NavigationStack {
            LoadingView(isShowing: $isLoading) {
                VStack {
                    
                    VStack {
                        
                        HStack {
                            VStack(spacing:5) {
                                Text("Quotation ID")
                                    .font(isFontMedium(size: 19))
                                
                                ForEach(quotationInfoArray.indices, id: \.self) { index in
                                    let quote = quotationInfoArray[index]
                                    
                                    if let quotationID = quote.GetQuotesInfo {
                                        Text(quotationID.QuotationNumber ?? "")
                                            .font(isFontMedium(size: 18))
                                            .foregroundColor(inkBlueColour)
                                        
                                    }
                                }
                            }
                            .frame(height: selectedDestinationListValue.count == 1 ? 40 : 50,alignment: .top)
                            .frame(maxWidth:.infinity)
                            .padding(.vertical,5)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            
                            
                            VStack(spacing:5) {
                                Text("Destination")
                                    .font(isFontMedium(size: 19))
                                
                                if selectedDestinationListValue.count == 1 {
                                    
                                    Text(Array(selectedDestinationListValue).first!)
                                        .font(isFontMedium(size: 17))
                                        .foregroundColor(inkBlueColour)
                                        .padding(2)
                                    
                                } else {
                                    HStack {
                                        
                                        if let firstCharacter = selectedDestinationListValue.first {
                                            Text(String(firstCharacter))
                                                .font(isFontMedium(size: 17))
                                                .foregroundColor(.black)
                                                .padding(.leading, 10)
                                                .lineLimit(1)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(isFontMedium(size: 17))
                                            .padding(.trailing,10)
                                        
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 27)
                                    .background(Color.white)
                                    .cornerRadius(6)
                                    .padding(.horizontal,6)
                                    .onTapGesture {
                                        showProductPopUp = true
                                    }
                                }
                            }
                            .frame(height: selectedDestinationListValue.count == 1 ? 40 : 50,alignment: .top)
                            .frame(maxWidth:.infinity)
                            .padding(.vertical,5)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            
                        }
                        
                        HStack {
                            
                            VStack(alignment: .center, spacing:5) {
                                
                                Text("Trip start date")
                                    .font(isFontMedium(size: 19))
                                
                                ForEach(quotationInfoArray.indices, id: \.self) { index in
                                    let quote = quotationInfoArray[index]
                                    
                                    if let quotation = quote.GetQuotesInfo {
                                        Text("\(quotation.FromDateString ?? "")")
                                            .font(isFontMedium(size: 17))
                                            .foregroundColor(inkBlueColour)
                                            .multilineTextAlignment(.center)
                                        
                                
                                    }
                                }
                                
                            }
                            .frame(height: selectedDestinationListValue.count == 1 ? 40 : 50,alignment: .top)
                            .padding(.vertical,5)
                            .frame(maxWidth:.infinity)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            
                            
                            VStack(spacing:5) {
                                Text("Trip end date")
                                    .font(isFontMedium(size: 19))
                                
                                ForEach(quotationInfoArray.indices, id: \.self) { index in
                                    let quote = quotationInfoArray[index]
                                    
                                    if let quotation = quote.GetQuotesInfo {
                                       
                                        Text(quotation.ToDateString ?? "")
                                            .font(isFontMedium(size: 17))
                                            .foregroundColor(inkBlueColour)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                            }
                            .frame(height: selectedDestinationListValue.count == 1 ? 40 : 50,alignment: .top)
                            .padding(.vertical,5)
                            .frame(maxWidth:.infinity)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        }
                    }
                    .padding(10)
                    
                    VStack {
                        ScrollView(showsIndicators: false) {
                            VStack {
                                
                                ForEach(quotationInfoArray.indices, id: \.self) { index in
                                    let quote = quotationInfoArray[index]
                                    
                                    if let getQuote = quote.GetQuotes {
                                        ForEach(getQuote.indices, id: \.self) { indexValue in
                                            let quoteValue = getQuote[indexValue]
                                            
                                            VStack(spacing:0) {
                                                
                                                VStack {
                                                    
                                                    VStack {
                                                        Text(quoteValue.ProductName ?? "")
                                                            .font(isFontMedium(size: 22))
                                                            .bold()
                                                            .foregroundColor(.white)
                                                    }
                                                    .frame(maxWidth: .infinity)
                                                    .padding(.horizontal)
                                                    .padding(.vertical)
                                                    .background(appTheme)
                                                    .frame(maxHeight: .infinity,alignment:.top)
                                                    
                                                    HStack {
                                                        
                                                        VStack(alignment:.leading, spacing:10) {
                                                            Text("Total Amount")
                                                                .font(isFontMedium(size: 20))
                                                                .bold()
                                                                .foregroundColor(.black)
                                                            
                                                            Text(quoteValue.sTotalAmount ?? "")
                                                                .font(isFontMedium(size: 20))
                                                                .bold()
                                                                .foregroundColor(inkBlueColour)
                                                        }
                                                        
                                                        Spacer()
                                                        
                                                        Button(action: {
                                                            
                                                            if selectedPolicy == indexValue {
                                                                selectedPolicy = nil
                                                            } else {
                                                                selectedPolicy = indexValue
                                                            }
                                                            
                                                            quotesIDValue = quoteValue.QuotesID ?? ""
                                                            getPremiumQuotationIDValue = quote.QuotationID ?? ""
                                                            
                                                            
                                                        })
                                                        {
                                                            Text(selectedPolicy == indexValue ? "Selected" : "Select")
                                                                .font(isFontMedium(size: 20))
                                                                .foregroundColor(.white)
                                                                .padding()
                                                                .background(selectedPolicy == indexValue ? rose : appTheme)
                                                                .cornerRadius(8)
                                                            
                                                        }
                                                    }
                                                    .padding()
                                                }
                                                .frame(maxWidth: .infinity)
                                                .background(Color.gray.opacity(0.2))
                                                .cornerRadius(10)
                                              
                                                HStack {
                                                    Text("COVERAGES")
                                                        .font(isFontMedium(size: 19))
                                                        .foregroundColor(.white)
                                                        .padding(.horizontal)
                                                        .padding(5)
                                                        .background(sykBlueColour)
                                                        .mask(RoundedCorner(radius: 10, corners: [.bottomLeft]))
                                                        .mask(RoundedCorner(radius: 10, corners: [.bottomRight]))
                                                        .onTapGesture {
                                                            showCoveragePopup = true
                                                            selectedCoverages = indexValue
                                                        }
                                                    
                                                    Text("BREAK-DOWN")
                                                        .font(isFontMedium(size: 19))
                                                        .foregroundColor(.white)
                                                        .padding(.horizontal)
                                                        .padding(5)
                                                        .background(sykBlueColour)
                                                        .mask(RoundedCorner(radius: 10, corners: [.bottomLeft]))
                                                        .mask(RoundedCorner(radius: 10, corners: [.bottomRight]))
                                                        .onTapGesture {
                                                            showBreakDownPopup = true
                                                            selectedBreakDown = quoteValue.QuotesID ?? ""
                                                        }
                                                    
                                                }
                                                
                                            }
                                            .padding(.vertical,6)
                                            
                                        }
                                    }
                                }
                                
                            }                           
                        }
                    }
                    .padding(.horizontal)
                    
                    if selectedPolicy != nil {
                        VStack {
                            
                            Button(action: {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                
                                if Extensions.token.isEmpty {
                                    withAnimation {
                                        navigateLoginPage = true
                                    }
                                    Extensions.navigateProposalForm = true
                                } else {
                                    withAnimation {
                                        navigateProposalForm = true
                                    }
                                }
                                
                            }) {
                                Text("NEXT >>")
                                    .padding(.top)
                                    .frame(maxWidth: .infinity)
                                    .background(rose)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .font(isFontBold(size: 22))
                            }
                            
                        }
                    }
                    
                    
                }
                .onAppear {
                   fetchQuotationInfo()
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
                                    navigateGetQuotePage = false
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
                    
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        HStack(spacing:20) {
                            
                            Image("compare")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width:30,height:30)
                                .foregroundColor(.white)
                                .bold()
                                .padding(.bottom,8)
                                .onTapGesture {
                                    showComparePopup = true
                                }
                           
                            Image("downloadPdf")
                                .resizable()
                                .frame(width:25,height:27)
                                .bold()
                                .padding(.bottom,8)
                                .onTapGesture {
                                    fetchDownloadPdf()
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
                navigateLoginPage ? LoginPage(navigateDashboard: $navigateLoginPage) : nil
                
                navigateProposalForm ? ProposalForm(navigateGetPremiumPage: $navigateProposalForm) : nil
                
                navigateComparePage ? ComparePage(navigateComparePage: $navigateComparePage,  selectedIndices: $selectedIndices) : nil
                
            }
        
            .overlay {
                if showProductPopUp {
                    ZStack {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                showProductPopUp = false
                            }
                        
                        VStack {
                            Spacer()
                            
                            List {
                                ForEach(selectedDestinationListValue, id: \.self) { value in
                                    Text(value)
                                        .font(isFontMedium(size: 18))
                                        .padding(8)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .onTapGesture {
                                            showProductPopUp = false
                                        }
                                }
                                .listRowSeparator(.hidden)
                            }
                            .listStyle(.plain)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                            
                            Spacer()
                        }
                        .frame(height: 400)
                        .onTapGesture {
                            showProductPopUp = false
                        }
                    }
                }
                
                if showCoveragePopup {
                    ZStack {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                showCoveragePopup = false
                            }
                        VStack {
                            HStack {
                                
                                Spacer()
                                Text("Coverage")
                                    .font(isFontMedium(size: 20))
                                    .bold()
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Image(systemName: "xmark")
                                    .font(isFontMedium(size: 22))
                                    .bold()
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        showCoveragePopup = false
                                    }
                                
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(appTheme)
                            
                            ForEach(quotationInfoArray.indices, id: \.self) { index in
                                let quote = quotationInfoArray[index]
                                
                                if let getQuote = quote.GetQuotes {
                                    ForEach(getQuote.indices, id: \.self) { indexValue in
                                        let quoteValue = getQuote[indexValue]
                                        
                                        if selectedCoverages == indexValue {
                                            
                                            VStack(alignment: .leading, spacing:10) {
                                                if let coverageTitle = quoteValue.CoverageTitle {
                                                    ForEach(splitCoverageTitle(coverageTitle), id: \.self) { title in
                                                        Text(title)
                                                            .font(isFontMedium(size: 17))
                                                    }
                                                }
                                            }
                                            .frame(maxWidth:.infinity,alignment:.leading)
                                            .padding(.horizontal)
                                            .padding([.top, .bottom],10)
                                            
                                            
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth:.infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal,30)
                        
                    }
                }
                
                if showBreakDownPopup {
                    ZStack {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                showBreakDownPopup = false
                            }
                        VStack {
                            HStack {
                                
                                Spacer()
                                Text("BREAK-DOWN")
                                    .font(isFontMedium(size: 20))
                                    .bold()
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Image(systemName: "xmark")
                                    .font(isFontMedium(size: 22))
                                    .bold()
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        showBreakDownPopup = false
                                    }
                                
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(appTheme)
                            
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    VStack(spacing: 0) {
                                        
                                        Text("S.No")
                                            .modifier(TextModifier())
                                            .bold()
                                            .foregroundColor(appTheme)
                                            .background(Color.gray.opacity(0.3))
                                            .multilineTextAlignment(.center)
                                            .frame(width:70)
                                        
                                        Divider()
                                            .frame(width:.infinity,height:2)
                                            .background(Color.white)
                                        
                                    }
                                    .frame(width:70)
                                    
                                    VStack(spacing: 0) {
                                        Text("Premium Information")
                                            .modifier(TextModifier())
                                            .bold()
                                            .foregroundColor(appTheme)
                                            .background(Color.white)
                                            .multilineTextAlignment(.center)
                                            .frame(maxWidth:.infinity,alignment:.center)
                                        
                                        Divider()
                                            .frame(height:1)
                                            .frame(maxWidth:.infinity,alignment:.center)
                                            .background(Color.gray.opacity(0.3))
                                    }
                                    .frame(maxWidth:.infinity,alignment:.center)
                                    
                                    
                                    VStack(spacing: 0) {
                                        Text("Amount (KSh)")
                                            .modifier(TextModifier())
                                            .bold()
                                            .foregroundColor(appTheme)
                                            .background(Color.gray.opacity(0.3))
                                            .multilineTextAlignment(.center)
                                            .frame(width:100)
                                        
                                        Divider()
                                            .frame(width:.infinity,height:2)
                                            .background(Color.white)
                                    }
                                    .frame(width:100)
                                }
                                .padding(.horizontal,8)
                                .fixedSize(horizontal: false, vertical: true)
                                
//                                ScrollView(showsIndicators:false) {
                                    VStack(spacing:0) {
                                        ForEach(quotationInfoArray.indices, id: \.self) { index in
                                            let quote = quotationInfoArray[index]
                                            
                                            if let premiumBreaks = quote.premiumBreaks {
                                                
                                                let sortedPremiumBreaks = premiumBreaks.sorted { ($0.Sequence ?? 0) < ($1.Sequence ?? 0) }
                                                
                                                ForEach(sortedPremiumBreaks.indices, id: \.self) { indexValue in
                                                    let premiumBreaksValue = sortedPremiumBreaks[indexValue]
                                                    
                                                    if selectedBreakDown == premiumBreaksValue.QuotesID {
                                                        
                                                        if premiumBreaksValue.PremiumText != "Total" {
                                                            
                                                            HStack(spacing: 0) {
                                                                VStack(spacing: 0) {
                                                                    
                                                                    Text("\(premiumBreaksValue.Sequence ?? 0)")
                                                                        .frame(maxWidth:.infinity,alignment:.leading)
                                                                        .modifier(TextModifier())
                                                                        .bold()
                                                                        .foregroundColor(.black)
                                                                        .background(Color.gray.opacity(0.3))
                                                                        .multilineTextAlignment(.center)
                                                                        .frame(width:70)
                                                                    
                                                                    Divider()
                                                                        .frame(width:.infinity,height:2)
                                                                        .background(Color.white)
                                                                    
                                                                }
                                                                .frame(width:70)
                                                                
                                                                VStack(spacing: 0) {
                                                                    Text(premiumBreaksValue.PremiumText ?? "")
                                                                        .frame(maxWidth:.infinity,alignment:.leading)
                                                                        .modifier(TextModifier())
                                                                        .foregroundColor(.black)
                                                                        .background(Color.white)
                                                                        .multilineTextAlignment(.leading)
                                                                        .frame(maxWidth:.infinity,alignment:.leading)
                                                                    
                                                                    Divider()
                                                                        .frame(height:1)
                                                                        .frame(maxWidth:.infinity,alignment:.center)
                                                                        .background(Color.gray.opacity(0.3))
                                                                }
                                                                .frame(maxWidth:.infinity,alignment:.center)
                                                                
                                                                
                                                                VStack(spacing: 0) {
                                                                    Text(formatDouble(premiumBreaksValue.PremiumValue ?? 0))
                                                                        .frame(maxWidth:.infinity,alignment:.center)
                                                                        .modifier(TextModifier())
                                                                        .foregroundColor(premiumBreaksValue.isNegative ? Color.red : Color.black)
                                                                        .background(Color.gray.opacity(0.3))
                                                                        .multilineTextAlignment(.center)
                                                                        .frame(width:100)
                                                                    
                                                                    Divider()
                                                                        .frame(width:.infinity,height:2)
                                                                        .background(Color.white)
                                                                }
                                                                .frame(width:100)
                                                            }
                                                            .padding(.horizontal,8)
                                                            .fixedSize(horizontal: false, vertical: true)
                                                        }
                                                        
                                                        
                                                    }
                                                }
                                            }
                                        }
                                        
                                        ForEach(quotationInfoArray.indices, id: \.self) { index in
                                            let quote = quotationInfoArray[index]
                                            
                                            if let premiumBreaks = quote.premiumBreaks {
                                                
                                                let sortedPremiumBreaks = premiumBreaks.sorted { ($0.Sequence ?? 0) < ($1.Sequence ?? 0) }
                                                
                                                ForEach(sortedPremiumBreaks.indices, id: \.self) { indexValue in
                                                    let premiumBreaksValue = sortedPremiumBreaks[indexValue]
                                                    
                                                    if selectedBreakDown == premiumBreaksValue.QuotesID {
                                                        
                                                        if premiumBreaksValue.PremiumText == "Total" {
                                                            
                                                            ZStack {
                                                                Color.gray.opacity(0.3)
                                                                HStack {
                                                                    
                                                                    Spacer()
                                                                    Text(premiumBreaksValue.PremiumText ?? "")
                                                                        .bold()
                                                                        .font(isFontMedium(size: 22))
                                                                        .foregroundColor(rose)
                                                                        .padding(.leading)
                                                                    
                                                                    Spacer()
                                                                    
                                                                    Text("KSh \(formatDouble(premiumBreaksValue.PremiumValue ?? 0))")
                                                                        .bold()
                                                                        .font(isFontBold(size: 22))
                                                                        .padding(.trailing)
                                                                    
                                                                }
                                                            }
                                                            .frame(maxWidth:.infinity)
                                                            .frame(height:50)
                                                            .cornerRadius(5)
                                                            .padding(.horizontal,8)
                                                            
                                                        }
                                                    }
                                                }
                                            }
                                        }

                                    }
//                                }
                                
                            }
                            .padding(.bottom,10)

                            

                        }
                        .frame(maxWidth:.infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal,10)
                        
                    }
                }
                
                if showComparePopup {
                    ZStack {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                showComparePopup = false
                                selectedIndices = []
                                showCompareButton = false
                            }
                        VStack {
                            HStack {
                                
                                Image(systemName: "xmark")
                                    .font(isFontMedium(size: 22))
                                    .bold()
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        showComparePopup = false
                                        selectedIndices = []
                                        showCompareButton = false
                                    }
                                
                                Spacer()
                                
                                Text("Compare Quotations")
                                    .font(isFontMedium(size: 20))
                                    .bold()
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(appTheme)
                            
                            ScrollView(showsIndicators: false) {
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                                    ForEach(quotationInfoArray.indices, id: \.self) { index in
                                        let quote = quotationInfoArray[index]
                                        
                                        if let getQuote = quote.GetQuotes {
                                            ForEach(getQuote.indices, id: \.self) { indexValue in
                                                let quoteValue = getQuote[indexValue]
                                                VStack {
                                                    ZStack {
                                                        Color.white
                                                        
                                                        VStack {
                                                            
                                                            HStack {
                                                                Image(systemName: selectedIndices.contains(quoteValue.ProductID ?? "") ?  "checkmark.square.fill" : "square")
                                                                    .bold()
                                                                    .font(isFontMedium(size: 23))
                                                                    .foregroundColor(selectedIndices.contains(quoteValue.ProductID ?? "") ? rose : rose)
                                                                    .frame(maxWidth:.infinity, alignment:.trailing)
                                                                //                                                                    .padding(15)
                                                            }
                                                            .frame(maxWidth:.infinity)
                                                            
                                                            VStack(spacing:8) {
                                                                //                                                            Image("CompareProductLogo")
                                                                Image(systemName: "exclamationmark.triangle")
                                                                    .resizable()
                                                                    .frame(width: 70, height: 70)
                                                                Text(quoteValue.ProductName ?? "")
                                                                    .font(isFontMedium(size: 14))
                                                                    .multilineTextAlignment(.center)
                                                                    .lineLimit(2)
                                                                
                                                                Text(quoteValue.sTotalAmount ?? "")
                                                                    .font(isFontMedium(size: 16))
                                                                    .foregroundColor(inkBlueColour)
                                                                    .multilineTextAlignment(.center)
                                                                    .lineLimit(1)
                                                            }
                                                            
                                                        }
                                                        .padding(8)
                                                        .frame(maxWidth:.infinity, maxHeight:.infinity, alignment:.top)
                                                    }
                                                    .frame(maxWidth:.infinity)
                                                    .frame(height: 180, alignment: .center)
                                                    .cornerRadius(15)
                                                    .shadow(radius: 2)
                                                    .onTapGesture {
                                                        
                                                        if selectedIndices.contains(quoteValue.ProductID ?? "") {
                                                            selectedIndices.remove(quoteValue.ProductID ?? "")
                                                            if selectedIndices.count != 2 {
                                                                showCompareButton = false
                                                                
                                                            }
                                                            
                                                        } else {
                                                            selectedIndices.insert(quoteValue.ProductID ?? "")
                                                            if selectedIndices.count == 2 {
                                                                showCompareButton = true
                                                            }
                                                        }
                                                    }
                                                    .padding(10)
                                                    
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                                .padding(10)
                                
                            }
                            
                            
                            if showCompareButton {
                                HStack {
                                    Text("Compare")
                                        .bold()
                                        .foregroundColor(.white)
                                        .font(isFontMedium(size: 20))
                                        .padding(.trailing)
                                }
                                .frame(maxWidth:.infinity)
                                .frame(height:50)
                                .background(rose)
                                .onTapGesture {
                                    if selectedIndices.count != 2 {
                                        if let errorDict = Extensions.getValidationDict() as? [String: String] {
                                            if let errorMessage = errorDict["VAL022"] {
                                                self.alertItem = AlertItem(title: Text("VAL022 \n \(errorMessage)"))
                                            }
                                        }
                                    } else {
                                        withAnimation {
                                            navigateComparePage = true
                                            showCompareButton = false
                                            showComparePopup = false
                                        }
                                        
                                    }
                                }
                            }
                            
                        }
                        .frame(maxWidth:.infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
                
            }
    }
    
    
    
    func splitCoverageTitle(_ coverageTitle: String) -> [String] {
        return coverageTitle.split(separator: ",").map { String($0) }.filter { !$0.isEmpty }
    }
    
    func formatDouble(_ value: Double) -> String {
           let formatter = NumberFormatter()
           formatter.minimumFractionDigits = 2
           formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
           return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
       }
    
    func fetchQuotationInfo() {
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
                
        let url = URL(string: "\(baseURL)api/Quotation/GetB2CQuotesInfo")!
        print(url)
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
//        let authToken:String! = "Bearer " + Extensions.token
//       
//        request.addValue(authToken, forHTTPHeaderField: "Authorization")
        
        
        request.addValue("\(theJSONData)", forHTTPHeaderField: "clientInfo")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("{\"orgAppID\":\"6120\",\"orgGroupID\":\"e6177150-0a4b-46f1-9c27-b55e848a69eb\"}", forHTTPHeaderField: "Webapirequest")
        request.addValue("mobile", forHTTPHeaderField: "source")

        let parameters: [String: Any] = [
            "QuotationID": quotationIDValue
//            "QuotationID": "22780ab3-add7-4fa6-9ccd-c213ae10fd77"
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
                
                let decoder = JSONDecoder()
                let getResponse = try decoder.decode(QuotationInfoResponseModel.self, from: data)
                
                DispatchQueue.main.async {
                    isLoading = false
                    
                    if getResponse.rcode == 200 {
                        
                        print(getResponse.rcode)
                        
                        quotationInfoArray = [getResponse.rObj]
                        quotationInfoArrayDetail = [getResponse.rObj]
                        
                        isLoading = false
                        
                        if let destinationCountryName = getResponse.rObj.GetQuotesInfo?.DestinationCountryName {
                            selectedDestinationListValue = destinationCountryName.split(separator: ",").map { String($0) }
                        }
                        
                        
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
    
    func fetchDownloadPdf() {
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
            
        let url = URL(string: "\(baseURL)api/Download/DownloadB2CQuotation")!
        print(url)
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("\(theJSONData)", forHTTPHeaderField: "clientInfo")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("{\"orgAppID\":\"6120\",\"orgGroupID\":\"e6177150-0a4b-46f1-9c27-b55e848a69eb\"}", forHTTPHeaderField: "Webapirequest")
        request.addValue("mobile", forHTTPHeaderField: "source")

        let parameters: [String: Any] = [
            "QuotationID": quotationIDValue
//            "QuotationID": "effcb90f-108a-402c-9519-4e19a5cd300a"
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
                        
                        print(rcode ?? 0)
                      
                        
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
    GetPremiumPage(navigateGetQuotePage: .constant(false))
}

struct TextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(5)
//            .frame(maxWidth: .infinity, alignment: .leading)
            .font(isFontMedium(size: 18))
            .modifier(EquallySized())
    }
}

struct EquallySized: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
                .frame(maxHeight: .infinity)
                .frame(height: .infinity)
                .background(GeometryReader { proxy in
                    Color.clear.preference(key: HeightPreferenceKey.self, value: proxy.size.height)
                })
                .onPreferenceChange(HeightPreferenceKey.self) { height in
                    content.frame(height: height)
                }
            Spacer()
        }
    }
}

struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
