//
//  Photo.swift
//  SnacktacularUI
//
//  Created by Daniel Harris on 10/04/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class Photo: Identifiable, Codable {
    @DocumentID var id: String?
    var imageURLString = "" // This will hold the uRL for loading the image
    var description = ""
    var reviewer: String = Auth.auth().currentUser?.email ?? ""
    var postedOn = Date() //Current Date / Time
    
    
}
