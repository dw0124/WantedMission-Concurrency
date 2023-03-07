//
//  Services.swift
//  WantedMission-Concurrency
//
//  Created by 김두원 on 2023/03/06.
//

import Foundation

class WebService {
    
    func getData(url: URL, completion: @escaping ([RandomImage]) -> ()) {
        
        let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: url) { (data:Data? ,response:URLResponse? ,error:Error?) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else {
                return
            }
            
            do{
                var apiResponse = try JSONDecoder().decode([RandomImage].self, from: data)
                DispatchQueue.main.sync {
                    completion(apiResponse)
                }
                
            } catch {
                print(error)
            }
        }
        dataTask.resume()
    }
}
