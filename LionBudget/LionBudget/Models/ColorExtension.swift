//
//  ColorExtension.swift
//  LionBudget
//
//  Created by Yifan Lu on 3/21/23.
//

import SwiftUI

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
    
    public static var logoColor: Color {
        return Color(red: 27/256, green: 34/256, blue: 214/256)
    }
    
    public static var lightLogoColor: Color {
        return Color(red: 225/255, green: 225/255, blue: 1)
    }
    
}

extension UIColor {
    public static var logoColor: UIColor {
        return UIColor(red: 27/256, green: 34/256, blue: 214/256, alpha: 1.0)
    }
}
