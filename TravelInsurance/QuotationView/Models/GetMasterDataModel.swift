

import SwiftUI


class MasterDataResponseData: Decodable {
    let rcode: Int
    let rObj: MasterDataRObj
    let rmsg: [MasterDataRMsg]
    let reqID: String?
    
    class MasterDataRObj: Decodable {
        let CountryCode: [CountryCode]
        let GetTravelPurpose: [TravelPurpose]
        let GetCountries: [CountryInfo]
        let Relationship: [RelationshipInfo]
        let PaymentMethods: [PaymentInfo]
        let kRAPintype: [KRAPinType]
        let consent: [consent]
        let declaration: [declaration]
        
        class CountryCode: Decodable {
            let masterDataID: String?
            let parentMasterDataID: String?
            let mdCategoryID: Int?
            let MDCategoryName: String?
            let mdTitle: String?
            let mdDesc: String?
            let mdValue: String?
            let iconURL: String?
            let regExValidation: String?
            let mstGroupID: String?
            let orgGroupID: String?
        }
        
        class TravelPurpose: Decodable {
            let masterDataID: String?
            let parentMasterDataID: String?
            let mdCategoryID: Int?
            let MDCategoryName: String?
            let mdTitle: String?
            let mdDesc: String?
            let mdValue: String?
            let iconURL: String?
            let regExValidation: String?
            let mstGroupID: String?
            let orgGroupID: String?
        }
        
        class CountryInfo: Decodable {
            let FromCountryId: String?
            let FromCountryName: String?
            let FromCountrySourceID: Int?
            let FromCountryCode: String?
            let ToCountryCode: String?
            let ToCountrySourceId: Int?
            let TocountryID: String?
            let ToCountryName: String?
        }

        class RelationshipInfo: Decodable {
            let masterDataID: String?
            let parentMasterDataID: String?
            let mdCategoryID: Int?
            let MDCategoryName: String?
            let mdTitle: String?
            let mdDesc: String?
            let mdValue: String?
            let iconURL: String?
            let regExValidation: String?
            let mstGroupID: String?
            let orgGroupID: String?
        }
        
        class PaymentInfo: Decodable {
            let masterDataID: String?
            let parentMasterDataID: String?
            let mdCategoryID: Int?
            let MDCategoryName: String?
            let mdTitle: String?
            let mdDesc: String?
            let mdValue: String?
            let iconURL: String?
            let regExValidation: String?
            let mstGroupID: String?
            let orgGroupID: String?
        }
        
        class KRAPinType: Decodable {
            let masterDataID: String?
            let parentMasterDataID: String?
            let mdCategoryID: Int?
            let MDCategoryName: String?
            let mdTitle: String?
            let mdDesc: String?
            let mdValue: String?
            let iconURL: String?
            let regExValidation: String?
            let mstGroupID: String?
            let orgGroupID: String?
        }
        
        class consent: Decodable {
            let masterDataID: String?
            let parentMasterDataID: String?
            let mdCategoryID: Int?
            let MDCategoryName: String?
            let mdTitle: String?
            let mdDesc: String?
            let mdValue: String?
            let iconURL: String?
            let regExValidation: String?
            let mstGroupID: String?
            let orgGroupID: String?
        }
        
        class declaration: Decodable {
            let masterDataID: String?
            let parentMasterDataID: String?
            let mdCategoryID: Int?
            let MDCategoryName: String?
            let mdTitle: String?
            let mdDesc: String?
            let mdValue: String?
            let iconURL: String?
            let regExValidation: String?
            let mstGroupID: String?
            let orgGroupID: String?
        }

    }
}


class MasterDataRMsg: Decodable {
    let errorText: String
    let errorCode: String
    let fieldName: String?
    let fieldValue: String?
}



