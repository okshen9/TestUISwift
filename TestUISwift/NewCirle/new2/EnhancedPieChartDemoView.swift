import SwiftUI

struct EnhancedPieChartDemoView: View {
    @StateObject private var viewModel = PieChartViewModel()
    @State private var selectedTheme: ColorTheme = .standard
    @State private var showInfo: Bool = false
    
    enum ColorTheme {
        case standard
        case warm
        case cool
        case rainbow
        
        var mainColors: [Color] {
            switch self {
            case .standard:
                return [.red, .blue, .green, .orange, .purple]
            case .warm:
                return [.red, .orange, .yellow, .pink, .brown]
            case .cool:
                return [.blue, .cyan, .teal, .mint, .indigo]
            case .rainbow:
                return [.red, .orange, .yellow, .green, .blue, .purple, .pink]
            }
        }
        
        var subColors: [Color] {
            switch self {
            case .standard:
                return [.purple, .teal, .pink, .yellow, .gray]
            case .warm:
                return [.orange, .yellow, .pink, .brown, .red.opacity(0.7)]
            case .cool:
                return [.teal, .mint, .cyan.opacity(0.7), .blue.opacity(0.7), .indigo.opacity(0.7)]
            case .rainbow:
                return mainColors.map { $0.opacity(0.7) }
            }
        }
        
        var title: String {
            switch self {
            case .standard: return "Стандартная"
            case .warm: return "Тёплая"
            case .cool: return "Холодная"
            case .rainbow: return "Радуга"
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Интерактивная диаграмма")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    showInfo.toggle()
                }) {
                    Image(systemName: "info.circle")
                        .font(.title2)
                }
                .sheet(isPresented: $showInfo) {
                    infoView
                }
            }
            .padding()
            
            EnhancedPieChartView(viewModel: viewModel)
                .frame(height: 300)
                .padding()
            
            Text("Текущий режим: \(displayModeDescription)")
                .font(.subheadline)
                .padding(.horizontal)
            
            Divider()
                .padding(.vertical, 8)
            
            themeSelector
                .padding(.horizontal)
            
            Spacer()
            
