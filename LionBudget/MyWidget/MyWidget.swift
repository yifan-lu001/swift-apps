//
//  MyWidget.swift
//  MyWidget
//
//  Created by Yifan Lu on 4/12/23.
//

import WidgetKit
import SwiftUI

func getData() -> [BudgetCategory] {
    var categories : [BudgetCategory] = []
    let fm = FileManager.default
    let containerURL = fm.containerURL(forSecurityApplicationGroupIdentifier: "group.edu.psu.yjl5480.MyGroup")
    var fileURL = containerURL!.appendingPathComponent("categories")
    fileURL = fileURL.appendingPathExtension("json")
    do {
        try categories = Bundle.main.decodeWithString(contents: String(contentsOf: fileURL))
    }
    catch {
        // print(error)
    }
    return categories
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> BudgetEntry {
        BudgetEntry(categories: [BudgetCategory.sampleFoodCategory, BudgetCategory.sampleHousingCategory, BudgetCategory.sampleSuppliesCategory, BudgetCategory.sampleTransportationCategory, BudgetCategory.sampleEntertainmentCategory, BudgetCategory.sampleMiscellaneousCategory])
    }

    func getSnapshot(in context: Context, completion: @escaping (BudgetEntry) -> ()) {
        let entry = BudgetEntry(categories: getData())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
            
        let entry = BudgetEntry(categories: getData())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct BudgetEntry: TimelineEntry {
    let date = Date()
    let categories: [BudgetCategory]
}


struct MyWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(Color.lightLogoColor.gradient)
            if entry.categories.count == 0 {
                Text("No spending data")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            else {
                CategoriesPieChartWidgetView(categories: entry.categories)
                    .offset(x: 22, y: 20)
            }
        }
    }
}

struct MyWidget: Widget {
    let kind: String = "MyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Spending")
        .description("Keep track of your spending.")
        .supportedFamilies([.systemSmall])
    }
}

struct MyWidget_Previews: PreviewProvider {
    static var previews: some View {
        MyWidgetEntryView(entry: BudgetEntry(categories: [BudgetCategory.sampleFoodCategory, BudgetCategory.sampleHousingCategory, BudgetCategory.sampleSuppliesCategory, BudgetCategory.sampleTransportationCategory, BudgetCategory.sampleEntertainmentCategory, BudgetCategory.sampleMiscellaneousCategory]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

public struct PieChartWidgetView: View {
    public let values: [Double]
    public let names: [String]
    public let formatter: (Double) -> String
    
    public var colors: [Color]
    public var backgroundColor: Color
    
    public var widthFraction: CGFloat
    public var innerRadiusFraction: CGFloat
    
    @State private var activeIndex: Int = -1
    
    var slices: [PieSliceData] {
        let sum = values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []
        
        for (i, value) in values.enumerated() {
            let degrees: Double = value * 360 / sum
            tempSlices.append(PieSliceData(startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endDeg + degrees), text: (value * 100 / sum) > 0 ? String(format: "%.0f%%", value * 100 / sum) : "", color: self.colors[i]))
            endDeg += degrees
        }
        return tempSlices
    }
    
    public init(values:[Double], names: [String], formatter: @escaping (Double) -> String, colors: [Color] = [Color.blue, Color.green, Color.orange], backgroundColor: Color = Color(red: 21 / 255, green: 24 / 255, blue: 30 / 255, opacity: 1.0), widthFraction: CGFloat = 0.75, innerRadiusFraction: CGFloat = 0.60){
        self.values = values
        self.names = names
        self.formatter = formatter
        
        self.colors = colors
        self.backgroundColor = backgroundColor
        self.widthFraction = widthFraction
        self.innerRadiusFraction = innerRadiusFraction
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack{
                ZStack{
                    ForEach(0..<self.values.count) { i in
                        PieSliceWidget(pieSliceData: self.slices[i])
                            .scaleEffect(self.activeIndex == i ? 1.03 : 1)
                            .animation(Animation.spring())
                    }
                    .frame(width: widthFraction * geometry.size.width, height: widthFraction * geometry.size.width)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let radius = 0.5 * widthFraction * geometry.size.width
                                let diff = CGPoint(x: value.location.x - radius, y: radius - value.location.y)
                                let dist = pow(pow(diff.x, 2.0) + pow(diff.y, 2.0), 0.5)
                                if (dist > radius || dist < radius * innerRadiusFraction) {
                                    self.activeIndex = -1
                                    return
                                }
                                var radians = Double(atan2(diff.x, diff.y))
                                if (radians < 0) {
                                    radians = 2 * Double.pi + radians
                                }
                                
                                for (i, slice) in slices.enumerated() {
                                    if (radians < slice.endAngle.radians) {
                                        self.activeIndex = i
                                        break
                                    }
                                }
                            }
                            .onEnded { value in
                                self.activeIndex = -1
                            }
                    )
                    Circle()
                        .frame(width: widthFraction * geometry.size.width * innerRadiusFraction, height: widthFraction * geometry.size.width * innerRadiusFraction)
                    
                    VStack {
                        Text(self.activeIndex == -1 ? "Total" : names[self.activeIndex])
                            .font(.caption)
                            .bold()
                            .foregroundColor(Color.gray)
                        Text(self.formatter(self.activeIndex == -1 ? values.reduce(0, +) : values[self.activeIndex]))
                            .font(.caption2)
                            .foregroundColor(.black)
                    }
                    
                }
            }
            .foregroundColor(.white)
            
        }
    }
}

struct PieSliceWidget: View {
    var pieSliceData: PieSliceData
    
    var midRadians: Double {
        return Double.pi / 2.0 - (pieSliceData.startAngle + pieSliceData.endAngle).radians / 2.0
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let width: CGFloat = min(geometry.size.width, geometry.size.height)
                    let height = width
                    path.move(
                        to: CGPoint(
                            x: width * 0.5,
                            y: height * 0.5
                        )
                    )
                    
                    path.addArc(center: CGPoint(x: width * 0.5, y: height * 0.5), radius: width * 0.5, startAngle: Angle(degrees: -90.0) + pieSliceData.startAngle, endAngle: Angle(degrees: -90.0) + pieSliceData.endAngle, clockwise: false)
                    
                }
                .fill(pieSliceData.color)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct CategoriesPieChartWidgetView: View {
    var categories: [BudgetCategory]
    
    var body: some View {
        let values: [Double] = categories.map { $0.currentSpending }
        let names: [String] = categories.map { $0.name }
        let colors: [Color] = categories.map { $0.budgetColor }
        PieChartWidgetView(values: values, names: names, formatter: {value in String(format: "$%.2f", value)}, colors: colors, backgroundColor: .white)
    }
}
