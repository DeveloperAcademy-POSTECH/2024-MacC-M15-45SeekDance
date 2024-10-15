//
//  MissionViewController.swift
//  appNameMessage
//
//  Created by hanseoyoung on 10/15/24.
//

import UIKit

class MissionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sampleMissions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MissionCollectionViewCell", for: indexPath) as! MissionCollectionViewCell
        let mission = sampleMissions[indexPath.item]
        cell.configure(with: mission)
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        missionCollection.delegate = self
        missionCollection.dataSource = self
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
    
    
    @IBOutlet weak var missionCollection: UICollectionView!
    
    
}

// 샘플 미션 리스트
class Mission: Codable {
    var missionID = UUID()
    let missionTitle: String
    let missionKwh: Float
    
    init(missionTitle: String, missionKwh: Float) {
        self.missionTitle = missionTitle
        self.missionKwh = missionKwh
    }
}

let sampleMissions: [Mission] = [
    Mission(missionTitle: "컴퓨터 24분 끄기", missionKwh: 0.2),
    Mission(missionTitle: "에어컨 12분 끄기", missionKwh: 0.2),
    Mission(missionTitle: "1층은 계단이동", missionKwh: 0.025),
    Mission(missionTitle: "전등키보드 1시간 안쓰기", missionKwh: 0.1),
    Mission(missionTitle: "쿨맵시 옷 입기", missionKwh: 0.01),
    Mission(missionTitle: "어쩌구 저쩌구", missionKwh: 0.3),
    Mission(missionTitle: "이열치열 대결하기", missionKwh: 0.4),
    Mission(missionTitle: "총장실 불끄기", missionKwh: 0.02),
    Mission(missionTitle: "디지털 디톡스 하기", missionKwh: 0.07)
]
