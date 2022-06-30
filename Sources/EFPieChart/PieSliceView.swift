//
//  PieSliceView.swift
//  
//
//  Created by Justin Trautman on 6/30/22.
//  Copyright © 2022 Everyman Finance LLC. All rights reserved.
//

import SwiftUI

struct PieSliceView: View {
    var data: PieSliceData
    
    var midRadians: Double {
        .pi / 2.0 - (data.startAngle + data.endAngle).radians / 2.0
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let width: CGFloat = min(geometry.size.width, geometry.size.height)
                    let height = width
                    path.move(to: CGPoint(x: width * 0.5, y: height * 0.5))
                    path.addArc(center: CGPoint(x: width * 0.5, y: height * 0.5),
                                radius: width * 0.5,
                                startAngle: Angle(degrees: -90.0) + data.startAngle,
                                endAngle: Angle(degrees: -90.0) + data.endAngle,
                                clockwise: false)
                }
                .fill(data.color)
                                
                Text(data.text)
                    .position(x: geometry.size.width * 0.5 * CGFloat(1.0 + 0.78 * cos(midRadians)),
                              y: geometry.size.height * 0.5 * CGFloat(1.0 - 0.78 * sin(midRadians)))
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                    .minimumScaleFactor(0.75)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct PieSliceView_Previews: PreviewProvider {
    static var previews: some View {
        PieSliceView(data: PieSliceData(startAngle: Angle(degrees: 0.0), endAngle: Angle(degrees: 120.0), text: "30%", color: Color.black))

    }
}

struct PieSliceData {
    var startAngle: Angle
    var endAngle: Angle
    var text: String
    var color: Color
}
