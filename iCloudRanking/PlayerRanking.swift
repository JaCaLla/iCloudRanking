//
//  PlayerRanking.swift
//  CloudKitRanking
//
//  Created by JAVIER CALATRAVA LLAVERIA on 23/4/25.
//

import CloudKit
import Foundation

struct PlayerScore: Identifiable {
    let id: CKRecord.ID
    let name: String
    let points: Int
    
    init(record: CKRecord) {
        self.id = record.recordID
        self.name = record["name"] as? String ?? "Unknown"
        self.points = record["points"] as? Int ?? 0
    }
}
