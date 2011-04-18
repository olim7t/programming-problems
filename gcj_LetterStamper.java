import static java.lang.Math.*;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

/** A multi-threaded Java port of my Ruby solution. On a quad-core, it solves the large problem in just under 1m 20s. */
public final class LetterStamper {
  private static final int CORE_COUNT = 4;
  private static final int MAX_GRADE_COUNT = 7000;
  private static final int MAX_STACK_COUNT = 6;

  public static void main(final String[] args) throws InterruptedException, ExecutionException {
    final Scanner s = new Scanner(System.in);
    new LetterStamper().solve(s, System.out);
    s.close();
  }

  void solve(Scanner in, PrintStream out) throws InterruptedException, ExecutionException {
    final int caseCount = in.nextInt();
    in.nextLine();

    ExecutorService executor = Executors.newFixedThreadPool(CORE_COUNT);
    List<Future<String>> results = new ArrayList<Future<String>>(caseCount);

    for (int c = 1; c <= caseCount; c++) {
      String input = in.nextLine();
      ComputeTask task = new ComputeTask(c, input);
      results.add(executor.submit(task));
    }
    executor.shutdown();
    for (Future<String> result : results)
      out.println(result.get());
  }


  static final class ComputeTask implements Callable<String> {
    private final String input;
    private final int caseNumber;
    private int[] previousRow = new int[(MAX_GRADE_COUNT + 1) * MAX_STACK_COUNT];
    private int[] currentRow  = new int[(MAX_GRADE_COUNT + 1) * MAX_STACK_COUNT];

    ComputeTask(int caseNumber, String input) {
      this.caseNumber = caseNumber;
      this.input = input;
    }

    @Override public String call() throws Exception {
      char grades[] = input.toCharArray();
      int best;
      Stacks stacks = new Stacks(grades);
      if (stacks.size == 1)
        best = grades.length + 2;
      else {
        for (int i = 0; i <= grades.length; i++)
          for (int s = 0; s < stacks.size; s++) currentRow[pos(i, s)] = i;

        int worst = 3 * grades.length;

        for (int j = 1; j <= grades.length; j++) {
          swapRows();
          char toPrint = grades[grades.length - j];
          for (int i = 0; i <= grades.length; i++)
            for (int s = 0; s < stacks.size; s++) {
              char onTop = stacks.elementAt(s, i);
              char canPush = stacks.elementAt(s, i + 1);
              int result;
              if (toPrint == onTop)
                result = previousRow[pos(i, s)] + 1;
              else {
                int pop = worst;
                if (i == 1)
                  for (int k = 0; k < stacks.size; k++) pop = min(pop, currentRow[pos(0, k)] + 1);
                else if (i == 2 && stacks.size == MAX_STACK_COUNT)
                  pop = min(currentRow[pos(1, s)], currentRow[pos(1, (s + 3) % stacks.size)]) + 1;
                else if (i != 0)
                  pop = currentRow[pos(i - 1, s)] + 1;

                if (toPrint == canPush) result = min(previousRow[pos(i + 1, s)] + 2, pop);
                else result = pop;
              }
              currentRow[pos(i, s)] = result;
            }

          // if (j == 1) {
          // printRow(previousRow, grades.length, stacks.size);
          // }
          // printRow(currentRow, grades.length, stacks.size);
        }
        int b = worst;
        for (int i = 0; i <= grades.length; i++)
          for (int s = 0; s < stacks.size; s++)
            b = min(b, currentRow[pos(i, s)] + i);
        best = b;
      }
      return "Case #" + caseNumber + ": " + best;
    }

    private int pos(int i, int s) {
      assert 0 <= i && i <= MAX_GRADE_COUNT;
      assert 0 <= s && s < MAX_STACK_COUNT;
      return (MAX_STACK_COUNT * i) + s;
    }

    private void swapRows() {
      int[] tmp = previousRow;
      previousRow = currentRow;
      currentRow = tmp;
    }

    private void printRow(int[] row, int gradesCount, int stacksCount) {
      for (int i = 0; i < gradesCount; i++) {
        for (int s = 0; s < stacksCount; s++) System.out.print(row[pos(i, s)] + " ");
        System.out.print("| ");
      }
      System.out.println();
    }
  }

  static final class Stacks {
    final int            size;
    private final char[] elements;
    private final char[] elements2;
    private final int    gradeCount;

    Stacks(char[] chars) {
      elements = findDistinct(chars);
      if (elements.length == 3) elements2 = new char[] { elements[0], elements[2], elements[1] };
      else elements2 = null;

      size = elements.length < 3 ? elements.length : MAX_STACK_COUNT;
      gradeCount = chars.length;
    }

    char elementAt(int s, int i) {
      if (i < 1 || i > gradeCount || s >= size)
        return 0;
      else {
        int p = (i - 1 + s) % elements.length;
        char[] target = s < 3 ? elements : elements2;
        return target[p];
      }
    }

    private char[] findDistinct(char[] chars) {
      char element1 = chars[0];
      char element2 = 0;
      char element3 = 0;
      for (char c : chars)
        if (element2 == 0 && c != element1) element2 = c;
        else if (c != element1 && c != element2) {
          element3 = c;
          break;
        }

      if (element3 != 0) return new char[] { element1, element2, element3 };
      else if (element2 != 0) return new char[] { element1, element2 };
      else return new char[] { element1 };
    }
  }
}
