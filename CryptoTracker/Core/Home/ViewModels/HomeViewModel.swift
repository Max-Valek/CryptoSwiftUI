//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Max Valek on 3/8/23.
//

/*
 
 Communicate with CoinGecko API and get data
 
 */

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var coins = [Coin]()
    @Published var topMovingCoins = [Coin]()
    
    init() {
        fetchCoinData()
    }
    
    func fetchCoinData() {
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24h"
        
        // convert url string to URL object
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            // handle error
            if let error = error {
                print("DEBUG: Error \(error.localizedDescription)")
                return
            }
            
            // print status code
            if let response = response as? HTTPURLResponse {
                print("DEBUG: Response code \(response.statusCode)")
            }
            
            // make sure we have data
            guard let data = data else { return }
            
            do {
                let coins = try JSONDecoder().decode([Coin].self, from: data)
                // put coins in our published property
                // have to use DispatchQueue to do in on main thread
                DispatchQueue.main.async {
                    self.coins = coins
                    self.configureTopMovingCoins()
                }
            } catch let error {
                print("DEBUG: Failed to decode with error: \(error)")
            }
            
        }.resume()
    }
    
    // configure coins for the top movers view
    func configureTopMovingCoins() {
        
        // sort by price change percentage
        let topMovers = coins.sorted(by: { $0.priceChangePercentage24H > $1.priceChangePercentage24H })
        
        // get top 5 coins
        self.topMovingCoins = Array(topMovers.prefix(5))
    }
    
}
