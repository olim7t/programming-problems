import java.util.Arrays;
import java.util.Random;

/**
 * The problem is: write a program to do a binary search in a sorted list, but the list is circularly shifted by an unknown amount.
 *
 * The solution below uses an int array for simplicity. The complexity is O(log n), like the normal binary search.
 */
public class ShiftedBinarySearch {
  
  public static int shiftedBinarySearch(int[] l, int v) {
    if (l.length == 0) return -1;
    return shiftedBinarySearch(l, v, 0, l.length - 1);
  }
  
  private static int shiftedBinarySearch(int[] l, int v, int start, int end) {
    if (start > end) return -1;
    
    int startValue = l[start];
    if (startValue == v) return start;
    int endValue = l[end];
    if (endValue == v) return end;
    
    if (startValue < endValue) return binarySearch(l, v, start, end); // no shift
    
    int mid = start + (end - start) / 2;
    int midValue = l[mid];
    if (midValue == v) return mid;
    if (startValue <= midValue) // left half is sorted, right half is shifted
      if (startValue < v && v < midValue) return binarySearch(l, v, start + 1, mid - 1);
      else return shiftedBinarySearch(l, v, mid + 1, end - 1);
    else
      if (midValue < v && v < endValue) return binarySearch(l, v, mid + 1, end - 1);
      else return shiftedBinarySearch(l, v, start + 1, mid - 1);
  }
  
  // Standard binary search on a sorted list
  private static int binarySearch(int[] l, int v, int start, int end) {
    if (start > end || v < l[start] && v > l[end]) return -1;
    if (l[start] == v) return start;
    if (l[end] == v) return end;

    int mid = start + (end - start) / 2;
    if (l[mid] == v) return mid;
    else if (l[mid] > v) return binarySearch(l, v, start, mid - 1);
    else return binarySearch(l, v, mid + 1, end);
  }
  


  // TESTS
  
  public static void main(String[] args) {
    assertEquals(shiftedBinarySearch(new int[] {}, 0), -1);

    for (int i = 1; i < 20; i++) testAllShifts(i);

    System.out.println("success");
  }
  
  private static void testAllShifts(int size) {
    int[] original = generateValues(size);
    int[] l = new int[size];
    System.arraycopy(original, 0, l, 0, size);
    
    int tooSmall = -1, tooBig = size;
    
    for (int amount = 0; amount < size; amount++) {
      shift(l, amount);
      assertEquals(shiftedBinarySearch(l, tooSmall), -1);
      assertEquals(shiftedBinarySearch(l, tooBig), -1);
      for (int i = 0; i < size; i++) {
        int found = shiftedBinarySearch(l, original[i]);
        assertNotEquals(found, -1);
        assertEquals(l[found], original[i]);
      }
    }
  }
  
  private static int[] generateValues(int size) {
    int[] values = new int[size];
    Random r = new Random();
    for (int i = 0; i < size; i++) values[i] = r.nextInt(size);
    Arrays.sort(values);
    return values;
  }
  
  private static void shift(int[] l, int amount) {
    int[] tmp = new int[l.length];
    for (int i = 0; i < l.length; i++) tmp[(i + amount) % l.length] = l[i];
    System.arraycopy(tmp, 0, l, 0, l.length);
  }
  
  private static void assertEquals(int actual, int expected) {
    if (actual != expected) throw new AssertionError();
  }
  
  private static void assertNotEquals(int actual, int expected) {
    if (actual == expected) throw new AssertionError();
  }
}
