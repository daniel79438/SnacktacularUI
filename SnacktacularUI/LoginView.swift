//
//  LoginView.swift
//  SnacktacularUI
//
//  Created by Daniel Harris on 05/04/2025.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    //state variables to get the user entered information
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
            //Fields to enter user & password
            Group {
                TextField("email", text: $email)
                    .keyboardType(.emailAddress) // Email friendly keyboard
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next) //changes return button on keyboard to next
                
                SecureField("password", text: $password) //hides the passowrd and disables copy/paste
                    .submitLabel(.done) //changes return button on keyboard to done
            }
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: 2)
            }
            
            HStack {
                Button("Sign Up") {
                    register()
                }
                .padding(.trailing)
                
                Button("Log In") {
                    login()
                }
                .padding(.leading)
            }
            .buttonStyle(.borderedProminent)
            .tint(.snack) //custom color from Assets
            .font(.title2)
            .padding(.top)
            
        }
        .padding()
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { //button if the error appears
        
            }
        }
    }
    
    func register() { //signup user
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error { // check to see if there is an error
                print("😡 SIGNUP ERROR: \(error.localizedDescription)")
                //show an alert to the user if there is an error
                alertMessage = "😡 SIGNUP ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("😎 Registration success!")
                //TODO: Load ListView
            }
        }
    }
    
    
    
    func login() { //login user
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error { // check to see if there is an error
                print("😡 LOGIN ERROR: \(error.localizedDescription)")
                //show an alert to the user if there is an error
                alertMessage = "😡 LOGIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("🪵 Login success!")
                //TODO: Load ListView
            }
        }
    }
    
}

#Preview {
    LoginView()
}
