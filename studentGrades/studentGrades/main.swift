//
//  main.swift
//  studentGrades
//
//  Created by StudentAM on 1/29/24.
//

import Foundation
import CSV

let stream = InputStream(fileAtPath: "/Users/studentam/Desktop/grades.csv" )
let csv = try CSVReader(stream: stream!)


mainMenu()

func mainMenu(){
    var menuChoice: String = "0"
    while menuChoice != "9"{
        print("Welcome to the Grade Manager!\n",
        "What would you like to do? (Enter the number):\n",
        "1. Display grade of a single student\n",
        "2. Display all grades for a student\n",
        "3. Display all grades of ALL students\n",
        "4. Find the average grade of the class\n",
        "5. Find the average grade of an assignment\n",
        "6. Find the lowest grade in the class\n",
        "7. Find the highest grade of the class\n",
        "8. Filter students by grade range\n",
        "9. Quit\n")
        
        if let userPick = readLine(), let userChoice = Int(userPick){
            if userChoice == 1 {
                displaySingleStudentGrade()
            } else if userChoice == 2 {
                displayAllStudentGrades()
            } else if userChoice == 3 {
                displayAllGradesForAllStudents ()
            } else if userChoice == 4 {
                classAverage()
            } else if userChoice == 5 {
                assignmentGradeAverage()
            } else if userChoice == 6 {
                classLowestGrade()
            } else if userChoice == 7 {
                classHighestGrade()
            } else if userChoice == 8 {
                studentsByGradeRange()
            } else if userChoice == 9 {
                quitMenu()
            } else {
                print ("Please enter a valid selection 1-9")
            }
            menuChoice = userPick
        }
    }
}

func displaySingleStudentGrade(){
    print ("Which student would you like to choose?")
    
    if let userChoice = readLine(), let selectedStudent = String(userChoice){
        findSingleGrade()
    }
}

func findSingleGrade(){
    
}
