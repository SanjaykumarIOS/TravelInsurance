//
//  QuotationCompareModel.swift
//  TravelInsurance
//
//  Created by SANJAY  on 03/06/24.
//

import SwiftUI

class QuotationCompareResponseModel: Decodable {
    let rcode: Int
    let rObj: QuotationCompareRobj
    let isSuccess: Bool
    let rmsg: [QuotationCompareResponseMessage]
    let reqID: String?
    let trnID: String?
    
    class QuotationCompareRobj: Decodable {
        let QuotationCompare: [QuotationCompare]?
        let Coverages: [CoverageQuotesCompare]?
    }
    
    class QuotationCompare: Decodable {
        let QuotesID: String?
        let QuotationID: String?
        let QuotationNumber: String?
        let ProductID: String?
        let ProductName: String?
        let ProductSourceID: Int?
        let coverageQuotesCompare: [CoverageQuotesCompare]?
    }

    // MARK: - Coverage Quotes Compare
    class CoverageQuotesCompare: Decodable {
        let CoverageID: String?
        let CoverageName: String?
        let additionalData: [AdditionalData]?
    }

    // MARK: - Additional Data
    class AdditionalData: Decodable {
        let CoverageID: String?
        let CoverageName: String?
        let CoverageDescription: String?
        let AdditionalCoverageID: String?
        let AdditionalCoverageName: String?
        let AdditionalCoverageLabel: String?
        let AdditionalCoverageLabelName: String?
        let AdditionalCoverageDescription: String?
        let AdditionalCoverageDescriptionUserLimit: String?
    }
    
    
}


class QuotationCompareResponseMessage: Decodable {
    let errorText: String
    let errorCode: String
    let fieldName: String?
    let fieldValue: String?
}
