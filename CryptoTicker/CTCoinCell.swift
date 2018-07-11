//
//  CTCoinCell.swift
//  CryptoTicker
//
//  Created by Abdullah Kahn on 7/9/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

import UIKit

class CTCoinCell: UICollectionViewCell {
    
    @IBOutlet var coinNameLabel: UILabel!
    @IBOutlet var coinSymbolLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var coinLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.layer.shadowRadius = 4;
        self.layer.shadowOpacity = 0.1;
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        coinLogo.inputView?.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

