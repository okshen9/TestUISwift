import SwiftUI

struct PieSliceData {
    let startAngle: Double
    let endAngle: Double
    let color: Color
    let value: Double
    let title: String
    let item: Any
}

struct PieChartView: View {
    @ObservedObject var viewModel: PieChartViewModel
    
    // Анимационное состояние для переходов
    @State private var animationAmount: Double = 0
    
    // Размер диаграммы
    var size: CGFloat = 250
    var centerCircleSize: CGFloat = 100
    
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
                PieSlice(slice: slices[i])
                    .scaleEffect(animationAmount)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            viewModel.onSegmentTapped(slices[i].item)
                            resetAnimation()
                        }
                    }
            }
            
            // Центральный круг
            Circle()
                .fill(Color.white)
                .frame(width: centerCircleSize, height: centerCircleSize)
                .shadow(radius: 2)
                .onTapGesture {
                    withAnimation(.spring()) {
                        viewModel.onCenterTapped()
                        resetAnimation()
                    }
                }
            
            // Текст в центре
            VStack {
                Text(viewModel.currentTitle)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 5)
                
                Text(String(format: "%.1f%%", viewModel.totalFillPercentage))
                    .font(.title3)
                    .fontWeight(.bold)
            }
            .frame(width: centerCircleSize - 20)
        }
        .frame(width: size, height: size)
        .onAppear {
            animationAmount = 1
        }
    }
    
    private func resetAnimation() {
        animationAmount = 0
        withAnimation(.easeInOut(duration: 0.5)) {
            animationAmount = 1
        }
    }
}

struct PieSlice: View {
    let slice: PieSliceData
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                let radius = min(geometry.size.width, geometry.size.height) / 2
                
                path.move(to: center)
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: .degrees(slice.startAngle),
                    endAngle: .degrees(slice.endAngle),
                    clockwise: false
                )
                path.closeSubpath()
            }
            .fill(slice.color)
        }
    }
}

// Предварительный просмотр
struct PieChartView_Previews: PreviewProvider {
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
        
        return PieChartView(viewModel: viewModel)
            .frame(width: 300, height: 300)
            .previewLayout(.sizeThatFits)
    }
} 
