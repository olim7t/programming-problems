/**
 * Given an array of size N that contains only numbers between 1 and N, determines if there are any
 * duplicates.
 */
public class FindDuplicates {
  
  public static void main(final String[] args) {
    System.out.println(hasDuplicates(new int[] { 1, 2, 3, 4 }));
    System.out.println(hasDuplicates(new int[] { 4, 2, 1, 3 }));
    System.out.println(hasDuplicates(new int[] { 1, 2, 1, 3 }));
  }
  
  /**
   * Try to put each value where it would be in a sorted array (1 at index 0, 2 at index 1, etc.). If that
   * slot already contains the correct value, it's a duplicate. Runs in O(n), but mutates the array.
   */
  public static boolean hasDuplicates(final int[] a) {
    int i = 0;
    while (i < a.length) {
      if (a[i] == i + 1) {
        i += 1;
      } else {
        final int j = a[i] - 1;
        if (a[i] == a[j]) {
          return true;
        } else {
          final int tmp = a[i];
          a[i] = a[j];
          a[j] = tmp;
        }
      }
    }
    return false;
  }
}
