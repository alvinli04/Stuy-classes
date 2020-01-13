import java.io.*;
import java.util.*;

public class Minutes{
        public static void main(String[] args) throws Exception{
                BufferedReader br = new BufferedReader(new FileReader("bovary.txt"));
                PrintWriter pw = new PrintWriter(new FileWriter("freq.out"));
                PrintWriter pw2 = new PrintWriter(new FileWriter("words.out"));
                HashMap<String, Integer> freq = new HashMap<>(); //word to freq
                HashMap<Double, String> reverse = new HashMap<>(); //freq to word
                String str;
                while((str = br.readLine()) != null){
                        str = str.replaceAll("\\p{Punct}","");
                        str = str.replaceAll("-"," ");
                        //System.out.println(str);
                        String[] arr = str.split(" ");
                        String[] lower = new String[arr.length];
                        for(int i = 0; i < arr.length; i++){
                                lower[i] = arr[i].toLowerCase();
                        }
                        for(String i: lower){
                                if(freq.containsKey(i)){
                                        freq.replace(i, freq.get(i), freq.get(i) + 1);
                                }
                                else{
                                        freq.put(i, 1);
                                }
                        }
                }
                String[] words = freq.keySet().toArray(new String[0]);
                for(String i: words){
                        reverse.put(freq.get(i) + Math.random(), i);
                        //System.out.println(i);
                }
                Double[] nums = reverse.keySet().toArray(new Double[0]);
                Arrays.sort(nums);
                for(int i = 0; i < words.length; i++){
                        words[i] = reverse.get(nums[i]);
                }

                for(int i = 0; i < nums.length; i++){
                        pw.println(Math.floor(nums[i]));
                        pw2.println(words[i]);
                }
                pw.close();
                pw2.close();
                br.close();
        }
}
