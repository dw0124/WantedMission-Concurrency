//
//  RandomImages.swift
//  WantedMission-Concurrency
//
//  Created by 김두원 on 2023/03/06.
//

import Foundation

struct ImageList: Codable {
    let images: [RandomImage]
}

// MARK: - RandomImage
struct RandomImage: Codable {
    let id: String
    let url,download_url: String
}

