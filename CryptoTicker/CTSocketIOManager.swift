//
//  CTSocketIOManager.swift
//  CryptoTicker
//
//  Created by Abdullah Kahn on 7/10/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

import Foundation
import SocketIO
import Haneke

protocol CTRefreshDelegate {
    func coinPriceUpdated(updatedArray: Array<Any>)
}

class CTSocketIOManager: NSObject {

    static let sharedInstance = CTSocketIOManager()
    let coinCache = Cache<Array<Any>>(name: "coinList")

    var priceDelegate: CTRefreshDelegate?

    let manager = SocketManager(socketURL: URL(string: CTAppConstants.sharedInstance.socketURL)!, config: [.log(true), .compress])

    override init() {
        super.init()

        let socket = manager.defaultSocket
        //trading pairs
        let dict = ["subs": ["5~CCCAGG~BTC~USD", "5~CCCAGG~XRP~USD", "5~CCCAGG~LTC~USD", "5~CCCAGG~GNT~USD", "5~CCCAGG~GNO~USD", "5~CCCAGG~OMG~USD", "5~CCCAGG~PIVX~USD", "5~CCCAGG~REP~USD", "5~CCCAGG~XMR~USD", "5~CCCAGG~DASH~USD", "5~CCCAGG~ZEC~USD"]]

        socket.on(clientEvent: .connect) { data, ack in
            print("socket connected \(data)")
            socket.emit("SubAdd", dict)
        }

        socket.on("m", callback: { data, ack in

            let myString: String = String(describing: data[0])
            if myString == "3~LOADCOMPLETE" {

            } else {
                var myStringArr = myString.components(separatedBy: "~")

                let flag = myStringArr[4]
                let symbol = myStringArr[2]
                let price = myStringArr[5]

                if flag != CTAppConstants.sharedInstance.priceUnchanged
                    {

                    self.coinCache.fetch(key: "coinList").onSuccess { (coinArray) in
                        print("coinListSuccess")

                        var updatedArray = coinArray

                        if let index = coinArray.index(where: { ($0 as! CTCoin).symbol == symbol }) {

                            let matchedCoin = coinArray[index] as? CTCoin

                                matchedCoin?.price = price
                                matchedCoin?.flag = flag

                                updatedArray[index] = matchedCoin!

                                self.coinCache.set(value: updatedArray, key: "coinList")
                                self.priceDelegate?.coinPriceUpdated(updatedArray: updatedArray)
                        }
                    }
                }
            }
        })
    }

    func establishConnection() {
        manager.defaultSocket.connect()
    }

    func closeConnection() {
        manager.defaultSocket.disconnect()
    }
}

extension Array: DataConvertible, DataRepresentable {

    public typealias Result = Array

    public static func convertFromData(_ data: Data) -> Result? {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? Array
    }

    public func asData() -> Data! {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }
}
