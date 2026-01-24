//
//  SignUpView.swift
//  TestingTask
//
//  Migrated to SwiftUI
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()

    var body: some View {
        Form {
            Section("Personal Information") {
                TextField("First Name", text: $viewModel.firstName)
                TextField("Last Name", text: $viewModel.lastName)

                Picker("Gender", selection: $viewModel.gender) {
                    Text("Select").tag("")
                    ForEach(viewModel.genderOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }

                DatePicker("Birth Date", selection: $viewModel.birthDate, displayedComponents: .date)
            }

            Section("Location") {
                Picker("Country", selection: $viewModel.country) {
                    Text("Select").tag("")
                    ForEach(viewModel.countryOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }

                Picker("City", selection: $viewModel.city) {
                    Text("Select").tag("")
                    ForEach(viewModel.cityOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
            }

            Section("Contact") {
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                TextField("Phone", text: $viewModel.phone)
                    .keyboardType(.numberPad)
                    .onChange(of: viewModel.phone) { newValue in
                        let filtered = newValue.filter { $0.isNumber }
                        if filtered.count > 15 {
                            viewModel.phone = String(filtered.prefix(15))
                        } else if filtered != newValue {
                            viewModel.phone = filtered
                        }
                    }
            }

            Section {
                Button(action: {
                    viewModel.createAccount()
                }) {
                    Text("Create Account")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .disabled(!viewModel.isFormValid || viewModel.isLoading)

                if let errorMessage = viewModel.errorMessage {
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
                    viewModel.goBack()
                }
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.2))
            }
        }
    }
}
