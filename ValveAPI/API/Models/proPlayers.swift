//
//  proPlayers.swift
//  ValveAPI
//
//  Created by Dmitry on 02.03.2023.
//

import Foundation

// MARK: - ProPlayerElement
struct ProPlayerElement: Codable {
    let name, avatarfull, personaname: String?
    let fantasyRole: Int?
    let teamName: String?

    enum CodingKeys: String, CodingKey {
        case name, avatarfull, personaname
        case fantasyRole = "fantasy_role"
        case teamName = "team_name"
    }
}

typealias ProPlayers = [ProPlayerElement]
