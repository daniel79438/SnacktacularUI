//
//  Spot.swift
//  SnacktacularUI
//
//  Created by Daniel Harris on 06/04/2025.
//

import Foundation
import FirebaseFirestore

struct Spot: Identifiable, Codable {
    @DocumentID var id: String?
    var name = ""
    var address = ""
}
