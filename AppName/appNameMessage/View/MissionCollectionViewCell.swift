//
//  MissionCollectionViewCell.swift
//  appNameMessage
//
//  Created by hanseoyoung on 10/15/24.
//

import UIKit

class MissionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var missionTitle: UILabel!
    @IBOutlet weak var missionKwh: UILabel!

    func configure(with mission: Mission) {
            missionTitle.text = mission.missionTitle
            missionKwh.text = "\(mission.missionKwh) kWh"
        }

}
