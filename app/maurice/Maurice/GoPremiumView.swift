import Foundation
import SwiftUI
import RevenueCat

struct GoPremiumView: View {
    @EnvironmentObject var user: User
    @State private var offering: Offering?
    @State private var monthlyPackageStoreProduct: StoreProduct?
    @State private var yearlyPackageStoreProduct: StoreProduct?
    @State private var showTransactionErrorAlert = false
    @State private var showTransactionSuccessAlert = false
    @State private var loadingMonthly = false
    @State private var loadingYearly = false
    @State private var loadingRestorePurchase = false
    
    func makePurchase(package: Package) {
        Purchases.shared.purchase(package: package) {(transaction, customerInfo, error, userCancelled) in
            loadingMonthly = false
            loadingYearly = false
            
            guard error == nil else {
                DispatchQueue.main.async {
                    showTransactionErrorAlert = true
                }
                return
            }
            
            if customerInfo?.entitlements.all["premium"]?.isActive == true {
                // User has gone premium
                DispatchQueue.main.async {
                    showTransactionSuccessAlert = true
                    user.showGoPremiumSheet = false
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                Spacer()
                VStack(alignment: .leading) {
                    Text("Upgrade to Maurice Premium")
                        .bold()
                        .font(.system(size: 36))
                        .padding(.bottom, 30)
                    Text("Up to 100 messages per day and access to the most advanced AI version of Maurice.")
                        .font(.system(size: 24))
                    if monthlyPackageStoreProduct != nil {
                        VStack {
                            Text("Cancel anytime")
                                .font(.system(size: 12))
                                .foregroundColor(Color(.systemGray))
                            PremiumOfferContainer(
                                duration: "Monthly",
                                price: monthlyPackageStoreProduct!.localizedPriceString,
                                onTap: {
                                    loadingMonthly = true
                                    makePurchase(package: (offering?.monthly)!)
                                },
                                loading: loadingMonthly
                            )
                            .disabled(loadingMonthly || loadingYearly)
                            Spacer().frame(height: 15)
                            PremiumOfferContainer(
                                duration: "Yearly",
                                price: yearlyPackageStoreProduct!.localizedPriceString,
                                onTap: {
                                    loadingYearly = true
                                    makePurchase(package: (offering?.annual)!)
                                },
                                loading: loadingYearly
                            )
                            .disabled(loadingMonthly || loadingYearly)
                        }
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 0,
                            maxHeight: .infinity,
                            alignment: .center
                        )
                        Spacer()
                        HStack(alignment: .center) {
                            VStack {
                                if loadingRestorePurchase {
                                    ProgressView()
                                } else {
                                    Text("Restore purchase")
                                        .onTapGesture {
                                            loadingRestorePurchase = true
                                            Purchases.shared.restorePurchases { customerInfo, error in
                                                loadingRestorePurchase = false
                                            }
                                        }
                                        .font(.system(size: 12))
                                        .foregroundColor(Color(.systemGray))
                                        .padding(.bottom, 10)
                                }
                                Link("Terms & Conditions", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(.systemGray))
                                    .padding(.bottom, 20)
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                }
                .onAppear {
                    // Fetch offerings from RevenueCat
                    Purchases.shared.getOfferings { (fetchedOfferings, error) in
                        guard error == nil else { return }
                        
                        offering = fetchedOfferings?.current
                        monthlyPackageStoreProduct = offering?.monthly?.storeProduct
                        yearlyPackageStoreProduct = offering?.annual?.storeProduct
                    }
                }
//                .alert(isPresented: $showTransactionErrorAlert ) {
//                    Alert(
//                        title: Text("An error happened"),
//                        message: Text("Your transaction couldn't be completed, please try again."),
//                        dismissButton: .default(Text("Ok"))
//                    )
//                }
//                .alert(isPresented: $showTransactionSuccessAlert) {
//                    Alert(
//                        title: Text("Purchase completed"),
//                        message: Text("Maurice is ready to assist you with all his love!"),
//                        dismissButton: .default(Text("Let's go"))
//                    )
//                }
                .frame(height: geometry.size.height)
                .padding(.horizontal, 20)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        DispatchQueue.main.async {
                            user.showGoPremiumSheet = false
                        }
                    }
                }
            }
        }
    }
}


struct PremiumOfferContainer: View {
    @Environment(\.colorScheme) var colorScheme
    let duration: String
    let price: String
    let onTap: () -> Void
    let loading: Bool
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                if loading {
                    ProgressView()
                } else {
                    Text(price).bold().font(.system(size: 22))
                    Spacer().frame(height: 5)
                    Text(duration)
                }
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 50,
                maxHeight: 50,
                alignment: .leading
            )
            .padding()
        }
        .background(Color(colorScheme == .dark ? .systemGray5 : .systemGray6))
        .cornerRadius(10)
        .onTapGesture {
            onTap()
        }
    }
}
