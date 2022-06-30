//
//  Colors.swift
//  
//
//  Created by Justin Trautman on 6/30/22.
//  Copyright © 2022 Everyman Finance LLC. All rights reserved.
//

import SwiftUI

public struct Colors {
    
    public func getColorFor(slice: Int) -> Color {
        let color = UIColor(named: "slice\(String(slice))")
        return color == nil ? Color.random : Color(uiColor: color!)
    }
    
    public static var allColors: [Color] {
        let range = 0...10
        var colors = [Color]()
        range.forEach { int in colors.append(Color("slice\(String(int))")) }        
        return colors
    }
}

public extension Color {
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1))
    }
}
