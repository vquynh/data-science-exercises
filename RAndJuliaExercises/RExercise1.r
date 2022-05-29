
random_number <- floor(runif(1, min = 0, max = 100));
user_number <- readline(prompt = "Guess a number from 0 to 100: ")

if (user_number == user_number) {
    print("Congratulations! You guessed correctly! The number is: ",
    user_number);

} else{
    print("Sorry! You guessed the number:", user_number,
    "but the program's number is: ", random_number);
    print("Good luck next time!");
}