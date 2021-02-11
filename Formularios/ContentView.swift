//
//  ContentView.swift
//  Formularios
//
//  Created by Jacob Aguilar on 12-01-21.
//

import SwiftUI

struct ContentView: View {
    
    @State var courses = [ //Se utiliza @state en este caso, para que el estado cambie si es que un curso es comprado o destacado por el usuario
        Course(name: "Probabilidad y Variables Aleatorias para ML e IA", image: "maths", type: "Matemáticas", priceLevel: 4),
        Course(name: "Machine Learning de la A a la Z", image: "ml_az", type: "Machine learning", priceLevel: 5),
        Course(name: "Resuelve problemas de Matemáticas con Sage y Python", image: "python", type: "Matemáticas", priceLevel: 5, featured: true),
        Course(name: "Aprueba la Selectividad con problemas resueltos", image: "selectividad", type: "Matemáticas", priceLevel: 5),
        Course(name: "Curso de introducción a Swift UI desde cero", image: "swift", type: "Desarrollo de apps", priceLevel: 1, featured: true, purchased: true),
        Course(name: "TensorFlow 2: Curso de Actualización Completo", image: "tensorflow2", type: "Machine learning", priceLevel: 3),
        Course(name: "Curso Completo de Unreal Engine de cero a experto", image: "unrealengine", type: "Videojuegods", priceLevel: 4),
        Course(name: "Curso de Unity 2019: Aprende a crear juegos de rol", image: "videogames", type: "Videojuegos", priceLevel: 3, purchased: true)
    ]
    
    
    @State private var showActionSheet = false
    @State private var selectedCourse: Course?
    @State private var showSettingsView: Bool = false
    @EnvironmentObject var settingsFactory: SettingsFactory
    
    var body: some View {
        NavigationView {
            List {
                ForEach(courses.filter(shouldShowCourse).sorted(by: self.settingsFactory.order.predicateSort())) { course in //A la lista le pasamos los cursos y utilizamos el curso actual //Se utiliza ForEach en vez de List con los parámetros, porque solo el ForEach permite eliminar elementos de la lista //Se filtra por los cursos que cumplan la condición de la función shouldShowCourse()
                    ZStack{
                        
                        CourseRoundImageRow(course: course)
                            .contextMenu {
                                
                                Button(action: {
                                    self.setPurchased(item: course)
                                }, label: {
                                    HStack {
                                        Text("Comprar")
                                        Image(systemName: "checkmark.circle")
                                    }
                                })
                                
                                Button(action: {
                                    self.setFeatured(item: course)
                                }, label: {
                                    HStack {
                                        Text("Destacar")
                                        Image(systemName: "star")
                                    }
                                })
                                
                                Button(action: {
                                    self.delete(item: course)
                                }, label: {
                                    HStack {
                                        Text("Eliminar")
                                        Image(systemName: "trash")
                                    }
                                })
                                
                            }
                            .onTapGesture {
                                self.showActionSheet.toggle()
                                self.selectedCourse = course
                            }
                            .actionSheet(isPresented: self.$showActionSheet, content: {
                            //.actionSheet(item: self.$selectedCourse { _ in
                                ActionSheet(title: Text("Indica tu acción a accionar"), message: nil, buttons: [
                                    .default(Text("Marcar como favorito"), action: { //Botón Default para el actionSheet
                                        if let selectedCourse = self.selectedCourse {
                                            self.setFeatured(item: selectedCourse)
                                        }
                                    }),
                                    .destructive(Text("Eliminar curso"), action: { //Botón destructivo para el actionSheet
                                        if let selectedCourse = self.selectedCourse {
                                            self.delete(item: selectedCourse)
                                        }
                                    }),
                                    .cancel() //botón cancelar para el actionSheet
                                ])
                                
                            })
                        
                        
                    }
                }
                .onDelete{ (indexSet) in //onDelete posibilita también que se pueda eliminar un elemento de la lista haciendo swipe hacia la izquierda
                    self.courses.remove(atOffsets: indexSet) //esto se utiliza para que el bucle forEach vaya a la par que el modelo de datos (atOffsets se utiliza porque es un conjunto de indices)
                }
                
            }
            .navigationBarTitle("Cursos online", displayMode: .automatic)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        self.showSettingsView = true
                                    }, label: {
                                        Image(systemName: "gear")
                                            .font(.title)
                                            .foregroundColor(.gray)
                                    })
            )
            .sheet(isPresented: $showSettingsView, content: {
                SettingsView().environmentObject(self.settingsFactory)
            })
        }
        
    }
    
    
    
    // ** Funciones para destacar, comprar o eliminar un curso **
    private func setFeatured(item course: Course) {
        if let idx = self.courses.firstIndex(where: {$0.id == course.id}){ //$0 es la variable de iteración de los closures
            self.courses[idx].featured.toggle()
        }
    }
    
    private func setPurchased(item course: Course) {
        if let idx = self.courses.firstIndex(where: {$0.id == course.id}) {
            self.courses[idx].purchased.toggle()
        }
    }
    
    private func delete(item course: Course) {
        if let idx = self.courses.firstIndex(where: {$0.id == course.id}) {
            self.courses.remove(at: idx)
        }
    }
    
    private func shouldShowCourse(course: Course) -> Bool {
        let checkPurchased = (self.settingsFactory.showPurchasedOnly && course.purchased) || !self.settingsFactory.showPurchasedOnly
        let checkPrice = (course.priceLevel <= self.settingsFactory.maxPrice)
        return checkPurchased && checkPrice
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SettingsFactory())
    }
}


struct CourseRoundImageRow: View {
    var course : Course
    var body: some View {
        HStack {
            Image(course.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                HStack {
                    Text(course.name)
                        .font(.system(.body, design: .rounded))
                        .bold()
                    
                    Text(String(repeating: "$", count: course.priceLevel))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Text(course.type)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.secondary)
            }
            Spacer().layoutPriority(-10)
            if course.featured {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            if course.purchased {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        
    }
}

