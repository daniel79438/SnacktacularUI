//
//  SpotViewModel.swift
//  SnacktacularUI
//
//  Created by Daniel Harris on 06/04/2025.
//

import Foundation
import FirebaseFirestore

@Observable
class SpotViewModel {
    
    static func saveSpot(spot: Spot) async -> String? {
        let db = Firestore.firestore()
        
        if let id = spot.id { // if true the spot already exists
            do {
                try db.collection("spots").document(id).setData(from: spot)
                print("😎 Data updated successfully!")
                return id
            } catch {
                print("😡 Could not update date in 'spots' \(error.localizedDescription)")
                return id
            }
        } else { //We need to add a new spot and a new id / document name
            do {
                let docRef = try db.collection("spots").addDocument(from: spot)
                print("🐣 Data added successfully!")
                return docRef.documentID
            } catch {
                print("😡 Could not create a new spot in 'spots' \(error.localizedDescription)")
                return nil
            }
        }
    }
    
   static func deleteSpot(spot: Spot) {
        let db = Firestore.firestore()
        guard let id = spot.id else {
            print("No spot.id")
            return
        }
        
        Task {
            do {
                try await db.collection("spots").document(id).delete()
            } catch {
                print("😡 Could not delete document \(id). \(error.localizedDescription)")
            }
        }
    }
}

