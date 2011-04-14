/**
 * Given an array containing negative and positive integers, find the subarray with the largest sum, in linear
 * time.
 */
public class BestSubarray {

  static void findBestSubarray(final int[] a) {
    int bestSum = a[0], bestStart = 0, bestEnd = 0;

    // The sum for the best subarray ending with the current element
    int currentSum = bestSum;
    int currentStart = bestStart;

    for (int i = 1; i < a.length; i++) {
      if (currentSum < 0) {
        // The current element alone is the best solution
        currentSum = a[i];
        currentStart = i;
      } else {
        currentSum += a[i];
      }
      if (currentSum > bestSum) {
        bestSum = currentSum;
        bestStart = currentStart;
        bestEnd = i;
      }
    }
    System.out.println("Best sum: " + bestSum + " between " + bestStart + " and " + bestEnd);
  }

  public static void main(final String[] args) {
    findBestSubarray(new int[] { 1, 2, -3, 4 });
    findBestSubarray(new int[] { 1, 1, 1, -1, 2 });
    findBestSubarray(new int[] { 1, 1, 1, -1, 10, -2 });
    findBestSubarray(new int[] { -10, 1, 1, 1 });
    findBestSubarray(new int[] { -4, -3, -2, -1 });
  }
}
