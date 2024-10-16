//
//  ComparePage.swift
//  TravelInsurance
//
//  Created by SANJAY  on 03/06/24.
//

import SwiftUI

var selectedAdditionalIndices: Set<String> = []

//var quotationCompareArray: [QuotationCompareResponseModel.QuotationCompareRobj] = []
//var uniqueCoverageNames: Set<String> = Set()
//var firstSelectedIndexLimits: Set<String> = []
//var secondSelectedIndexLimits: Set<String> = []
var uniqueLabels: Set<String> = []


struct ComparePage: View {
    
    @State private var quotationCompareArray: [QuotationCompareResponseModel.QuotationCompareRobj] = []
    
    @Binding var navigateComparePage: Bool
    @Binding var selectedIndices: Set<String>
    
//    @State private var uniqueLabels: Set<String> = []
    @State private var uniqueCoverageNames: Set<String> = Set()
    
    @State private var additionalDataLabelArray:[String] = []
    
    @State private var firstSelectedIndexLimits: Set<String> = []
    @State private var secondSelectedIndexLimits: Set<String> = []
    
    @State private var firstSelectedIndex: String? = nil
    @State private var secondSelectedIndex: String? = nil

    var selectedIndicesArray: [String] {
        Array(selectedIndices)
    }
    
    @State private var isLoading = false
    @State private var alertItem: AlertItem?
        
