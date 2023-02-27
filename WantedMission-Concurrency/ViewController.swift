//
//  ViewController.swift
//  WantedMission-Concurrency
//
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    
    let urlArr: [String] = ["https://cdn.pixabay.com/photo/2013/02/01/18/14/url-77169_1280.jpg",
                            "https://cdn.pixabay.com/photo/2016/03/08/20/03/flag-1244648_1280.jpg",
                            "https://cdn.pixabay.com/photo/2013/03/01/18/40/crispus-87928_1280.jpg",
                            "https://cdn.pixabay.com/photo/2016/03/08/20/03/flag-1244649_1280.jpg",
                            "https://cdn.pixabay.com/photo/2023/02/24/10/14/flowers-7810659_1280.jpg"]
    
    @IBAction func image1LoadButton(_ sender: Any) {
        let url = URL(string: urlArr[0])!
        imageLoad(image1, url: url)
    }
    @IBAction func image2LoadButton(_ sender: Any) {
        let url = URL(string: urlArr[1])!
        imageLoad(image2, url: url)
    }
    @IBAction func image3LoadButton(_ sender: Any) {
        let url = URL(string: urlArr[2])!
        imageLoad(image3, url: url)
    }
    @IBAction func image4LoadButton(_ sender: Any) {
        let url = URL(string: urlArr[3])!
        imageLoad(image4, url: url)
    }
    @IBAction func image5LoadButton(_ sender: Any) {
        let url = URL(string: urlArr[4])!
        imageLoad(image5, url: url)
    }
    
    @IBAction func LoadAllImages(_ sender: Any) {
        image1LoadButton((Any).self)
        image2LoadButton((Any).self)
        image3LoadButton((Any).self)
        image4LoadButton((Any).self)
        image5LoadButton((Any).self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    func imageLoad(_ imageV: UIImageView, url: URL) {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                imageV.image = UIImage(systemName: "photo")
            }
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageV.image = image
                    }
                }
            }
        }
    }
    
}

