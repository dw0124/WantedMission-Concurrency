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
            guard let url = URL(string: imageList[i].download_url) else {
                return
            }
            DispatchQueue.global().async {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    cell?.photoView?.image = nil
                    cell?.photoView.image = UIImage(systemName: "photo")
                }
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell?.photoView?.image = image
                        }
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
            self?.tableView.reloadData()
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

            DispatchQueue.global().async {
                if let url = URL(string: (self?.imageList[indexPath.row].download_url)!) {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                        cell.photoView?.image = UIImage(systemName: "photo")
                    }

                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.photoView?.image = image
                            }
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
    
}