    var body: some View {
        NavigationStack {
            LoadingView(isShowing: $isLoading) {
                VStack {
                    
                    let selectedIndicesArray = Array(selectedIndices)
                    
                    HStack {
                        
                        if selectedIndicesArray.count > 0 {
                            let secondSelectedIndex = selectedIndicesArray[0]
                            
                            HStack {
                                ForEach(quotationCompareArray.indices, id: \.self) { compare in
                                    let quote = quotationCompareArray[compare]
                                    
                                    if let quotationCompare = quote.QuotationCompare {
                                        ForEach(quotationCompare.indices, id: \.self) { index in
                                            let compareValue = quotationCompare[index]
                                            
                                            if compareValue.ProductID == secondSelectedIndex {
                                                Text(compareValue.ProductName ?? "")
                                                    .font(isFontMedium(size: 19))
                                                    .bold()
                                                    .foregroundColor(appTheme)
                                                    .multilineTextAlignment(.center)
                                                    .frame(maxWidth: .infinity)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(10)
                        }
                        
                        
                        DottedLineVertical()
                            .frame(width: 1)
                            .foregroundColor(.black)
                        
                        if selectedIndicesArray.count > 1 {
                            let secondSelectedIndex = selectedIndicesArray[1]
                            
                            HStack {
                                ForEach(quotationCompareArray.indices, id: \.self) { compare in
                                    let quote = quotationCompareArray[compare]
                                    
                                    if let quotationCompare = quote.QuotationCompare {
                                        ForEach(quotationCompare.indices, id: \.self) { index in
                                            let compareValue = quotationCompare[index]
                                            
                                            if compareValue.ProductID == secondSelectedIndex {
                                                Text(compareValue.ProductName ?? "")
                                                    .font(isFontMedium(size: 19))
                                                    .bold()
                                                    .foregroundColor(appTheme)
                                                    .multilineTextAlignment(.center)
                                                    .frame(maxWidth: .infinity)
                                                
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(10)
                        }
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment:.leading, spacing:10) {
                            
                            
                            //                                                        AdditionalDataComparePage(quotationCompareArray: $quotationCompareArray, selectedIndices: $selectedIndices, uniqueCoverageNames: $uniqueCoverageNames,firstSelectedIndexLimits: $firstSelectedIndexLimits, secondSelectedIndexLimits: $secondSelectedIndexLimits)
                            
                            ForEach(quotationCompareArray.indices, id: \.self) { compare in
                                let quote = quotationCompareArray[compare]
                                
                                if let coverages = quote.Coverages {
                                    ForEach(coverages, id: \.CoverageID) { coverage in
                                        
                                        ZStack {
                                            Color.white
                                            VStack {
                                                Text(coverage.CoverageName ?? "")
                                                    .font(isFontMedium(size: 19))
                                                    .foregroundColor(.white)
                                                    .multilineTextAlignment(.center)
                                                    .frame(maxWidth:.infinity)
                                                    .padding()
                                                    .background(appTheme)
                                                    .fixedSize(horizontal: false, vertical: true)
                                                
                                                if !uniqueCoverageNames.contains(coverage.CoverageName ?? "") {
                                                    Image(systemName: "multiply.circle.fill")
                                                        .resizable()
                                                        .bold()
                                                        .frame(width: 30, height:30)
                                                        .foregroundColor(.red)
                                                }
                                                
                                                VStack {
                                                    
                                                    if let additionalData = coverage.additionalData {
                                                        ForEach(additionalData.indices, id: \.self) { indexValue in
                                                            let additional = additionalData[indexValue]
                                                            
                                                            ZStack {
                                                                Color.white
                                                                
                                                                VStack {
                                                                    
                                                                    VStack {
                                                                        Text(additional.AdditionalCoverageLabel ?? "")
                                                                            .font(isFontMedium(size: 18))
                                                                            .foregroundColor(.white)
                                                                            .multilineTextAlignment(.center)
                                                                        
                                                                    }
                                                                    .frame(maxWidth:.infinity)
                                                                    .padding()
                                                                    .background(rose)
                                                                    .fixedSize(horizontal: false, vertical: true)
                                                                    
                                                                    
                                                                    HStack(alignment:.top) {
                                                                        
                                                                        if selectedIndicesArray.count > 0 {
                                                                            let firstSelectedIndex = selectedIndicesArray[0]
                                                                            let additionalCoverageDict = buildAdditionalCoverageDictionary(for: firstSelectedIndex)
                                                                            
                                                                            if let label = additional.AdditionalCoverageLabel, let matchingDescription = additionalCoverageDict[label] {
                                                                                
                                                                                VStack {
                                                                                    Image(systemName: "checkmark.circle.fill")
                                                                                        .resizable()
                                                                                        .bold()
                                                                                        .frame(width: 30, height: 30)
                                                                                        .foregroundColor(.green)
                                                                                    
                                                                                    Text(matchingDescription)
                                                                                        .font(isFontMedium(size: 17))
                                                                                        .foregroundColor(.black)
                                                                                        .multilineTextAlignment(.center)
                                                                                }
                                                                                .frame(maxWidth: .infinity)
                                                                            } else {
                                                                                VStack {
                                                                                    Image(systemName: "multiply.circle.fill")
                                                                                        .resizable()
                                                                                        .bold()
                                                                                        .frame(width: 30, height:30)
                                                                                        .foregroundColor(.red)
                                                                                }
                                                                                .frame(maxWidth: .infinity)
                                                                                .padding(10)
                                                                            }
                                                                        }
                                                                        
                                                                        DottedLineVertical()
                                                                            .frame(width: 1)
                                                                            .foregroundColor(.black)
                                                                        
                                                                        if selectedIndicesArray.count > 1 {
                                                                            let firstSelectedIndex = selectedIndicesArray[1]
                                                                            let additionalCoverageDict = buildAdditionalCoverageDictionary(for: firstSelectedIndex)
                                                                            
                                                                            if let label = additional.AdditionalCoverageLabel, let matchingDescription = additionalCoverageDict[label] {
                                                                                VStack {
                                                                                    Image(systemName: "checkmark.circle.fill")
                                                                                        .resizable()
                                                                                        .bold()
                                                                                        .frame(width: 30, height: 30)
                                                                                        .foregroundColor(.green)
                                                                                    
                                                                                    Text(matchingDescription)
                                                                                        .font(isFontMedium(size: 17))
                                                                                        .foregroundColor(.black)
                                                                                        .multilineTextAlignment(.center)
                                                                                }
                                                                                .frame(maxWidth: .infinity)
                                                                            } else {
                                                                                VStack {
                                                                                    Image(systemName: "multiply.circle.fill")
                                                                                        .resizable()
                                                                                        .bold()
                                                                                        .frame(width: 30, height:30)
                                                                                        .foregroundColor(.red)
                                                                                }
                                                                                .frame(maxWidth: .infinity)
                                                                                .padding(10)
                                                                            }
                                                                        }
                                                                    }
                                                                    
                                                                }
                                                                
                                                            }
                                                            .frame(maxWidth:.infinity)
                                                            .cornerRadius(10)
                                                            .shadow(radius: 1)
                                                            .padding(10)
                                                            .fixedSize(horizontal: false, vertical: true)
                                                        }
                                                    }
                                                }
                                                
                                            }
                                        }
                                        .frame(maxWidth:.infinity)
                                        .cornerRadius(10)
                                        .shadow(radius: 2)
                                        .padding(10)
                                    }
                                }
                            }
                            
                        }
                    }
                }
                
                .onAppear {
                    fetchQuotationCompare()
                }
                
                .onAppear {
                    let selectedIndicesArray = Array(selectedIndices)
                    if selectedIndicesArray.count > 0 {
                        firstSelectedIndex = selectedIndicesArray[0]
                    }
                    if selectedIndicesArray.count > 1 {
                        secondSelectedIndex = selectedIndicesArray[1]
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
                            
                            Button(action: {
                                withAnimation {
                                    navigateComparePage = false
                                    selectedIndices.removeAll()
                                }
                            })
                            {
                                Image(systemName: "arrow.backward")
                                    .bold()
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding(.bottom)
                            }
                            
                            Text("Compare Products")
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
        }
    }
    
    private func buildAdditionalCoverageDictionary(for productID: String) -> [String: String] {
        var additionalCoverageDict: [String: String] = [:]
        
        for compare in quotationCompareArray {
            if let quotationCompare = compare.QuotationCompare {
                for compareValue in quotationCompare {
                    if compareValue.ProductID == productID {
                        if let coverageQuotesCompare = compareValue.coverageQuotesCompare {
                            for coverageQuotesValue in coverageQuotesCompare {
                                if let additionalData = coverageQuotesValue.additionalData {
                                    for additionalValue in additionalData {
                                        if let label = additionalValue.AdditionalCoverageLabel {
                                            additionalCoverageDict[label] = additionalValue.AdditionalCoverageDescriptionUserLimit ?? ""
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return additionalCoverageDict
    }

 
    
    func fetchQuotationCompare() {
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
                
        let url = URL(string: "\(baseURL)api/Quotation/QuotationB2CCompare")!
        print(url)
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
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
                let getResponse = try decoder.decode(QuotationCompareResponseModel.self, from: data)
                
                DispatchQueue.main.async {
                    isLoading = false
                    
                    let rcode = resultDictionary["rcode"] as? Int
                    
                    if getResponse.rcode == 200 {
                        
                        print(rcode ?? 0)
                        
                        quotationCompareArray = [getResponse.rObj]
                                                
                        var newUniqueLabels: Set<String> = []
                        
                        for data in quotationCompareArray {
                            if let value = data.QuotationCompare {
                                for data1 in value {
                                    if let value1 = data1.coverageQuotesCompare {
                                        for compare in value1 {
                                            if let additionalData = compare.additionalData {
                                                for datum in additionalData {
                                                    if selectedIndices.contains(data1.ProductID ?? "") {
                                                        newUniqueLabels.insert(datum.AdditionalCoverageLabel ?? "")
                                                        if let additionalData = compare.additionalData, !additionalData.isEmpty {
                                                            uniqueCoverageNames.insert(compare.CoverageName ?? "")
                                                            
                                                            if let additionalDataLabel = datum.AdditionalCoverageLabel {
                                                                additionalDataLabelArray.append(additionalDataLabel)
                                                            }
                                                            
                                                            // Check if we have found the first selected index
                                                            if let descriptionUserLimit = datum.AdditionalCoverageDescriptionUserLimit {
                                                                if let firstSelectedIndex = selectedIndices.first, data1.ProductID == firstSelectedIndex {
                                                                    firstSelectedIndexLimits.insert(descriptionUserLimit)
                                                                }
                                                                // Check if we have found the second selected index
                                                                if let secondSelectedIndex = selectedIndices.dropFirst().first, data1.ProductID == secondSelectedIndex {
                                                                    secondSelectedIndexLimits.insert(descriptionUserLimit)
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
                        }

                        // Now firstSelectedIndexLimits array contains AdditionalCoverageDescriptionUserLimit values for the first selected index
                        print("AdditionalCoverageDescriptionUserLimit for first selected index == \(firstSelectedIndexLimits)")

                        // Now secondSelectedIndexLimits array contains AdditionalCoverageDescriptionUserLimit values for the second selected index
                        print("AdditionalCoverageDescriptionUserLimit for second selected index == \(secondSelectedIndexLimits)")
                                                
                        uniqueLabels = newUniqueLabels
                    
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
}

#Preview {
    GetPremiumPage(navigateGetQuotePage: .constant(false))
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

struct DottedLineVertical: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let pattern: [CGFloat] = [4,4] // Customize the pattern as per your requirement
        
        let start = rect.origin
        let end = CGPoint(x: rect.origin.x, y: rect.maxY)
        
        path.move(to: start)
        path.addLine(to: end)
        path = path.strokedPath(StrokeStyle(lineWidth: 1, dash: pattern))
        
        return path
    }
}



//HStack {
//    if let quotationCompare = quote.QuotationCompare {
//        let matchFound = isMatchFound(quotationCompare: quotationCompare, additional: additional, coverageName: coverage.CoverageName ?? "")
//        
//        if matchFound {
//            ForEach(quotationCompare.indices, id: \.self) { index in
//                let compareValue = quotationCompare[index]
//                
//                if selectedIndices.contains(compareValue.ProductID ?? "") {
//                    
//                    if let coverageQuotesCompare = compareValue.coverageQuotesCompare {
//                        
//                        ForEach(coverageQuotesCompare.indices, id: \.self) { coverageQuotesIndex in
//                            let coverageQuotesValue = coverageQuotesCompare[coverageQuotesIndex]
//                            
//                            if let additionalData = coverageQuotesValue.additionalData, !additionalData.isEmpty {
//                                ForEach(additionalData.indices, id: \.self) { additionalIndex in
//                                    let additionalValue = additionalData[additionalIndex]
//                                    
//                                    if coverage.CoverageName == additionalValue.CoverageName {
//                                        
//                                        if additional.AdditionalCoverageLabel == additionalValue.AdditionalCoverageLabel {
//                                            
//                                            VStack {
//                                                Image(systemName: "checkmark.circle.fill")
//                                                    .resizable()
//                                                    .bold()
//                                                    .frame(width: 30, height: 30)
//                                                    .foregroundColor(.green)
//                                                
//                                                Text(additionalValue.AdditionalCoverageDescriptionUserLimit ?? "")
//                                                    .font(isFontMedium(size: 17))
//                                                    .foregroundColor(.black)
//                                                    .multilineTextAlignment(.center)
//                                            }
//                                            .frame(maxWidth: .infinity)
//                                            
//                                            DottedLineVertical()
//                                                .frame(width: 1)
//                                                .foregroundColor(.black)
//                                        }
//                                    }
//                                    
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        } else {
//            VStack {
//                Image(systemName: "multiply.circle.fill")
//                    .resizable()
//                    .bold()
//                    .frame(width: 30, height:30)
//                    .foregroundColor(.red)
//            }
//            .frame(maxWidth: .infinity)
//            .padding(10)
//            
//           
//        }
//    }
//    
//}




//                                                  if let quotationCompare = quote.QuotationCompare {
//                                                        ForEach(quotationCompare.indices, id: \.self) { index in
//                                                            let compareValue = quotationCompare[index]
//
////                                                            if selectedIndices.contains(compareValue.ProductID ?? "") {
//
//                                                                if let firstSelectedIndex = selectedIndices.first, compareValue.ProductID == firstSelectedIndex {
//
//                                                                if let additionalData = coverage.additionalData {
//                                                                    ForEach(additionalData.indices, id: \.self) { indexValue in
//                                                                        let additional = additionalData[indexValue]
//                                                                        ZStack {
//                                                                            Color.white
//                                                                            VStack {
//
//                                                                                VStack {
//                                                                                    Text(additional.AdditionalCoverageLabel ?? "")
//                                                                                        .font(isFontMedium(size: 18))
//                                                                                        .foregroundColor(.white)
//                                                                                        .multilineTextAlignment(.center)
//
//                                                                                }
//                                                                                .frame(maxWidth:.infinity)
//                                                                                .padding()
//                                                                                .background(rose)
//                                                                                .fixedSize(horizontal: false, vertical: true)
//
//                                                                            }
//                                                                        }
//                                                                        .frame(maxWidth:.infinity)
//                                                                        .cornerRadius(10)
//                                                                        .shadow(radius: 1)
//                                                                        .padding(10)
//                                                                        .fixedSize(horizontal: false, vertical: true)
//                                                                    }
//                                                                }
//                                                            }
//                                                        }
//                                                    }
                                                    
