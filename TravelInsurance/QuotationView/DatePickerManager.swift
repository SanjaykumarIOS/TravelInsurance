//
//  DatePickerManager.swift
//  TravelInsurance
//
//  Created by SANJAY  on 16/05/24.
//

import SwiftUI


class DateRangeViewModel: ObservableObject {
    @Published var startDate: Date {
        didSet {
            if endDate < startDate {
                endDate = startDate
            }
        }
    }
    
    @Published var endDate: Date {
        didSet {
            if endDate < startDate {
                endDate = startDate
            }
            
        }
    }
    
    init() {
        let today = Date()
        self.startDate = today
        self.endDate = today
    }
    
    func calculateNumberOfDays() -> Int {
        let calendar = Calendar.current
        // Add one day to endDate to include the end date as a whole day
        let endDateForCalculation = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: endDate) ?? endDate)
        // Calculate the difference in days between startDate and endDateForCalculation
        let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: startDate), to: endDateForCalculation)
        // Return the number of days
        return components.day ?? 0
    }

}
