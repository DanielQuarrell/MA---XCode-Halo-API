//
//  StatisticGraphData.swift
//  Xcode - HaloAPI
//
//  Created by Daniel Quarrell on 24/11/2019.
//  Copyright © 2019 Daniel Quarrell. All rights reserved.
//

import Foundation
import Charts

class StatisticGraph {
    
    var title: String?
    var pieChartData: [PieChartDataEntry]?
    var barChartData: [BarChartDataSet]?
    
    init(title: String? = nil, pieChartData: [PieChartDataEntry]? = [PieChartDataEntry](), barChartData: [BarChartDataSet]? = [BarChartDataSet]()){
        
        //Initialise data
        self.title = title
        self.pieChartData = pieChartData
        self.barChartData = barChartData
    }
    
    func createPieChartData(chartData: [Statistic]) {
        var pieChartDataEntries: [PieChartDataEntry] = Array()
        
        //Convert statistics array into pie chart data entries
        for i in 0..<chartData.count {
            pieChartDataEntries.append(PieChartDataEntry(value: Double(chartData[i].value!), label: chartData[i].name))
        }
        
        //Save data to class
        self.pieChartData = pieChartDataEntries
    }
    
    func createBarChartData(chartData: [Statistic]) {
        
        var barChartDataSets: [BarChartDataSet] = Array()
        
        //Convert statistics array into bar chart data sets
        for i in 0..<chartData.count {
            var dataSet: [BarChartDataEntry] = Array()
            dataSet.append(BarChartDataEntry(x: Double(i), y: Double(chartData[i].value!)))
            
            barChartDataSets.append(BarChartDataSet(entries: dataSet, label: chartData[i].name))
        }
        
        //Save data to class
        self.barChartData = barChartDataSets
    }
}
