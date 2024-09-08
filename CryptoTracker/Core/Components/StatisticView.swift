//
//  StatisticView.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 08/09/24.
//

import SwiftUI

struct StatisticView: View {
    let stat: StatisticModel
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(Color.theme.secondaryText)
            Text(stat.value)
                .foregroundStyle(Color.theme.accent)
                .font(.headline)
            
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees: (stat.percentageChange ?? 0) >= 0 ? 0 : 180))
                Text(stat.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle((stat.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(stat.percentageChange == nil ? 0 : 1)
            
        }
    }
}

#Preview {
    StatisticView(stat: DeveloperPreview.instance.stat3)
}
