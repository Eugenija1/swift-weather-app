import SwiftUI
import CoreLocation
import MapKit

struct ContentView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        ScrollView(.vertical){
            VStack {
                ForEach(viewModel.records){record in
                    WeatherRecordView(record: record, viewModel: viewModel)
            }
            }.padding()
        }
  }
}
struct Place: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }

struct WeatherRecordView: View{
    let CELL_HEIGHT :CGFloat = 50
    let CORNER_RADIUS :CGFloat = 25.0
    let WEATHER_ICON_SCALE :CGFloat = 0.8
    let VSTACK_X_OFFSET: CGFloat = -20
    var record: WeatherModel.WeatherRecord
    var viewModel: WeatherViewModel
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.0, longitude: 20.0), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    @State private var showingSheet: Bool = false
    
    struct SheetView: View{
        @Environment(\.presentationMode) var presentationMode
        
        var body: some View{
            ZStack{
                Button("Dismiss"){
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    
    
    var body: some View{
        
        ZStack{
            RoundedRectangle(cornerRadius: CORNER_RADIUS).stroke()
            HStack{
                GeometryReader{ geometry in
                    Text(record.icon)
                    .font(.system(size: WEATHER_ICON_SCALE * geometry.size.height))
                    .frame(alignment: .leading)
                    .padding(.leading, 10)
                }
                VStack(alignment: .leading){
                    Text(record.cityName)
                    Text("Temperature:\(record.temperature, specifier: "%.1f")'C")
                        .font(.caption)
                }.offset(x: VSTACK_X_OFFSET)
                
            
                Text("🔄")
                    .font(.largeTitle)
                    .onTapGesture{
                        viewModel.refresh(record: record)
                    }
                    .frame(alignment: .trailing)
                    .padding(.trailing, 10)
                
                Text("🔎")
                    .font(.largeTitle)
                    .onTapGesture{
                        showingSheet = true
                    }
                    .sheet(isPresented: $showingSheet, content:{ Map(coordinateRegion: $region,annotationItems: [Place(coordinate: .init(latitude: record.latt, longitude: record.long))] )
                        {_ in SheetView()}
                        .onAppear()
            })
                    .onAppear(perform: {setCoordinates(latt: record.latt, long: record.long)})
                           
                    .frame(alignment: .trailing)
                    .padding(.trailing, 10)
            }
        }
        .frame(height: CELL_HEIGHT)
        //using .frame modifier to set height of element
      
    }
    func setCoordinates(latt: Double, long: Double){
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latt, longitude: long), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))}
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WeatherViewModel())
    }
}
