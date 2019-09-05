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
        lb.textColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let CellBar: UILabel = {
        let cb = UILabel()
        cb.backgroundColor = UIColor.white
        cb.translatesAutoresizingMaskIntoConstraints = false
        return cb
    }()
    
    override var isHighlighted: Bool {
        didSet {
            CellLabels.textColor = isHighlighted ? UIColor.black : UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
            CellBar.backgroundColor = isHighlighted ? UIColor.black : UIColor.white
        }
    }
    override var isSelected: Bool {
        didSet {
            CellLabels.textColor = isSelected ? UIColor.black : UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
            CellBar.backgroundColor = isSelected ? UIColor.black : UIColor.white
        }
    }
    
    override func setupViews() {
        super.setupViews()
        addSubview(CellLabels)
        addSubview(CellBar)
        addConstraintsWithFormat(format: "H:[v0(120)]", views: CellLabels)
        addConstraintsWithFormat(format: "V:[v0(20)]", views: CellLabels)
        addConstraintsWithFormat(format: "H:|[v0]|", views: CellBar)
        addConstraintsWithFormat(format: "V:[v0(5)]|", views: CellBar)
        addConstraint(NSLayoutConstraint(item: CellLabels, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: CellLabels, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        backgroundColor = UIColor.white
    }
}
