//
//  TourneyMenuBar.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/3/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit

class TourneyMenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    let cellID = "CellID"
    let displayNames = ["Overall", "Recent Matches", "My Matches"]
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection2View.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MenuCell
        cell.CellLabels.text = displayNames[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 3, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    lazy var collection2View: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.blue
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collection2View.register(MenuCell.self, forCellWithReuseIdentifier: "CellID")
        
        addSubview(collection2View)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collection2View)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collection2View)
        
        let selectedIndexPath = NSIndexPath(item: 0, section: 0)
        collection2View.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: [])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuCell: BaseCell {
    
    let CellLabels: UILabel = {
        let lb = UILabel()
        lb.text = "Nothin"
        lb.font = UIFont.boldSystemFont(ofSize: 15)
        lb.textAlignment = .center
        lb.textColor = UIColor.init(displayP3Red: 13/255, green: 80/255, blue: 80/255, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    override var isHighlighted: Bool {
        didSet {
            CellLabels.textColor = isHighlighted ? UIColor.white : UIColor.init(displayP3Red: 13/255, green: 80/255, blue: 80/255, alpha: 1)
        }
    }
    override var isSelected: Bool {
        didSet {
            CellLabels.textColor = isSelected ? UIColor.white : UIColor.init(displayP3Red: 13/255, green: 80/255, blue: 80/255, alpha: 1)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        addSubview(CellLabels)
        addConstraintsWithFormat(format: "H:[v0(120)]", views: CellLabels)
        addConstraintsWithFormat(format: "V:[v0(20)]", views: CellLabels)
        addConstraint(NSLayoutConstraint(item: CellLabels, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: CellLabels, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        backgroundColor = UIColor.green
    }
}
