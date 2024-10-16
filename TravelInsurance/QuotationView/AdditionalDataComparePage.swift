//
//  AdditionalDataComparePage.swift
//  TravelInsurance
//
//  Created by SANJAY  on 05/06/24.
//

import SwiftUI

struct AdditionalDataComparePage: View {
    
    @Binding var quotationCompareArray: [QuotationCompareResponseModel.QuotationCompareRobj]
    
    @Binding var selectedIndices: Set<String>
    @Binding var uniqueCoverageNames: Set<String>
    @Binding var firstSelectedIndexLimits: Set<String>
    @Binding var secondSelectedIndexLimits: Set<String>
    
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            LoadingView(isShowing: $isLoading) {
                VStack {

                    
                    
                    
                    ForEach(quotationCompareArray.indices, id: \.self) { compare in
                        let quote = quotationCompareArray[compare]
                        
                        if let coverages = quote.Coverages {
                            // Collect unique coverage names
                            let uniqueCoverages = Array(Set(coverages.compactMap { $0.CoverageName }))
                            
                            ForEach(uniqueCoverages, id: \.self) { coverageName in
                                
                                VStack {
                                    Text(coverageName)
                                        .font(isFontMedium(size: 19))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth:.infinity)
                                        .padding()
                                        .background(appTheme)
                                        .frame(height:50, alignment:.top)
                                    
                                    if !uniqueCoverageNames.contains(coverageName) {
                                        Image(systemName: "multiply.circle.fill")
                                            .resizable()
                                            .bold()
                                            .frame(width: 30, height:30)
                                            .foregroundColor(.red)
                                    }
                                    
                                    
                                    VStack {
                                        if let quotationCompare = quote.QuotationCompare {
                                            ForEach(quotationCompare.indices, id: \.self) { index in
                                                let compareValue = quotationCompare[index]
                                                
                                                if selectedIndices.contains(compareValue.ProductID ?? "") {
                                                    
                                                    if let coverageQuotesCompare = compareValue.coverageQuotesCompare {
                                                        ForEach(coverageQuotesCompare.indices, id: \.self) { coverageQuotesIndex in
                                                            let coverageQuotesValue = coverageQuotesCompare[coverageQuotesIndex]
                                                            
                                                            
                                                            if coverageName == coverageQuotesValue.CoverageName {
                                                                if let additionalData = coverageQuotesValue.additionalData, !additionalData.isEmpty {
                                                                    
                                                                    let uniqueLabels = Set(additionalData.map { $0.AdditionalCoverageLabel ?? "" })
                                                                    
                                                                    VStack {
                                                                        ForEach(uniqueLabels.sorted(), id: \.self) { uniqueLabel in
                                                                            
                                                                            VStack {
                                                                                
                                                                                VStack {
                                                                                    Text(uniqueLabel)
                                                                                        .font(isFontMedium(size: 18))
                                                                                        .foregroundColor(.white)
                                                                                        .multilineTextAlignment(.center)
                                                                                    
                                                                                }
                                                                                .frame(maxWidth:.infinity)
                                                                                .padding()
                                                                                .background(rose)
                                                                                .fixedSize(horizontal: false, vertical: true)
                                                                                
                                                                                HStack {

                                                                                    ForEach(additionalData.indices, id: \.self) { additionalDataIndex in
                                                                                        let data = additionalData[additionalDataIndex]
                                                                                        if uniqueLabel == data.AdditionalCoverageLabel {
                                                                                            
                                                                                            VStack {
                                                                                            if firstSelectedIndexLimits.contains(data.AdditionalCoverageDescriptionUserLimit ?? "") {
                                                                                                
                                                                                              
                                                                                                    Image(systemName: "checkmark.circle.fill")
                                                                                                        .resizable()
                                                                                                        .bold()
                                                                                                        .frame(width: 30, height:30)
                                                                                                        .foregroundColor(.green)
                                                                                                    
                                                                                                    Text(data.AdditionalCoverageDescriptionUserLimit ?? "")
                                                                                                        .font(isFontMedium(size: 17))
                                                                                                        .foregroundColor(.black)
                                                                                                        .multilineTextAlignment(.center)
                                                                                                    
                                                                                                } else {
                                                                                                    Image(systemName: "multiply.circle.fill")
                                                                                                        .resizable()
                                                                                                        .bold()
                                                                                                        .frame(width: 30, height:30)
                                                                                                        .foregroundColor(.red)
                                                                                                    
                                                                                                }
                                                                                                
                                                                                            }
                                                                                            .frame(maxWidth: .infinity)
                                                                                            
                                                                                            DottedLineVertical()
                                                                                                .frame(width: 1)
                                                                                                .foregroundColor(.black)
                                                                                            
                                                                                            VStack {
                                                                                            if secondSelectedIndexLimits.contains(data.AdditionalCoverageDescriptionUserLimit ?? "") {
                                                                                                
                                                                                               
                                                                                                    Image(systemName: "checkmark.circle.fill")
                                                                                                        .resizable()
                                                                                                        .bold()
                                                                                                        .frame(width: 30, height:30)
                                                                                                        .foregroundColor(.green)
                                                                                                    
                                                                                                    Text(data.AdditionalCoverageDescriptionUserLimit ?? "")
                                                                                                        .font(isFontMedium(size: 17))
                                                                                                        .foregroundColor(.black)
                                                                                                        .multilineTextAlignment(.center)
                                                                                                    
                                                                                                } else {
                                                                                                    Image(systemName: "multiply.circle.fill")
                                                                                                        .resizable()
                                                                                                        .bold()
                                                                                                        .frame(width: 30, height:30)
                                                                                                        .foregroundColor(.red)
                                                                                                    
                                                                                                }
                                                                                                
                                                                                            }
                                                                                            .frame(maxWidth: .infinity)
                                                                                        }
                                                                                    }
                                                                                }
                                                                                
                                                                                
                                                                            }
                                                                            .frame(maxWidth:.infinity)
                                                                            .background(Color.white)
                                                                            .cornerRadius(10)
                                                                            .shadow(radius: 2)
                                                                            .padding(10)
                                                                            .fixedSize(horizontal: false, vertical: true)
                                                                            
                                                                        }
                                                                        
                                                                    }
                                                                }
                                                                
                                                            }
                                                            
                                                        }
                                                    }
                                                    
                                                }
                                                
                                            }
                                        }
                                    }
                                    .padding(5)
                                }
                                .frame(maxWidth:.infinity)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                                .padding(10)
                                
                            }
                        }
                    }
                    
                }
                .onAppear{
                    isLoading = true
                    
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    GetPremiumPage(navigateGetQuotePage: .constant(false))
}



