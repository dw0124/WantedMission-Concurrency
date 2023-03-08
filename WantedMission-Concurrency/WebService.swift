//
//  Services.swift
//  WantedMission-Concurrency
//
//  Created by 김두원 on 2023/03/06.
//

import Foundation

class WebService {
    
    func getData<T: Decodable>(url: URL, completion: @escaping (T) -> ()) {
        
        let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: url) { (data:Data? ,response:URLResponse? ,error:Error?) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else {
                return
            }
            
            do{
                let apiResponse = try JSONDecoder().decode(T.self, from: data)
                    completion(apiResponse)
            } catch {
                print(error)
            }
        }
        dataTask.resume()
    }
}
