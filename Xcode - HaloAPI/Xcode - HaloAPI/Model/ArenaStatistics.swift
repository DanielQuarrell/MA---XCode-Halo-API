//
//  ArenaStatistics.swift
//  Xcode - HaloAPI
//
//  Created by Daniel Quarrell on 30/11/2019.
//  Copyright © 2019 Daniel Quarrell. All rights reserved.
//

import Foundation
import Charts

class ArenaStatistics {
    
    let KDA_graph = StatisticGraph()
    let matchResults_graph = StatisticGraph()
    let physicalCombatTotals_graph = StatisticGraph()
    let weaponCombatTotals_graph = StatisticGraph()
    
    func getData ()
    {
        
    }
    
    func getGraphs() -> [StatisticGraph] {
        return [
            KDA_graph,
            matchResults_graph,
            physicalCombatTotals_graph,
            weaponCombatTotals_graph,
        ]
    }
}




