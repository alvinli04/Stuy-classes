import java.util.*;
import java.io.*;
public class Hw22{
        public static void main(String[] args) throws IOException{
                int n = Integer.parseInt(args[0]);
                boolean[] numPresent = new boolean[n];
                for(boolean k: numPresent){
                        k = false;
                }
                for(int i = 0; i <= i - 1; i++){
                        numPresent[System.in.read()] = true;
                }
                for(boolean n: numPresent){
                        if(n == false){
                                System.out.println(n);
                        }
                }
        }
}

class noDataStructures{
        public static void main(String[] args) {
                int last = 0;
                while(System.in.read() != -1){
                        int n = Integer.in.read();
                        if(n != last + 1){
                                System.out.println(last + 1);
                                System.exit(0);
                        }
                        last = n;
                }
        }
}
