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
    
    @IBOutlet weak var graphTitlelabel: UILabel!
    
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
    
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var currentPage: Int = 0 {
        didSet {
            self.updateViews(index: self.currentPage)
            self.pageControl.currentPage = self.currentPage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView.center = self.view.center
        activityIndicatorView.hidesWhenStopped = true
        view.addSubview(activityIndicatorView)
        
        activityIndicatorView.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        arenaStatistics.getArenaData(completion: {
            self.setUpPage()
            
            self.activityIndicatorView.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        })
    }
    
    func setUpPage() {
        setupCollectionView()
        setupTableView()
        
        carouselGraphs = arenaStatistics.getGraphs()
        self.updateViews(index: 0)
        
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
        statTableView.dataSource = self
        statTableView.delegate = self
        statTableView.register(nib, forCellReuseIdentifier: "StatTableViewCell")
    }
    
    func updateViews(index: Int) {
        if(index >= 0 && index < carouselGraphs.count) {
            graphTitlelabel.text = self.carouselGraphs[index].title
            tableStatistics = arenaStatistics.getTableAtIndex(index: index)
            statTableView.reloadData()
        }
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
        
        cell.leftStatistic = leftStatistic
        cell.rightStatistic = rightStatistic
        
        return cell
    }
}

extension ArenaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 3
    }
}
