//
//  PieChartView.swift
//  
//
//  Created by Justin Trautman on 6/30/22.
//  Copyright © 2022 Everyman Finance LLC. All rights reserved.
//

import SwiftUI

public struct PieChartView: View {
    public let values: [Double]
    public let names: [String]
    public let formatter: (Double) -> String
    
    public var colors: [Color]
    public var backgroundColor: Color
    
    public var size: PieSize
    public var innerRadiusFraction: CGFloat
    
    @State private var activeIndex: Int = -1
    
    var slices: [PieSliceData] {
        let sum = values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []
        
        for (i, value) in values.enumerated() {
            let degrees: Double = value * 360 / sum
            tempSlices.append(PieSliceData(startAngle: Angle(degrees: endDeg),
                                           endAngle: Angle(degrees: endDeg + degrees),
                                           text: String(format: "%.0f%%",
                                                        value * 100 / sum),
                                           color: Colors().getColorFor(slice: i)))
            endDeg += degrees
        }
        
        return tempSlices
    }
    
    public init(values: [Double],
                names: [String],
                formatter: @escaping (Double) -> String,
                colors: [Color] = Colors.allColors,
                backgroundColor: Color = .white,
                size: PieSize = .small,
                innerRadiusFraction: CGFloat = 0.60) {
                    
        self.values              = values
        self.names               = names
        self.formatter           = formatter
        self.colors              = colors
        self.backgroundColor     = backgroundColor
        self.size                = size
        self.innerRadiusFraction = innerRadiusFraction
    }
    
    public var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center, spacing: 20) {
                Spacer()
                ZStack {
                    ForEach(0..<values.count, id: \.self) { i in
                        PieSliceView(data: slices[i])
                            .scaleEffect(activeIndex == i ? 1.1 : 1)
                            .animation(.spring())
                     }
                    .frame(width: size.rawValue * geometry.size.width,
                           height: size.rawValue * geometry.size.width)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let radius = 0.5 * size.rawValue * geometry.size.width
                                let diff = CGPoint(x: value.location.x - radius, y: radius - value.location.y)
                                let dist = pow(pow(diff.x, 2.0) + pow(diff.y, 2.0), 0.5)
                                if (dist > radius || dist < radius * innerRadiusFraction) {
                                    activeIndex = -1
                                    return
                                }
                                
                                var radians = Double(atan2(diff.x, diff.y))
                                
                                if radians < 0 {
                                    radians = 2 * .pi + radians
                                }
                                
                                for (i, slice) in slices.enumerated() {
                                    if (radians < slice.endAngle.radians) {
                                        activeIndex = i
                                        break
                                    }
                                }
                            }
                            .onEnded({ value in
                                activeIndex = -1
                            })
                    )
                    Circle()
                        .fill(backgroundColor)
                        .frame(width: size.rawValue * geometry.size.width * innerRadiusFraction,
                               height: size.rawValue * geometry.size.width * innerRadiusFraction)
                    
                    VStack {
                        Text(activeIndex == -1 ? "Total" : names[activeIndex])
                            .font(size == .large ? .title : .headline)
                            .foregroundColor(.gray)
                        Text(formatter(activeIndex == -1 ? values.reduce(0, +) : values[activeIndex]))
                            .font(size == .large ? .title : .headline)
                    }
                }
                PieChartRows(colors: colors,
                             names: names,
                             values: values.map { formatter($0) },
                             percents: values.map { String(format: "%.0f%%", $0 * 100 / values.reduce(0, +)) })
                
            }
            .padding()
            .foregroundColor(.gray)
        }
        .frame(height: 180)
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(values: [1600, 300, 350],
                     names: ["Rent", "Gas", "Utilities"],
                     formatter: { value in String(format: "$%.2f", value) })
    }
}

public struct PieChartRows: View {
    var colors: [Color]
    var names: [String]
    var values: [String]
    var percents: [String]
    
    public var body: some View {
        VStack {
            ForEach(0..<values.count, id: \.self) { i in
                HStack {
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(colors[i])
                        .frame(width: 20, height: 20)
                    Text(names[i])
                        .lineLimit(2)
                    Spacer()
                    
                    /**
                     Uncomment this to enable slice details
                     
                     VStack(alignment: .trailing) {
                         Text(values[i])
                         Text(percents[i])
                             .foregroundColor(.gray)
                     }
                     */
                }
            }
        }
    }
}

public enum PieSize: CGFloat {
    case small = 0.45
    case large = 0.75
}
