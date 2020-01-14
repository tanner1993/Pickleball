//
//  FriendList.swift
//  Pickleball
//
//  Created by Tanner Rozier on 1/13/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FriendList: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+Friend", style: .plain, target: self, action: #selector(handleSearchFriends))

    }
    
    @objc func handleSearchFriends() {
        let layout = UICollectionViewFlowLayout()
        let findFriends = FindFriends(collectionViewLayout: layout)
        findFriends.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(findFriends, animated: true)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }



    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

    
        return cell
    }



}
