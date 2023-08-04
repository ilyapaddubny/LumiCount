//
//  ProfileView.swift
//  CountMate
//
//  Created by Ilya Paddubny on 23.05.2023.
//
import FirebaseAuth
import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    
    
    var body: some View {
        ZStack {
            LinearGradient (
                gradient: Gradient(colors: [Color.backgroundTop, Color.backgroundBottom]),
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
//                Pofile section
//            VStack {
//                if let user = viewModel.user {
//                    profile(user: user)
//                }else{
//                    Text("Loading Profile...")
//                }
//            }
            
        }
        .onAppear {
            viewModel.fetchUser()
        }
        .navigationTitle("About the app")
    }
    
    @ViewBuilder
    func profile(user: DBUser) -> some View {
        
//        Avatar
//        Image(systemName: "person.crop.circle.badge.xmark")
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .foregroundColor(Color.white)
//            .imageScale(.large)
//            .font(Font.system(size: 60, weight: .ultraLight))
//            .frame(width: 130, height: 130)
        
//        Profile section
//        VStack(alignment: .leading) {
//            Text("Profile")
//                .black18()
//                .padding(.leading, 28)
//                .textCase(.uppercase)
//                .padding(.top, 10)
//
//            Rectangle()
//                .fill(.white)
//                .overlay{
//                    VStack(spacing: 0){
//                        HStack{
//                            Text("Full name").black18()
//                            Spacer()
//                            Text(user.name).black18()
//                        }
//                        .frame(height: 43)
//                        .padding([.leading, .trailing])
//
//                        Divider()
//
//                        HStack{
//                            Text("Email Address").black18()
//                            Spacer()
//                            Text(user.email).black18()
//                        }
//                        .frame(height: 43)
//                        .padding([.leading, .trailing])
//
//                        Divider()
//
//                        HStack{
//                            Text("Member since:").black18()
//                            Spacer()
//                            Text("\(viewModel.formattedDate)").black18()
//                        }
//                        .frame(height: 43)
//                        .padding([.leading, .trailing])
//
//                        Divider()
//
//                        CMButton(color: Color.blue, lable: "Register"){
////                                        TODO: Implement Register us logic
//                            do {
//                                try Auth.auth().signOut()
//                                // Code to execute if sign out is successful
//                            } catch let signOutError as NSError {
//                                // Handle any errors that occur during sign out
//                                print("❗️ Error signing out: \(signOutError)")
//                            }
//
//                        }
//                    }
//                    .padding(.top, 3)
//
//                }
//                .cornerRadius(10)
//                .frame(height: 43*4+3)
//                .padding([.leading, .trailing])
//        }
        
//        Support Us section
        VStack(alignment: .leading) {
            Text("Support us")
                .black18()
                .padding(.leading, 28)
                .textCase(.uppercase)
                .padding(.top, 10)
            
            Rectangle()
                .fill(.white)
                .overlay{
                    VStack(spacing: 0){
//                        TODO: change the link and make it blue underlined
                        Text("We strive to provide a free counting tool. \n If you find our app helpful, you can \n [RATE THE APP](https://duckduckgo.com) or support us.")
                            .tint(.blue)
                            .padding()
                            .multilineTextAlignment(.center)
                        
                        Spacer(minLength: 0)
                        
                        CMButton(color: Color.green, lable: "Support us"){
//                                        TODO: Implement Support us logic
                        }
                    }
                }
                .cornerRadius(10)
                .frame(height: 140)
                .padding([.leading, .trailing])
        }
        Spacer()
        Text("Thank you for using LumiCount!")
            .white22()
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
        Spacer()
    }
}
    
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileView()
        }
    }
