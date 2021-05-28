import SwiftUI

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

struct WeatherRecordView: View{
    let CELL_HEIGHT :CGFloat = 50
    let CORNER_RADIUS :CGFloat = 25.0
    let WEATHER_ICON_SCALE :CGFloat = 0.8
    let VSTACK_X_OFFSET: CGFloat = -20
    var record: WeatherModel.WeatherRecord
    var viewModel: WeatherViewModel
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
            }
        }
        .frame(height: CELL_HEIGHT)
        //using .frame modifier to set height of element
      
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WeatherViewModel())
    }
}
