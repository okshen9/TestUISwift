//
//  ProfileInfoViewModel.swift
//  MMApp
//
//  Created by artem on 24.03.2025.
//


import SwiftUI

class ProfileInfoViewModel: ObservableObject {
    @Published var userProfile: UserProfile
    @Published var errors: [String: String] = [:]
    @Published var isValid = false

    init(userProfile: UserProfile = UserProfile(
        firstName: "",
        telegramUsername: "@okshen9",
        occupation: "",
        city: "",
        phoneNumber: "",
        about: ""
    )) {
        self.userProfile = userProfile
    }
    
    // Валидация всех полей
    func validate() {

        withAnimation {
            errors["firstName"] =  userProfile.firstName.isEmpty || userProfile.firstName.count > 3 ? nil : "Имя не может быть 3 символов"
            errors["telegramUsername"] =  userProfile.telegramUsername.isEmpty || userProfile.telegramUsername.count > 3 ? nil : "Имя пользователя в Telegram не может быть менее 3 символов"
            errors["occupation"] =  userProfile.occupation.isEmpty || userProfile.occupation.count > 3 ? nil : "Род деятельности не может быть менее 3 символов"
            errors["city"] =  userProfile.city.isEmpty || userProfile.city.count > 3 ? nil : "Город проживания не может быть менее 3 символов"
            errors["about"] =  userProfile.about.isEmpty || userProfile.about.count > 3 ? nil : "Поле 'О себе' не может быть 3 символов"
            errors["phoneNumber"] =  (userProfile.phoneNumber.isEmpty || isValidPhoneNumber(userProfile.phoneNumber))  ? nil : "Некорректный номер телефона"

            let anyEmpty = userProfile.firstName.isEmpty || userProfile.telegramUsername.isEmpty || userProfile.occupation.isEmpty || userProfile.city.isEmpty || userProfile.about.isEmpty || userProfile.phoneNumber.isEmpty

            isValid = errors.isEmpty && !anyEmpty
        }


    }

    // Проверка номера телефона
    private func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^\\+7 \\(9\\d{2}\\) \\d{3}-\\d{2}-\\d{2}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: phoneNumber)
    }

    // Функция сохранения профиля (адаптирована из запроса)
    func createProfile() async {
//        if validate() {
//            do {
//                let finalUser = try await apiFactory.createProfile(profileData: CreateUserProfileBodyModel(
//                    externalId: 0, // Предполагаем, что ID будет получен позже
//                    username: userProfile.telegramUsername,
//                    fullName: userProfile.firstName,
//                    userProfileStatus: "DRAFT",
//                    userPaymentStatus: "DRAFT",
//                    comment: userProfile.occupation,
//                    photoUrl: "", // Поле не указано в списке, оставляем пустым
//                    location: userProfile.city,
//                    phoneNumber: userProfile.phoneNumber
//                ))
//                
//                UserRepository.shared.setRoles([(finalUser?.userProfileStatus) ?? ""])
//                guard let viewController else { return }
//                Task {
//                    await navigateToMain(viewController)
//                }
//                print(finalUser ?? "No user returned")
//            } catch {
//                print(error)
//            }
//        }
    }
}
