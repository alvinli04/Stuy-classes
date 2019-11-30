import java.util.*;
public class HW16{        
        /*
        Write a code fragment that reverses the order of the values in a one-dimensional string array.
        Do not creat another array to hold the result.
        */
        public static String[] flip(String[] input) {
                String[] arr = input;
                for(int i = 0; i < arr.length / 2; i ++){
                        String n = arr[i];
                        arr[i] = arr[arr.length - 1 - i];
                        arr[arr.length - 1 - i] = n;
                }
                return arr;
        }

        /*
        Write the program HowMany that takes a variable number of command-line arguments and prints how many there are.
        */
        public static void HowMany(){
                System.out.println(argscopy.length);
        }
        static String[] argscopy; //to copy args from main method

        //Dice simulation
        public static double[] diceRoll(int rolls){
                double[] prob = new double[13];
                for(int i = 0; i < rolls; i ++){
                        int j = (int)(Math.random() * 6 + 1);
                        int k = (int)(Math.random() * 6 + 1);
                        prob[j + k] ++;
                }
                for(int i = 0; i < prob.length; i ++){
                        prob[i] = prob[i] / rolls;
                }
                return prob;
        }


        public static void main(String[] args) {
                /*
                String[] test = {"hi", "bye", "joe", "bob"};
                String[] ftest = flip(test);
                for(int i = 0; i < test.length; i ++){
                        System.out.println(ftest[i]);
                }
                */
                argscopy = args;
                //HowMany();

                //making the original distribution function:
                int [] frequencies = new int[13];
		for (int i = 1; i <= 6; i++){
		    for (int j = 1; j <= 6; j++){
                        frequencies[i + j]++;
                    }
                }
                double[] probabilities = new double[13];
		for (int k = 1; k <= 12; k++){
                    probabilities[k] = frequencies[k] / 36.0;
                }
                for(int i = 1; i < probabilities.length; i ++){
                        System.out.println(i + ":" + probabilities[i]);
                }
                
                System.out.println("________");
                //printing own distribution
                double[] prob2 = diceRoll(1000000);
                for(int i = 1; i < prob2.length; i ++){
                        System.out.println(i + ":" + prob2[i]);
                }
                //the probabilities match at about 1000000 or so rolls.
        }
}
