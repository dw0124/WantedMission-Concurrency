//
//  ViewController.swift
//  WantedMission-Concurrency
//
//

import UIKit

class ViewController: UIViewController {
    
    var imageList: [RandomImage] = []
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func loadAllImageButton(_ sender: UIButton) {
        for i in 0..<imageList.count {
            
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? TableViewCell
            
            cell?.progressBar.progress = 0
            
            DispatchQueue.global().async {
                guard let url = URL(string: (self.imageList[i].download_url)) else {
                    return
                }
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    
                    if let error = error {
                        fatalError(error.localizedDescription)
                        return
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        cell?.photoView?.image = UIImage(systemName: "photo")
                    }
                    
                    if let data = data ,let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell?.photoView?.image = image
                            }
                    }
                }
                task.resume()
                
                cell?.observation = task.progress.observe(\.fractionCompleted, options: [.new]) { progress, change in
                    DispatchQueue.main.async {
                        print(progress.fractionCompleted)
                        cell?.progressBar.progress = Float(progress.fractionCompleted)
                    }
                }
            }
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let url = URL(string: "https://picsum.photos/v2/list?limit=3")
        WebService().getData(url: url!) { [weak self] images in
            self?.imageList = images
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        cell.loadImage = { [weak self] in
            
            cell.progressBar.progress = 0
            
            DispatchQueue.global().async {
                guard let url = URL(string: (self?.imageList[indexPath.row].download_url)!) else {
                    return
                }
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    
                    if let error = error {
                        fatalError(error.localizedDescription)
                        return
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        cell.photoView?.image = UIImage(systemName: "photo")
                    }
                    
                    if let data = data ,let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.photoView?.image = image
                            }
                    }
                }
                task.resume()
                
                cell.observation = task.progress.observe(\.fractionCompleted, options: [.new]) { progress, change in
                    DispatchQueue.main.async {
                        print(progress.fractionCompleted)
                        cell.progressBar.progress = Float(progress.fractionCompleted)
                    }
                }
            }
        }
        
        return cell
    }
    
    
}
