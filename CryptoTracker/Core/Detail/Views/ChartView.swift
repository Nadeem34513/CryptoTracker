//
//  ChartView.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 11/09/24.
//

import SwiftUI

struct ChartView: View {
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    @State private var percentage: CGFloat = 0
    
    init(coin: CoinModel) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange < 0 ?  .theme.red : .theme.green
        
        
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        // starting date is 7 days from ending // substract 7 days from ending date
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }
    
    var body: some View {
        VStack {
            chartView
                .frame(height: 250)
                .background(chartBackground)
                .overlay(alignment: .leading) { chartYAxis.padding(.horizontal, 4)  }
            
            chartDateLabels
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                withAnimation(.linear(duration: 1)) {
                    percentage = 1.0
                }
            })
        }
    }
        
}

#Preview {
    ChartView(coin: DeveloperPreview.instance.coin)
}

extension ChartView {
    private var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(1 + index)
                    
                    let yAxis = maxY - minY
                    
                    let yPosition = (1 -  CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                    
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            
            .trim(to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round))
            .shadow(color: lineColor.opacity(0.5), radius: 10, y: 15)
            .shadow(color: lineColor.opacity(0.3), radius: 10, y: 25)
            .shadow(color: lineColor.opacity(0.2), radius: 10, y: 35)
            .shadow(color: lineColor.opacity(0.1), radius: 10, y: 45)
        }
    }
    
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartYAxis: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    
    private var chartDateLabels: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString() )
        }
    }
}
