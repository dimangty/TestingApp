//
//  SignUpView.swift
//  TestingTask
//
//  Migrated to SwiftUI with TCA
//

import SwiftUI
import ComposableArchitecture

struct SignUpView: View {
    @Perception.Bindable var store: StoreOf<SignUpFeature>

    var body: some View {
        Form {
            Section("Personal Information") {
                TextField("First Name", text: $store.firstName)
                TextField("Last Name", text: $store.lastName)

                Picker("Gender", selection: $store.gender) {
                    Text("Select").tag("")
                    ForEach(store.genderOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }

                DatePicker("Birth Date", selection: $store.birthDate, displayedComponents: .date)
            }

            Section("Location") {
                Picker("Country", selection: $store.country) {
                    Text("Select").tag("")
                    ForEach(store.countryOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }

                Picker("City", selection: $store.city) {
                    Text("Select").tag("")
                    ForEach(store.cityOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
            }

            Section("Contact") {
                TextField("Email", text: $store.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                TextField("Phone", text: $store.phone)
                    .keyboardType(.numberPad)
                    .onChange(of: store.phone, perform: { newValue in
                        let filtered = newValue.filter { $0.isNumber }
                        if filtered.count > 15 {
                            store.phone = String(filtered.prefix(15))
                        } else if filtered != newValue {
                            store.phone = filtered
                        }
                    })
            }

            Section {
                Button(action: {
                    store.send(.createAccountTapped)
                }) {
                    Text("Create Account")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .disabled(!store.isFormValid || store.isLoading)

                if let errorMessage = store.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("Sign Up")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") {
                    store.send(.backButtonTapped)
                }
            }
        }
        .overlay {
            if store.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.2))
            }
        }
    }
}
