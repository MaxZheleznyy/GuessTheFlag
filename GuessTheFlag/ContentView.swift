//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Maxim Zheleznyy on 3/3/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var userScore = 0
    
    //WTF I coould not use Double value with degrees convertation 🤬
    @State private var animationDegree = Angle.degrees(0)
    @State private var offset = CGSize.zero
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.orange, .green]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.black)
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                .scaledToFill()
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        FlagImage(imageName: self.countries[number])
                        .rotation3DEffect(number == self.correctAnswer ? self.animationDegree : .degrees(0), axis: (x: 0, y: 1, z: 0))
                        .offset(self.offset)
                        .opacity(((number != self.correctAnswer) && self.showingScore) ? 0.25 : 1)
                    }
                }
                
                Text("Your score is \(userScore)")
                .foregroundColor(.black)
                
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(userScore)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            userScore += 1
            
            withAnimation {
                self.animationDegree += .degrees(360)
            }
        } else {
            scoreTitle = "Wrong \n" + "That's the flag of \(countries[number])"
            
            if userScore > 0 {
                userScore -= 1
            }
            
            self.offset = CGSize(width: 10, height: 0)
            withAnimation(.interpolatingSpring(stiffness: 300, damping: 5)) {
                self.offset = .zero
            }
        }

        showingScore = true
    }
    
    func askQuestion() {
        self.showingScore = false
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct FlagImage: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
