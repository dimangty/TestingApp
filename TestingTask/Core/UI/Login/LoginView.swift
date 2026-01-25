//
//  LoginView.swift
//  TestingTask
//
//  Migrated to SwiftUI with TCA
//

import SwiftUI
import ComposableArchitecture

struct LoginView: View {
    @Perception.Bindable var store: StoreOf<LoginFeature>

    var body: some View {
        VStack(spacing: 20) {
            TextField("Phone Number", text: $store.phone)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                .onChange(of: store.phone, perform: { newValue in
                    let filtered = newValue.filter { $0.isNumber }
                    if filtered.count > 15 {
                        store.phone = String(filtered.prefix(15))
                    } else if filtered != newValue {
                        store.phone = filtered
                    }
                })

            Button(action: {
                store.send(.loginButtonTapped)
            }) {
                Text("Confirm")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(store.isPhoneValid ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!store.isPhoneValid || store.isLoading)
            .padding(.horizontal)

            Button("Sign Up") {
                store.send(.signUpButtonTapped)
            }
            .padding()

            if let errorMessage = store.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
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
