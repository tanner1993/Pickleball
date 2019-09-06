//
//  TourneyLayout.swift
//  Pickleball
//
//  Created by Tanner Rozier on 8/30/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit

class TourneyStandings: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
//    let changepagebutton: UIButton = {
//        let cpb = UIButton()
//        cpb.backgroundColor = UIColor.blue
//        cpb.translatesAutoresizingMaskIntoConstraints = false
//        cpb.addTarget(self, action: #selector(cpbAction), for: UIControl.Event.touchUpInside)
//        return cpb
//    }()
//    @objc func cpbAction(sender: UIButton!) {
//        print("Button tapped")
//    }

    let cellId = "cellId"
    let rmCellId = "rmCellId"
    let threeSectionTitles = ["Overall", "Recent Matches", "My Matches"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupTitle()
        setupCollectionView()
        setupTourneyMenuBar()
        
    }
    
    private func setupTitle() {
        navigationItem.title = "Tournament 1"
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Tourney 1 Overall"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
    }
    private func setupCollectionView() {
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        //collectionView?.register(TeamCell.self, forCellWithReuseIdentifier: "CellID")
        //collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(MatchCell.self, forCellWithReuseIdentifier: rmCellId)
        
        collectionView?.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        collectionView?.contentInset = UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0)
        collectionView?.isPagingEnabled = true
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
        
        setTitleForIndex(index: menuIndex)
    }
    
    private func setTitleForIndex(index: Int) {
        if let titleLabels = navigationItem.titleView as? UILabel {
            titleLabels.text = threeSectionTitles[index]
        }
    }
    
    lazy var menusBar: TourneyMenuBar = {
        let mb = TourneyMenuBar()
        mb.tourneystandings = self
        mb.translatesAutoresizingMaskIntoConstraints = false
        return mb
    }()
    
    private func setupTourneyMenuBar() {
        
        view.addSubview(menusBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menusBar)
        view.addConstraintsWithFormat(format: "V:|[v0(35)]", views: menusBar)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menusBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 3
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        
        let indexPath = NSIndexPath(item: Int(index), section: 0)
        menusBar.collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition:[])
        
        setTitleForIndex(index: Int(index))
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 1 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: rmCellId, for: indexPath)
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 35)
    }
    

    

}
