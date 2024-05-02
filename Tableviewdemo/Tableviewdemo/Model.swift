//
//  Model.swift
//  Tableviewdemo
//
//  Created by Bodar Nirmal on 02/05/24.
//

import Foundation

// MARK: - PostRe
class PostRe: Codable {
    let userID, id: Int?
    let title, body: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }

    init(userID: Int?, id: Int?, title: String?, body: String?) {
        self.userID = userID
        self.id = id
        self.title = title
        self.body = body
    }
}

typealias PostRes = [PostRe]
