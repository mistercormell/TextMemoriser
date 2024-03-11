//
//  Translation.swift
//  TextMemoriser
//
//  Created by Cormell, David - DPC on 11/03/2024.
//

import Foundation

enum Translation: String, CaseIterable {
    case esv, niv, kjv, nlt
    
    var details: (shortName: String, description: String) {
        switch self {
        case .esv:
            return ("ESV","English Standard Version (ESV)")
        case .niv:
            return ("NIV","New International Version (NIV)")
        case .kjv:
            return ("KJV","King James Version (KJV)")
        case .nlt:
            return ("NLT","New Living Translation (NLT)")
        }
    
    }
}
