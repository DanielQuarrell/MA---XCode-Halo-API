//
//  ArenaStatistics.swift
//  Xcode - HaloAPI
//
//  Created by Daniel Quarrell on 30/11/2019.
//  Copyright © 2019 Daniel Quarrell. All rights reserved.
//

import Foundation
import Charts
import SwiftyJSON

class ArenaStatistics {
    
    let KDA_graph = StatisticGraph()
    let accuracy_graph = StatisticGraph()
    let matchResults_graph = StatisticGraph()
    let physicalCombatTotals_graph = StatisticGraph()
    let weaponCombatTotals_graph = StatisticGraph()
    
    var tableStatistics = [[Statistic]]()
    
    public func getArenaData (completion: @escaping () -> ()) {
        
        HaloApiInterface.sharedInstance.getArenaJsonStatistics(completion: {(json) in

            self.getKDA_Data(json: json)
            self.getAccuracy_Data(json: json)
            self.getMatchResult_Data(json: json)
            self.getWeaponCombat_Data(json: json)
            self.getPhysicalCombat_Data(json: json)
            
            completion()
        })
    }
    
    private func getKDA_Data(json: JSON){
        
        let totalKills = json["Results"][0]["Result"]["ArenaStats"]["TotalKills"].intValue
        let totalDeaths = json["Results"][0]["Result"]["ArenaStats"]["TotalDeaths"].intValue
        let totalAssists = json["Results"][0]["Result"]["ArenaStats"]["TotalAssists"].intValue
        
        var KDA_stats: [Statistic] = Array()
        KDA_stats.append(Statistic(name:"Total Kills", value: Float(totalKills)))
        KDA_stats.append(Statistic(name:"Total Deaths", value: Float(totalDeaths)))
        
        self.KDA_graph.createPieChartData(chartData: KDA_stats)
        self.KDA_graph.title = "Kills to Deaths"
        
        KDA_stats.append(Statistic(name:"Total Assists", value: Float(totalAssists)))
        KDA_stats.append(Statistic(name:"KD ratio", value: Float(totalKills) / Float(totalDeaths), isFloat: true))
        
        self.tableStatistics.append(KDA_stats)
    }
    
    private func getWeaponCombat_Data(json: JSON) {
        
        let headshotKills = json["Results"][0]["Result"]["ArenaStats"]["TotalHeadshots"].intValue
        let powerWeaponKills = json["Results"][0]["Result"]["ArenaStats"]["TotalPowerWeaponKills"].intValue
        let grenadeKills = json["Results"][0]["Result"]["ArenaStats"]["TotalGrenadeKills"].intValue
        let vehicleKills = json["Results"][0]["Result"]["ArenaStats"]["DestroyedEnemyVehicles"][0]["TotalKills"].intValue
        
        var weaponCombat_stats: [Statistic] = Array()
        weaponCombat_stats.append(Statistic(name:"Headshot Kills", value: Float(headshotKills)))
        weaponCombat_stats.append(Statistic(name:"Power Weapon Kills", value: Float(powerWeaponKills)))
        weaponCombat_stats.append(Statistic(name:"Grenade Kills", value: Float(grenadeKills)))
        weaponCombat_stats.append(Statistic(name:"Vehicle Kills", value: Float(vehicleKills)))
        
        self.weaponCombatTotals_graph.createPieChartData(chartData: weaponCombat_stats)
        self.weaponCombatTotals_graph.title = "Categorized Kills"
        
        self.tableStatistics.append(weaponCombat_stats)
    }
    
    private func getAccuracy_Data(json: JSON) {
        
        let shotsFired = json["Results"][0]["Result"]["ArenaStats"]["TotalShotsFired"].intValue
        let shotsLanded = json["Results"][0]["Result"]["ArenaStats"]["TotalShotsLanded"].intValue
        let totalWeaponDamage = json["Results"][0]["Result"]["ArenaStats"]["TotalWeaponDamage"].doubleValue
        
        var accuracy_stats: [Statistic] = Array()
        accuracy_stats.append(Statistic(name:"Total Shots Fired", value: Float(shotsFired)))
        accuracy_stats.append(Statistic(name:"Total Shots Landed", value: Float(shotsLanded)))
        
        self.accuracy_graph.createBarChartData(chartData: accuracy_stats)
        self.accuracy_graph.title = "Weapon Accuracy"
        
        accuracy_stats.append(Statistic(name:"Accuracy", value: Float(shotsLanded) / Float(shotsFired), isFloat: true))
        accuracy_stats.append(Statistic(name:"Total Weapon Damage", value: Float(totalWeaponDamage)))
        
        self.tableStatistics.append(accuracy_stats)
    }
    
