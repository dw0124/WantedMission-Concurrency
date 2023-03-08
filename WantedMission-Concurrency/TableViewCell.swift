//
//  tableViewCell.swift
//  WantedMission-Concurrency
//
//  Created by 김두원 on 2023/03/07.
//

import Foundation
import UIKit

class TableViewCell: UITableViewCell {
    
    var observation: NSKeyValueObservation?

    deinit {
        observation?.invalidate()
        observation = nil
    }
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var loadImage: (()->())?
    
    @IBAction func touchButton(_ sender: UIButton) {
        loadImage?()
    }

}
