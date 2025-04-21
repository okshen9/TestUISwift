import SwiftUI

struct EnhancedPieChartView: View {
    @ObservedObject var viewModel: PieChartViewModel
    
    // Анимационное состояние для переходов
    @State private var animationAmount: Double = 0
    @State private var rotationDegrees: Double = 0
    @State private var selectedSliceIndex: Int? = nil
    @State private var showDetails: Bool = false
    
    // Размер диаграммы
    var size: CGFloat = 250
    var centerCircleSize: CGFloat = 100
    
    // Отступы для выделения выбранного сегмента
    var selectedSliceOffset: CGFloat = 15
    
    // Вычисляем данные для сегментов диаграммы
    private var slices: [PieSliceData] {
        // Преобразуем текущие элементы в данные для сегментов
        var startAngle: Double = 0
        var slices: [PieSliceData] = []
        
        // Получаем сумму всех значений
        var sum = 0.0
        
        switch viewModel.displayMode {
        case .categories:
            sum = viewModel.categories.reduce(0) { $0 + $1.totalValue }
            
            for category in viewModel.categories {
                let percentage = category.totalValue / sum
                let endAngle = startAngle + 360 * percentage
                
                slices.append(PieSliceData(
                    startAngle: startAngle,
                    endAngle: endAngle,
                    color: category.color,
                    value: category.totalValue,
                    title: category.title,
                    item: category
                ))
                
                startAngle = endAngle
            }
            
        case .subCategories(let category):
            guard let subCats = category.subCat, !subCats.isEmpty else { return [] }
            
            sum = subCats.reduce(0) { $0 + $1.totalValue }
            
            for subCat in subCats {
                let percentage = subCat.totalValue / sum
                let endAngle = startAngle + 360 * percentage
                
                slices.append(PieSliceData(
                    startAngle: startAngle,
                    endAngle: endAngle,
                    color: subCat.color,
                    value: subCat.totalValue,
                    title: subCat.title,
                    item: subCat
                ))
                
                startAngle = endAngle
            }
            
        case .subSubCategories(let subCat):
            guard let subSubCats = subCat.subSubCat, !subSubCats.isEmpty else { return [] }
            
            sum = subSubCats.reduce(0) { $0 + $1.totalValue }
            
            for subSubCat in subSubCats {
                let percentage = subSubCat.totalValue / sum
                let endAngle = startAngle + 360 * percentage
                
                slices.append(PieSliceData(
                    startAngle: startAngle,
                    endAngle: endAngle,
                    color: subSubCat.color,
                    value: subSubCat.totalValue,
                    title: subSubCat.title,
                    item: subSubCat
                ))
                
                startAngle = endAngle
            }
            
        case .subSubSubCategories(let subSubCat):
            guard let subSubSubCats = subSubCat.subSubSubCat, !subSubSubCats.isEmpty else { return [] }
            
            sum = subSubSubCats.reduce(0) { $0 + $1.totalValue }
            
            for subSubSubCat in subSubSubCats {
                let percentage = subSubSubCat.totalValue / sum
                let endAngle = startAngle + 360 * percentage
                
                slices.append(PieSliceData(
                    startAngle: startAngle,
                    endAngle: endAngle,
                    color: subSubSubCat.color,
                    value: subSubSubCat.totalValue,
                    title: subSubSubCat.title,
                    item: subSubSubCat
                ))
                
                startAngle = endAngle
            }
        }
        
        return slices
    }
    
    var body: some View {
        ZStack {
            // Круговая диаграмма
            ForEach(0..<slices.count, id: \.self) { i in
                EnhancedPieSlice(
                    slice: slices[i],
                    isSelected: selectedSliceIndex == i,
                    offsetDistance: selectedSliceOffset
                )
                .scaleEffect(animationAmount)
                .animation(.spring(), value: animationAmount)
                .onTapGesture {
                    withAnimation(.spring()) {
                        if selectedSliceIndex == i {
                            // Если выбран тот же сегмент, переходим в подкатегории
                            viewModel.onSegmentTapped(slices[i].item)
                            selectedSliceIndex = nil
                            resetAnimation()
                        } else {
                            // Выбираем сегмент
                            selectedSliceIndex = i
                            rotateToCenter(sliceIndex: i)
                            showDetails = true
                        }
                    }
                }
            }
            .rotationEffect(Angle(degrees: rotationDegrees))
            .animation(.easeInOut(duration: 0.5), value: rotationDegrees)
            
            // Центральный круг
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [.white, .white.opacity(0.9)]),
                        center: .center,
                        startRadius: 0,
                        endRadius: centerCircleSize / 2
                    )
                )
                .frame(width: centerCircleSize, height: centerCircleSize)
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                )
                .onTapGesture {
                    withAnimation(.spring()) {
                        viewModel.onCenterTapped()
                        selectedSliceIndex = nil
                        showDetails = false
                        resetAnimation()
                    }
                }
            
            // Текст в центре
            VStack {
                if showDetails && selectedSliceIndex != nil {
                    // Детали выбранного сегмента
                    let slice = slices[selectedSliceIndex!]
                    
                    Text(slice.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .padding(.horizontal, 5)
                    
                    Text(String(format: "%.0f (%.1f%%)", slice.value, (slice.value / slices.reduce(0) { $0 + $1.value } * 100)))
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .padding(.top, 2)
                    
                    Button {
                        withAnimation(.spring()) {
                            viewModel.onSegmentTapped(slice.item)
                            selectedSliceIndex = nil
                            showDetails = false
                            resetAnimation()
                        }
                    } label: {
                        Text("Подробнее")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(slice.color.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.top, 5)
                } else {
                    // Общая информация
                    Text(viewModel.currentTitle)
                        .font(.headline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .padding(.horizontal, 5)
                        .padding(.bottom, 5)
                    
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 5)
                            .frame(width: 50, height: 50)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(min(viewModel.totalFillPercentage / 100, 1.0)))
                            .stroke(
                                AngularGradient(
                                    gradient: Gradient(colors: [.blue, .purple, .red]),
                                    center: .center
                                ),
                                style: StrokeStyle(lineWidth: 5, lineCap: .round)
                            )
                            .frame(width: 50, height: 50)
                            .rotationEffect(Angle(degrees: -90))
                        
                        Text(String(format: "%.0f%%", viewModel.totalFillPercentage))
                            .font(.system(size: 12, weight: .bold))
                    }
                }
            }
            .frame(width: centerCircleSize - 20)
            .animation(.easeOut(duration: 0.3), value: showDetails)
            .animation(.easeOut(duration: 0.3), value: selectedSliceIndex)
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                animationAmount = 1
            }
        }
    }
    
    private func resetAnimation() {
        animationAmount = 0
        withAnimation(.easeInOut(duration: 0.5)) {
            animationAmount = 1
        }
    }
    
    private func rotateToCenter(sliceIndex: Int) {
        let slice = slices[sliceIndex]
        let midAngle = (slice.startAngle + slice.endAngle) / 2
        // Поворачиваем так, чтобы середина сегмента была сверху (270 градусов)
        rotationDegrees = 270 - midAngle
    }
}

