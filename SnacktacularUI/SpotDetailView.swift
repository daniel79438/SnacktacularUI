//
//  SpotView.swift
//  SnacktacularUI
//
//  Created by Daniel Harris on 06/04/2025.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct SpotDetailView: View {
    @FirestoreQuery(collectionPath: "spots") var fsPhotos: [Photo]
    @State var spot: Spot // pass in value from ListView
    @State var spotVM = SpotViewModel()
    @State private var photoSheetIsPresented = false
    @State private var showingAlert  = false // Alert user if they need to save Spot before adding a Photo
    @State private var alertMessage = "Cannot add a photo until you save the Spot."
    @Environment(\.dismiss) private var dismiss
    private var photos: [Photo] {
        // If running in Preview then show mock data
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            return [Photo.preview, Photo.preview, Photo.preview, Photo.preview, Photo.preview, Photo.preview]
        }
        // Else show Firebase Data
        return fsPhotos
    }
    
    
    var body: some View {
        VStack{
            Group {
                TextField("name", text: $spot.name)
                    .font(.title)
                    .autocorrectionDisabled()
                
                TextField("address", text: $spot.address)
                    .font(.title2)
            }
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: 2)
            }
            .padding(.horizontal)
            
            Button { // Photo Button
                if spot.id == nil { // Ask if you want to save
                    showingAlert.toggle()
                } else { // Go right to phototview
                    photoSheetIsPresented.toggle()
                }
            } label: {
                Image(systemName: "camera.fill")
                Text("Photo")
            }
            .bold()
            .buttonStyle(.borderedProminent)
            .tint(.snack)
            
            ScrollView(.horizontal) {
                HStack{
                    ForEach(photos) { photo in
                        let url = URL(string: photo.imageURLString)
                        AsyncImage(url: url) { image in image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
            }
            .frame(height: 80)
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .task {
            $fsPhotos.path = "spots/\(spot.id ?? "")/photos"
        }
        
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    saveSpot()
                    dismiss()
                }
            }
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Save") {
                // We want to return spot.id after saving a new Spot. Right now it's nil
                Task{
                    guard let id = await SpotViewModel.saveSpot(spot: spot) else {
                        print("😡 ERROR: Saving spot in alert returned nil")
                        return
                    }
                    spot.id = id
                    print("spot id: \(id)")
                    photoSheetIsPresented.toggle() // Now open sheet and move to PhotoView
                }
            }
        }
        .fullScreenCover(isPresented: $photoSheetIsPresented) {
            PhotoView(spot: spot)
            
        }
    }
    
    func  saveSpot() {
        Task{
            guard let id = await SpotViewModel.saveSpot(spot: spot) else {
                print("😡 ERROR: Saving spot from save button")
                return
            }
            print("spot id: \(id)")
            print("😎 Nice Spot save!")
        }
    }
}

#Preview {
    NavigationStack {
        SpotDetailView(spot: Spot.preview)
    }
}
