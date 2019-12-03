//
//  ArenaViewController.swift
//  Xcode - HaloAPI
//
//  Created by Daniel Quarrell on 22/11/2019.
//  Copyright © 2019 Daniel Quarrell. All rights reserved.
//

import UIKit
import Charts

class ArenaViewController: UIViewController {
    
    //@IBOutlet weak var graphTitlelabel: UILabel!
    
    @IBOutlet weak var statTableView: UITableView!
    @IBOutlet weak var graphCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var topView: UIView!
    
    var arenaStatistics = ArenaStatistics()
    
    var tableStatistics = [Statistic]()
    var carouselGraphs = [StatisticGraph]()
    
    let cellXScale: CGFloat = 0.9
    let cellYScale: CGFloat = 0.6
    
    var pieChartDataEntries = [PieChartDataEntry]()
    var barChartDataSets = [BarChartDataSet]()
    
    var currentPage: Int = 0 {
        didSet {
            //let graph = self.graphs[self.currentPage]
            
            self.pageControl.currentPage = self.currentPage
            //self.graphTitlelabel.text = graph.title?.uppercased()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupTableView()
        
        arenaStatistics.getData();
        
        //Call to api class here
        createSampleData()
        
        pageControl.numberOfPages = carouselGraphs.count
        currentPage = 0

    }
    
    func setupCollectionView() {
        topView.layoutIfNeeded()
        let viewSize = topView.bounds.size
        let cellWidth = floor(viewSize.width * cellXScale)
        let cellHeight = floor(viewSize.height * cellYScale)
        let insetX = (topView.bounds.width - cellWidth) / 2
        let insetY = (topView.bounds.height - cellHeight) / 2
        
        let layout = graphCollectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        graphCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        
        graphCollectionView.dataSource = self
        graphCollectionView.delegate = self
        graphCollectionView.backgroundColor = UIColor.clear
    }
    
    func setupTableView() {
        let nib = UINib(nibName: "StatTableViewCell", bundle: nil)
        statTableView.register(nib, forCellReuseIdentifier: "StatTableViewCell")
    }
    
    func createSampleData() {
        var pieEntries: [PieChartDataEntry] = Array()
        pieEntries.append(PieChartDataEntry(value: 10.0, label:"Standard"))
        pieEntries.append(PieChartDataEntry(value: 5.0, label: "Power"))
        pieEntries.append(PieChartDataEntry(value: 3.0, label: "Grenade"))
        pieEntries.append(PieChartDataEntry(value: 2.0, label: "Vehicle"))
        pieEntries.append(PieChartDataEntry(value: 4.0, label: "Turret"))
        pieEntries.append(PieChartDataEntry(value: 1.0, label: "Unknown"))
        
        pieChartDataEntries = pieEntries
        
        
        var kills: [BarChartDataEntry] = Array()
        kills.append(BarChartDataEntry(x: 0, y: 12))
        
        var deaths: [BarChartDataEntry] = Array()
        deaths.append(BarChartDataEntry(x: 1, y: 3))
        
        var barDataSets: [BarChartDataSet] = Array()
        barDataSets.append(BarChartDataSet(entries: kills, label: "Kills"))
        barDataSets.append(BarChartDataSet(entries: deaths, label: "Deaths"))
        
        barChartDataSets = barDataSets
        
        
        var stats: [Statistic] = Array()
        stats.append(Statistic(name:"Standard", value: 10))
        stats.append(Statistic(name:"Power", value: 5))
        stats.append(Statistic(name:"Grenade", value: 3))
        stats.append(Statistic(name:"Vehicle", value: 2))
        stats.append(Statistic(name:"Turret", value: 4))
        stats.append(Statistic(name:"Unknown", value: 1))
        
        tableStatistics = stats
        
        let KDGraph: StatisticGraph = StatisticGraph()
        KDGraph.createPieChartData(chartData: stats)
        KDGraph.title = "Kills to deaths"
        
        carouselGraphs.append(KDGraph)
    }
}

extension ArenaViewController : UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselGraphs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GraphCollectionViewCell.identifier, for: indexPath) as! GraphCollectionViewCell
        let graph = carouselGraphs[indexPath.item]
        
        cell.graph = graph
        
        return cell
    }
}

extension ArenaViewController : UIScrollViewDelegate, UICollectionViewDelegate{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.graphCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidth
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
        
        targetContentOffset.pointee = offset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.graphCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let pageSide = layout.itemSize.width
        let pageOffset = scrollView.contentOffset.x
        currentPage = Int(floor((pageOffset - pageSide / 2) / pageSide) + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GraphCollectionViewCell.identifier, for: indexPath) as! GraphCollectionViewCell
        cell.updateLegends()
    }
}

extension ArenaViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(tableStatistics.count / 2)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatTableViewCell.identifier, for: indexPath) as! StatTableViewCell
        
        let index = indexPath.row * 2
        
        let leftStatistic = tableStatistics[index]
        let rightStatistic = tableStatistics[index + 1]
        
        if(leftStatistic != nil)
        {
            cell.leftStatistic = leftStatistic
        }
        if(rightStatistic != nil)
        {
            cell.rightStatistic = rightStatistic
        }
       
        return cell
    }
}

extension ArenaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 4
    }
}
