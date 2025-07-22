//
//  TipsView.swift
//  ZeusAppExternos
//
//  Created by Omar Aldair Romero Pérez on 07/08/24.
//

import SwiftUI
import ZeusCoreInterceptor

struct TipsView: View {
    @Environment(\.presentationMode) var navigator
    @State var selectedIndex = 1
    @State var timer: Timer? = nil
    @State var seconds = 0
    @State var hideAnnouncements = false
    let secondsToChange = 3
    var delegate: TipsDelegate
    var body: some View {
        VStack {
            ScrollView {
                Image("tips")
                    .resizable()
                    .frame(width: 137, height: 130)
                    .padding(.top, 70)
                
                Text("Tips Zeus")
                    .font(.system(size: 18, weight: .bold))
                    .padding(.top, 20)
                    .padding(.horizontal)
                
                Text("Puedes usar estos gestos para controlar la reproducción de los comunicados")
                    .font(.system(size: 14, weight: .regular))
                    .padding(.horizontal, 40)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 1) {
                    ItemTip(title: "Avanzar al siguiente", description: "Toca el centro de la pantalla", index: 1, iconName: "tip1", selectedIndex: $selectedIndex)
                    
                    ItemTip(title: "Pausar", description: "Mantén presionado para pausar", index: 2, iconName: "tip2", selectedIndex: $selectedIndex)
                    
                    ItemTip(title: "Retroceder al anterior", description: "Toca el borde izquierdo", index: 3, iconName: "tip3", selectedIndex: $selectedIndex)
                    
                    ItemTip(title: "Ver la siguiente categoría", description: "Desliza hacia los lados", index: 4, iconName: "tip4", selectedIndex: $selectedIndex)
                }
                .padding(.top, 20)
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            onAppearLogic()
        }
    }
    
    func onAppearLogic() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            seconds += 1
            if seconds >= secondsToChange {
                if selectedIndex >= 4 {
                    timer?.invalidate()
                    timer = nil
                    seconds = 0
                    navigator.wrappedValue.dismiss()
                    delegate.goToAnnouncements()
                } else {
                    seconds = 0
                    withAnimation(.spring(duration: 0.8)) {
                        selectedIndex += 1
                    }
                }
               
              
            }
        }
        
    }
}

struct ItemTip: View {
    var title: String
    var description: String
    var index: Int
    var iconName: String
    @Binding var selectedIndex: Int
    var body: some View {
        HStack(alignment: .center) {
            Image(iconName)
                .resizable()
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    
                
                Text(description)
                    .font(.system(size: 14, weight: .regular))
            }
            
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 70)
        .background(selectedIndex == index ? Color(UIColor.secondaryLightGrey) : Color.white)
        .cornerRadius(12)
    }
}

protocol TipsDelegate {
    func goToAnnouncements()
}
