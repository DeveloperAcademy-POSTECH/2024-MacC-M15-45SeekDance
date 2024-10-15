//
//  ChallengeRecordTableViewCell.swift
//  appNameMessage
//
//  Created by hanseoyoung on 10/15/24.
//

import UIKit

class ChallengeRecordTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var recordTitle: UILabel!

    @IBOutlet weak var recordKwh: UILabel!
    
    @IBOutlet weak var recordTarget: UILabel!

    func configure(with record: ChallengeRecord) {
            recordTitle.text = record.recordName
            recordKwh.text = "\(record.recordkWh) kWh"
            recordTarget.text = record.recordTarget
        }
}
