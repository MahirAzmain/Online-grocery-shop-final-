import SwiftUI

struct ProductCardView: View {
    var product: Product
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(product.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100)
                .padding()
            
            VStack(alignment: .leading, spacing: 5) {
                Text(product.name)
                    .font(.system(size: 16, weight: .semibold))
                
                Text("\(product.quantity)")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                HStack {
                    Text("$\(String(format: "%.2f", product.price))")
                        .font(.system(size: 18, weight: .bold))
                    
                    Spacer()
                    
                    Button(action: {
                        // Add to cart action
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 25))
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 2)
    }
} 