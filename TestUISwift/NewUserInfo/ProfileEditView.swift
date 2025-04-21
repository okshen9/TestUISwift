//
//  ProfileInfoView.swift
//  MMApp
//
//  Created by artem on 24.03.2025.
//

import SwiftUI

struct ProfileInfoView: View {
    @ObservedObject var viewModel: ProfileInfoViewModel
    @State var isKeyboardVisible = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ValidatedTextField(
                        title: "Имя",
                        text: $viewModel.userProfile.firstName,
                        error: viewModel.errors["firstName"]
                    )

                    ValidatedTextField(
                        title: "Имя пользователя в Telegram",
                        text: $viewModel.userProfile.telegramUsername,
                        error: viewModel.errors["telegramUsername"]
                    )
                    .setCanEdit(false)

                    ValidatedTextField(
                        title: "Род деятельности",
                        text: $viewModel.userProfile.occupation,
                        error: viewModel.errors["occupation"]
                    )

                    ValidatedTextField(
                        title: "Город проживания",
                        text: $viewModel.userProfile.city,
                        error: viewModel.errors["city"]
                    )

                    PhoneNumberTextField(
                        phoneNumber: $viewModel.userProfile.phoneNumber,
                        error: viewModel.errors["phoneNumber"]
                    )

                    ValidatedTextEditor(
                        title: "О себе",
                        text: $viewModel.userProfile.about,
                        error: viewModel.errors["about"]
                    )

                    Button(action: {
                        Task {
                            await viewModel.createProfile()
                        }
                    }) {
                        Text("Сохранить")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isValid ? Color.mainRed : Color.gray.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                    .disabled(!viewModel.isValid)

                }
                .padding()
                .onChange(of: viewModel.userProfile) {
                    viewModel.validate()
                }

            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Данные профиля")
            .onAppear {
                // Отслеживание клавиатуры
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
                    isKeyboardVisible = true
                }
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    isKeyboardVisible = false
                }
            }
            .onDisappear {
                NotificationCenter.default.removeObserver(self)
            }
        }
    }
}


#Preview {
    ProfileInfoView(viewModel: ProfileInfoViewModel(), isKeyboardVisible: false)
}
