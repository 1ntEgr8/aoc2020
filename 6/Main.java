import java.util.HashSet;
import java.nio.file.Files;
import java.nio.file.Path;
import java.io.IOException;
import java.util.HashMap;

public class Main {
    public static void main (String[] args) throws IOException {
        // read input
        Path fileName = Path.of("./input.txt");
        String input = Files.readString(fileName);
        
        int count = 0;
        for (String group: input.split("\n\n")) {
            count += processGroup_pt2(group); 
        }

        System.out.println(count);
    }

    static int processGroup_pt1(String group) {
        HashSet<Character> set = new HashSet<>();
        
        for (String line: group.split("\n")) {
            for (char c: line.toCharArray()) {
                set.add(c);
            }
        }
                
        return set.size();
    }

    static int processGroup_pt2(String group) {
        HashMap<Character, Integer> cnts = new HashMap<>();
        int lineCount = 0;
        int counts = 0;
        
        for (String line: group.split("\n")) {
            for (char c: line.toCharArray()) {
                cnts.put(c, cnts.getOrDefault(c,0)+1); 
            }
            lineCount += 1;
        }


        for (Character key: cnts.keySet()) {
            if (cnts.get(key) == lineCount) {
                counts += 1;
            }
        }

        return counts;
    }
}
