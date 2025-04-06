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
    enum Field { //Cases to be created for focus to go between
        case email, password
    }
    
    //State variables to get the user entered information
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonDisabled = true
    @FocusState private var focusField: Field? //Used to set and move the focus(which field the cursor is associated to)
    
    
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
                    .focused($focusField, equals: .email) //email focus
                //When submit button is pressed change focus
                    .onSubmit {
                        focusField = .password
                    }
                //runs enabledButtons function everytime a new character is entered into email / password field
                    .onChange(of: email) {
                        enabledButtons()
                    }
                
                SecureField("password", text: $password) //hides the passowrd and disables copy/paste
                    .submitLabel(.done) //changes return button on keyboard to done
                    .focused($focusField, equals: .password) //password focus
                //When submit button is pressed, the keyboard is dismissed
                    .onSubmit {
                        focusField = nil
                    }
                //runs enabledButtons function everytime a new character is entered into email / password field
                    .onChange(of: email) {
                        enabledButtons()
                    }
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
            .disabled(buttonDisabled)
            
        }
        .padding()
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { //button if the error appears
        
            }
        }
    }
    //Function to check whether the buttons should be disabled or not
    func enabledButtons() {
        let emailIsGood = email.count > 6 && email.contains("@")
        let passwordIsGood = password.count > 6
        buttonDisabled = !(emailIsGood && passwordIsGood)
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
