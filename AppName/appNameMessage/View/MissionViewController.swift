//
//  MissionViewController.swift
//  appNameMessage
//
//  Created by hanseoyoung on 10/15/24.
//

import UIKit

class MissionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        missionCollection.delegate = self
        missionCollection.dataSource = self
    }

    @IBOutlet weak var missionCollection: UICollectionView!
    
    
}

// MARK: - CollectionView


extension MissionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sampleMissions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MissionCollectionViewCell", for: indexPath) as! MissionCollectionViewCell
        let mission = sampleMissions[indexPath.item]
        cell.configure(with: mission)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let padding: CGFloat = 10
        let totalPadding = padding * 2 + padding * 2
        let individualWidth = (collectionView.frame.width - totalPadding) / 3

        return CGSize(width: individualWidth, height: individualWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }



}
