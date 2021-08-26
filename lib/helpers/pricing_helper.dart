class PricingHelper {
    // in USD
  static double calculateFares(int duration, int distance) {
    double timeTraveledFare = (duration / 60) * 0.20;
    double distanceTraveledFare = (distance / 1000) * 0.20;
    double total = timeTraveledFare + distanceTraveledFare;

    return total;
  }
}
