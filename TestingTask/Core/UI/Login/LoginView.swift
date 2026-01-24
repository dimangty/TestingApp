//
//  LoginView.swift
//  TestingTask
//
//  Migrated to SwiftUI
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        VStack(spacing: 20) {
            TextField("Phone Number", text: $viewModel.phone)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                .onChange(of: viewModel.phone) { newValue in
                    let filtered = newValue.filter { $0.isNumber }
                    if filtered.count > 15 {
                        viewModel.phone = String(filtered.prefix(15))
                    } else if filtered != newValue {
                        viewModel.phone = filtered
                    }
                }

            Button(action: {
                viewModel.login()
            }) {
                Text("Confirm")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isPhoneValid ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!viewModel.isPhoneValid || viewModel.isLoading)
            .padding(.horizontal)

            Button("Sign Up") {
                viewModel.navigateToSignUp()
            }
            .padding()

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
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
