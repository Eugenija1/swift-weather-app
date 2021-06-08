

import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    var body: some View {
        //możliwośc przewijania ekranu jeśli nie wszystkie komórki się mieszczą
        ScrollView {
            VStack{
                ForEach(viewModel.records) { rec in
                    WeatherRecordView(record: rec, viewModel: viewModel)
                }
            }.padding()
        }
    }
}

struct WeatherRecordView: View {
    @ObservedObject var record: WeatherModel.WeatherRecord
    @ObservedObject var viewModel: WeatherViewModel
    
    //slownik z ikonami
    let weatherIcons = ["Sleet"       : "🌨",
                        "Snow"         : "❄️",
                        "Hail"         : "🌨",
                        "Thunderstorm" : "🌩",
                        "Heavy Rain"   : "🌧",
                        "Light Rain"   : "🌦",
                        "Heavy Cloud"  : "☁️",
                        "Light Cloud"  : "⛅️",
                        "Clear"        : "☀️"]
    
    let weatherParams = ["Temperature", "Humidity", "Wind speed", "Wind direction"]
    //wszystkie wartości mają byc sparametryzowane
    let itemWidth: CGFloat = 300
    let itemHeight: CGFloat = 75
    let iconScaleFactor: CGFloat = 0.7
    let padding: CGFloat = 10
    let cornerRadius: CGFloat = 10
    
    @State var tap = 0
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.0, longitude: 20.0), span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
    
    
    @State var showingSheet = false
    
    
    var body: some View {
        ZStack(alignment: .leading){
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke()
                .frame(height: itemHeight)
            HStack {
                //ikonka zajmuje calą przestrzeń
                GeometryReader {
                    geometry in
                    Text(weatherIcons[record.weatherState] ?? "🌤")
                        .font(.system(size: geometry.size.height * iconScaleFactor))
                    
                }
                .frame(width: itemHeight * iconScaleFactor) // Ograniczenie szerokości komórek - rozwiązanie problemu z UI związanego z GeometryReader
                VStack(alignment: .leading) { //wyrównanie tekstu do lewej w obrębie VStack'u
                    Text(record.cityName)
                    Text(getText(tap: tap)).font(.caption)
                }
                //Spacer powoduje że ikonka odświeżania jet wyrównana do prawej strony
                Spacer()
                Text("⟳").font(.title).onTapGesture{
                    viewModel.refresh(record: record)
                }
                Text("🌎").font(.title)
                    .onTapGesture{
                        showingSheet.toggle()
                        region = MKCoordinateRegion(center: record.latLong, span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
                        print("============ \(region)")
                    }
                    .sheet(isPresented: $showingSheet) {
                        ModalSheetView(region: $region)
                        
                    }
            }
            .padding(padding)
            // wysokośc komórek z miastami ustalona parametrem
            //
            .frame(height: itemHeight)
        }
        .padding(padding)
        .onTapGesture(perform: {
            tap = (tap + 1) % 3
        })
    }
    
    struct ModalSheetView: View {
        @Binding var region: MKCoordinateRegion
        
        var body: some View {
            Map(coordinateRegion: $region)
        }
    }
        
    func getText(tap: Int) -> String {
        var text: String = ""
        switch tap {
        case 1:
            text = "Humidity: \(round(record.humidity * 10.0) / 10.0)%"
        case 2:
            text = "Wind Speed: \(round(record.windSpeed * 10.0) / 10.0) km/h, Direction: \(record.windDirection)"
        default:
            text = "Temperature: \(round(record.temperature * 10.0) / 10.0) ℃"
        }
        return text
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WeatherViewModel())
    }
}