struct EnhancedPieSlice: View {
    let slice: PieSliceData
    let isSelected: Bool
    let offsetDistance: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                let radius = min(geometry.size.width, geometry.size.height) / 2
                
                // Вычисляем угол для смещения выделенного сегмента
                let midAngle = (slice.startAngle + slice.endAngle) / 2
                let xOffset = isSelected ? cos(midAngle * .pi / 180) * offsetDistance : 0
                let yOffset = isSelected ? sin(midAngle * .pi / 180) * offsetDistance : 0
                
                let adjustedCenter = CGPoint(
                    x: center.x + xOffset,
                    y: center.y + yOffset
                )
                
                path.move(to: adjustedCenter)
                path.addArc(
                    center: adjustedCenter,
                    radius: radius,
                    startAngle: .degrees(slice.startAngle),
                    endAngle: .degrees(slice.endAngle),
                    clockwise: false
                )
                path.closeSubpath()
            }
            .fill(
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            slice.color.opacity(0.8),
                            slice.color
                        ]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                Path { path in
                    let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    let radius = min(geometry.size.width, geometry.size.height) / 2
                    
                    // Вычисляем угол для смещения выделенного сегмента
                    let midAngle = (slice.startAngle + slice.endAngle) / 2
                    let xOffset = isSelected ? cos(midAngle * .pi / 180) * offsetDistance : 0
                    let yOffset = isSelected ? sin(midAngle * .pi / 180) * offsetDistance : 0
                    
                    let adjustedCenter = CGPoint(
                        x: center.x + xOffset,
                        y: center.y + yOffset
                    )
                    
                    path.move(to: adjustedCenter)
                    path.addArc(
                        center: adjustedCenter,
                        radius: radius,
                        startAngle: .degrees(slice.startAngle),
                        endAngle: .degrees(slice.endAngle),
                        clockwise: false
                    )
                    path.closeSubpath()
                }
                .stroke(
                    isSelected ? Color.white : Color.clear,
                    lineWidth: isSelected ? 2 : 0
                )
            )
            .shadow(
                color: isSelected ? Color.black.opacity(0.2) : Color.clear,
                radius: isSelected ? 5 : 0,
                x: 0,
                y: 0
            )
        }
    }
}

// Предварительный просмотр
struct EnhancedPieChartView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PieChartViewModel()
        
        // Создаем тестовые данные
        let subSubSubCat1 = SubSubSubCat(totalValue: 30, currentValue: 15, color: .orange, title: "Sub-Sub-Sub Cat 1")
        let subSubSubCat2 = SubSubSubCat(totalValue: 70, currentValue: 30, color: .yellow, title: "Sub-Sub-Sub Cat 2")
        
        let subSubCat1 = SubSubCat(totalValue: 40, currentValue: 20, subSubSubCat: [subSubSubCat1, subSubSubCat2], color: .green, title: "Sub-Sub Cat 1")
        let subSubCat2 = SubSubCat(totalValue: 60, currentValue: 45, subSubSubCat: nil, color: .blue, title: "Sub-Sub Cat 2")
        
        let subCat1 = SubCat(totalValue: 30, currentValue: 15, subSubCat: [subSubCat1, subSubCat2], color: .purple, title: "Sub Cat 1")
        let subCat2 = SubCat(totalValue: 70, currentValue: 50, subSubCat: nil, color: .pink, title: "Sub Cat 2")
        
        let category1 = Category(totalValue: 40, currentValue: 20, subCat: [subCat1, subCat2], color: .red, title: "Category 1")
        let category2 = Category(totalValue: 60, currentValue: 30, subCat: nil, color: .blue, title: "Category 2")
        
        viewModel.categories = [category1, category2]
        
        return EnhancedPieChartView(viewModel: viewModel)
            .frame(width: 300, height: 300)
            .previewLayout(.sizeThatFits)
    }
} 