//
//  SpotView.swift
//  SnacktacularUI
//
//  Created by Daniel Harris on 06/04/2025.
//

import SwiftUI

struct SpotDetailView: View {
    @State var spot: Spot // pass in value from ListView
    @State var spotVM = SpotViewModel()
    @State private var photoSheetIsPresented = false
    @State private var showingAlert  = false // Alert user if they need to save Spot before adding a Photo
    @State private var alertMessage = "Cannot add a photo until you save the Spot."
    @Environment(\.dismiss) private var dismiss
    
    
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
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        
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
        SpotDetailView(spot: Spot())
    }
}
