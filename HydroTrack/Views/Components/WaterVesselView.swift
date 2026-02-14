import SwiftUI

struct WaterVesselView: View {
    let current: Double
    let goal: Double
    
    var percentage: Double {
        min(current / goal, 1.5)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Container (vessel outline)
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Theme.primaryBlue.opacity(0.3), lineWidth: 4)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white)
                    )
                
                // Water fill
                GeometryReader { geo in
                    let fillHeight = geo.size.height * CGFloat(percentage)
                    
                    VStack {
                        Spacer()
                        
                        ZStack(alignment: .bottom) {
                            // Water with wave effect
                            Theme.waterGradient(for: percentage)
                                .frame(height: fillHeight)
                                .mask(
                                    WaveShape(percent: percentage)
                                        .fill()
                                        .frame(height: fillHeight + 20)
                                )
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 26))
                .padding(4)
                
                // Progress ring
                Circle()
                    .trim(from: 0, to: min(percentage, 1.0))
                    .stroke(
                        progressColor,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: Theme.animationSlow), value: percentage)
                    .padding(8)
                
                // Amount text
                VStack(spacing: 8) {
                    Text("\(Int(current))")
                        .font(.system(size: 64, weight: .semibold, design: .rounded))
                        .foregroundColor(percentage > 0.5 ? .white : Theme.primaryBlue)
                    
                    Text("oz / \(Int(goal)) oz")
                        .font(.headline)
                        .foregroundColor((percentage > 0.5 ? Color.white : Theme.textSecondary).opacity(0.8))
                    
                    Text("\(Int(percentage * 100))%")
                        .font(.title2.bold())
                        .foregroundColor(percentage > 0.5 ? .white : Theme.primaryBlue)
                }
                .shadow(color: .black.opacity(percentage > 0.5 ? 0.2 : 0), radius: 4)
            }
        }
        .padding(.horizontal, Theme.spacingL)
    }
    
    var progressColor: Color {
        switch percentage {
        case 0..<0.5:
            return Theme.primaryBlue
        case 0.5..<0.8:
            return Theme.secondaryCyan
        case 0.8..<1.0:
            return Theme.accentGreen
        default:
            return Color(hex: "FFD700") // Gold for over 100%
        }
    }
}

struct WaveShape: Shape {
    var percent: Double
    var animatableData: Double {
        get { percent }
        set { percent = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let waveHeight: CGFloat = 10
        let waveLength = rect.width
        
        path.move(to: CGPoint(x: 0, y: rect.height))
        
        for x in stride(from: 0, through: rect.width, by: 1) {
            let relativeX = x / waveLength
            let sine = sin(relativeX * .pi * 4)
            let y = waveHeight * sine
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    VStack {
        WaterVesselView(current: 32, goal: 64)
            .frame(height: 300)
        
        WaterVesselView(current: 48, goal: 64)
            .frame(height: 300)
        
        WaterVesselView(current: 64, goal: 64)
            .frame(height: 300)
    }
}
