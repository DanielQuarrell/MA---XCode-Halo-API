//
//  StatisticGraphData.swift
//  Xcode - HaloAPI
//
//  Created by Daniel Quarrell on 24/11/2019.
//  Copyright © 2019 Daniel Quarrell. All rights reserved.
//

import Foundation
import Charts

class StatisticGraph
{
    var title: String?
    var pieChartData: [PieChartDataEntry]?
    var barChartData: [BarChartDataSet]?
    
    init(title: String? = nil, pieChartData: [PieChartDataEntry]? = nil, barChartData: [BarChartDataSet]? = nil){
        self.title = title
        self.pieChartData = pieChartData
        self.barChartData = barChartData
    }
}