    private func getPhysicalCombat_Data(json: JSON) {
        
        let totalMeleeKills = json["Results"][0]["Result"]["ArenaStats"]["TotalMeleeKills"].intValue
        let totalAssassinations = json["Results"][0]["Result"]["ArenaStats"]["TotalAssassinations"].intValue
        let totalGroundPoundKills = json["Results"][0]["Result"]["ArenaStats"]["TotalGroundPoundKills"].intValue
        let totalShoulderBashKills = json["Results"][0]["Result"]["ArenaStats"]["TotalShoulderBashKills"].intValue
        
        var physicalCombat_stats: [Statistic] = Array()
        physicalCombat_stats.append(Statistic(name:"Melee Kills", value: Float(totalMeleeKills)))
        physicalCombat_stats.append(Statistic(name:"Assassinations", value: Float(totalAssassinations)))
        physicalCombat_stats.append(Statistic(name:"Ground Pound Kills", value: Float(totalGroundPoundKills)))
        physicalCombat_stats.append(Statistic(name:"Shoulder Bash Kills", value: Float(totalShoulderBashKills)))
        
        self.physicalCombatTotals_graph.createBarChartData(chartData: physicalCombat_stats)
        self.physicalCombatTotals_graph.title = "Physical Combat Totals"
        
        self.tableStatistics.append(physicalCombat_stats)
    }
    
    private func getMatchResult_Data(json: JSON) {
        
        let totalGamesWon = json["Results"][0]["Result"]["ArenaStats"]["TotalGamesWon"].intValue
        let totalGamesLost = json["Results"][0]["Result"]["ArenaStats"]["TotalGamesLost"].intValue
        let totalGamesTied = json["Results"][0]["Result"]["ArenaStats"]["TotalGamesTied"].intValue
        
        var matchResults_stats: [Statistic] = Array()
        matchResults_stats.append(Statistic(name:"Total Games Won", value: Float(totalGamesWon)))
        matchResults_stats.append(Statistic(name:"Total Games Lost", value: Float(totalGamesLost)))
        matchResults_stats.append(Statistic(name:"Total Games Tied", value: Float(totalGamesTied)))
        
        self.matchResults_graph.createPieChartData(chartData: matchResults_stats)
        self.matchResults_graph.title = "Match Results"
        
        let totalGamesCompleted = json["Results"][0]["Result"]["ArenaStats"]["TotalGamesCompleted"].intValue
        let timePlayedValue = json["Results"][0]["Result"]["ArenaStats"]["TotalTimePlayed"].stringValue
        var timePlayedArray = timePlayedValue.components(separatedBy: ".")
        var timePlayedString = timePlayedArray[0]
        if(timePlayedString != "") {
            timePlayedString = timePlayedString.replacingOccurrences(of: "P", with: "")
            timePlayedString = timePlayedString.replacingOccurrences(of: "T", with: "")
            timePlayedString = String(timePlayedString.prefix(timePlayedString.count - 2))
            timePlayedString = timePlayedString.replacingOccurrences(of: "D", with: "D ")
            timePlayedString = timePlayedString.replacingOccurrences(of: "H", with: "H ")
        } else {
            timePlayedString = "0S"
        }
        
        matchResults_stats.append(Statistic(name:"Win / Loss Ratio", value: Float(totalGamesWon) / Float(totalGamesLost), isFloat: true))
        matchResults_stats.append(Statistic(name:"Total Time Played", valueString: timePlayedString))
        matchResults_stats.append(Statistic(name:"Games Completed", value: Float(totalGamesCompleted)))
        
        self.tableStatistics.append(matchResults_stats)
    }
    
    public func getGraphs() -> [StatisticGraph] {
        
        return [
            KDA_graph,
            accuracy_graph,
            matchResults_graph,
            weaponCombatTotals_graph,
            physicalCombatTotals_graph,
        ]
    }
    
    public func getTableAtIndex(index: Int) -> [Statistic] {
        return tableStatistics[index]
    }
}




