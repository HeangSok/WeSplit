//
//  ContentView.swift
//  WeSplit
//
//  Created by Heang Sok on 17/3/2022.
//

import SwiftUI

struct ContentView: View {
    // @state so that we can change our struct properties' value
    // private tell that this variable is used in this struct only
    @State private var checkAmount:Double = 0.0
    @State private var numberOfPeople:Int = 2
    @State private var seletedTipPercentage:Int = 20
    
    // @FocusState is exactly like @State; it is design specifically for handle focus. Ex: focus in textfield or not.
    @FocusState private var textFieldIsFocused:Bool
    
    
    let tipPercentage:Array<Int> = [10, 15, 20, 25, 0]
    
    // create a new computed property
    var totalPerPerson:Double {
        // calculate the total person;note: our picker started from 2
        let peopleCount = Double(numberOfPeople + 2)
        // casting selectedTipPercentage
        let tipSelection = Double(seletedTipPercentage)
        
        let tipValue = checkAmount * tipSelection / 100
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }

    
    
    // note: var body: some View... accepts only one return
    var body: some View {
        NavigationView{
            Form {
                
                Section {
                    /* Amount to pay */
                    
                    // use value instead of text because checkAmount is Double
                    // value is use with format or formatter
                    // check stackoverflow to see how to accept Int from textField
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currencyCode ?? "AUD"))
                        .keyboardType(.decimalPad)
                        .focused($textFieldIsFocused) // swiftui will know it is focus or not
                    
                    /* or we can use this technique if we don't work with currency
                    TextField("Amount", value: $checkAmount, formatter: NumberFormatter())
                                .keyboardType(.numberPad)*/
                    /*
                    TextField("Amount", value: $checkAmount, format: .number)
                                .keyboardType(.numberPad)*/
                    
                    /* picker for number of people*/
                    // careful: our picker list start from 2..<100 and numberOfPeople is 2; this will make the picker not working
                    // we need to embed it into navigation
                    Picker("Number of People", selection: $numberOfPeople) {
                        ForEach(2..<100) {// note: value on the picker screen will start from two, but the acutal value that pass to $numberOfPeople is its index. So 2 is at index 0 (value 0); 4 is at index 2 (value 2). to make the value that appear on the screen means what it is. ex: if 2 appears on the picker screen, we add 2 to make it means 2. also see line 20
                            Text("\($0) people")
                        }
                    }
                                
                } header: {
                    Text("Total Amount")
                }
                
                
                Section {
                    Picker("Tip percentage", selection: $seletedTipPercentage) {
                        ForEach(tipPercentage, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Want to tip?")
                } footer: {
                    Text("Thanks you for your kindness ♥️!")
                }
                
                Section {
//                    Text(checkAmount, format: .number)
                    Text(totalPerPerson, format: .currency(code: Locale.current.currencyCode ?? "AUD"))
                } header: {
                    Text("Amount to be paid per person")
                }
            }.navigationTitle("Money Sharing App")
                .toolbar { // place a done button into keyboard toolbar to hide it when we are done
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer() // use Spacer() to push the "Done" to the right
                        Button("Done") {
                            textFieldIsFocused = false
                        }
                    }
                }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
