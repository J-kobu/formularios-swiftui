//
//  SettingsView.swift
//  Formularios
//
//  Created by Jacob Aguilar on 21-01-21.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var settingsFactory: SettingsFactory //EnviromentObject es similar a un state, pero este será compartido por toda la aplicación
    @State private var selectedOrder = SortingOrderType.alphabetical
    @State private var showPurchasedOnly = false
    @Environment(\.presentationMode) var presentationMode
    @State private var maxPrice = 5 {
        didSet {
            if maxPrice > 5 {
                maxPrice = 5
            }
            if maxPrice < 1 {
                maxPrice = 1
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Ordenar cursos")) {
                    Picker(selection: $selectedOrder, label: Text("Orden de cursos")) { //Selection: se encarga de bindear (atar o vincular) la variable que indica la posición que se está seleccionando en ese momento, y como es un binding se utiliza "$" para indicar la variable
                        ForEach(SortingOrderType.allCases, id: \.self) { orderType in //con .allCases recorremos todos los enums que creamos en el archivo de Swift SortingOrdenType //**Ojo que también está el .AllCase, y este, devuelve otra estructura, la cual no nos sirve en este caso**
                            Text(orderType.description)
                        }
                    }
                }
                Section(header: Text("Filtrar cursos")) {
                    Toggle(isOn: $showPurchasedOnly, label: {
                        Text("Mostrar solo los comprados")
                    })
                    
                    Stepper(
                        onIncrement: { self.maxPrice += 1},
                        onDecrement: { self.maxPrice -= 1 },
                        label: {
                            Text("Mostrar \(String(repeating: "$", count: maxPrice))")
                        })
                }
            }
            .navigationBarTitle("Configuración")
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark.circle")
                    .font(.system(size: 25))
                    .foregroundColor(.red)
            }), trailing: Button(action: {
                self.settingsFactory.order = self.selectedOrder
                self.settingsFactory.showPurchasedOnly = self.showPurchasedOnly
                self.settingsFactory.maxPrice = self.maxPrice
                
                settingsFactory.objectWillChange.send() //Para actualizar de manera automática cuando guardemos los cambios de la SettingsView 
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 25))
                    .foregroundColor(.green)
            }))
        }
        .onAppear {
            self.selectedOrder = self.settingsFactory.order
            self.showPurchasedOnly = self.settingsFactory.showPurchasedOnly
            self.maxPrice = self.settingsFactory.maxPrice
        }
        
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(SettingsFactory())
    }
}
