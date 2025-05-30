import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack {
            Spacer(minLength: 60)

            // 상단 문구
            Text("Air Quality Collection")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom, 16)

            // 앱 로고
            Image("app_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding(.bottom, 40)

            Spacer()

            // 소셜 로그인 버튼 (Apple, Google)
            VStack(spacing: 16) {
                SignInWithAppleButton(
                    onRequest: { request in
                        // Handle Apple request
                    },
                    onCompletion: { result in
                        // Handle Apple result
                    }
                )
                .frame(height: 50)
                .signInWithAppleButtonStyle(.black)

                Button(action: {
                    // Handle Google login
                }) {
                    HStack {
                        Image("google_logo")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Continue with Google")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 1)
                }
            }
            .padding(.horizontal)

            Spacer(minLength: 40)
        }
        .background(Color(.systemBackground))
        .ignoresSafeArea()
    }
}
