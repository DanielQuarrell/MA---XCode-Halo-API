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
    @IBOutlet weak var graphCollectionView: UICollectionView!
    
    @IBOutlet weak var topView: UIView!
    
    var graphs = [StatisticGraph]()
    let cellScale: CGFloat = 0.9
    
    var currentPage: Int = 0 {
        didSet {
            let graph = self.graphs[self.currentPage]
            //self.graphTitlelabel.text = graph.title?.uppercased()
        }
    }
    
    var pieChartDataEntries = [PieChartDataEntry]()
    var barChartDataSets = [BarChartDataSet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = topView.bounds.size
        let cellWidth = floor(screenSize.width * cellScale)
        let cellHeight = floor(screenSize.height * cellScale)
        let insetX = (topView.bounds.width - cellWidth) / 2
        let insetY = (topView.bounds.height - cellHeight) / 2
        
        let layout = graphCollectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        graphCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        
        graphCollectionView.dataSource = self
        graphCollectionView.delegate = self
        graphCollectionView.backgroundColor = UIColor.clear
        
        //Call to api class here
        createData()
        graphs = createGraphs()
        
        currentPage = 0
    }
    
    func createData(){
        var pieEntries: [PieChartDataEntry] = Array()
        pieEntries.append(PieChartDataEntry(value: 10.0, label: "Standard"))
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
    }
    
    func createGraphs() -> [StatisticGraph] {
        return [
            StatisticGraph(title: "Kill", pieChartData: pieChartDataEntries),
            StatisticGraph(title: "Me", pieChartData: pieChartDataEntries),
            StatisticGraph(title: "Now", barChartData: barChartDataSets)
        ]
    }
}
extension ArenaViewController : UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return graphs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GraphCollectionViewCell.identifier, for: indexPath) as! GraphCollectionViewCell
        let graph = graphs[indexPath.item]
        
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
