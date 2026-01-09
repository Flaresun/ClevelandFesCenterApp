//
//  AvatarView.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/9/26.
//

import SwiftUI

struct AvatarView: View {

    let name: String?
    let size: CGFloat

    var body: some View {
        Circle()
            .fill(Color.blue.opacity(0.6))
            .frame(width: size, height: size)
            .overlay(
                Text(initials)
                    .font(.system(size: size / 2))
                    .foregroundColor(.white)
            )
    }

    private var initials: String {
        guard let name else { return "?" }
        let parts = name.split(separator: " ")
        return parts.prefix(2).compactMap { $0.first }.map(String.init).joined()
    }
}
