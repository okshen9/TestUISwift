import SwiftUI

struct CircularProgressView: View {
    @State private var animatedProgress: CGFloat = 0.0
    @State private var glowOpacity: Double = 0.3 // Для анимации свечения
    var progress: CGFloat // От 0.0 до 1.0
    let mainRed = Color(red: 1.0, green: 0.275, blue: 0.275) // FF4646

    var body: some View {
        ZStack {
            // Фоновый серый круг
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 8)

            // Свечение (размытый круг)
            Circle()
                .trim(from: 0.0, to: animatedProgress)
                .stroke(
                    mainRed.opacity(glowOpacity),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .blur(radius: 8) // Дает эффект свечения
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.5), value: animatedProgress)

            // Прогресс-бар
            Circle()
                .trim(from: 0.0, to: animatedProgress)
                .stroke(
                    mainRed,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 1.5), value: animatedProgress)

            // Текст с процентами
            Text("\(Int(progress * 100))%")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.black.opacity(0.7))
        }
        .frame(width: 100, height: 100)
        .onAppear {
            animatedProgress = progress > 1.0 ? 1.0 : progress
            withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                glowOpacity = 0.7 // Плавное мерцание свечения
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // Минималистичный фон
            CircularProgressView(progress: 0.75)
        }
    }
}


#Preview {
    CircularProgressView(progress: 2332.5)
}
