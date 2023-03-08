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

    var task: URLSessionDataTask?
    
    func updatePhoto(with url: URL) {
        progressBar.progress = 0
        
        photoView.image = UIImage(systemName: "photo")
        
        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.photoView.image = image
                self.task = nil
            }
        }
        
        task?.resume()
        
        observation = task?.progress.observe(\.fractionCompleted, options: [.new]) { progress, change in
            DispatchQueue.main.async {
                print(progress.fractionCompleted)
                self.progressBar.progress = Float(progress.fractionCompleted)
            }
        }
    }
    
    
}
