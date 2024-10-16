//
//  Untitled.swift
//  AppName
//
//  Created by hanseoyoung on 10/16/24.
//
import UIKit

class ChallengeCollectionCell: UICollectionViewCell {

    @IBOutlet weak var challengeTitle: UILabel!
    @IBOutlet weak var challengeKwh: UILabel!
    @IBOutlet weak var challengeDday: UILabel!

    func configure(_ elec: ElecChallenge) {
        challengeTitle.text = "\(elec.name)"
        challengeKwh.text = "\(elec.totalKwh)kWh"
        challengeDday.text = "D-\(elec.date)"
    }
}
