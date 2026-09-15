import SwiftUI

struct LoginScreen: View {
    @Binding var loggedIn: Bool
    @State var email = ""
    @State var pass = ""
    @State var msg = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("Campus Quest")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 50)

                TextField("email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()

                SecureField("password", text: $pass)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Log In") {
                    if email == "" || pass == "" {
                        msg = "need email and password"
                    } else {
                        loginUser(email: email, password: pass) { ok, err in
                            if ok {
                                loggedIn = true
                            } else {
                                msg = err
                            }
                        }
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)

                Button("Sign Up") {
                    if email == "" || pass == "" {
                        msg = "need email and password"
                    } else {
                        signupUser(email: email, password: pass) { ok, err in
                            if ok {
                                loggedIn = true
                            } else {
                                msg = err
                            }
                        }
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.gray)
                .cornerRadius(8)

                Text(msg)
                    .foregroundColor(.gray)
                    .padding()

                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}
