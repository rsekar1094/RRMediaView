//
//  CircularProgressView.swift
//  
//
//  Created by Raj S on 31/01/23.
//

import SwiftUI

public struct CircularProgressView: View {
    public init(
        viewModel: CircularProgressViewModel
    ) {
        self.viewModel = viewModel
    }
    
    let viewModel: CircularProgressViewModel
    
    public var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .stroke(viewModel.config.unProgressColor,
                        lineWidth: viewModel.config.strokeWidth)
            Circle()
                .trim(from: 0, to: viewModel.progress)
                .stroke(viewModel.config.progressColor,
                        style: StrokeStyle(lineWidth: viewModel.config.strokeWidth,
                                           lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut,
                           value: viewModel.progress)
            
            switch viewModel.config.centerText {
            case .progress:
                centerTextView("\(Int(viewModel.progress*100))%")
            case .progressOtherThanZero(let value):
                if viewModel.progress == 0 {
                    centerTextView(value)
                } else {
                    centerTextView("\(Int(viewModel.progress*100))%")
                }
            case .text(let value):
                centerTextView(value)
            }
        }
    }
    
    func centerTextView(_ value: String) -> some View {
        Text(value)
            .foregroundColor(viewModel.config.centerTextColor)
            .font(.footnote)
    }
}

public struct CircularProgressViewModel {
    let progress: Double
    let config: Config
    
    public init(progress: Double, config: Config) {
        self.progress = progress
        self.config = config
    }

    public struct Config {
        let strokeWidth: CGFloat
        let progressColor: Color
        let unProgressColor: Color
        let centerText: CenterText
        let centerTextColor: Color
        
        public init(
            strokeWidth: CGFloat,
            progressColor: Color,
            unProgressColor: Color,
            centerText: CenterText = .progress,
            centerTextColor: Color
        ) {
            self.strokeWidth = strokeWidth
            self.progressColor = progressColor
            self.unProgressColor = unProgressColor
            self.centerText = centerText
            self.centerTextColor = centerTextColor
        }
        
        public init(
            strokeWidth: CGFloat,
            progressColor: Color,
            unProgressColor: Color,
            centerText: CenterText = .progress
        ) {
            self.strokeWidth = strokeWidth
            self.progressColor = progressColor
            self.unProgressColor = unProgressColor
            self.centerText = centerText
            self.centerTextColor = progressColor
        }
    }
    
    public enum CenterText {
        case progress
        case text(String)
        case progressOtherThanZero(String)
    }
}
