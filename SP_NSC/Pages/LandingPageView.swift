//
//  LandingPageView.swift
//  SP_NSC
//
//  Created by Ted Goh on 19/3/25.
//
import SwiftUI
struct LandingPageView: View {
    var body: some View {
        NavigationStack{
            ZStack{
                Image("LandingPageBG").resizable().scaledToFill().ignoresSafeArea().opacity(0.6)
                VStack {
                    Image("SG60")
                        .offset(y: -100)
                    Text("Building Our Singapore Together")
                        .font(.custom("Lato", size: 36))
                        .foregroundColor(Color.white) // color: #FFF;
                        .fontWeight(.black) // font-weight: 900;
                        .frame(maxWidth: .infinity) // text-align: center;
                        .multilineTextAlignment(.center)
                        .offset(y: -80)
                    NavigationLink {
                        ContentView().navigationBarBackButtonHidden(true)
                    } label: {
                        Text("Enter")
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .bold))
                            .frame(width: 312, height: 70)
                            .background(Color(red: 202 / 255, green: 1 / 255, blue: 25 / 255))
                            .cornerRadius(10)
                            .offset(y: -40)
                    }

                }
            }
        }

    }
}
