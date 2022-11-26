//
//  IntExt.swift
//  GLITechnicalTest
//
//  Created by Prawira Hadi Fitrajaya on 25/11/22.
//

import Foundation

extension Int {
    
    func numberSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        
        return formatter.string(from: self as NSNumber) ?? ""
    }
}
