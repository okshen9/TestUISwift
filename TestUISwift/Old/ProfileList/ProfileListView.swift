//
//  ProfileListView.swift
//  TestUISwift
//
//  Created by artem on 23.02.2025.
//

import SwiftUI

// MARK: - Enums

enum TypeGroupe {
    case stream(String)
    case group(String)
    
    var name: String {
        switch self {
        case .stream(let name): return "Стрим " + name
        case .group(let name): return "Группа " + name
        }
    }
}

enum StatusGruop {
    case ended
    case current
    
    var name: String {
        switch self {
        case .ended: return "Завершен"
        case .current: return "Текущий"
        }
    }
    
    var color: Color {
        switch self {
        case .ended: return .red
        case .current: return .green
        }
    }
}

// MARK: - Models

struct StreamUserProfileShortInfoDto: Identifiable {
    let id = UUID()
    let externalId: Int?
    let username: String?
    let fullName: String?
    let targetCalculationInfoDto: TargetCalculationInfoDto?
}

struct TargetCalculationInfoDto {
    var categoryToInfoMapping: [String: TargetCategoryCalculationInfoDto]
    var allCategoriesDonePercentage: Double
}

struct TargetCategoryCalculationInfoDto {
    var quantityForUserProfile: Int?
    var doneForUserProfile: Int?
    var percentageOfDoneAllCategoryForUserProfile: Double?
}

// MARK: - View

struct GroupView: View {
    let type: TypeGroupe
    let status: StatusGruop
    let mentors: [StreamUserProfileShortInfoDto]
    let participants: [StreamUserProfileShortInfoDto]
    let dateStart = Date.init(timeIntervalSince1970: 232324)
    let dateEnd = Date.now
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    let dateStr1 = DateFormatter.localizedString(from: dateStart, dateStyle: .short, timeStyle: .none)
                    let dateStr2 = DateFormatter.localizedString(from: dateEnd, dateStyle: .short, timeStyle: .none)
                    Text(dateStr1 + " - " + dateStr2)
                        .font(.body)
                        .bold()
                    Spacer()
                    Text(status.name)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(6)
                        .background(status.color)
                        .cornerRadius(8)
                }
                .padding()
                
                List {
                    if !mentors.isEmpty {
                        Section(header: Text("Менторы").font(.headline)) {
                            ForEach(mentors) { mentor in
                                UserRow(user: mentor)
                            }
                        }
                    }
                    
                    if !participants.isEmpty {
                        Section(header: Text("Участники").font(.headline)) {
                            ForEach(participants) { participant in
                                UserRow(user: participant)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle(type.name)
        }
    }
}

#Preview {
    GroupView(type: .stream("7"), status: .ended,
              mentors: mockOwners,
              participants: mockParticipants)
}

// MARK: - UserRow

struct UserRow: View {
    let user: StreamUserProfileShortInfoDto
    
    var body: some View {
        NavigationLink(destination: UserProfileView(user: user)) {
            HStack {
                VStack(alignment: .leading) {
                    Text(user.fullName ?? "Неизвестный пользователь")
                        .font(.body)
                        .bold()
                    if let username = user.username {
                        Text(username)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                if let progress = user.targetCalculationInfoDto?.allCategoriesDonePercentage {
                    ProgressView(value: progress, total: 100)
                        .progressViewStyle(LinearProgressViewStyle())
                        .frame(width: 50)
                }
            }
            .padding(4)
        }
    }
}

// MARK: - UserProfileView (Заглушка)

struct UserProfileView: View {
    let user: StreamUserProfileShortInfoDto
    
    var body: some View {
        VStack {
            Text(user.fullName ?? "Неизвестный пользователь")
                .font(.largeTitle)
                .bold()
            if let username = user.username {
                Text("@\(username)")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Профиль")
    }
}



let mockOwners: [StreamUserProfileShortInfoDto] = [
    StreamUserProfileShortInfoDto(
        externalId: 14,
        username: "katesapon",
        fullName: "Сапон Екатерина Игоревна",
        targetCalculationInfoDto: nil
    )
]

let mockParticipants: [StreamUserProfileShortInfoDto] = [
    StreamUserProfileShortInfoDto(
        externalId: 11,
        username: "okshen9",
        fullName: "Artem Neshko",
        targetCalculationInfoDto: nil
    ),
    StreamUserProfileShortInfoDto(
        externalId: 12,
        username: "KirillMoiseenkov",
        fullName: "Kirill Moiseenkov",
        targetCalculationInfoDto: nil
    ),
    StreamUserProfileShortInfoDto(
        externalId: 9,
        username: "bestofoleg",
        fullName: "Oleg Abramov",
        targetCalculationInfoDto: nil
    )
]
