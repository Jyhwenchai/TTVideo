//
//  PlayListFilterView.swift
//  SixThirty (iOS)
//
//  Created by 蔡志文 on 2021/12/29.
//

import SwiftUI


struct PlayListFilterView: View {
    
    private let filterDateRange: ClosedRange<Date> = {
        let calender = Calendar.current
        let start = calender.date(from: DateComponents(year: 2017, month: 1, day: 1))!
        let end = Date()
        return start...end
    }()
    
    @Binding var selectDate: Date
    @Binding var show: Bool
    
    var confirm: () async -> Void

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .opacity(0.5)
                .ignoresSafeArea()
            
            VStack {
                DatePicker(selection: $selectDate, in: filterDateRange, displayedComponents: .date){}
                .datePickerStyle(WheelDatePickerStyle()).environment(\.locale, .init(identifier: "zh-CN"))
                .background(Color.white)
                .clipped()

                HStack {
                    Button(action: { show.toggle() }) {
                        Text("取消")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                    }
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .cornerRadius(6)

                    Spacer()
                    Button(action: {
                        show.toggle()
                        Task { await confirm() }
                    }) {
                        Text("确定")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                    }
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(6)
                }
                .padding()
            }
            .background(Color.white)
            .cornerRadius(6)
            .padding(.horizontal)
            
        }
    }
}

struct PlayListFilterOverlay: ViewModifier {
    
    @Binding var selectDate: Date
    @Binding var show: Bool
    
    var confirm: () async -> Void
    
    func body(content: Content) -> some View {
        content
            .overlay {
                PlayListFilterView(selectDate: $selectDate, show: $show, confirm: confirm)
            }
    }
}

extension View {
    func overlayPlayListFilter(show: Binding<Bool>, selectDate: Binding<Date>, confirm: @escaping () async -> Void) -> some View {
        return modifier(PlayListFilterOverlay(selectDate: selectDate, show: show, confirm: confirm))
    }
}
