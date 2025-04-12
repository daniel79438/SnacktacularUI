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
    
    init(id: String? = nil, imageURLString: String = "", description: String = "", reviewer: String = (Auth.auth().currentUser?.email ?? ""), postedOn: Date = Date()) {
        self.id = id
        self.imageURLString = imageURLString
        self.description = description
        self.reviewer = reviewer
        self.postedOn = postedOn
    }
}

extension Photo {
    static var preview: Photo {
        let newPhoto = Photo(
            id: "1",
            imageURLString: "https://en.wikipedia.org/wiki/File:Pizza-3007395.jpg",
            description: "Yummy Pizza",
            reviewer: "little@caesers.com",
            postedOn: Date()
        )
        return newPhoto
    }
}
