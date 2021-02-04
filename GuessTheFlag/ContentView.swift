//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Travis Brigman on 1/30/21.
//  Copyright © 2021 Travis Brigman. All rights reserved.
//

import SwiftUI

//custom modifier - this can be implemented anywwhere and can reduce lines of code in the contentView
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

struct FlagImage: View {
    
    var number: Int
    var countries: [String]
    
    var body: some View {       
        Image(countries[number])
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.gray, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
    
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy","Nigeria","Poland","Russia","Spain","UK","US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var userScore = 0
    
    @State private var animationAmount = 0.0
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30){
                VStack{
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3) {
                    number in
                    Button(action: {
                        self.flagTapped(number)
                        withAnimation {
                            if number == self.correctAnswer {
                                self.animationAmount += 360
                            }
                            
                        }
                    }) {
                        FlagImage(number: number, countries: self.countries)
                            .rotation3DEffect(.degrees(number == self.correctAnswer ? self.animationAmount : 0), axis: (x: 0, y: 1, z: 0))
                        
                    }
                }
                Text("Current Score: \(userScore)")
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("Continue")){
                self.askQuestion()
                })
        }
    }
    func flagTapped(_ number: Int){
        if number == correctAnswer {
            userScore += 1
        }
        
        let flagTapped = countries[number]
        
        scoreTitle = number == correctAnswer ? "Correct" : "Wrong"
        
        if number != correctAnswer {
            scoreMessage = "Wrong! That's the flag of \(flagTapped)"
        } else {
            scoreMessage = "Your Score is \(userScore)"
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
