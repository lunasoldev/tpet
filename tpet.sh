#!/bin/bash

SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

cd "$SCRIPT_DIR"

# Variables
mood="happy"
hunger=5
fun=5
tiredness=5

dialogue_dir="./dialogue"

# Pick random dialogue 
random_line() {
  local file=$1
  if [ -f "$file" ]; then
    mapfile -t lines < "$file"
    line="${lines[$((RANDOM % ${#lines[@]}))]}"
    eval cowsay "$line"
  else
    echo "the stupid person who created me has not added dialogue for this mood ($mood). or you deleted it.. meow?" | cowsay
  fi
}

# Calculate the current mood
get_mood() {
  if [ $fun -lt 3 ] && [ $hunger -lt 5 ] && [ $tiredness -lt 5 ]; then
    echo "playful"
  elif [ $tiredness -ge 7 ] && [ $fun -ge 5 ]; then
    echo "sleepy"
  elif [ $hunger -ge 7 ] && [ $fun -ge 3 ]; then
    echo "hungry"
  elif [ $fun -ge 7 ] && [ $hunger -ge 4 ]; then
    echo "grumpy"
  else
    echo "neutral"
  fi
}

die() {
  clear
  cowsay $1
  sleep 1
  clear
  cowsay "bye..."
  sleep 1
}


# Main Loop
while true; do
  clear

  mood=$(get_mood)

  random_line "$dialogue_dir/$mood.txt"
  echo "Mood: $mood | Hunger: $hunger/10 | Fun: $((10 - fun))/10 | Tiredness: $tiredness/10"
  echo -e "\nCommands: [F]eed [P]lay [S]leep [Q]uit"
  
  # Input
  read -n 1 -t 3 action
  case $action in 
    f) 
      fun=$((fun + 1))
      hunger=$((hunger - 3))
      ;;
    p) 
      fun=$((fun - 3))
      hunger=$((hunger + 2))
      tiredness=$((tiredness + 3))
      ;;
    s)
      fun=$((fun + 3))
      hunger=$((hunger + 3))
      tiredness=$((tiredness - 8))
      echo "pet is sleeping. please be quiet for 5 seconds."
      sleep 5
      ;;
    q) 
      clear
      break
      ;;
  esac

  # Prevent scores from going out of bounds
  if [ $fun -gt 10 ]; then
    fun=10
    die "you aren't fun anymore..."
    break
  elif [ $fun -lt 0 ]; then
    fun=0
  fi

  if [ $tiredness -gt 10 ]; then
    tiredness=10
    die "I'll... *yawn*... go.. lay down..."
    break
  elif [ $tiredness -lt 0 ]; then
    tiredness=0
  fi

  if [ $hunger -gt 10 ]; then
    hunger=10
    die "s-.. so.. hungr-...."
    break
  elif [ $hunger -lt 0 ]; then
    hunger=0
  fi

done
