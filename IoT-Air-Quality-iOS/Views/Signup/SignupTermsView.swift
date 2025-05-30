//
//  TermsView.swift
//  IoT-Air-Quality-iOS
//
//  Created by HyungJun Lee on 5/23/25.
//

import SwiftUI

struct TermsAgreementView: View {
    @State private var agreements: [Bool] = Array(repeating: false, count: 4)
    @State private var showingTermIndex: IdentifiableInt? = nil

    var allAgreed: Bool {
        agreements.allSatisfy { $0 }
    }

    var body: some View {
        VStack(spacing: 40) {
            Spacer(minLength: 20)

            Text("Sign up")
                .font(.largeTitle)
                .fontWeight(.bold)

            Image("app_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)

            Spacer()

            VStack(alignment: .leading, spacing: 10) {
                ForEach(terms.indices) { index in
                    HStack {
                        Text(terms[index])
                        Spacer()
                        Button("[View]") {
                            showingTermIndex = IdentifiableInt(value: index)
                        }
                        Toggle("", isOn: $agreements[index])
                            .labelsHidden()
                    }
                }
            }
            .padding(.horizontal)

            HStack(spacing: 16) {
                Button(action: {
                    agreements = Array(repeating: false, count: 4)
                }) {
                    Text("Reset")
                        .font(.title)
                        .frame(maxWidth: .infinity, minHeight: 55)
                }
                .buttonStyle(.bordered)

                Button(action: {
                    // 다음 화면으로 이동
                }) {
                    Text("Next")
                        .font(.title)
                        .frame(maxWidth: .infinity, minHeight: 55)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!allAgreed)
            }
            .padding(.horizontal)

            Spacer(minLength: 20)
        }
        .sheet(item: $showingTermIndex) { identifiable in
            ScrollView {
                Text("Detail content for \(terms[identifiable.value])")
                    .padding()
            }
        }
    }
}

struct IdentifiableInt: Identifiable {
    let value: Int
    var id: Int { value }
}

#Preview {
    TermsAgreementView()
}
