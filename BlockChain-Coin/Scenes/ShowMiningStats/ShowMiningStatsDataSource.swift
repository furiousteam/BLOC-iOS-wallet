//  
//  ShowMiningStatsDataSource.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 02/04/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class ShowMiningStatsDataSource: ArrayDataSource {
    var poolStats: PoolStatsModel?
    var addressStats: MiningAddressStatsModel?

    override func numberOfSections(in tableView: UITableView) -> Int {
        if isLoading || errorText != nil {
            return super.numberOfSections(in: tableView)
        }
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading || errorText != nil {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
        
        if section == 0 {
            if poolStats != nil {
                return 1
            } else {
                return 0
            }
        } else if section == 1 {
            if poolStats != nil {
                return 1
            } else {
                return 0
            }
        } else if section == 2 {
            if addressStats != nil {
                return 1
            } else {
                return 0
            }
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading || errorText != nil {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ShowMiningStatsCell.reuseIdentifier(), for: indexPath) as! ShowMiningStatsCell
        
        if indexPath.section == 0 {
            guard let poolStats = poolStats else { return cell }

            let hashRate = poolStats.networkHashRate

            let hashRateMeasurement: Measurement = {
                if hashRate < 1_000 {
                    return Measurement(value: Double(hashRate), unit: UnitHash.HashPerSec)
                } else if hashRate < 1_000_000 {
                    return Measurement(value: Double(hashRate) / 1_000, unit: UnitHash.KiloHashPerSec)
                } else if hashRate < 1_000_000_000 {
                    return Measurement(value: Double(hashRate) / 1_000_000, unit: UnitHash.MegaHashPerSec)
                } else {
                    return Measurement(value: Double(hashRate) / 1_000_000_000, unit: UnitHash.GigaHashPerSec)
                }
            }()

            cell.configure(title: R.string.localizable.pool_stats_network().localizedUppercase,
                           image: R.image.stats_network()!,
                           titles: [ R.string.localizable.pool_stats_network_hash_rate(),
                                      R.string.localizable.pool_stats_network_block_found(),
                                      R.string.localizable.pool_stats_network_difficulty(),
                                      R.string.localizable.pool_stats_network_height(),
                                      R.string.localizable.pool_stats_network_last_reward() ],
                           content: [ String(describing: hashRateMeasurement),
                                      poolStats.networkLastBlockFound.relativeShortDate(),
                                      "\(poolStats.networkDifficulty)",
                                      "\(poolStats.networkHeight)",
                                      poolStats.lastReward.blocCurrency(mode: .withCurrency) ])
        } else if indexPath.section == 1 {
            guard let poolStats = poolStats else { return cell }

            let hashRate = poolStats.hashRate
            
            let hashRateMeasurement: Measurement = {
                if hashRate < 1_000 {
                    return Measurement(value: Double(hashRate), unit: UnitHash.HashPerSec)
                } else if hashRate < 1_000_000 {
                    return Measurement(value: Double(hashRate) / 1_000, unit: UnitHash.KiloHashPerSec)
                } else if hashRate < 1_000_000_000 {
                    return Measurement(value: Double(hashRate) / 1_000_000, unit: UnitHash.MegaHashPerSec)
                } else {
                    return Measurement(value: Double(hashRate) / 1_000_000_000, unit: UnitHash.GigaHashPerSec)
                }
            }()

            cell.configure(title: R.string.localizable.pool_stats_global_stats().localizedUppercase,
                           image: R.image.stats_pool()!,
                           titles: [ R.string.localizable.pool_stats_global_stats_hash_rate(),
                                     R.string.localizable.pool_stats_global_stats_block_found(),
                                     R.string.localizable.pool_stats_global_stats_miners(),
                                     R.string.localizable.pool_stats_global_stats_fee(),
                                     R.string.localizable.pool_stats_global_stats_block_found_every() ],
                           content: [ String(describing: hashRateMeasurement),
                                      poolStats.lastBlockFound.relativeShortDate(),
                                      "\(poolStats.miners)",
                                      "\(poolStats.fee)%",
                                      "\(poolStats.blockTime)s (est.)" ])
        } else if indexPath.section == 2 {
            guard let addressStats = addressStats else { return cell }
            
            cell.configure(title: R.string.localizable.pool_stats_your_stats().localizedUppercase,
                           image: R.image.stats_mine()!,
                           titles: [ R.string.localizable.pool_stats_your_stats_pending_balance(),
                                     R.string.localizable.pool_stats_your_stats_total_paid(),
                                     R.string.localizable.pool_stats_your_stats_last_share_submitted(),
                                     R.string.localizable.pool_stats_your_stats_hash_rate(),
                                     R.string.localizable.pool_stats_your_stats_total_hashes() ],
                           content: [ addressStats.pendingBalance.blocCurrency(mode: .withCurrency),
                                      addressStats.paid.blocCurrency(mode: .withCurrency),
                                      addressStats.lastShare != nil ? addressStats.lastShare!.relativeShortDate() : "",
                                      "\(addressStats.hashRate)/sec",
                                      "\(addressStats.hashes)" ])
        }
        
        return cell
    }
}
