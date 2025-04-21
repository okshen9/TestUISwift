import SwiftUI

/// Компонент для отображения сектора диаграммы с заполнением
struct UniversalPieSlice: View {
    let slice: UniversalPieSliceData
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Основной сектор (незаполненный)
                sliceBaseShape(in: geometry)
                    .fill(slice.model.color.opacity(0.3))
                
                // Заполненная часть сектора
                sliceFilledShape(in: geometry)
                    .fill(slice.model.color)
                
                // Индикатор подкатегорий
                if slice.model.hasSubModels {
                    subcategoryIndicator(in: geometry)
                }
            }
        }
    }
    
    // Создает форму всего сегмента с пониженной непрозрачностью
    private func sliceBaseShape(in geometry: GeometryProxy) -> Path {
        return createSlicePath(in: geometry)
    }
    
    // Создает форму заполненной части сегмента
    private func sliceFilledShape(in geometry: GeometryProxy) -> Path {
        let fillPath = Path { path in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = min(geometry.size.width, geometry.size.height) / 2
            
            // Вычисляем пропорцию заполнения
            let fillFraction = slice.model.fillPercentage
            let spanAngle = slice.endAngle - slice.startAngle
            let filledEndAngle = slice.startAngle + (spanAngle * fillFraction)
            
            path.move(to: center)
            path.addArc(
                center: center,
                radius: radius,
                startAngle: .degrees(slice.startAngle),
                endAngle: .degrees(filledEndAngle),
                clockwise: false
            )
            path.closeSubpath()
        }
        
        // Вычисляем пересечение с базовой формой, чтобы не выходить за ее пределы
        return fillPath
    }
    
    // Создает основную форму сегмента
    private func createSlicePath(in geometry: GeometryProxy) -> Path {
        return Path { path in
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
} 