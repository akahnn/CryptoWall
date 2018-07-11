//
//  CTMainViewController.swift
//  CryptoTicker
//
//  Created by Abdullah Kahn on 7/9/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

import UIKit
import Haneke

class CTMainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,DrapDropCollectionViewDelegate,UICollectionViewDelegateFlowLayout,CTRefreshDelegate
 {
    
    @IBOutlet var collectionView: DragDropCollectionView!
    
    let coinCache = Cache<Array<Any>>(name: "coinList")
    var coinList = Array<Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CTSocketIOManager.sharedInstance.priceDelegate = self
        
        //TODO. change datasource after reorder.
        collectionView.delegate = self;
        collectionView.draggingDelegate = self;
        collectionView.enableDragging(true)
        
        checkCache()
    }
    
    func coinPriceUpdated(updatedArray: Array<Any>) {
        coinList.removeAll()
        coinList = updatedArray
        self.collectionView.reloadData()
    }
    
    //MARK: UICollectionViewDataSource
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coinList.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "coincell", for: indexPath) as! CTCoinCell
        
        let coinObject = coinList[indexPath.row] as! CTCoin
        
        cell.coinNameLabel.text = coinObject.name
        cell.coinSymbolLabel.text = coinObject.symbol
        cell.coinLogo.image = UIImage(named: coinObject.symbol)
        cell.priceLabel.text = coinObject.price
        
        if coinObject.flag == CTAppConstants.sharedInstance.priceWentUp {
            cell.backgroundColor = CTAppConstants.sharedInstance.priceUpColor
        }
        else if coinObject.flag == CTAppConstants.sharedInstance.priceWentDown {
            cell.backgroundColor = CTAppConstants.sharedInstance.priceDownColor
        }
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let temp = coinList.remove(at: sourceIndexPath.item)
        coinList.insert(temp, at: destinationIndexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CTAppConstants.sharedInstance.coinCellWidth, height: CTAppConstants.sharedInstance.coinCellHeight)
    }
    
    //MARK: DragDropCollectionView Delegate
    func dragDropCollectionViewDidMoveCellFromInitialIndexPath(_ initialIndexPath: IndexPath, toNewIndexPath newIndexPath: IndexPath) {
        let colorToMove = coinList[initialIndexPath.row]
        
        coinList.remove(at: initialIndexPath.row)
        coinList.insert(colorToMove, at: newIndexPath.row)
        //TODO: Change sequence in datasource
    }
    
    //MARK: Initial Setup
    
    func setUpCoinList()
    {
        let coins = ["Golem": "GNT", "Ripple": "XRP", "Litecoin": "LTC", "ZCash": "ZEC", "Gnosis": "GNO", "OmiseGo": "OMG", "PIVX": "PIVX", "Augur": "REP", "Bitcoin": "BTC", "Monero": "XMR", "Dash": "DASH"]
        
        var coinsList = Array<Any>()
        for (coinName, coinSymbol) in coins {
            
            let coin = CTCoin()
            coin.name = coinName
            coin.symbol = coinSymbol
            coin.flag = "4"
            coin.price = "0.0"
            
            coinsList.append(coin)
        }
        coinCache.set(value: coinsList, key: "coinList")
    }
    
    func checkCache() {
        coinCache.fetch(key: "coinList").onSuccess { (coinArray) in
            print("coinListSuccess")
            self.coinList.removeAll()
            self.coinList = coinArray
            self.collectionView.reloadData()
        }
        
        coinCache.fetch(key: "coinList").onFailure({ (error) in
            print("coinListFail")
            self.setUpCoinList()
        })
    }

}
