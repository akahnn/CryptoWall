//
//  CTAppConstants.swift
//  CryptoTicker
//
//  Created by Abdullah Kahn on 7/10/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

import UIKit

class CTAppConstants {
    
    static let sharedInstance = CTAppConstants()
    
    //Price Flags
    let priceWentUp = "1"
    let priceWentDown = "2"
    let priceUnchanged = "4"

    //Cell
    let coinCellHeight = 126
    let coinCellWidth = 160
    
    //API
    let socketURL = "https://streamer.cryptocompare.com"

    //Colors
    let priceUpColor = UIColor(red:0.13, green:0.80, blue:0.00, alpha:1.0)
    let priceDownColor = UIColor(red:0.88, green:0.19, blue:0.19, alpha:1.0)

}
