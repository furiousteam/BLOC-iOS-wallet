//
//  SetMiningThreadsViews.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 29/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class SetMiningThreadsViews: NSObject {
    let orderedViews: [UIView]
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.mining_threads_title()
        label.font = .regular(size: 12.5)
        label.textColor = UIColor.white.withAlphaComponent(0.75)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let threadsCountLabelsView = MarkerContentView()
    let threadsCountMarksView = MarkerBarsView()
    
    let sliderView = MiningSliderView()
    
    let powerLabelsView = MarkerContentView()
    let powerMarksView = MarkerBarsView()
    
    let warningView = MiningWarningView()
    
    // Action
    
    override init() {
        orderedViews = [ SpacerView(height: 25.0),
                         titleLabel,
                         SpacerView(height: 15.0),
                         threadsCountLabelsView,
                         SpacerView(height: 5.0),
                         threadsCountMarksView,
                         SpacerView(height: 15.0),
                         sliderView,
                         SpacerView(height: 15.0),
                         powerMarksView,
                         SpacerView(height: 5.0),
                         powerLabelsView,
                         SpacerView(height: 35.0),
                         warningView ]
        
        let threadsCount = ProcessInfo.processInfo.activeProcessorCount
        
        var threadsCountStrings = (1...threadsCount).filter({ $0 % 2 == 0 }).map({ [ "\($0)", "" ] })
        threadsCountStrings.insert(["1", ""], at: 0)
        
        var finalThreadsCountStrings = threadsCountStrings.flatMap({ $0 })
        
        if threadsCount % 2 != 0 {
            finalThreadsCountStrings.append("\(threadsCount)")
        } else {
            finalThreadsCountStrings.removeLast()
        }
        
        threadsCountLabelsView.configure(items: finalThreadsCountStrings, centerAll: false)
        
        threadsCountMarksView.configure(count: finalThreadsCountStrings.count / 2)
        
        let powerStrings: [String] = [ MiningPower.low.readableString, MiningPower.medium.readableString, MiningPower.high.readableString, MiningPower.intense.readableString ]
                
        powerLabelsView.configure(items: powerStrings, centerAll: true)
        
        powerMarksView.configure(count: powerStrings.count)
        
        sliderView.snp.makeConstraints({
            $0.height.equalTo(30.0)
        })
        
        super.init()
    }
    
}
