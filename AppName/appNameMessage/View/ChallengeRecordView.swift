//
//  ChallengeRecordView.swift
//  AppName
//
//  Created by hanseoyoung on 10/15/24.
//

import UIKit

class ChallengeRecordView: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        recordTableView.delegate = self
        recordTableView.dataSource = self
    }

    @IBOutlet weak var recordTableView: UITableView!

}

// MARK: - TableView

extension ChallengeRecordView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleRecords.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeRecordCell", for: indexPath) as! ChallengeRecordTableViewCell
        let record = sampleRecords[indexPath.row]
        cell.configure(with: record)
        return cell
    }
}
