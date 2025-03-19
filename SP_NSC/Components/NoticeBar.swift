//
//  NoticeBar.swift
//  SP_NSC
//
//  Created by Ted Goh on 19/3/25.
//

import SwiftUI

struct NoticeBar: View {
    @Binding var showNotice: Bool
    var notice: String
    var body: some View {
        HStack {
            Text(notice)
                .foregroundColor(.white)
                .font(.subheadline)
            
            Spacer()
            
            // An 'X' button to dismiss the notice
            Button {
                withAnimation {
                    showNotice = false
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
                    .font(.title2)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        // Customize background color
        .background(Color(hex: "#ED1C24"))
    }
}
