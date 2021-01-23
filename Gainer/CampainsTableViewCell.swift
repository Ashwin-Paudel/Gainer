//
//  CampainsTableViewCell.swift
//  Gainer
//
//  Created by आश्विन पौडेल  on 2021-01-18.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit

class CampainsTableViewCell: UITableViewCell {
    @IBOutlet var channelName: UILabel!
    @IBOutlet var channelImage: UIImageView!
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
        progressBar.isHidden = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
