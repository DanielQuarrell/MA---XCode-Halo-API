//
//  WarzoneViewController.swift
//  Xcode - HaloAPI
//
//  Created by Daniel Quarrell on 22/11/2019.
//  Copyright © 2019 Daniel Quarrell. All rights reserved.
//

import UIKit
import Charts

class WarzoneViewController: UIViewController {
    
    @IBOutlet weak var graphTitlelabel: UILabel!
    
    @IBOutlet weak var statTableView: UITableView!
    @IBOutlet weak var graphCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var topView: UIView!
    
    var warzoneStatistics = WarzoneStatistics()
    
    var tableStatistics = [Statistic]()
    var carouselGraphs = [StatisticGraph]()
    
    let cellXScale: CGFloat = 0.9
    let cellYScale: CGFloat = 0.6
    
    var pieChartDataEntries = [PieChartDataEntry]()
    var barChartDataSets = [BarChartDataSet]()
    
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var currentGraphIndex: Int = 0 {
        didSet {
            //Update view when variable is set
            self.updateViews(index: self.currentGraphIndex)
            self.pageControl.currentPage = self.currentGraphIndex
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create and position activity indicator in the center of the screen
        activityIndicatorView.center = self.view.center
        activityIndicatorView.hidesWhenStopped = true
        view.addSubview(activityIndicatorView)
        
        //Indicator to show that calls to the network are being made
        activityIndicatorView.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Update view elements with API data
        warzoneStatistics.getWarzoneData(completion: {
            self.setUpPage()
            
            self.activityIndicatorView.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        })
    }
    
    func setUpPage() {
        setupCollectionView()
        setupTableView()
        
        //Fill collection view with graphs created from API data
        carouselGraphs = warzoneStatistics.getGraphs()
        //Update the table view to display information relervant to the first graph
        self.updateViews(index: 0)
        
        //Update the number of pages the page control shows
        pageControl.numberOfPages = carouselGraphs.count
        currentGraphIndex = 0
    }
    
    func setupCollectionView() {
        //Force top view to update contraints
        topView.layoutIfNeeded()
        //Set carousel cell size based on the size of the top view
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
        //Create table view cell from the .xib view prototype
        let nib = UINib(nibName: "StatTableViewCell", bundle: nil)
        statTableView.dataSource = self
        statTableView.delegate = self
        statTableView.register(nib, forCellReuseIdentifier: "StatTableViewCell")
    }
    
    func updateViews(index: Int) {
        if(index >= 0 && index < carouselGraphs.count) {
            //Update title and table view based on carousel index
            graphTitlelabel.text = self.carouselGraphs[index].title
            tableStatistics = warzoneStatistics.getTableAtIndex(index: index)
            statTableView.reloadData()
        }
    }
}

extension WarzoneViewController : UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Set number of cells in the carousel to the number of graphs created
        return carouselGraphs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GraphCollectionViewCell.identifier, for: indexPath) as! GraphCollectionViewCell
        let graph = carouselGraphs[indexPath.item]
        
        //Populate new cell with graph at corresponding index
        cell.graph = graph
        
        return cell
    }
}

extension WarzoneViewController : UIScrollViewDelegate, UICollectionViewDelegate{
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.graphCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidth
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
        
        //Set carousel offset based on the position the user stops dragging
        //This makes sure a graph is always in focus
        targetContentOffset.pointee = offset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.graphCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let pageSide = layout.itemSize.width
        let pageOffset = scrollView.contentOffset.x
        
        //Set graph index based on the position of the scroll view inside the carousel
        currentGraphIndex = Int(floor((pageOffset - pageSide / 2) / pageSide) + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GraphCollectionViewCell.identifier, for: indexPath) as! GraphCollectionViewCell
        //Update legend position when cell comes into view (fix positioning errors)
        cell.updateLegends()
    }
}

extension WarzoneViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Set number of cells in the table view to half the number of statistics
        return Int(tableStatistics.count / 2)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatTableViewCell.identifier, for: indexPath) as! StatTableViewCell
        
        //Create cell with 2 sets of statistics
        let index = indexPath.row * 2
        
        let leftStatistic = tableStatistics[index]
        let rightStatistic = tableStatistics[index + 1]
        
        cell.leftStatistic = leftStatistic
        cell.rightStatistic = rightStatistic
        
        return cell
    }
}

extension WarzoneViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Set table cell height to be a third of view height
        return tableView.frame.height / 3
    }
}
