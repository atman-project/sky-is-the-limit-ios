//
//  MainTabView.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/15/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Flights().tabItem {
                Label("Flights", systemImage: "airplane")
            }
            SettingsView().tabItem {
                Label("Settings", systemImage: "gearshape")
            }
        }.onAppear {
            hello_devworld()
            let answer = add_numbers(15, 25)
            print("The answer is: \(answer)")
            let string = "for an anvil, this library sure is lightweight"
            print("The length is: \(string_length(string))")
            
            let p = give_me_a_point()
            let mag = magnitude(p)
            print("Magnitude of given Point is: \(mag)")
            let another = MyPoint(x: 1.0, y: 2.0)
            print("Magnitude of another Point is: \(magnitude(another))")
            
            let colour = what_colour()
            if colour == Green {
                print("go")
            } else {
                print("stop")
            }
            
            let word1 = "agreeable"
            let word2 = "affable"
            let distance = leven(word1, word2)
            print("Distance: \(distance)")
            
            if let five_a_cstr = give_me_letter_a(5) {
                let five_a = String.init(cString: five_a_cstr)
                free_string(five_a_cstr)
                print("5 of letter A: \(five_a)")
            } else {
                print("Returned string was null!")
            }
            
            print("Adding numbers with callback...")
            add_numbers_cb(4, 5) {
                answer in
                print("The answer is \(answer)")
            }
            print("Finished adding numbers!")
            
//            countdown() {
//                (timer: Int32) in
//                if timer > 0 {
//                    print("\(timer) seconds to go...")
//                } else {
//                    print("Houston we have liftoff")
//                }
//            }
            
            countdown() {
                (timer: Int32) in
                
                // Uh oh
                if timer == 7 {
                    print("Aborting!")
                    return Abort
                }
                
                if timer > 0 {
                    print("\(timer) seconds to go...")
                } else {
                    print("Houston we have liftoff")
                }
                return Continue
            }
        }
    }
}

#Preview {
    MainTabView()
}
