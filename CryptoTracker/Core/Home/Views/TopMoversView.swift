//
//  TopMoversView.swift
//  CryptoTracker
//
//  Created by Max Valek on 3/8/23.
//

/*
 
 Top view for coins with the largest price change
 in the last 24 hours.
 
 */

import SwiftUI

struct TopMoversView: View {
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Top Movers")
                .font(.headline)
            
            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ForEach(viewModel.topMovingCoins) { coin in
                        TopMoversItemView(coin: coin)
                    }
                }
            }
        }
        .padding()
    }
}
