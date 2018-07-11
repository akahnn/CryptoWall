//
//  CNOCoin.swift
//  Coino
//
//  Created by Abdullah Kahn on 5/23/17.
//  Copyright © 2017 Sifted. All rights reserved.
//

import Haneke

class CTCoin: NSObject,NSCoding {
    
    var name: String!
    var symbol: String!
    var price: String!
    var flag: String!
    
    override init() {}
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        
        name = aDecoder.decodeObject(forKey: "name") as? String
        symbol = aDecoder.decodeObject(forKey: "symbol") as? String
        price = aDecoder.decodeObject(forKey: "price") as! String
        flag = aDecoder.decodeObject(forKey: "flag") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(symbol, forKey: "symbol")
        aCoder.encode(price, forKey:"price")
        aCoder.encode(flag, forKey:"flag")
    }
    
}
