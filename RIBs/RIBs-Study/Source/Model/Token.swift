//
//  Token.swift
//  RIBs-Study
//
//  Created by 이현욱 on 6/30/25.
//

import Foundation

struct Token: Codable {
    let access_token: String
    let token_type: String
    let expires_in: Int
}