            HStack(spacing: 20) {
                Button("Сбросить") {
                    withAnimation {
                        viewModel.displayMode = .categories
                    }
                }
                .buttonStyle(PrimaryButtonStyle(backgroundColor: .blue))
                
                Button("Обновить данные") {
                    withAnimation {
                        setupDemoData()
                    }
                }
                .buttonStyle(PrimaryButtonStyle(backgroundColor: .green))
            }
            .padding(.bottom)
        }
        .onAppear {
            setupDemoData()
        }
    }
    
    private var themeSelector: some View {
        VStack(alignment: .leading) {
            Text("Цветовая схема:")
                .font(.subheadline)
                .padding(.bottom, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach([ColorTheme.standard, .warm, .cool, .rainbow], id: \.title) { theme in
                        Button {
                            selectedTheme = theme
                            updateTheme()
                        } label: {
                            VStack {
                                HStack(spacing: 2) {
                                    ForEach(0..<theme.mainColors.count, id: \.self) { i in
                                        Circle()
                                            .fill(theme.mainColors[i])
                                            .frame(width: 12, height: 12)
                                    }
                                }
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                
                                Text(theme.title)
                                    .font(.caption)
                                    .foregroundColor(selectedTheme == theme ? .primary : .secondary)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(selectedTheme == theme ? Color.primary : Color.gray.opacity(0.3), lineWidth: selectedTheme == theme ? 2 : 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.bottom, 4)
            }
        }
    }
    
    private var infoView: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Как использовать диаграмму")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    showInfo = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            VStack(alignment: .leading, spacing: 16) {
                instructionRow(
                    icon: "1.circle.fill",
                    title: "Просмотр сегментов",
                    description: "Нажмите на сегмент, чтобы выбрать его и увидеть детальную информацию в центре."
                )
                
                instructionRow(
                    icon: "2.circle.fill",
                    title: "Переход к подкатегориям",
                    description: "Нажмите на кнопку 'Подробнее' в центре или дважды на сегмент, чтобы увидеть его подкатегории."
                )
                
                instructionRow(
                    icon: "3.circle.fill",
                    title: "Возврат назад",
                    description: "Нажмите на центр диаграммы, чтобы вернуться к предыдущему уровню категорий."
                )
                
                instructionRow(
                    icon: "4.circle.fill",
                    title: "Процент заполнения",
                    description: "Круг в центре показывает заполнение текущего уровня категорий в процентах."
                )
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                showInfo = false
            }) {
                Text("Закрыть")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding()
        }
    }
    
    private func instructionRow(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    private var displayModeDescription: String {
        switch viewModel.displayMode {
        case .categories:
            return "Все категории"
        case .subCategories(let category):
            return "Подкатегории для '\(category.title)'"
        case .subSubCategories(let subCat):
            return "Под-подкатегории для '\(subCat.title)'"
        case .subSubSubCategories(let subSubCat):
            return "Под-под-подкатегории для '\(subSubCat.title)'"
        }
    }
    
    private func updateTheme() {
        let mainColors = selectedTheme.mainColors
        let subColors = selectedTheme.subColors
        
        var updatedCategories: [Category] = []
        
        for (index, var category) in viewModel.categories.enumerated() {
            let colorIndex = index % mainColors.count
            
            if var subCats = category.subCat {
                for i in 0..<subCats.count {
                    let subColorIndex = i % subColors.count
                    
                    if var subSubCats = subCats[i].subSubCat {
                        for j in 0..<subSubCats.count {
                            let subSubColorIndex = (j + colorIndex) % mainColors.count
                            
                            if var subSubSubCats = subSubCats[j].subSubSubCat {
                                for k in 0..<subSubSubCats.count {
                                    let subSubSubColorIndex = (k + subColorIndex) % subColors.count
                                    subSubSubCats[k] = SubSubSubCat(
                                        totalValue: subSubSubCats[k].totalValue,
                                        currentValue: subSubSubCats[k].currentValue,
                                        color: subColors[subSubSubColorIndex],
                                        title: subSubSubCats[k].title
                                    )
                                }
                                
                                subSubCats[j] = SubSubCat(
                                    totalValue: subSubCats[j].totalValue,
                                    currentValue: subSubCats[j].currentValue,
                                    subSubSubCat: subSubSubCats,
                                    color: mainColors[subSubColorIndex],
                                    title: subSubCats[j].title
                                )
                            } else {
                                subSubCats[j] = SubSubCat(
                                    totalValue: subSubCats[j].totalValue,
                                    currentValue: subSubCats[j].currentValue,
                                    subSubSubCat: nil,
                                    color: mainColors[subSubColorIndex],
                                    title: subSubCats[j].title
                                )
                            }
                        }
                        
                        subCats[i] = SubCat(
                            totalValue: subCats[i].totalValue,
                            currentValue: subCats[i].currentValue,
                            subSubCat: subSubCats,
                            color: subColors[subColorIndex],
                            title: subCats[i].title
                        )
                    } else {
                        subCats[i] = SubCat(
                            totalValue: subCats[i].totalValue,
                            currentValue: subCats[i].currentValue,
                            subSubCat: nil,
                            color: subColors[subColorIndex],
                            title: subCats[i].title
                        )
                    }
                }
                
                category = Category(
                    totalValue: category.totalValue,
                    currentValue: category.currentValue,
                    subCat: subCats,
                    color: mainColors[colorIndex],
                    title: category.title
                )
            } else {
                category = Category(
                    totalValue: category.totalValue,
                    currentValue: category.currentValue,
                    subCat: nil,
                    color: mainColors[colorIndex],
                    title: category.title
                )
            }
            
            updatedCategories.append(category)
        }
        
        viewModel.categories = updatedCategories
    }
    
    private func setupDemoData() {
        // Создаем тестовые данные с большей глубиной и разнообразием
        
        // SubSubSubCat для первой SubSubCat
        let subSubSubCat1_1 = SubSubSubCat(
            totalValue: 35,
            currentValue: 20,
            color: selectedTheme.subColors[0],
            title: "Дет. 1.1.1.1"
        )
        
        let subSubSubCat1_2 = SubSubSubCat(
            totalValue: 65,
            currentValue: 40,
            color: selectedTheme.subColors[1],
            title: "Дет. 1.1.1.2"
        )
        
        // SubSubCat для первой SubCat
        let subSubCat1_1 = SubSubCat(
            totalValue: 40,
            currentValue: 25,
            subSubSubCat: [subSubSubCat1_1, subSubSubCat1_2],
            color: selectedTheme.mainColors[2],
            title: "Дет. 1.1.1"
        )
        
        let subSubCat1_2 = SubSubCat(
            totalValue: 60,
            currentValue: 35,
            subSubSubCat: nil,
            color: selectedTheme.mainColors[3],
            title: "Дет. 1.1.2"
        )
        
        // SubCat для первой Category
        let subCat1 = SubCat(
            totalValue: 30,
            currentValue: 15,
            subSubCat: [subSubCat1_1, subSubCat1_2],
            color: selectedTheme.subColors[0],
            title: "Дет. 1.1"
        )
        
        let subCat2 = SubCat(
            totalValue: 70,
            currentValue: 30,
            subSubCat: nil,
            color: selectedTheme.subColors[1],
            title: "Дет. 1.2"
        )
        
        // SubSubCat для второй SubCat
        let subSubCat3_1 = SubSubCat(
            totalValue: 25,
            currentValue: 10,
            subSubSubCat: nil,
            color: selectedTheme.mainColors[0],
            title: "Дет. 2.1.1"
        )
        
        let subSubCat3_2 = SubSubCat(
            totalValue: 75,
            currentValue: 50,
            subSubSubCat: nil,
            color: selectedTheme.mainColors[1],
            title: "Дет. 2.1.2"
        )
        
        // SubCat для второй Category
        let subCat3 = SubCat(
            totalValue: 60,
            currentValue: 40,
            subSubCat: [subSubCat3_1, subSubCat3_2],
            color: selectedTheme.subColors[2],
            title: "Дет. 2.1"
        )
        
        let subCat4 = SubCat(
            totalValue: 40,
            currentValue: 25,
            subSubCat: nil,
            color: selectedTheme.subColors[3],
            title: "Дет. 2.2"
        )
        
        // Основные категории
        let category1 = Category(
            totalValue: 40,
            currentValue: 20,
            subCat: [subCat1, subCat2],
            color: selectedTheme.mainColors[0],
            title: "Категория 1"
        )
        
        let category2 = Category(
            totalValue: 30,
            currentValue: 15,
            subCat: [subCat3, subCat4],
            color: selectedTheme.mainColors[1],
            title: "Категория 2"
        )
        
        let category3 = Category(
            totalValue: 30,
            currentValue: 25,
            subCat: nil,
            color: selectedTheme.mainColors[2],
            title: "Категория 3"
        )
        
        // Устанавливаем данные в viewModel
        viewModel.categories = [category1, category2, category3]
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    var backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(
                Capsule()
                    .fill(configuration.isPressed ? backgroundColor.opacity(0.7) : backgroundColor)
            )
            .foregroundColor(.white)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct EnhancedPieChartDemoView_Previews: PreviewProvider {
    static var previews: some View {
        EnhancedPieChartDemoView()
    }
}