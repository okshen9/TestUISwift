import SwiftUI

/// Улучшенная версия компонента для отображения сектора диаграммы с заполнением
struct EnhancedUniversalPieSlice: View {
    let slice: UniversalPieSliceData
    let isSelected: Bool
    let offsetDistance: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Основной сектор (незаполненный фон)
                sliceBaseShape(in: geometry)
                    .fill(slice.model.color.opacity(0.3))
                    .overlay(sliceStroke(in: geometry))
                    .shadow(
                        color: isSelected ? Color.black.opacity(0.2) : Color.clear,
                        radius: isSelected ? 5 : 0,
                        x: 0,
                        y: 0
                    )
                
                // Заполненная часть сектора
                sliceFilledShape(in: geometry)
                    .fill(slice.model.color)
                
                // Индикатор подкатегорий
                if slice.model.hasSubModels && !isSelected {
                    subcategoryIndicator(in: geometry)
                }
            }
        }
    }
    
    // Создает форму всего сектора
    private func sliceBaseShape(in geometry: GeometryProxy) -> Path {
        Path { path in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = min(geometry.size.width, geometry.size.height) / 2
            
            // Вычисляем смещение для выделенного сегмента
            let (xOffset, yOffset) = calculateOffset()
            
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
    }
    
    // Создает форму заполненной части сектора
    private func sliceFilledShape(in geometry: GeometryProxy) -> Path {
        Path { path in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = min(geometry.size.width, geometry.size.height) / 2
            
            // Вычисляем смещение для выделенного сегмента
            let (xOffset, yOffset) = calculateOffset()
            
            let adjustedCenter = CGPoint(
                x: center.x + xOffset,
                y: center.y + yOffset
            )
            
            // Вычисляем угол заполненной части
            let fillFraction = slice.model.fillPercentage
            let spanAngle = slice.endAngle - slice.startAngle
            let filledEndAngle = slice.startAngle + (spanAngle * fillFraction)
            
            path.move(to: adjustedCenter)
            path.addArc(
                center: adjustedCenter,
                radius: radius,
                startAngle: .degrees(slice.startAngle),
                endAngle: .degrees(filledEndAngle),
                clockwise: false
            )
            path.closeSubpath()
        }
    }
    
    // Обводка сегмента
    private func sliceStroke(in geometry: GeometryProxy) -> some View {
        sliceBaseShape(in: geometry)
            .stroke(
                isSelected ? Color.white : (slice.model.hasSubModels ? Color.white.opacity(0.3) : Color.clear),
                lineWidth: isSelected ? 2 : (slice.model.hasSubModels ? 1 : 0)
            )
    }
    
    // Индикатор наличия подкатегорий
    private func subcategoryIndicator(in geometry: GeometryProxy) -> some View {
        let midAngle = (slice.startAngle + slice.endAngle) / 2
        let radius = min(geometry.size.width, geometry.size.height) / 2
        let indicatorDistance = radius * 0.7
        let x = cos(midAngle * .pi / 180) * indicatorDistance + geometry.size.width / 2
        let y = sin(midAngle * .pi / 180) * indicatorDistance + geometry.size.height / 2
        
        return Circle()
            .fill(Color.white)
            .frame(width: 6, height: 6)
            .position(x: x, y: y)
    }
    
    // Вычисляет смещение для выделения сегмента
    private func calculateOffset() -> (CGFloat, CGFloat) {
        let midAngle = (slice.startAngle + slice.endAngle) / 2
        if isSelected {
            let xOffset = cos(midAngle * .pi / 180) * offsetDistance
            let yOffset = sin(midAngle * .pi / 180) * offsetDistance
            return (xOffset, yOffset)
        } else {
            return (0, 0)
        }
    }
} 