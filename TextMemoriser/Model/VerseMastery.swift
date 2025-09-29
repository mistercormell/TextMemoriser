//
//  VerseMastery.swift
//  TextMemoriser
//
//  Created by David Cormell on 26/01/2022.
//

import Foundation

struct VerseMastery {
    var attempts: Int
    var correct: Int
    var lastStudied: Date
    
    func getMasteryLevel() -> Double {
        guard attempts >= 0 && correct >= 0 && attempts >= correct else { return 0.0 }
        
        //constants
        let alphaPrior = 1.0
        let betaPrior = 1.0
        let practiceK = 0.25
        let lambda = 0.03
        let normalizeFactor = 1.2
        
        //calculate days since last revised
        let calendar = Calendar.current
        let daysSinceLastRevised = calendar.dateComponents([.day], from: lastStudied, to: Date.now).day ?? 0
        
        // Smoothed accuracy (Bayesian)
        let pHat = (Double(correct) + alphaPrior) / (Double(attempts) + alphaPrior + betaPrior)
        // diminishing practice bonus
        let practiceBonus = log(1.0 + Double(attempts)) * practiceK
        // exponential decay
        let decay = exp(-lambda * Double(daysSinceLastRevised))
        // raw mastery (might exceed 1.0 depending on practiceBonus)
        let raw = pHat * (1.0 + practiceBonus) * decay
        // normalize and clamp to 0..100
        let normalised = raw / normalizeFactor
        let score = normalised * 100.0
        return max(0.0, min(100.0, score))
    }
}
